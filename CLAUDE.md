# CLAUDE.md

## 参照するもの

**規約はこのファイルと、全リポジトリ共通の原則（hub の `PRINCIPLES.md`。下の「行動原則・Git」で読み込む）。** 使いかた・構成・Cloudflare 側の設定・移行記録は [`README.md`](README.md) が正本。
ここへ写さない —— 手で一致させる正本が 2 つになる。

## 何のリポジトリか

Scrapbox（Cosense）`maindex` プロジェクトの画像置き場。**GitHub が正本、Cloudflare Pages が配信**
（`main` への push で自動デプロイ）。Scrapbox の画像配信はここに一本化してある（2026-09-24）。
兄弟リポジトリ `scrapbox-maindex`（private）は Scrapbox の知識のミラーで、配信はしない。

## 対象範囲

- **リポジトリ直下がそのまま公開される。** 公開リポジトリで、Pages の出力ディレクトリも `/`。
  画像以外のファイル（このファイル・`scripts/` も）が `pages.dev` から読める。
  秘密情報・下書き・調査用の一時ファイルを置かない。
- **`scripts/add.sh` と `scripts/fetch_gyazo.sh` は commit と push まで行う。**
  push ＝ 公開なので、ユーザーの明示指示なしに走らせない。
- **`index.html` は生成物。** 手で書かない。`scripts/build_index.py` で作り直す。
- **`404.html` を消さない。** 無いと存在しない画像が壊れた画像として 1 日残る（理由と実例は README「構成」）。
- **配信 URL の正本は `scripts/config.sh`。** URL を他のファイルへ直書きしない。
- **公開済みの画像を同じ名前で上書きしない**（`--force`）。Scrapbox のページは URL で参照しており、
  キャッシュ期間（正本は `_headers`）のあいだは閲覧者の手元に古い画像が残る。上書きが必要なら問う。

## 行動原則・Git

共通の正本は hub（`XiangkaiLiu/maindex`、private）の `PRINCIPLES.md`。このリポジトリと同じ階層に clone してあれば読み込まれる:

@../maindex/PRINCIPLES.md

このリポジトリだけの決まり:

- **push が即デプロイ・即公開になる。** 可否は共通の決まり（hub の付与）に従う。

<tone_preference>
応答も成果物も簡潔に。要点に字数を割き、前置き・注意書き・再要約は短く。
進捗の逐一実況はしない。完了時は結論から書く。
</tone_preference>
