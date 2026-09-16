#!/usr/bin/env bash
# 画像を追加して GitHub へ push し、Scrapbox に貼る記法を表示する。
#
#   scripts/add.sh <画像ファイル> [公開名]
#
#   例: scripts/add.sh ~/Desktop/スクショ.png attachment-map
#       → images/attachment-map.png として push され、
#         [https://maindex-images.pages.dev/images/attachment-map.png] が表示される
#
# 公開名を省略すると元のファイル名（空白は - に置換）を使う。
# 同名ファイルが既にあるときは上書きせず止まる（--force で上書き）。
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
# shellcheck source=config.sh
source "$ROOT/scripts/config.sh"

FORCE=0
if [[ "${1:-}" == "--force" ]]; then FORCE=1; shift; fi

SRC="${1:-}"
if [[ -z "$SRC" || ! -f "$SRC" ]]; then
  echo "使い方: scripts/add.sh [--force] <画像ファイル> [公開名]" >&2
  exit 1
fi

EXT="${SRC##*.}"
EXT="$(printf '%s' "$EXT" | tr '[:upper:]' '[:lower:]')"
case "$EXT" in
  png|jpg|jpeg|gif|webp|svg) ;;
  *) echo "対応していない拡張子です: .$EXT（png/jpg/jpeg/gif/webp/svg）" >&2; exit 1 ;;
esac

NAME="${2:-$(basename "$SRC" ".${SRC##*.}")}"
NAME="$(printf '%s' "$NAME" | sed -E 's/[[:space:]]+/-/g; s#/#-#g')"
DEST="$ROOT/images/$NAME.$EXT"

if [[ -e "$DEST" && $FORCE -eq 0 ]]; then
  echo "同名のファイルがあります: images/$NAME.$EXT（上書きするなら --force）" >&2
  exit 1
fi

cp "$SRC" "$DEST"
python3 "$ROOT/scripts/build_index.py"

cd "$ROOT"
git add "images/$NAME.$EXT" index.html
git commit -q -m "画像追加: $NAME.$EXT"
git push -q origin main

URL="$BASE_URL/images/$NAME.$EXT"
echo
echo "push しました。Cloudflare Pages の反映まで 1 分ほど待ってから使えます。"
echo "  URL            : $URL"
echo "  Scrapbox 記法  : [$URL]"
echo "  リンク付き     : [$URL リンク先URL]   （画像をクリックで飛ばしたいとき）"
