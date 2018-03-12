module Views.Page exposing (frame, ActivePage)

import Color
import Html.Styled as Html exposing (Html, div, text, ul, li, a)
import Svg.Styled as Svg exposing (Svg)


--import Material.Icons.Action exposing (account_balance)

import Material.Icons.Navigation exposing (unfold_less)
import Material.Icons.Device exposing (sd_storage)
import Route exposing (Route)


type ActivePage
    = Other
    | Home
    | Login


frame : Html msg -> Html msg
frame content =
    div []
        [ header
        , content
        ]


header : Html msg
header =
    div []
        [ --Svg.fromUnstyled (sd_storage Color.red 25)
          div []
            [ ul []
                [ li []
                    [ a [ Route.href Route.Home ] [ text "Home" ]
                    ]
                , li []
                    [ a [ Route.href Route.Login ] [ text "Login" ]
                    ]
                ]
            ]
        ]
