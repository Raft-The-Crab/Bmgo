const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const bodyParser = require('body-parser');
const axios = require('axios');
const multer = require('multer');
const cloudinary = require('cloudinary').v2;
const rateLimit = require('express-rate-limit');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3000;

// Cloudinary for Voice Chat Storage (Free Tier)
cloudinary.config({
    cloud_name: process.env.CLOUDINARY_NAME,
    api_key: process.env.CLOUDINARY_KEY,
    api_secret: process.env.CLOUDINARY_SECRET
});

const upload = multer({ dest: 'uploads/' });

// Production Middleware
app.use(cors());
app.use(bodyParser.json());

// Rate Limiting
const limiter = rateLimit({
    windowMs: 15 * 60 * 1000, // 15 minutes
    max: 100, // limit each IP to 100 requests per windowMs
    message: "Too many requests from this IP, please try again later."
});
app.use('/api/', limiter);

// --- MONGODB CONNECTION & ROTATION ---
const dbUris = [process.env.MONGO_URI_A, process.env.MONGO_URI_B];
let currentDbIndex = 0;

// Enhanced User Schema with earning systems
const userSchema = new mongoose.Schema({
    userId: { type: String, unique: true, required: true },
    username: String,
    level: { type: Number, default: 1 },
    experience: { type: Number, default: 0 },
    gcubes: { type: Number, default: 1000000 },
    diamonds: { type: Number, default: 50000 },
    vipLevel: { type: Number, default: 3 }, // MVP Tier
    
    // Daily Rewards Tracking
    lastLoginAt: { type: Date, default: null },
    loginStreak: { type: Number, default: 0 },
    totalLoginDays: { type: Number, default: 0 },
    
    // Earning Tracking
    totalGcubesEarned: { type: Number, default: 1000000 },
    totalGcubesSpent: { type: Number, default: 0 },
    
    // Referral System
    referralCode: { type: String, unique: true, sparse: true },
    referredBy: { type: String, default: null },
    referralCount: { type: Number, default: 0 },
    referralEarnings: { type: Number, default: 0 },
    
    // Account Status
    isBanned: { type: Boolean, default: false },
    bantReason: { type: String, default: null },
    lastActionTime: { type: Date, default: Date.now },
    
    // Statistics
    battleWins: { type: Number, default: 0 },
    battleLosses: { type: Number, default: 0 },
    levelsCompleted: { type: Number, default: 0 },
    questsCompleted: { type: Number, default: 0 },
    
    createdAt: { type: Date, default: Date.now },
    updatedAt: { type: Date, default: Date.now }
});

const User = mongoose.model('User', userSchema);

// Quest Schema
const questSchema = new mongoose.Schema({
    questId: { type: String, unique: true, required: true },
    title: String,
    description: String,
    type: { type: String, enum: ['daily', 'weekly', 'special'], default: 'daily' },
    reward: { type: Number, default: 5000 }, // Gcubes
    requirement: Number, // e.g., complete 3 levels
    progress: [{ userId: String, completed: Number }],
    createdAt: { type: Date, default: Date.now },
    expiresAt: Date
});
const Quest = mongoose.model('Quest', questSchema);

// Battle Result Schema
const battleSchema = new mongoose.Schema({
    battleId: { type: String, unique: true },
    player1: String,
    player2: String,
    winner: String,
    loser: String,
    prizePool: { type: Number, default: 2000 },
    timestamp: { type: Date, default: Date.now }
});
const Battle = mongoose.model('Battle', battleSchema);

// Leaderboard Entry Schema
const leaderboardSchema = new mongoose.Schema({
    userId: { type: String, unique: true },
    username: String,
    gcubes: Number,
    level: Number,
    battleWins: Number,
    vipLevel: Number,
    timestamp: { type: Date, default: Date.now }
});
const Leaderboard = mongoose.model('Leaderboard', leaderboardSchema);

async function connectToDatabase() {
    const uri = dbUris[currentDbIndex];
    if (!uri) return console.log("Waiting for .env MongoDB URIs...");
    try {
        await mongoose.connect(uri);
        console.log(`✓ LIVE: Connected to MongoDB Instance ${currentDbIndex === 0 ? 'A' : 'B'}`);
    } catch (err) {
        console.error("❌ DB Error:", err);
    }
}

// --- AUTOMATED ARCHIVE & RESET (DATABASE CYCLE) ---
async function archiveAndReset() {
    console.log("📦 Starting DB Cycle: Archiving to GitHub...");
    try {
        const users = await User.find({});
        const data = JSON.stringify({ users, archiveDate: new Date().toISOString() }, null, 2);
        const fileName = `archive_${Date.now()}.json`;

        await axios.put(`https://api.github.com/repos/${process.env.REPO_NAME}/contents/archives/${fileName}`, {
            message: `Automated DB Archive ${new Date().toISOString()}`,
            content: Buffer.from(data).toString('base64'),
            branch: "main"
        }, {
            headers: { Authorization: `token ${process.env.GITHUB_TOKEN}` }
        });

        console.log("✓ Archive Successful. Rotating DB instance...");
        await User.deleteMany({});
        currentDbIndex = (currentDbIndex + 1) % dbUris.length;
        await mongoose.connection.close();
        await connectToDatabase();
    } catch (err) {
        console.error("❌ ARCHIVE FAILED:", err.message);
    }
}

// --- EARNING SYSTEM FUNCTIONS ---

// Generate Referral Code
const generateReferralCode = (userId) => {
    return `BMG${userId.substring(0, 4).toUpperCase()}${Math.random().toString(36).substring(2, 8).toUpperCase()}`;
};

// Calculate XP Needed for Next Level
const xpForLevel = (level) => (level * 500) + (level * level * 100);

// Level Up Check
const checkLevelUp = async (user) => {
    let levelsGained = 0;
    while (user.experience >= xpForLevel(user.level)) {
        user.experience -= xpForLevel(user.level);
        user.level += 1;
        user.gcubes += 10000; // Bonus for leveling up
        levelsGained += 1;
    }
    if (levelsGained > 0) {
        await user.save();
        return { levelsGained, newLevel: user.level, bonusGcubes: 10000 * levelsGained };
    }
    return null;
};

// Update Leaderboard
const updateLeaderboard = async (userId) => {
    const user = await User.findOne({ userId });
    if (!user) return;
    
    await Leaderboard.findOneAndUpdate(
        { userId },
        {
            username: user.username,
            gcubes: user.gcubes,
            level: user.level,
            battleWins: user.battleWins,
            vipLevel: user.vipLevel,
            timestamp: new Date()
        },
        { upsert: true }
    );
};

// --- CORE GAME ENDPOINTS ---

// 1. User Profile + Auto-Setup
app.get('/api/v1/user/profile/:userId', async (req, res) => {
    try {
        let user = await User.findOne({ userId: req.params.userId });
        if (!user) {
            const referralCode = generateReferralCode(req.params.userId);
            user = await User.create({
                userId: req.params.userId,
                username: `Player_${req.params.userId.slice(-4)}`,
                referralCode
            });
            console.log(`✓ New user created: ${user.username} (Code: ${referralCode})`);
        }
        
        // Check for level up
        const levelUp = await checkLevelUp(user);
        const responseData = user.toObject();
        if (levelUp) responseData.levelUp = levelUp;
        
        res.json({ status: 200, data: responseData });
    } catch (err) {
        res.status(500).json({ status: 500, error: err.message });
    }
});

// 2. Daily Login Rewards (Main Earning Method #1)
app.post('/api/v1/rewards/daily-login', async (req, res) => {
    const { userId } = req.body;
    try {
        const user = await User.findOne({ userId });
        if (!user) return res.status(400).json({ error: "User not found" });

        const today = new Date().toDateString();
        const lastLogin = user.lastLoginAt ? new Date(user.lastLoginAt).toDateString() : null;

        let reward = 5000; // Base daily reward
        let streakBonus = 0;
        let newStreak = user.loginStreak;

        if (lastLogin === today) {
            return res.status(400).json({ error: "Already claimed daily reward today" });
        }

        if (lastLogin !== today && lastLogin !== new Date(Date.now() - 86400000).toDateString()) {
            newStreak = 1; // Reset streak
        } else {
            newStreak = user.loginStreak + 1;
            streakBonus = Math.min(newStreak * 1000, 10000); // Cap at 10k bonus
        }

        // VIP Multiplier
        const vipMultiplier = [1.0, 1.2, 1.5, 2.0][user.vipLevel] || 1.0;
        const finalReward = Math.floor((reward + streakBonus) * vipMultiplier);

        user.gcubes += finalReward;
        user.totalGcubesEarned += finalReward;
        user.experience += Math.floor(finalReward / 10);
        user.lastLoginAt = new Date();
        user.loginStreak = newStreak;
        user.totalLoginDays += 1;
        await user.save();

        // Check for level up
        const levelUp = await checkLevelUp(user);
        await updateLeaderboard(userId);

        res.json({
            status: 200,
            message: "Daily reward claimed!",
            reward: finalReward,
            streak: newStreak,
            streakBonus,
            vipMultiplier,
            newBalance: user.gcubes,
            levelUp: levelUp || null
        });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// 3. Quest System (Main Earning Method #2)
app.get('/api/v1/quests', async (req, res) => {
    try {
        const now = new Date();
        const activeQuests = await Quest.find({
            $or: [
                { type: 'daily', expiresAt: { $gt: now } },
                { type: 'weekly', expiresAt: { $gt: now } },
                { type: 'special' }
            ]
        });
        res.json({ status: 200, data: activeQuests });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

app.post('/api/v1/quests/complete', async (req, res) => {
    const { userId, questId, progress } = req.body;
    try {
        const user = await User.findOne({ userId });
        const quest = await Quest.findOne({ questId });

        if (!user) return res.status(400).json({ error: "User not found" });
        if (!quest) return res.status(400).json({ error: "Quest not found" });

        if (progress >= quest.requirement) {
            // VIP Multiplier for quest rewards
            const vipMultiplier = [1.0, 1.2, 1.5, 2.0][user.vipLevel] || 1.0;
            const reward = Math.floor(quest.reward * vipMultiplier);

            user.gcubes += reward;
            user.totalGcubesEarned += reward;
            user.experience += Math.floor(reward / 5);
            user.questsCompleted += 1;
            await user.save();

            const levelUp = await checkLevelUp(user);
            await updateLeaderboard(userId);

            res.json({
                status: 200,
                message: `Quest completed: ${quest.title}`,
                reward,
                progress: quest.requirement,
                newBalance: user.gcubes,
                levelUp: levelUp || null
            });
        } else {
            res.json({ status: 200, message: "Progress updated", progress, required: quest.requirement });
        }
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// 4. Level Completion Rewards (Main Earning Method #3)
app.post('/api/v1/game/complete-level', async (req, res) => {
    const { userId, levelId } = req.body;
    try {
        const user = await User.findOne({ userId });
        if (!user) return res.status(400).json({ error: "User not found" });

        // Base reward: 1000 * level
        let reward = 1000 * levelId;
        
        // Difficulty multiplier
        const difficulty = levelId < 10 ? 1.0 : levelId < 30 ? 1.5 : 2.0;
        reward = Math.floor(reward * difficulty);
        
        // VIP Multiplier
        const vipMultiplier = [1.0, 1.2, 1.5, 2.0][user.vipLevel] || 1.0;
        reward = Math.floor(reward * vipMultiplier);

        user.gcubes += reward;
        user.totalGcubesEarned += reward;
        user.experience += Math.floor(reward / 3);
        user.levelsCompleted += 1;
        await user.save();

        const levelUp = await checkLevelUp(user);
        await updateLeaderboard(userId);

        res.json({
            status: 200,
            message: `Level ${levelId} completed!`,
            reward,
            baseReward: 1000 * levelId,
            difficultyMultiplier: difficulty,
            vipMultiplier,
            newBalance: user.gcubes,
            experience: user.experience,
            level: user.level,
            levelUp: levelUp || null
        });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// 5. Battle System (Main Earning Method #4)
app.post('/api/v1/battle/start', async (req, res) => {
    const { userId1, userId2 } = req.body;
    try {
        const user1 = await User.findOne({ userId: userId1 });
        const user2 = await User.findOne({ userId: userId2 });

        if (!user1 || !user2) return res.status(400).json({ error: "One or both players not found" });

        // Determine winner (random)
        const isPlayer1Winner = Math.random() > 0.5;
        const winner = isPlayer1Winner ? user1 : user2;
        const loser = isPlayer1Winner ? user2 : user1;

        // Prize pool (VIP players win more)
        const vipWinnerMultiplier = [1.0, 1.3, 1.6, 2.0][winner.vipLevel] || 1.0;
        const prizePool = Math.floor(5000 * vipWinnerMultiplier);

        // Update winner
        winner.gcubes += prizePool;
        winner.totalGcubesEarned += prizePool;
        winner.battleWins += 1;
        winner.experience += Math.floor(prizePool / 2);
        await winner.save();

        // Update loser (participation reward)
        const participationReward = Math.floor(1000 * (1 + loser.vipLevel * 0.2));
        loser.gcubes += participationReward;
        loser.totalGcubesEarned += participationReward;
        loser.battleLosses += 1;
        loser.experience += Math.floor(participationReward / 2);
        await loser.save();

        // Create battle record
        const battleId = `battle_${Date.now()}`;
        await Battle.create({
            battleId,
            player1: userId1,
            player2: userId2,
            winner: winner.userId,
            loser: loser.userId,
            prizePool
        });

        // Check level ups
        const winner_levelUp = await checkLevelUp(winner);
        const loser_levelUp = await checkLevelUp(loser);

        await updateLeaderboard(userId1);
        await updateLeaderboard(userId2);

        res.json({
            status: 200,
            message: `Battle completed! ${winner.username} wins!`,
            winner: { userId: winner.userId, prize: prizePool, levelUp: winner_levelUp },
            loser: { userId: loser.userId, prize: participationReward, levelUp: loser_levelUp }
        });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// 6. Referral System (Secondary Earning Method)
app.post('/api/v1/referral/use-code', async (req, res) => {
    const { userId, referralCode } = req.body;
    try {
        const referrer = await User.findOne({ referralCode });
        if (!referrer) return res.status(400).json({ error: "Invalid referral code" });

        const player = await User.findOne({ userId });
        if (!player) return res.status(400).json({ error: "Player not found" });

        if (player.referredBy) return res.status(400).json({ error: "Already used a referral code" });

        // Sign-up bonus for new player
        const signupBonus = 50000;
        player.gcubes += signupBonus;
        player.totalGcubesEarned += signupBonus;
        player.referredBy = referrer.userId;
        await player.save();

        // Referral bonus for referrer
        const referralBonus = 10000;
        referrer.gcubes += referralBonus;
        referrer.totalGcubesEarned += referralBonus;
        referrer.referralCount += 1;
        referrer.referralEarnings += referralBonus;
        await referrer.save();

        await updateLeaderboard(userId);
        await updateLeaderboard(referrer.userId);

        res.json({
            status: 200,
            message: "Referral applied successfully!",
            playerBonus: signupBonus,
            referrerBonus: referralBonus,
            playerNewBalance: player.gcubes,
            referrerNewBalance: referrer.gcubes
        });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// 7. Leaderboard
app.get('/api/v1/leaderboard', async (req, res) => {
    try {
        const top100 = await Leaderboard.find()
            .sort({ gcubes: -1 })
            .limit(100);
        res.json({ status: 200, data: top100 });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

app.get('/api/v1/leaderboard/rank/:userId', async (req, res) => {
    try {
        const user = await Leaderboard.findOne({ userId: req.params.userId });
        if (!user) return res.status(400).json({ error: "User not on leaderboard" });

        const betterPlayers = await Leaderboard.countDocuments({ gcubes: { $gt: user.gcubes } });
        res.json({ status: 200, rank: betterPlayers + 1, data: user });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// 8. Cosmetics Shop System (Spending System)
const cosmeticsDatabase = [
    { id: 1, name: "Red Hoodie", type: "shirt", price: 50000, rarity: "common" },
    { id: 2, name: "Golden Crown", type: "hat", price: 100000, rarity: "rare" },
    { id: 3, name: "Diamond Armor", type: "suit", price: 250000, rarity: "epic" },
    { id: 4, name: "Rainbow Wings", type: "back", price: 350000, rarity: "legendary" },
    { id: 5, name: "Fire Helmet", type: "hat", price: 75000, rarity: "rare" },
    { id: 6, name: "Ocean Suit", type: "suit", price: 200000, rarity: "rare" },
    { id: 7, name: "Neon Jacket", type: "shirt", price: 120000, rarity: "epic" },
    { id: 8, name: "Star Cape", type: "back", price: 300000, rarity: "epic" }
];

const inventorySchema = new mongoose.Schema({
    userId: { type: String, unique: true, required: true },
    cosmetics: [{ cosmeticId: Number, purchasedAt: { type: Date, default: Date.now } }]
});
const Inventory = mongoose.model('Inventory', inventorySchema);

app.get('/api/v1/shop/cosmetics', async (req, res) => {
    try {
        res.json({ status: 200, data: cosmeticsDatabase });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

app.post('/api/v1/shop/buy-cosmetic', async (req, res) => {
    const { userId, cosmeticId } = req.body;
    try {
        const cosmetic = cosmeticsDatabase.find(c => c.id === cosmeticId);
        if (!cosmetic) return res.status(400).json({ error: "Cosmetic not found" });

        const user = await User.findOne({ userId });
        if (!user) return res.status(400).json({ error: "User not found" });

        let inventory = await Inventory.findOne({ userId });
        if (!inventory) inventory = await Inventory.create({ userId });
        
        const alreadyOwned = inventory.cosmetics.some(c => c.cosmeticId === cosmeticId);
        if (alreadyOwned) return res.status(400).json({ error: "Already own this cosmetic" });

        if (user.gcubes < cosmetic.price) {
            return res.status(400).json({ error: "Insufficient Gcubes", needed: cosmetic.price, have: user.gcubes });
        }

        user.gcubes -= cosmetic.price;
        user.totalGcubesSpent += cosmetic.price;
        await user.save();

        inventory.cosmetics.push({ cosmeticId });
        await inventory.save();

        await updateLeaderboard(userId);

        res.json({
            status: 200,
            message: `Purchased ${cosmetic.name}!`,
            cosmeticName: cosmetic.name,
            gcubesRemaining: user.gcubes
        });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// 9. VIP System
const vipPrivileges = [
    { level: 0, name: "None", multipliers: { currency: 1.0, experience: 1.0, donation: 1.0 } },
    { level: 1, name: "VIP", multipliers: { currency: 1.2, experience: 1.2, donation: 1.5 } },
    { level: 2, name: "VIP+", multipliers: { currency: 1.5, experience: 1.5, donation: 2.0 } },
    { level: 3, name: "MVP", multipliers: { currency: 2.0, experience: 2.0, donation: 3.0 } }
];

app.post('/api/v1/vip/purchase', async (req, res) => {
    const { userId, vipLevel } = req.body;
    try {
        if (!Number.isInteger(vipLevel) || vipLevel < 0 || vipLevel > 3) {
            return res.status(400).json({ error: "Invalid VIP level (0-3)" });
        }

        let user = await User.findOne({ userId });
        if (!user) user = await User.create({ userId });

        user.vipLevel = vipLevel;
        await user.save();
        await updateLeaderboard(userId);

        res.json({
            status: 200,
            message: `VIP Level upgraded to ${vipLevel}`,
            success: true,
            data: { userId: user.userId, vipLevel: user.vipLevel, gcubes: user.gcubes }
        });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

app.get('/api/v1/vip/privileges/:level', async (req, res) => {
    const level = parseInt(req.params.level);
    const privilege = vipPrivileges.find(p => p.level === level);
    if (!privilege) return res.status(400).json({ error: "Invalid VIP level" });
    res.json({ status: 200, data: privilege });
});

// 10. Admin Panel
app.get('/api/admin/stats', async (req, res) => {
    if (req.headers['x-admin-key'] !== process.env.ADMIN_KEY) {
        return res.status(403).json({ error: "Unauthorized" });
    }
    
    try {
        const totalUsers = await User.countDocuments();
        const totalGcubesInGame = await User.aggregate([{ $group: { _id: null, total: { $sum: "$gcubes" } } }]);
        const topPlayers = await User.find().sort({ gcubes: -1 }).limit(10);
        
        res.json({
            status: 200,
            stats: {
                totalUsers,
                totalGcubesInGame: totalGcubesInGame[0]?.total || 0,
                topPlayers
            }
        });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

app.post('/api/admin/rotate', async (req, res) => {
    if (req.headers['x-admin-key'] !== process.env.ADMIN_KEY) return res.status(403).json({ error: "Unauthorized" });
    await archiveAndReset();
    res.json({ message: "Rotation triggered successfully" });
});

// Health Check
app.get('/api/health', (req, res) => {
    res.json({ status: 200, message: "Backend is running", timestamp: new Date() });
});

// Admin Dashboard
app.get('/admin', (req, res) => {
    res.sendFile(__dirname + '/admin-dashboard.html');
});

// Start Server
app.listen(PORT, async () => {
    await connectToDatabase();
    console.log(`
╔═══════════════════════════════════════════════════════════╗
║     BLOCKMAN GO - COMMUNITY EDITION BACKEND READY        ║
║            Production Server on Port ${PORT}            ║
╚═══════════════════════════════════════════════════════════╝
    `);
});

module.exports = app;
