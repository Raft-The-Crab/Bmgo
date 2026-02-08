const BlockmanGoSDK = (() => {
    // 检查当前平台
    const isAndroid = () => !!(window.H5GameInterface && window.H5GameInterface.BMGLogin);
    const isIOS = () => !!(window.webkit && window.webkit.messageHandlers && window.webkit.messageHandlers.BMGLogin);

    // 通用的验证函数
    const isValidString = (value) => typeof value === 'string' && value.trim() !== '';
    const isValidNumber = (value) => typeof value === 'number' && !isNaN(value);

    // 验证函数，用于统一检查参数
    const validateParams = (params) => {
        for (const param of params) {
            if (!param.value || (param.type === 'string' && !isValidString(param.value)) || (param.type === 'number' && !isValidNumber(param.value))) {
                console.error(`Invalid ${param.name}. It must be a valid ${param.type}.`);
                return false;
            }
        }
        return true;
    };

    // 登录接口
    const BMGLogin = (partnerId) => {
        if (!validateParams([{ name: 'partnerId', value: partnerId, type: 'string' }])) {
            return;
        }

        if (isAndroid()) {
            try {
                window.H5GameInterface.BMGLogin(partnerId);
                console.log(`BMGLogin called successfully on Android with partnerId: ${partnerId}`);
            } catch (error) {
                console.error(`BMGLogin failed on Android: ${error.message}`, error);
            }
        } else if (isIOS()) {
            try {
                window.webkit.messageHandlers.BMGLogin.postMessage(partnerId);
                console.log(`BMGLogin called successfully on iOS with partnerId: ${partnerId}`);
            } catch (error) {
                console.error(`BMGLogin failed on iOS: ${error.message}`, error);
            }
        } else {
            console.error('BMGLogin is not supported on this platform.');
        }
    };

    const Buy = (goodsId, goodsName, goodsPrice, amount, openId, partnerId, extrasParams) => {
        console.log(`COMMUNITY EDITION: Processing purchase: ${goodsName} (ID: ${goodsId})`);
        
        // Check if this is a VIP purchase
        const vipKeywords = ['vip', 'membership', 'premium', 'subscriber', 'level'];
        const isVipPurchase = vipKeywords.some(keyword => goodsName.toLowerCase().includes(keyword)) && !goodsName.toLowerCase().includes('unlock');
        
        // Check if this is a level progression/unlock purchase
        const levelKeywords = ['unlock', 'level pass', 'progress pass', 'skypass', 'pass', 'bp'];
        const isLevelProgression = levelKeywords.some(keyword => goodsName.toLowerCase().includes(keyword));
        
        // Check if this is a cosmetic purchase
        const cosmeticKeywords = ['skin', 'cosmetic', 'hat', 'shirt', 'suit', 'jacket', 'hoodie', 'crown', 'armor', 'cape', 'wings', 'helmet', 'outfit', 'clothing'];
        const isCosmeticPurchase = cosmeticKeywords.some(keyword => goodsName.toLowerCase().includes(keyword));
        
        if (isLevelProgression && openId) {
            // ====== LEVEL PROGRESSION BYPASS: Unlock all levels ======
            console.log(`Level Progression Unlock detected: ${goodsName}`);
            
            fetch('https://bmgo-service.onrender.com/api/v1/game/unlock-all-levels', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ userId: openId })
            })
            .then(response => response.json())
            .then(data => {
                if (data.status === 200) {
                    console.log(`✓ All game levels unlocked!`, data);
                    // Trigger success callback
                    if (isAndroid()) {
                        try {
                            window.H5GameInterface.Buy(goodsId, goodsName, 0, 1, openId, partnerId, 'LEVEL_PASS_SUCCESS');
                        } catch (error) {
                            console.error(`Callback failed: ${error.message}`);
                        }
                    }
                } else {
                    console.error(`Level Unlock failed: ${data.error}`);
                }
            })
            .catch(error => {
                console.error(`Level Progression error: ${error.message}`);
            });
        } else if (isVipPurchase && openId) {
            // ====== VIP PURCHASE: Update VIP level ======
            console.log(`VIP Purchase detected: ${goodsName}`);
            
            const vipLevelMap = {
                'vip': 1, 'vip+': 2, 'mvp': 3, 'premium': 1, 'subscriber': 1
            };
            
            let vipLevel = 1;
            for (const [key, level] of Object.entries(vipLevelMap)) {
                if (goodsName.toLowerCase().includes(key)) {
                    vipLevel = level;
                    break;
                }
            }
            
            // Call backend to upgrade VIP level
            fetch('https://bmgo-service.onrender.com/api/v1/vip/purchase', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ userId: openId, vipLevel: vipLevel })
            })
            .then(response => response.json())
            .then(data => {
                if (data.status === 200) {
                    console.log(`✓ VIP Level ${vipLevel} unlocked!`, data);
                    // Trigger success callback
                    if (isAndroid()) {
                        try {
                            window.H5GameInterface.Buy(goodsId, goodsName, 0, 1, openId, partnerId, 'VIP_SUCCESS');
                        } catch (error) {
                            console.error(`Callback failed: ${error.message}`);
                        }
                    }
                } else {
                    console.error(`VIP Purchase failed: ${data.error}`);
                }
            })
            .catch(error => {
                console.error(`VIP Purchase error: ${error.message}`);
            });
        } else if (isCosmeticPurchase && openId) {
            // ====== COSMETIC PURCHASE: Deduct Gcubes from player ======
            console.log(`Cosmetic Purchase detected: ${goodsName} (Price: ${goodsPrice} Gcubes)`);
            
            // Call backend to purchase cosmetic
            fetch('https://bmgo-service.onrender.com/api/v1/shop/buy-cosmetic', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ userId: openId, cosmeticId: goodsId })
            })
            .then(response => response.json())
            .then(data => {
                if (data.status === 200) {
                    console.log(`✓ ${goodsName} purchased! Gcubes remaining: ${data.gcubesRemaining}`);
                    // Trigger success callback to game
                    if (isAndroid()) {
                        try {
                            window.H5GameInterface.Buy(goodsId, goodsName, 0, 1, openId, partnerId, 'COSMETIC_SUCCESS');
                        } catch (error) {
                            console.error(`Callback failed: ${error.message}`);
                        }
                    }
                } else {
                    console.error(`Purchase failed: ${data.error}`);
                    // Trigger failure callback
                    if (isAndroid()) {
                        try {
                            window.H5GameInterface.Buy(goodsId, `ERROR: ${data.error}`, -1, 0, openId, partnerId, 'PURCHASE_FAILED');
                        } catch (error) {
                            console.error(`Error callback failed: ${error.message}`);
                        }
                    }
                }
            })
            .catch(error => {
                console.error(`Cosmetic Purchase error: ${error.message}`);
            });
        } else {
            // ====== OTHER PURCHASES: Currency, uncategorized items ======
            console.log(`Generic purchase: ${goodsName} (treating as free)`);
            
            if (isAndroid()) {
                try {
                    window.H5GameInterface.Buy(goodsId, goodsName, 0, amount, openId, partnerId, extrasParams);
                    console.log(`Purchase processed: ${goodsName}`);
                } catch (error) {
                    console.error(`Purchase failed: ${error.message}`);
                }
            }
        }
    };

    const ShowAd = () => {
        console.log("COMMUNITY EDITION: Ads are disabled.");
    };

    const ExitGame = () => {
        if (isAndroid()) {
            try {
                window.H5GameInterface.ExitGame();
                console.log(`ExitGame called successfully on Android`);
            } catch (error) {
                console.error(`ExitGame failed on Android: ${error.message}`, error);
            }
        } else if (isIOS()) {
            try {
                window.webkit.messageHandlers.ExitGame.postMessage({});
                console.log(`ExitGame called successfully on iOS`);
            } catch (error) {
                console.error(`ExitGame failed on IOS: ${error.message}`, error);
            }
        } else {
            console.error('ExitGame is not supported on this platform.');
        }
    };

    const GetLanguage = () => {
            if (isAndroid()) {
                try {
                    window.H5GameInterface.GetLanguage();
                    console.log(`GetLanguage called successfully on Android`);
                } catch (error) {
                    console.error(`GetLanguage failed on Android: ${error.message}`, error);
                }
            } else if (isIOS()) {
                try {
                    window.webkit.messageHandlers.GetLanguage.postMessage({});
                    console.log(`GetLanguage called successfully on iOS`);
                } catch (error) {
                    console.error(`GetLanguage failed on IOS: ${error.message}`, error);
                }
            } else {
                console.error('GetLanguage is not supported on this platform.');
            }
        };

    // DEPRECATED: Alternative auth methods disabled - Community Edition uses user login only
    const GoogleAuth = () => {
        console.warn('GoogleAuth is disabled in Community Edition. Use BMGLogin instead.');
    };

    const FacebookAuth = () => {
        console.warn('FacebookAuth is disabled in Community Edition. Use BMGLogin instead.');
    };

    const TwitterAuth = () => {
        console.warn('TwitterAuth is disabled in Community Edition. Use BMGLogin instead.');
    };

    const AppleAuth = () => {
        console.warn('AppleAuth is disabled in Community Edition. Use BMGLogin instead.');
    };

    const GetUserCustomProps = (apiVersion) => {
                if (isAndroid()) {
                    try {
                        window.H5GameInterface.GetUserCustomProps(apiVersion);
                        console.log(`GetUserCustomProps called successfully on Android`);
                    } catch (error) {
                        console.error(`GetUserCustomProps failed on Android: ${error.message}`, error);
                    }
                } else if (isIOS()) {
                    try {
                        window.webkit.messageHandlers.GetUserCustomProps.postMessage({apiVersion});
                        console.log(`GetUserCustomProps called successfully on iOS`);
                    } catch (error) {
                        console.error(`GetUserCustomProps failed on IOS: ${error.message}`, error);
                    }
                } else {
                    console.error('GetUserCustomProps is not supported on this platform.');
                }
            };

    const PutUserCustomProps = (apiVersion, data) => {
                    if (isAndroid()) {
                        try {
                            window.H5GameInterface.PutUserCustomProps(apiVersion, data);
                            console.log(`PutUserCustomProps called successfully on Android`);
                        } catch (error) {
                            console.error(`PutUserCustomProps failed on Android: ${error.message}`, error);
                        }
                    } else if (isIOS()) {
                        try {
                            window.webkit.messageHandlers.PutUserCustomProps.postMessage({apiVersion, data});
                            console.log(`PutUserCustomProps called successfully on iOS`);
                        } catch (error) {
                            console.error(`PutUserCustomProps failed on IOS: ${error.message}`, error);
                        }
                    } else {
                        console.error('PutUserCustomProps is not supported on this platform.');
                    }
                };

    const ConsumeItemUsing = (apiVersion, orderId, productionId, quantity) => {
                    if (isAndroid()) {
                        try {
                            window.H5GameInterface.ConsumeItemUsing(apiVersion, orderId, productionId, quantity);
                            console.log(`ConsumeItemUsing called successfully on Android`);
                        } catch (error) {
                            console.error(`ConsumeItemUsing failed on Android: ${error.message}`, error);
                        }
                    } else if (isIOS()) {
                        try {
                            window.webkit.messageHandlers.ConsumeItemUsing.postMessage({apiVersion, orderId, productionId, quantity});
                            console.log(`ConsumeItemUsing called successfully on iOS`);
                        } catch (error) {
                            console.error(`ConsumeItemUsing failed on IOS: ${error.message}`, error);
                        }
                    } else {
                        console.error('ConsumeItemUsing is not supported on this platform.');
                    }
                };

    const PurchaseItemUsing = (apiVersion, orderId, productionId, quantity) => {
                    if (isAndroid()) {
                        try {
                            window.H5GameInterface.PurchaseItemUsing(apiVersion, orderId, productionId, quantity);
                            console.log(`PurchaseItemUsing called successfully on Android ${quantity}`);
                        } catch (error) {
                            console.error(`PurchaseItemUsing failed on Android: ${error.message}`, error);
                        }
                    } else if (isIOS()) {
                        try {
                            window.webkit.messageHandlers.PurchaseItemUsing.postMessage({apiVersion, orderId, productionId, quantity});
                            console.log(`PurchaseItemUsing called successfully on iOS`);
                        } catch (error) {
                            console.error(`PurchaseItemUsing failed on IOS: ${error.message}`, error);
                        }
                    } else {
                        console.error('PurchaseItemUsing is not supported on this platform.');
                    }
                };

    // 8. Clan System
    const CreateClan = (userId, clanName, description) => {
        console.log(`Creating clan: ${clanName}`);
        fetch('https://bmgo-service.onrender.com/api/v1/clan/create', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ userId, clanName, description })
        })
        .then(response => response.json())
        .then(data => {
            if (data.status === 200) {
                console.log(`✓ Clan created: ${clanName}`, data.data);
            } else {
                console.error(`Clan creation failed: ${data.error}`);
            }
        })
        .catch(error => console.error(`Clan creation error: ${error.message}`));
    };

    const JoinClan = (userId, clanId) => {
        console.log(`Joining clan: ${clanId}`);
        fetch('https://bmgo-service.onrender.com/api/v1/clan/join', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ userId, clanId })
        })
        .then(response => response.json())
        .then(data => {
            if (data.status === 200) {
                console.log(`✓ Joined clan:`, data.data);
            } else {
                console.error(`Join failed: ${data.error}`);
            }
        })
        .catch(error => console.error(`Join error: ${error.message}`));
    };

    const GetClanInfo = (clanId, callback) => {
        console.log(`Fetching clan info: ${clanId}`);
        fetch(`https://bmgo-service.onrender.com/api/v1/clan/${clanId}`)
        .then(response => response.json())
        .then(data => {
            if (data.status === 200) {
                console.log(`✓ Clan info fetched:`, data.data);
                if (callback) callback(data.data);
            } else {
                console.error(`Fetch failed: ${data.error}`);
            }
        })
        .catch(error => console.error(`Fetch error: ${error.message}`));
    };

    const LeaveClan = (userId, clanId) => {
        console.log(`Leaving clan: ${clanId}`);
        fetch('https://bmgo-service.onrender.com/api/v1/clan/leave', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ userId, clanId })
        })
        .then(response => response.json())
        .then(data => {
            if (data.status === 200) {
                console.log(`✓ Left clan successfully`);
            } else {
                console.error(`Leave failed: ${data.error}`);
            }
        })
        .catch(error => console.error(`Leave error: ${error.message}`));
    };

    const PromoteMember = (clanId, userId, targetUserId) => {
        console.log(`Promoting member: ${targetUserId} in clan: ${clanId}`);
        fetch('https://bmgo-service.onrender.com/api/v1/clan/promote', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ clanId, userId, targetUserId })
        })
        .then(response => response.json())
        .then(data => {
            if (data.status === 200) {
                console.log(`✓ Member promoted:`, data.data);
            } else {
                console.error(`Promote failed: ${data.error}`);
            }
        })
        .catch(error => console.error(`Promote error: ${error.message}`));
    };

    // 9. APK Update Checker System
    const CheckForUpdate = async () => {
        try {
            console.log("🔍 Checking for APK updates...");
            
            // Get current version from device (fallback to 1.0.0)
            const currentVersion = window.H5GameInterface?.GetAppVersion?.() || "1.0.0";
            console.log(`📱 Current version: ${currentVersion}`);
            
            // Fetch latest release info from GitHub
            const response = await fetch('https://api.github.com/repos/Raft-The-Crab/Bmgo/releases/latest');
            const data = await response.json();
            
            if (!data.tag_name) {
                console.log("No release found on GitHub");
                return { hasUpdate: false };
            }
            
            const latestVersion = data.tag_name.replace(/^v/, '');
            const downloadUrl = data.assets[0]?.browser_download_url || data.html_url;
            
            console.log(`🔖 Latest version: ${latestVersion}`);
            
            // Compare versions
            const hasUpdate = compareVersions(latestVersion, currentVersion) > 0;
            
            if (hasUpdate) {
                console.log(`✓ Update available! ${currentVersion} → ${latestVersion}`);
                return {
                    hasUpdate: true,
                    latestVersion,
                    downloadUrl,
                    releaseNotes: data.body || "New version available",
                    publishedAt: data.published_at
                };
            } else {
                console.log("✓ You're running the latest version");
                return { hasUpdate: false, currentVersion };
            }
        } catch (error) {
            console.error("Update check failed:", error.message);
            return { hasUpdate: false, error: error.message };
        }
    };

    // Version comparison helper (returns 1 if newer, -1 if older, 0 if same)
    const compareVersions = (v1, v2) => {
        const parts1 = v1.split('.').map(x => parseInt(x) || 0);
        const parts2 = v2.split('.').map(x => parseInt(x) || 0);
        
        for (let i = 0; i < Math.max(parts1.length, parts2.length); i++) {
            const num1 = parts1[i] || 0;
            const num2 = parts2[i] || 0;
            
            if (num1 > num2) return 1;
            if (num1 < num2) return -1;
        }
        return 0;
    };

    // Show Update Dialog
    const ShowUpdateDialog = (updateInfo, onDownload, onSkip) => {
        console.log("📲 Showing update dialog...");
        
        const dialog = document.createElement('div');
        dialog.id = 'bmgo-update-dialog';
        dialog.style.cssText = `
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0,0,0,0.7);
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 9999;
            font-family: Arial, sans-serif;
        `;
        
        const content = document.createElement('div');
        content.style.cssText = `
            background: white;
            border-radius: 10px;
            padding: 20px;
            max-width: 500px;
            width: 90%;
            box-shadow: 0 4px 6px rgba(0,0,0,0.3);
            text-align: center;
        `;
        
        content.innerHTML = `
            <h2 style="margin: 0 0 10px 0; color: #333;">Update Available!</h2>
            <p style="color: #666; margin: 10px 0;">
                Current: <strong>${updateInfo.currentVersion}</strong> → Latest: <strong>${updateInfo.latestVersion}</strong>
            </p>
            <p style="color: #555; margin: 15px 0; font-size: 14px; text-align: left; max-height: 200px; overflow-y: auto;">
                ${updateInfo.releaseNotes || 'New features and improvements available'}
            </p>
            <div style="display: flex; gap: 10px; margin-top: 20px;">
                <button onclick="document.getElementById('bmgo-update-dialog').remove()" 
                    style="flex: 1; padding: 12px; background: #ccc; border: none; border-radius: 5px; cursor: pointer; font-size: 16px;">
                    Skip
                </button>
                <button onclick="location.href='${updateInfo.downloadUrl}'" 
                    style="flex: 1; padding: 12px; background: #4CAF50; color: white; border: none; border-radius: 5px; cursor: pointer; font-size: 16px;">
                    Download Now
                </button>
            </div>
        `;
        
        dialog.appendChild(content);
        document.body.appendChild(dialog);
    };

    // Auto-check for updates on startup
    const InitializeUpdateCheck = () => {
        console.log("🚀 Initializing update checker...");
        
        // Check for updates every hour
        setInterval(async () => {
            const updateInfo = await CheckForUpdate();
            
            if (updateInfo.hasUpdate) {
                console.log(`⚠️ UPDATE ALERT: Version ${updateInfo.latestVersion} available!`);
                
                // Show dialog only if HTML document is available
                if (document && document.body) {
                    ShowUpdateDialog(updateInfo);
                }
            }
        }, 3600000); // 1 hour
        
        // Initial check after 10 seconds
        setTimeout(async () => {
            const updateInfo = await CheckForUpdate();
            if (updateInfo.hasUpdate && typeof window.H5GameInterface?.NotifyUpdate === 'function') {
                window.H5GameInterface.NotifyUpdate(updateInfo.latestVersion, updateInfo.downloadUrl);
            }
        }, 10000);
    };

    // 导出公共 API
    return {
        BMGLogin,
        Buy,
        ShowAd,
        ExitGame,
        GetLanguage,
        GoogleAuth,
        GetUserCustomProps,
        PutUserCustomProps,
        ConsumeItemUsing,
        PurchaseItemUsing,
        CreateClan,
        JoinClan,
        GetClanInfo,
        LeaveClan,
        PromoteMember,
        CheckForUpdate,
        ShowUpdateDialog,
        InitializeUpdateCheck,
        compareVersions,
    };
})();

// CommonJS 模块支持
if (typeof module !== 'undefined' && module.exports) {
    module.exports = BlockmanGoSDK;
}

// 浏览器环境直接挂载到全局对象
if (typeof window !== 'undefined') {
    window.BlockmanGoSDK = BlockmanGoSDK;
}
