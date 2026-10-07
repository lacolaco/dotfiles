---
name: dotfiles-sync
description: "手元の macOS 環境と dotfiles リポジトリのずれを棚卸しし、使っていないものを片付けてから、残すものをリポジトリへ反映する。Homebrew の formula・cask・tap、mise のツール、symlink 先で直接書き換えられた設定ファイルが対象である。"
when_to_use: "「ローカルの状態を取り込んで」「Brewfile を今の状態に合わせて」「入れっぱなしのものを整理したい」「dotfiles に反映できていないものは」など、手元の環境と dotfiles の食い違いを解消する場面で使用する。Brewfile の 1 行だけを足す・消すといった、対象が決まっている編集では使用しない。"
---

# dotfiles の棚卸しと反映

手元の環境とリポジトリの食い違いを洗い出し、項目ごとに「残してリポジトリへ反映する」か「アンインストールする」かを決め、結果を 1 本の PR にまとめる。

棚卸しの目的は、手元にあるものを全部リポジトリへ載せることではない。手元に溜まった、覚えのないものを片付けることも含む。見つけたものを確かめずに Brewfile へ足すな。

## 1. 食い違いを洗い出す

次の 4 種類を調べる。Brewfile の管理方針はリポジトリの CLAUDE.md にある。

### 未コミットの変更

`fish/`・`mise/`・`.gitconfig`・`.gitignore_global` などは symlink で読み込まれるため、ツールのインストーラーや手作業による書き換えが、作業ツリーの未コミットの変更として現れる。`git status` と `git diff` で中身を読み、何がいつ追記したものかを特定する (例: インストーラーが追記した PATH)。

### Homebrew の formula

基準は `brew leaves --installed-on-request` である。依存として入ったものは Brewfile に書かない。

- leaves にあって Brewfile に無いもの: 取り込みの候補
- Brewfile にあって leaves に無いもの: アンインストール済みか、依存へ変わったもの
- `brew list --installed-on-request` にあって leaves に無いもの: 明示的に入れたが、別の formula の依存にもなっているもの。leaves だけを見ると見落とす。依存元を外すと Brewfile から漏れるので、`brew uses --installed <name>` で依存元を確かめる

### Homebrew の cask と tap

- `brew list --cask` と Brewfile の cask を比べる。名前が違っても同じ cask のことがある。`brew info --cask <name>` で解決先を確かめる (例: `linear-linear` は `linear` の旧名)
- 同じ名前の cask が別の tap にあることがある。`brew info --cask <name>` が別物を返したら、Caskroom のバージョンと tap 付きの名前 (`<user>/<tap>/<name>`) で照合し、Brewfile にはフルネームで書く
- `brew tap` の各 tap について、Brewfile の項目が使っているかを確かめる。formula が homebrew-core から入っているのに tap だけ残っていることがある。Homebrew は信頼していない tap に警告を出す

### mise と Homebrew の重複

`mise/config.toml` のツールと Homebrew の formula に同じツールが無いかを確かめる。アプリが同梱するコマンドとの重複も確かめる (例: OrbStack は docker CLI を同梱し、Homebrew の `docker` はそれを PATH で隠す)。`which -a <command>` で、どれが使われているかが分かる。

## 2. 覚えのないものを確かめる

取り込みの候補のうち、用途が明らかでないものは、ユーザーへ 1 件ずつ示して判断を仰ぐ。示す内容は次のとおり。

- 何をするものか (1〜2 文)
- インストールした日: formula は `/opt/homebrew/Cellar/<name>`、cask は `/opt/homebrew/Caskroom/<name>` の更新日時で分かる
- 依存元: `brew uses --installed <name>`
- 使っている形跡: 設定ファイル、データディレクトリ、関連するプロジェクト (例: rebar3 なら `works/` に Gleam のプロジェクトがあるか)
- 残すか外すかの推奨と、その根拠

形跡の調べ方は対象ごとに変わる。形跡が無いことは使っていないことの証明にならないので、確かめた範囲を添えよ。

ユーザーが「使っていない」と言ったものは、その場でアンインストールする。確認を繰り返すな。

## 3. 片付ける

- formula は `brew uninstall <name>`、cask は `brew uninstall --cask <name>` で外す。cask に `--zap` を付けるとアプリのデータまで消えるので、ユーザーが求めたときだけ付ける
- Homebrew が依存を自動で削除したら、その一覧を報告する。単体でも使うコマンドが含まれることがある (例: poppler を外すと gnupg も消える)
- 使っていない tap は `brew untap` で外す

## 4. リポジトリへ反映する

### Brewfile の書き方

セクションは用途で分ける。formula か cask かでは分けない。

- 開発の作業で使うものは、種類を問わず「開発」に入れる。Git、言語ランタイム、ビルドツール、クラウドの CLI、コンテナ、エディタはここに入る
- AI エージェントを前提にしたツールは「AI」に入れる
- その他は「シェルと基本コマンド」「ブラウザ」「コミュニケーションと共同作業」「認証とアクセス」「画像、動画、音声、文書」「macOS の操作と入力」などに入れる。既存の Brewfile のセクションに合わせる
- セクション内は formula、cask の順に、それぞれ名前順で並べる
- 用途が名前から分からないのに残すものには、行末のコメントで理由を書く (例: `brew "rebar3" # Gleam の Erlang ターゲットが ...`)

セクションの分け方を変えたら、変更前後で `tap`・`brew`・`cask` の項目が過不足なく一致することを確かめる。

### 確かめる

- `brew bundle check --no-upgrade` が満たされる
- `brew leaves --installed-on-request` と `brew list --cask` が、Brewfile と一致する。一致しない項目が残るなら、その理由を報告に書く
- mise のツールを変えたら、リポジトリの CLAUDE.md にあるツール一覧も合わせる

### PR

構造変更 (セクションの並べ替え) と振る舞い変更 (項目の追加・削除) を、別のコミットに分ける。ただし PR は 1 本にまとめる。棚卸しの途中で外すものが増えるたびに、積んだ PR をリベースする手間を避けるためである。PR の作成とレビューは、ユーザーの規範が定める手順に従う。

PR 本文には次を書く。
- 取り込んだもの
- 外してアンインストールしたもの
- 手元に残っているが Brewfile に書いていないものと、その理由
