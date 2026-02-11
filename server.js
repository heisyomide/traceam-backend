const { Client, LocalAuth } = require('whatsapp-web.js');
const qrcode = require('qrcode-terminal');
const express = require('express');
const app = express();

app.use(express.json());

const client = new Client({
    authStrategy: new LocalAuth({ clientId: "traceam-dispatcher" }),
puppeteer: {
    headless: true,
    // This tells the code: "Use the path Render provides, or fallback to the local one"
    executablePath: process.env.PUPPETEER_EXECUTABLE_PATH || 'C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe',
    args: ['--no-sandbox', '--disable-setuid-sandbox']
}
});

let isReady = false;

client.on('qr', qr => {
    console.log('📡 SCAN THIS TO LINK YOUR DISPATCHER:');
    qrcode.generate(qr, {small: true});
});

client.on('ready', () => {
    isReady = true;
    console.log('🛡️ TRACEAM DISPATCHER ONLINE');
});

client.initialize();

app.post('/dispatch', async (req, res) => {
    const { phone, message, apiKey } = req.body;
    if (apiKey !== "traceam_secure_9999_dispatch_v1") {
    console.log(`❌ Unauthorized attempt with key: [${apiKey}]`); // This will show us what it actually received
    return res.status(401).send("Unauthorized");
}
    if (!isReady) return res.status(503).send("Dispatcher warming up...");

    try {
        let cleanPhone = phone.replace(/\D/g, '');
        if (cleanPhone.startsWith('0')) cleanPhone = '234' + cleanPhone.slice(1);
        await client.sendMessage(`${cleanPhone}@c.us`, message);
        res.send({ success: true });
    } catch (err) {
        res.status(500).send({ error: err.message });
    }
});

app.listen(3001, () => console.log(`📡 Dispatcher API listening on port 3001`));