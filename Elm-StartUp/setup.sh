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
    text "test"
EOF

# run.shを作成
cat << EOF > ./run.sh
elm-live src/Main.elm --open
EOF

# 少し間をおく
sleep 2

