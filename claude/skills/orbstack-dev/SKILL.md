---
name: orbstack-dev
version: 0.1.0
description: OrbStack がホストの Docker runtime として常に利用可能である前提で、Docker Compose 開発環境にアクセスする方法。OrbStack 特有の自動 DNS・自動 port forwarding を活用し、dnsmasq や ports: 公開の手間を省く。Docker Compose 上の Rails/Node 等のサーバーにローカルからアクセスする場面、マルチテナントアプリのサブドメインルーティングを検証する場面で使用する。
---

# OrbStack 開発環境アクセス

## 前提

- ホストの Docker runtime は **OrbStack** が常駐している（Docker Desktop ではない）
- `docker compose` / `docker` コマンドはすべて OrbStack backend で動く
- ユーザー確認なしにこの前提で判断してよい

## 自動 DNS

OrbStack は compose で起動したコンテナに自動で DNS を割り当てる。設定不要、dnsmasq 不要、`/etc/hosts` への追記不要。

### ホスト名の形式

```
<container-name>.<project-name>.orb.local
```

- `container-name`: compose.yaml の service 名（例: `app`, `worker`）
- `project-name`: `docker compose -p <project>` で指定したプロジェクト名、もしくは compose.yaml 冒頭の `name:` フィールド

例: `docker compose -p caravan` で `app` service を起動した場合 → `app.caravan.orb.local`

### ワイルドカードサブドメイン

任意のサブドメインを前置しても同じコンテナに解決される。**マルチテナントアプリで tenant 名を subdomain に載せる用途にそのまま使える。**

```
<anything>.<container>.<project>.orb.local
<tenant>.<container>.<project>.orb.local
```

例: tenant `twogate` へのアクセス → `twogate.app.caravan.orb.local`

## 自動 Port Forwarding

OrbStack は `EXPOSE` されたコンテナポートを自動で `localhost` に forward する。**compose.yaml に `ports:` セクションを書かなくても `http://localhost:<port>` で届く**（ポートが重複した場合は後勝ち等の挙動があるので、複数 project を並行起動するなら orb.local ホスト名経由が安全）。

- 単一プロジェクトのみ起動 → `http://localhost:3000` でも可
- 複数プロジェクトを並行起動する、または port 衝突を避けたい → `http://app.<project>.orb.local:3000` を使う

## 判断フロー

1. 「localhost 経由でアクセスできない」「port 公開が必要」と言われたら → まず OrbStack の自動 forwarding で既に届いていないか `curl -I http://localhost:<port>` で確認
2. 「マルチテナント dev に dnsmasq を設定する必要がある」系のドキュメント記述 → OrbStack 環境では不要、`*.app.<project>.orb.local` で代替できる
3. compose.yaml に `ports:` を追加する PR を作る前に、OrbStack 前提なら不要ではないか再検討

## 検証コマンド

```bash
# コンテナ直接
curl -s -o /dev/null -w "%{http_code}\n" http://<container>.<project>.orb.local:<port>

# サブドメイン経由（マルチテナント）
curl -s -o /dev/null -w "%{http_code}\n" http://<tenant>.<container>.<project>.orb.local:<port>
```

## 注意点

- OrbStack の DNS は OrbStack が起動している間のみ有効。CI 等 OrbStack がない環境では `*.orb.local` は解決されない。CI 用設定をこの機能に依存させない。
- プロジェクト名にアンダースコア等の DNS 非互換文字を使うと解決されない。ハイフン or 英数字で統一する。
- compose の `name:` フィールドと `-p` フラグが両方ある場合、`-p` が優先される。
