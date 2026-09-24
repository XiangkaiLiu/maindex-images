# maindex-images

Scrapbox（Cosense）`maindex` プロジェクトで使う画像の置き場。
**GitHub が正本、Cloudflare Pages が配信**。Gyazo など外部サービスの障害に左右されない。

```
このリポジトリ (GitHub)  ──push──▶  Cloudflare Pages（自動デプロイ）  ──▶  https://maindex-images.pages.dev/images/〜
```

## 画像を追加する

```bash
scripts/add.sh <画像ファイル> [公開名]
```

例:

```bash
scripts/add.sh ~/Desktop/スクショ.png attachment-map
#   → images/attachment-map.png を commit & push
#   → Scrapbox 記法 [https://maindex-images.pages.dev/images/attachment-map.png] が表示される
```

- 公開名を省略すると元のファイル名（空白は `-`）になる。同名があると止まる（`--force` で上書き）。
- push から配信までは 1 分ほど。Scrapbox には表示された記法をそのまま貼る。
- 手動でやるなら `images/` にファイルを置いて `git push` するだけでも同じ。

## 一覧ページ

`https://maindex-images.pages.dev/` を開くと `images/` の一覧（サムネイル＋記法、クリックでコピー）。
`index.html` は `scripts/build_index.py` が生成する（`add.sh` が自動で呼ぶ）。

## Gyazo からの救出

```bash
scripts/fetch_gyazo.sh <GyazoのIDまたはURL> [公開名]
```

`i.gyazo.com` が復旧しているときだけ成功する。503 のあいだは再実行を待つ。

## 構成

| パス | 役割 |
|---|---|
| `images/` | 公開する画像本体 |
| `index.html` | 一覧ページ（生成物） |
| `404.html` | 存在しないパスに 404 を返させる。**消さない** —— 無いと Pages は `index.html` を 200 で返し、`/images/*` ではそれが画像として 1 日キャッシュされて壊れた画像が残る（2026-09-24 に W-001.png で実際に起きた） |
| `_headers` | Cloudflare Pages のキャッシュ・CORS ヘッダ |
| `scripts/config.sh` | 配信 URL の正本（ドメインを変えたらここだけ直す） |
| `scripts/add.sh` | 追加 → commit → push → 記法表示 |
| `scripts/fetch_gyazo.sh` | Gyazo から ID 指定で取り寄せて追加 |
| `scripts/build_index.py` | `index.html` を再生成 |

## Cloudflare 側の設定（覚え書き）

- Workers & Pages → Pages プロジェクト `maindex-images` — Git 連携（このリポジトリの `main`）
- Build command: なし ／ Build output directory: `/`（リポジトリ直下をそのまま配信）
- 独自ドメインを付ける場合は Pages プロジェクトの Custom domains から（例: `img.maindex.ccwu.cc`）

## 移行記録（2026-09-17）

Gyazo の画像配信（`i.gyazo.com`）障害を機に、Scrapbox 内の Gyazo 参照をすべてここへ移した。

| Scrapbox 側 | 旧 | 新 |
|---|---|---|
| `maindex` ページ 2 行目（プロジェクトアイコン） | `gyazo.com/28c40135…` | `images/maindex-icon.png`（GitHub アバターと同一画像・256px） |
| `Settings` `.brand-icon { --logo-url }` と `cv:p1p2` 行の `--cv-logo-url` | `i.gyazo.com/28c40135….png` | 同上 |
| `Scrapboxの使い方` の画像 2 枚 | `gyazo.com/5f93e65a…`, `gyazo.com/c3a68ab8…` | `images/gyazo-5f93e65a….png`, `images/gyazo-c3a68ab8….png`（Internet Archive から復元） |

- `Settings` の `cv:*` 行のソースは Settings にしか無い（行内の注記「source: scrapbox-maindex repo / src」は古い。2026-09-24 確認）。`--cv-logo-url` は新 URL へ移行済み。
- 独自ドメイン（例: `img.maindex.ccwu.cc`）は未設定。付けるなら Pages プロジェクト → Custom domains から。Scrapbox 側の参照は Cloudflare 直轄の `pages.dev` のままでよい。
