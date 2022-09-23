const { readFileSync } = require("fs");
const { join } = require("path");
const fetch = require("node-fetch");
const changelog = readFileSync(join(__dirname, "../CHANGELOG.md"), "utf-8");

fetch("https://discord.com/api/webhooks/1023016819835031602/z7G4h6Wyu4Jf5Ck6fA-j-XZzkQ4y6jDclk4EKPOpIEmoRvjS8-IOyEEgwYQ9ZGnxbset", {
    method: "POST",
    headers: {
        ["Content-Type"]: "application/json"
    },
    body: JSON.stringify({
        "content": `Update has been detected, change-logs:\`\`\`md\n${changelog}\n\`\`\``,
        "embeds": null,
        "attachments": []
    })
});