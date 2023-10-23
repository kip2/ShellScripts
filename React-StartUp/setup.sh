#!/bin/bash

echo "---------------------------------"
echo "プロジェクト名を入力してください"
echo "---------------------------------"

# プロジェクト名
read ipt

# ディレクトリの作成
mkdir $ipt

# run.shのコピー
cp run.sh $ipt/run.sh

# 移動
cd $ipt

# npmの初期化
npm init -y

# 必要な依存関係のインストール
npm i react react-dom serve
npm i --save-dev  webpack webpack-cli
npm i --save-dev babel-loader @babel/core @babel/preset-env @babel/preset-react

# webpackの設定を記述
cat << EOF > webpack.config.js
var path = require("path");

module.exports = {
	entry: "./src/index.js",
	output: {
		path: path.join(__dirname, "dist", "assets"),
		filename: "bundle.js"
	},
	module: {
		rules: [{ test: /\.js$/, exclude: /node_modules/, loader: "babel-loader"}]
	}
};
EOF

# babelrcに設定を追加
echo '{\n    "presets": ["@babel/preset-env", "@babel/preset-react"]\n}' > .babelrc

# package.jsonに定義を追加
sed -i '/"scripts": {/a \ \     "build": "webpack --mode production",' package.json

# distにバンドルファイルをロードするファイルを設置
mkdir dist

cat << EOF > ./dist/index.html
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <title>React App</title>
  </head>
  <body>
    <div id="root"></div>
    <script src="assets/bundle.js"></script>
  </body>
</html>
EOF

# ソースファイルの作成
mkdir -p src/components

# src/index.jsの作成
cat << EOF > ./src/index.js
import React from "react";
import { render } from "react-dom";
import Hello from "./components/Hello";

render(<Hello />, document.getElementById("root"));
EOF

# src/components/Hello.jsの作成
cat << EOF > ./src/components/Hello.js
import React from "react";

export default function Hello() {
	return (
	  <>
	    <h1>Hello React!</h1>
	  </>
	);
}
EOF
