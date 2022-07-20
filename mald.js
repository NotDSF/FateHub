const { readFileSync, writeFileSync } = require("fs");

const data = readFileSync("./mald.txt", "utf8");
const d = data.split("\n");

let levels = [];

let i = 0
for (const l of d) {
    const matches = l.match(/.*Level .= (?<startLevel>\d+)+\s(or|and) Level .. (?<endLevel>\d+)/);
    if (matches) {
        const groups = matches?.groups
        
        if (groups) {
            levels[levels.length] = {
                levels: [],
                NPCName: '',
                questNumber: 1,
                questPosition: [1, 2, 3],
                questName: ''
            };

            levels[levels.length - 1].levels = [parseInt(groups.startLevel) + 1, parseInt(groups.endLevel) + 1]
            let e = i
            levels[levels.length - 1].NPCName = d[e + 1].split("[")[0].split('"')[1].trim()
            e += 1
            levels[levels.length - 1].questName = d[e + 1].split('"')[1].split('"')[0]
            e += 1
            levels[levels.length - 1].questNumber = parseInt(d[e + 1].split("= ")[1].trim());
            e += 2
            levels[levels.length - 1].questPosition = d[e + 1].trim().split("(")[1].split(")")[0].split(",").map(x => parseInt(x.split(".")[0]));
            
        }
    }
    i += 1
}

let lua = `local questOrder = {
`
levels.forEach((level) => {
    lua += `\t{\n\t\tlevels = { ${level.levels[0]}, ${level.levels[1]} },\n\t\tNPCName = "${level.NPCName}",\n\t\tquestNumber = ${level.questNumber},\n\t\tquestPosition = { ${level.questPosition.join(", ")} },\n\t\tquestName = "${level.questName}"\n\t},\n`
});

lua += "}";

writeFileSync("./out.txt", lua, "utf8");


console.log("done");