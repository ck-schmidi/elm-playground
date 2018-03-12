module Page.Home exposing (..)

import Html.Styled exposing (Html, div, text)


-- MODEL --


type alias Model =
    Int


initialModel : Model
initialModel =
    0



-- VIEW --


view : Model -> Html Msg
view model =
    div [] [ "Hello " |> text ]



-- UPDATE


type Msg
    = NoOp


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    model ! []
