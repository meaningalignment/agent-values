import { readdirSync, readFileSync, writeFileSync } from "node:fs";
import { join, resolve } from "node:path";

const VALUES_DIR = resolve(process.env.AGENT_VALUES_DIR || `${process.env.HOME || "~"}/.openclaw/values`);
const CARDS_DIR = join(VALUES_DIR, "cards");
const OUTPUT = join(VALUES_DIR, "VALUES.md");

function parseFrontmatter(raw: string): { data: Record<string, any>; content: string } {
  const match = raw.match(/^---\n([\s\S]*?)\n---\n([\s\S]*)$/);
  if (!match) return { data: {}, content: raw };

  const data: Record<string, any> = {};
  for (const line of match[1].split("\n")) {
    const idx = line.indexOf(":");
    if (idx === -1) continue;
    const key = line.slice(0, idx).trim();
    let val = line.slice(idx + 1).trim();
    if (val.startsWith("[") && val.endsWith("]")) {
      val = val.slice(1, -1);
      data[key] = val.split(",").map((s) => s.trim());
    } else {
      data[key] = val;
    }
  }
  return { data, content: match[2] };
}

const files = readdirSync(CARDS_DIR)
  .filter((f) => f.endsWith(".md"))
  .sort();

const sections: string[] = [];

for (const file of files) {
  const raw = readFileSync(join(CARDS_DIR, file), "utf-8");
  const { data, content } = parseFrontmatter(raw);

  const title = data.title || file.replace(/\.md$/, "");
  const contexts = Array.isArray(data.contexts) ? data.contexts.join(", ") : data.contexts || "";

  const body = content.trimStart();
  const section = `# ${title}\n\n*Contexts: ${contexts}*\n\n${body}`;
  sections.push(section);
}

const now = new Date().toISOString();
const output = `# User's Values

This file is generated from ${CARDS_DIR}/. Do not edit directly.
Last built: ${now}

---

${sections.join("\n\n---\n\n")}
`;

writeFileSync(OUTPUT, output);
console.log(`VALUES.md rebuilt with ${files.length} card(s) at ${now}`);
