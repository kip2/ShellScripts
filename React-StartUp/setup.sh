#!/bin/bash

echo "---------------------------------"
echo "プロジェクト名を入力してください"
echo "---------------------------------"

# プロジェクト名
read ipt

# ディレクトリの作成
mkdir $ipt

# 移動
cd $ipt

# npmの初期化
npm init -y

# 必要な依存関係のインストール
npm i react react-dom serve
npm i --save-dev  webpack webpack-cli
npm i --save-dev babel-loader @babel/core @babel/preset-env @babel/preset-react @babel/register
npm i --save-dev style-loader css-loader

# deploy用モジュールのインストール
npm i --save-dev gh-pages 

# eslintのインストール
npm i eslint --save-dev
npm i --save-dev eslint-plugin-react@latest
npm i --save-dev eslint-plugin-react-hooks
cat << EOF > .eslintrc.json
{
    "settings": {
        "react": {
            "version": "detect"
        }
    },
    "env": {
        "browser": true,
        "es2021": true
    },
    "extends": [
        "eslint:recommended",
        "plugin:react/recommended"
    ],
    "parserOptions": {
        "ecmaVersion": "latest",
        "sourceType": "module"
    },
    "plugins": [
        "react",
        "react-hooks"
    ],
    "rules": {
        "react-hooks/rules-of-hooks": "error",
        "react-hooks/exhaustive-deps": "warn",
        "react/prop-types": "off"
    }
}
EOF

# .eslintignoreを作成
cat << EOF > .eslintignore
dist/assets
webpack.config.js
development.js
EOF


# webpackの設定を記述
cat << EOF > webpack.config.js
require('@babel/register');
module.exports = require('./development');
EOF

# webpackの実際の設定(ES6式の記述で設定)
cat << EOF > development.js
import path from "path"

const src = path.resolve(__dirname, "src")
const dist = path.resolve(__dirname, "dist/assets")

export default {
	devtool: "source-map",
	entry: src + "/index.js",
	output: {
		path: dist,
		filename: "bundle.js"
	},
	module: {
		rules: [
			{ 
				test: /\.js$/, 
				exclude: /node_modules/, 
				loader: "babel-loader"
			},
			{
				test: /\.css$/,
				use: [
					"style-loader",
					{
						loader: "css-loader",
						options: {
							modules: {
								localIdentName: "[name]__[local]___[hash:base64:5]",
							},
						},
					},
				],
			},
		]
	}
};
EOF


# babelrcに設定を追加
echo '{\n    "presets": ["@babel/preset-env", "@babel/preset-react"]\n}' > .babelrc

# package.jsonに定義を追加
sed -i '/"scripts": {/a \ \   "lint": "eslint", "predeploy": "npm run build", "deploy": "gh-pages -d dist", "build": "webpack --mode production",' package.json

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
import { createRoot } from "react-dom/client";
import App from "./components/App";

const root = createRoot(document.getElementById("root"));
root.render(<App />);
EOF

# src/components/Hello.jsの作成
cat << EOF > ./src/components/App.js
import React from "react";
import "../css/styles.css";

export default function App() {
	return (
		<>
			<h1>Hello React!</h1>
		</>
	);
}
EOF

# cssファイルの作成
mkdir -p src/css
cat << EOF > ./src/css/styles.css
body {
    font-family: 'Arial', sans-serif;
    background-color: #282C34; 
    color: #61DAFB; 
    display: flex;
    height: 100vh;
    align-items: center;
    justify-content: center;
}

h1 {
    position: relative;
    font-size: 2.5em;
    color: #61DAFB; 
    padding: 10px 20px;
    background-image: linear-gradient(to right, #282C34, #61DAFB, #282C34); 
    -webkit-background-clip: text;
    color: transparent;
}

h1::before {
    content: '';
    position: absolute;
    left: 5%; 
    right: 5%; 
    bottom: -10px; 
    height: 3px;
    background-image: linear-gradient(to right, #61DAFB, #3BAEDC); 
    border-radius: 3px;
}

@keyframes titleHover {
    0% {
        color: transparent;
        text-shadow: 3px 3px 0 #3BAEDC, 6px 6px 0 #2A8BB9;
    }
    100% {
        color: #61DAFB;
        text-shadow: 0 0 5px #3BAEDC, 0 0 10px #2A8BB9;
    }
}

h1:hover {
    animation: titleHover 0.5s forwards;
}

@keyframes underlineAnimation {
    0% {
        box-shadow: 0 0 5px #3BAEDC, 0 0 10px #2A8BB9;
    }
    100% {
        box-shadow: 0 0 15px #3BAEDC, 0 0 20px #2A8BB9;
    }
}

h1:hover::before {
    animation: underlineAnimation 0.5s forwards;
}
EOF

# run.shの作成
cat << EOF > ./run.sh
#!/bin/bash
npm run build

{
    sleep 1
    open http://localhost:3000
} & 

serve ./dist
EOF

# ちょっと間をおく
sleep 2

# ビルドのテスト
. run.sh