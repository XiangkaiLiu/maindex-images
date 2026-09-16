#!/usr/bin/env python3
"""images/ の一覧ページ index.html を生成する（add.sh から自動で呼ばれる）。

配信先で https://<BASE_URL>/ を開くと、画像のサムネイルと Scrapbox に貼る記法が
一覧で見られ、クリックで記法をコピーできる。
"""
from __future__ import annotations

import html
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
IMAGES = ROOT / "images"
EXTS = {".png", ".jpg", ".jpeg", ".gif", ".webp", ".svg"}

config = (ROOT / "scripts" / "config.sh").read_text(encoding="utf-8")
BASE_URL = re.search(r'BASE_URL="([^"]+)"', config).group(1).rstrip("/")

files = sorted(p for p in IMAGES.iterdir() if p.suffix.lower() in EXTS)

cards = []
for p in files:
    url = f"{BASE_URL}/images/{p.name}"
    notation = f"[{url}]"
    cards.append(
        f'<figure><a href="images/{html.escape(p.name)}" target="_blank" rel="noopener">'
        f'<img src="images/{html.escape(p.name)}" alt="{html.escape(p.name)}" loading="lazy"></a>'
        f"<figcaption><b>{html.escape(p.name)}</b>"
        f'<code title="クリックでコピー" data-copy="{html.escape(notation)}">{html.escape(notation)}</code>'
        f"</figcaption></figure>"
    )

page = f"""<!DOCTYPE html>
<html lang="ja"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>maindex images</title>
<style>
  body{{margin:0;padding:24px 16px;background:#202228;color:rgba(255,255,255,.87);font:15px/1.6 Roboto,Helvetica,Arial,"Hiragino Sans",sans-serif}}
  h1{{font-size:20px;margin:0 0 4px}} p{{color:rgba(255,255,255,.55);margin:0 0 20px;font-size:13px}}
  .grid{{display:grid;grid-template-columns:repeat(auto-fill,minmax(240px,1fr));gap:16px}}
  figure{{margin:0;background:#373b44;border-radius:8px;padding:12px;box-shadow:0 2px 0 #000}}
  img{{display:block;max-width:100%;max-height:200px;margin:0 auto 8px;background:#fff;border-radius:4px}}
  figcaption b{{display:block;font-size:13px;word-break:break-all}}
  code{{display:block;margin-top:6px;padding:6px 8px;border-radius:4px;background:rgba(0,0,0,.25);color:#5de3ec;font-size:12px;word-break:break-all;cursor:pointer}}
  code.copied{{color:#fff;background:#308ee6}}
</style></head><body>
<h1>maindex images</h1>
<p>{len(files)} 枚 ／ 記法をクリックするとコピーします ／ 追加は <code style="display:inline;padding:1px 6px">scripts/add.sh &lt;ファイル&gt; [名前]</code></p>
<div class="grid">
{chr(10).join(cards)}
</div>
<script>
document.querySelectorAll('code[data-copy]').forEach(c=>c.addEventListener('click',async()=>{{
  try{{await navigator.clipboard.writeText(c.dataset.copy);c.classList.add('copied');setTimeout(()=>c.classList.remove('copied'),900)}}catch(e){{}}
}}));
</script>
</body></html>
"""
(ROOT / "index.html").write_text(page, encoding="utf-8")
print(f"index.html: {len(files)} images")
