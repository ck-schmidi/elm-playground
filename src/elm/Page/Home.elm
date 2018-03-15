module Page.Home exposing (..)

import Html.Styled exposing (Html, div, text)


-- MODEL --


type alias Model =
    String


init : Model
init =
    "Hello World"



-- VIEW --


view : Model -> Html Msg
view model =
    div [] [ model |> text ]



-- UPDATE


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    model ! []
