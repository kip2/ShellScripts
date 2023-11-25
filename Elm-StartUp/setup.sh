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

# elmの初期化
echo y | elm init

# index.htmlの作成
cat << EOF > index.html
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Elm App</title>
    <link rel="stylesheet" type="text/css" href="css/styles.css">
</head>
<body>
    <div id="elm-root"></div>
    <script src="elm.js"></script>
	<script>
		var app = Elm.Main.init({
			node: document.getElementById('elm-root')
		})
	</script>
</body>
</html>
EOF

# cssファイルの作成
mkdir css
cat << EOF > css/styles.css
.my-class {
    color: purple;
}
EOF

# 雛形ファイルの作成
cat << EOF > src/Main.elm
module Main exposing (main)

import Browser
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

main : Program() Model Msg
main = 
    Browser.sandbox
    { init = init
    , update = update
    , view = view
    }

-- MODEL
type alias Model = 
    {}

init : Model
init = 
    {}

-- UPDATE

type Msg = Msg

update : Msg -> Model -> Model
update msg model = 
    model

-- VIEW

view : Model -> Html msg
view model = 
    div []
        [
            h1 [ class "my-class" ] [ text "Hello, Elm!!!"]
        ]
EOF

# run.shを作成
cat << EOF > ./run.sh
elm-live src/Main.elm --open -- --output=elm.js
EOF
