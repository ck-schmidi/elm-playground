module Page.Tryout exposing (..)

import Html.Styled exposing (Html, div, text, styled, span)
import Html.Styled.Events exposing (onClick)
import Views.Components as Components exposing (button)
import Css exposing (width, pt, margin)


-- MODEL --


type alias Model =
    Int


initialModel : Model
initialModel =
    0



-- VIEW --


view : Model -> Html Msg
view model =
    let
        button =
            styled Components.button
                [ width (pt 100)
                , margin (pt 10)
                ]
    in
        div []
            [ button [ onClick Inc ] [ text "+" ]
            , model
                |> toString
                |> text
            , button [ onClick Dec ] [ text "-" ]
            ]



-- UPDATE


type Msg
    = Inc
    | Dec


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case msg of
        Inc ->
            (model + 1) ! []

        Dec ->
            (model - 1) ! []
