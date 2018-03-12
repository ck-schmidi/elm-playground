module Page.Tryout exposing (..)

import Html.Styled exposing (Html, div, text)


-- MODEL --


type alias Model =
    String


initialModel : Model
initialModel =
    "Tryout"



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
