#!/usr/bin/env bash
# Gyazo の画像を ID で取り寄せてリポジトリへ追加する（Gyazo 復旧後の救出用）。
#
#   scripts/fetch_gyazo.sh <GyazoのID または URL> [公開名]
#
#   例: scripts/fetch_gyazo.sh https://gyazo.com/28c401356c834914727d330b0416a322 maindex-icon
#
# i.gyazo.com が 503 のあいだは失敗する（数時間おきに再実行すればよい）。
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
ID="${1:-}"
[[ -z "$ID" ]] && { echo "使い方: scripts/fetch_gyazo.sh <ID or URL> [公開名]" >&2; exit 1; }
ID="$(printf '%s' "$ID" | sed -E 's#^https?://(i\.)?gyazo\.com/##; s#\.(png|jpg|gif)$##')"
NAME="${2:-gyazo-$ID}"

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
for EXT in png jpg gif; do
  CODE="$(curl -s -L -m 60 -A "Mozilla/5.0" -o "$TMP/img.$EXT" -w '%{http_code}' "https://i.gyazo.com/$ID.$EXT")"
  if [[ "$CODE" == "200" ]] && file "$TMP/img.$EXT" | grep -qi "image data"; then
    exec "$ROOT/scripts/add.sh" "$TMP/img.$EXT" "$NAME"
  fi
done
echo "取得できませんでした（最後の HTTP ステータス: $CODE）。Gyazo 側が復旧してから再実行してください。" >&2
exit 1
