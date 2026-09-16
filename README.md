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
| `_headers` | Cloudflare Pages のキャッシュ・CORS ヘッダ |
| `scripts/config.sh` | 配信 URL の正本（ドメインを変えたらここだけ直す） |
| `scripts/add.sh` | 追加 → commit → push → 記法表示 |
| `scripts/fetch_gyazo.sh` | Gyazo から ID 指定で取り寄せて追加 |
| `scripts/build_index.py` | `index.html` を再生成 |

## Cloudflare 側の設定（覚え書き）

- Workers & Pages → Pages プロジェクト `maindex-images` — Git 連携（このリポジトリの `main`）
- Build command: なし ／ Build output directory: `/`（リポジトリ直下をそのまま配信）
- 独自ドメインを付ける場合は Pages プロジェクトの Custom domains から（例: `img.maindex.ccwu.cc`）
