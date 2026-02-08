const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const bodyParser = require('body-parser');
const axios = require('axios');
const multer = require('multer');
const cloudinary = require('cloudinary').v2;
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

// --- MONGODB CONNECTION & ROTATION ---
const dbUris = [process.env.MONGO_URI_A, process.env.MONGO_URI_B];
let currentDbIndex = 0;

const userSchema = new mongoose.Schema({
    userId: { type: String, unique: true, required: true },
    username: String,
    gcubes: { type: Number, default: 1000000 },
    diamonds: { type: Number, default: 50000 },
    vipLevel: { type: Number, default: 3 }, // MVP Tier
    lastDonationTime: { type: Date, default: null },
    nextActionAvailableAt: { type: Date, default: Date.now },
    isBanned: { type: Boolean, default: false }
});

const User = mongoose.model('User', userSchema);

async function connectToDatabase() {
    const uri = dbUris[currentDbIndex];
    if (!uri) return console.log("Waiting for .env MongoDB URIs...");
    try {
        await mongoose.connect(uri);
        console.log(`LIVE: Connected to MongoDB Instance ${currentDbIndex === 0 ? 'A' : 'B'}`);
    } catch (err) {
        console.error("DB Error:", err);
    }
}

// --- AUTOMATED ARCHIVE & RESET (DATABASE CYCLE) ---
async function archiveAndReset() {
    console.log("Starting DB Cycle: Archiving to GitHub...");
    try {
        const users = await User.find({});
        const data = JSON.stringify(users, null, 2);
        const fileName = `archive_${Date.now()}.json`;

        await axios.put(`https://api.github.com/repos/${process.env.REPO_NAME}/contents/archives/${fileName}`, {
            message: `Automated DB Archive ${new Date().toISOString()}`,
            content: Buffer.from(data).toString('base64'),
            branch: "main"
        }, {
            headers: { Authorization: `token ${process.env.GITHUB_TOKEN}` }
        });

        console.log("Archive Successful. Wiping DB...");
        await User.deleteMany({});
        currentDbIndex = (currentDbIndex + 1) % dbUris.length;
        await mongoose.connection.close();
        await connectToDatabase();
    } catch (err) {
        console.error("ARCHIVE FAILED:", err.message);
    }
}

// --- CORE GAME ENDPOINTS ---

// 1. User Profile Loader
app.get('/api/v1/user/profile/:userId', async (req, res) => {
    try {
        let user = await User.findOne({ userId: req.params.userId });
        if (!user) user = await User.create({ userId: req.params.userId, username: `Player_${req.params.userId.slice(-4)}` });
        res.json({ status: 200, data: user });
    } catch (err) {
        res.status(500).json({ status: 500, error: err.message });
    }
});

// 2. Clan Donation System (Fair Play Rule)
app.post('/api/v1/clan/donate', async (req, res) => {
    const { userId, amount } = req.body;
    try {
        const user = await User.findOne({ userId });
        if (!user || user.gcubes < amount) return res.status(400).json({ error: "Insufficient Gcubes" });

        let waitHours = 1;
        if (amount > 50000) waitHours = 24;
        else if (amount > 10000) waitHours = 6;

        let nextAction = new Date();
        nextAction.setHours(nextAction.getHours() + waitHours);

        user.gcubes -= amount;
        user.nextActionAvailableAt = nextAction;
        await user.save();

        res.json({ status: 200, message: "Donation processed", waitDuration: `${waitHours}h`, unlocksAt: nextAction });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// 3. Cosmetics Shop System
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

// Inventory schema
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

app.get('/api/v1/inventory/:userId', async (req, res) => {
    try {
        let inventory = await Inventory.findOne({ userId: req.params.userId });
        if (!inventory) {
            inventory = await Inventory.create({ userId: req.params.userId });
        }
        res.json({ status: 200, data: inventory.cosmetics });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

app.post('/api/v1/shop/buy-cosmetic', async (req, res) => {
    const { userId, cosmeticId } = req.body;
    try {
        // Find cosmetic
        const cosmetic = cosmeticsDatabase.find(c => c.id === cosmeticId);
        if (!cosmetic) return res.status(400).json({ error: "Cosmetic not found" });

        // Get user
        const user = await User.findOne({ userId });
        if (!user) return res.status(400).json({ error: "User not found" });

        // Check if already owned
        let inventory = await Inventory.findOne({ userId });
        if (!inventory) inventory = await Inventory.create({ userId });
        
        const alreadyOwned = inventory.cosmetics.some(c => c.cosmeticId === cosmeticId);
        if (alreadyOwned) return res.status(400).json({ error: "Already own this cosmetic" });

        // Check Gcubes
        if (user.gcubes < cosmetic.price) {
            return res.status(400).json({ error: "Insufficient Gcubes", needed: cosmetic.price, have: user.gcubes });
        }

        // Process purchase
        user.gcubes -= cosmetic.price;
        await user.save();

        inventory.cosmetics.push({ cosmeticId });
        await inventory.save();

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

// 3. Social: Message Reactions
const reactionsSchema = new mongoose.Schema({
    messageId: { type: String, unique: true },
    reactions: [{ userId: String, emoji: String }]
});
const Reaction = mongoose.model('Reaction', reactionsSchema);

app.post('/api/v1/chat/react', async (req, res) => {
    const { messageId, userId, emoji } = req.body;
    try {
        await Reaction.findOneAndUpdate(
            { messageId },
            { $push: { reactions: { userId, emoji } } },
            { upsert: true }
        );
        res.json({ status: 200, success: true });
    } catch (err) { res.status(500).json({ error: err.message }); }
});

app.get('/api/v1/chat/reactions/:messageId', async (req, res) => {
    const doc = await Reaction.findOne({ messageId: req.params.messageId });
    res.json({ status: 200, data: doc ? doc.reactions : [] });
});

// 4. Social: Voice Chat Upload
app.post('/api/v1/voice/upload', upload.single('voice'), async (req, res) => {
    try {
        const result = await cloudinary.uploader.upload(req.file.path, { resource_type: "raw", folder: "voice_chat" });
        res.json({ status: 200, url: result.secure_url });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// 4. VIP Purchase System (FAKE - No payment, instant unlock)
app.post('/api/v1/vip/purchase', async (req, res) => {
    const { userId, vipLevel } = req.body;
    try {
        // Validate VIP level (0-3: None, VIP, VIP+, MVP)
        if (!Number.isInteger(vipLevel) || vipLevel < 0 || vipLevel > 3) {
            return res.status(400).json({ error: "Invalid VIP level (0-3)" });
        }

        let user = await User.findOne({ userId });
        if (!user) {
            user = await User.create({ userId });
        }

        // FAKE PURCHASE: No actual payment, just update level
        user.vipLevel = vipLevel;
        await user.save();

        // Return success with user data
        res.json({
            status: 200,
            message: `VIP Level upgraded to ${vipLevel}`,
            success: true,
            data: {
                userId: user.userId,
                vipLevel: user.vipLevel,
                gcubes: user.gcubes
            }
        });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// 5. Get VIP Privileges (based on level)
const vipPrivileges = [
    { level: 0, name: "None", multipliers: { currency: 1.0, experience: 1.0, donation: 1.0 } },
    { level: 1, name: "VIP", multipliers: { currency: 1.2, experience: 1.2, donation: 1.5 } },
    { level: 2, name: "VIP+", multipliers: { currency: 1.5, experience: 1.5, donation: 2.0 } },
    { level: 3, name: "MVP", multipliers: { currency: 2.0, experience: 2.0, donation: 3.0 } }
];

app.get('/api/v1/vip/privileges/:level', async (req, res) => {
    const level = parseInt(req.params.level);
    const privilege = vipPrivileges.find(p => p.level === level);
    
    if (!privilege) {
        return res.status(400).json({ error: "Invalid VIP level" });
    }
    
    res.json({ status: 200, data: privilege });
});

// 6. Game Progression Bypass - Unlock all levels and modes
const gameLevels = Array.from({ length: 50 }, (_, i) => ({
    id: i + 1,
    name: `Level ${i + 1}`,
    difficulty: i < 10 ? 'easy' : i < 30 ? 'normal' : 'hard',
    reward: 1000 * (i + 1)
}));

const gameModes = [
    { id: 1, name: "Story Mode", levels: 50, reward: 50000 },
    { id: 2, name: "Survival Mode", levels: 30, reward: 30000 },
    { id: 3, name: "Creative Mode", levels: 0, reward: 0 },
    { id: 4, name: "Sandbox Mode", levels: 0, reward: 0 },
    { id: 5, name: "Multiplayer Arena", levels: 20, reward: 25000 }
];

// Player progression schema
const progressionSchema = new mongoose.Schema({
    userId: { type: String, unique: true, required: true },
    unlockedLevels: { type: [Number], default: Array.from({ length: 50 }, (_, i) => i + 1) },
    unlockedModes: { type: [Number], default: [1, 2, 3, 4, 5] },
    completedLevels: { type: [Number], default: [] },
    skypassLevel: { type: Number, default: 50 }
});
const Progression = mongoose.model('Progression', progressionSchema);

app.get('/api/v1/game/levels', async (req, res) => {
    try {
        res.json({ status: 200, data: gameLevels });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

app.get('/api/v1/game/modes', async (req, res) => {
    try {
        res.json({ status: 200, data: gameModes });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

app.get('/api/v1/game/progression/:userId', async (req, res) => {
    try {
        let progression = await Progression.findOne({ userId: req.params.userId });
        if (!progression) {
            progression = await Progression.create({ userId: req.params.userId });
        }
        res.json({ status: 200, data: progression });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

app.post('/api/v1/game/complete-level', async (req, res) => {
    const { userId, levelId } = req.body;
    try {
        let progression = await Progression.findOne({ userId });
        if (!progression) {
            progression = await Progression.create({ userId });
        }

        if (!progression.completedLevels.includes(levelId)) {
            progression.completedLevels.push(levelId);
        }

        // Award reward for level
        const level = gameLevels.find(l => l.id === levelId);
        const user = await User.findOne({ userId });
        if (user && level) {
            user.gcubes += level.reward;
            await user.save();
        }

        await progression.save();

        res.json({
            status: 200,
            message: `Level ${levelId} completed!`,
            reward: level ? level.reward : 0,
            newGcubeBalance: user ? user.gcubes : 0
        });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

app.post('/api/v1/game/unlock-all-levels', async (req, res) => {
    const { userId } = req.body;
    try {
        let progression = await Progression.findOne({ userId });
        if (!progression) {
            progression = await Progression.create({ userId });
        }

        // Unlock all levels
        progression.unlockedLevels = Array.from({ length: 50 }, (_, i) => i + 1);
        progression.unlockedModes = [1, 2, 3, 4, 5];
        progression.completedLevels = Array.from({ length: 50 }, (_, i) => i + 1);

        const user = await User.findOne({ userId });
        if (user) {
            const totalReward = gameLevels.reduce((sum, l) => sum + l.reward, 0);
            user.gcubes += totalReward;
            await user.save();
        }

        await progression.save();

        res.json({
            status: 200,
            message: "All levels and modes unlocked!",
            totalReward: gameLevels.reduce((sum, l) => sum + l.reward, 0),
            newGcubeBalance: user ? user.gcubes : 0
        });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// 7. Clan System
const clanSchema = new mongoose.Schema({
    clanId: { type: String, unique: true, required: true },
    clanName: { type: String, required: true },
    leader: { type: String, required: true },
    description: { type: String, default: "A great clan!" },
    members: [{ userId: String, role: String, joinDate: { type: Date, default: Date.now } }],
    icon: { type: String, default: "default_clan_icon.png" },
    level: { type: Number, default: 1 },
    experience: { type: Number, default: 0 },
    treasury: { type: Number, default: 10000 },
    createdAt: { type: Date, default: Date.now },
    updatedAt: { type: Date, default: Date.now }
});
const Clan = mongoose.model('Clan', clanSchema);

// Create/Join clan
app.post('/api/v1/clan/create', async (req, res) => {
    const { userId, clanName, description } = req.body;
    try {
        const clanId = 'clan_' + Date.now();
        
        const newClan = await Clan.create({
            clanId,
            clanName,
            leader: userId,
            description,
            members: [{ userId, role: 'leader' }]
        });

        res.json({
            status: 200,
            message: `Clan "${clanName}" created successfully!`,
            data: newClan
        });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// Join clan
app.post('/api/v1/clan/join', async (req, res) => {
    const { userId, clanId } = req.body;
    try {
        const clan = await Clan.findOne({ clanId });
        if (!clan) {
            return res.status(404).json({ error: "Clan not found" });
        }

        // Check if already member
        if (clan.members.some(m => m.userId === userId)) {
            return res.status(400).json({ error: "Already a clan member" });
        }

        clan.members.push({ userId, role: 'member' });
        await clan.save();

        res.json({
            status: 200,
            message: `Joined clan: ${clan.clanName}`,
            data: clan
        });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// Get clan info
app.get('/api/v1/clan/:clanId', async (req, res) => {
    try {
        const clan = await Clan.findOne({ clanId: req.params.clanId });
        if (!clan) {
            return res.status(404).json({ error: "Clan not found" });
        }
        res.json({ status: 200, data: clan });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// Leave clan
app.post('/api/v1/clan/leave', async (req, res) => {
    const { userId, clanId } = req.body;
    try {
        const clan = await Clan.findOne({ clanId });
        if (!clan) {
            return res.status(404).json({ error: "Clan not found" });
        }

        // Check if leader
        if (clan.leader === userId && clan.members.length > 1) {
            return res.status(400).json({ error: "Leader cannot leave - transfer leadership first" });
        }

        clan.members = clan.members.filter(m => m.userId !== userId);
        await clan.save();

        res.json({
            status: 200,
            message: "Left clan successfully"
        });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// Promote member
app.post('/api/v1/clan/promote', async (req, res) => {
    const { clanId, userId, targetUserId } = req.body;
    try {
        const clan = await Clan.findOne({ clanId });
        if (!clan) {
            return res.status(404).json({ error: "Clan not found" });
        }

        // Only leader can promote
        if (clan.leader !== userId) {
            return res.status(403).json({ error: "Only leader can promote members" });
        }

        const member = clan.members.find(m => m.userId === targetUserId);
        if (!member) {
            return res.status(404).json({ error: "Member not found" });
        }

        member.role = member.role === 'member' ? 'officer' : 'member';
        await clan.save();

        res.json({
            status: 200,
            message: `Member promoted to ${member.role}`,
            data: clan
        });
    } catch (err) {
        res.status(500).json({ error: err.message });
    }
});

// --- ADMIN & ROTATION ---
app.post('/api/admin/rotate', async (req, res) => {
    if (req.headers['x-admin-key'] !== process.env.ADMIN_KEY) return res.status(403).json({ error: "Unauthorized" });
    await archiveAndReset();
    res.json({ message: "Rotation triggered successfully" });
});;

app.listen(PORT, async () => {
    await connectToDatabase();
    console.log(`PRODUCTION BACKEND READY ON PORT ${PORT}`);
});
