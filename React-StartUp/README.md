# Reactのプロジェクト作成用シェルスクリプト

Reactの簡易的なプロジェクト作成用のシェルスクリプト

エラー処理は完備していません

create-react-app的なものを自作してみたかった由(車輪の再発明)

# 実行環境

現在、手元で動かしている環境

別な環境では動かない可能性があります

OS: MacOS Ventura 13.5.2

npm: 8.19.2

node: 18.10.0

---

# 使い方

## startup.shでインストールされるもの

- gh-pages: deploy用。ホームページの記述のみ、後から付け足す必要がある
- eslint: pluginとして、esint-plugin-react-hooks

### コマンド

```shell
# buildコマンド
npm run build

# linterコマンド
npm run lint

# deployコマンド
# 先に、ホームページの設定をpackage.jsonに記載してから
npm run deploy
```


## startup.shの使い方

1. startup.shの起動

```shell
$ . startup.sh
```

2. プロジェクト名の入力

プロジェクト名の入力を求められます

作成したいプロジェクト名を入力してください

3. あとは自動作成

エラーが出ない限りは自動で作成されます

4. ブラウザが自動で開く

ビルドが終わると、ブラウザが自動で開き、テストページにアクセスします

5. サーバーの閉じ方

ターミナル上で Ctrl + Cキー を押してください。

---

## run.shの使い方

1. プロジェクトディレクトリ内で、run.shを起動する

```shell
$ . run.sh
```

2. ブラウザでアクセスする

serverが立ち上がるので、ブラウザから、以下のURLにアクセスする

http://localhost:3000

