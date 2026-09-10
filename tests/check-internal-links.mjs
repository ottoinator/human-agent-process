import fs from "node:fs";
import path from "node:path";

const markdownFiles = [];

function walk(dir) {
  for (const entry of fs.readdirSync(dir, { withFileTypes: true })) {
    const full = path.join(dir, entry.name);
    const rel = path.relative(process.cwd(), full);
    if (rel.startsWith(".git") || rel.startsWith("node_modules")) continue;
    if (entry.isDirectory()) {
      walk(full);
    } else if (entry.isFile() && entry.name.endsWith(".md")) {
      markdownFiles.push(full);
    }
  }
}

function slugify(text) {
  return text
    .trim()
    .toLowerCase()
    .replace(/[^\w\s-]/g, "")
    .replace(/\s+/g, "-");
}

function anchorsFor(file) {
  const text = fs.readFileSync(file, "utf8");
  const anchors = new Set();
  for (const line of text.split(/\r?\n/)) {
    const match = line.match(/^(#{1,6})\s+(.+)$/);
    if (match) anchors.add(slugify(match[2]));
  }
  return anchors;
}

walk(process.cwd());

let failed = false;
const linkPattern = /(?<!!)\[[^\]]+\]\(([^)]+)\)/g;
const anchorCache = new Map();

for (const file of markdownFiles) {
  const text = fs.readFileSync(file, "utf8");
  for (const match of text.matchAll(linkPattern)) {
    const raw = match[1].trim();
    if (
      raw.startsWith("http://") ||
      raw.startsWith("https://") ||
      raw.startsWith("mailto:") ||
      raw.startsWith("#")
    ) {
      continue;
    }

    const [targetPath, anchor] = raw.split("#");
    const decoded = decodeURIComponent(targetPath);
    const target = path.resolve(path.dirname(file), decoded);

    if (!fs.existsSync(target)) {
      console.error(`${path.relative(process.cwd(), file)} links to missing path ${raw}`);
      failed = true;
      continue;
    }

    if (anchor) {
      const stat = fs.statSync(target);
      if (stat.isFile() && target.endsWith(".md")) {
        if (!anchorCache.has(target)) anchorCache.set(target, anchorsFor(target));
        if (!anchorCache.get(target).has(anchor.toLowerCase())) {
          console.error(`${path.relative(process.cwd(), file)} links to missing anchor ${raw}`);
          failed = true;
        }
      }
    }
  }
}

if (failed) process.exit(1);

