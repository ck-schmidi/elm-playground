module Views.Components exposing (..)

import Css exposing (color)
import Html.Styled as Html exposing (..)
import Html.Styled.Attributes exposing (type_)
import Theme exposing (colorPalette)
import Views.Style exposing (..)


-- HTML Components


button : List (Attribute msg) -> List (Html msg) -> Html msg
button =
    styled Html.button [ buttonStyle ]


input : List (Attribute msg) -> List (Html msg) -> Html msg
input =
    styled Html.input [ inputStyle ]


password : List (Attribute msg) -> List (Html msg) -> Html msg
password list =
    styled Html.input [ inputStyle ] ([ type_ "password" ] ++ list)


h1 : List (Attribute msg) -> List (Html msg) -> Html msg
h1 =
    styled Html.h1 [ fontStyle ]


h2 : List (Attribute msg) -> List (Html msg) -> Html msg
h2 =
    styled Html.h2 [ fontStyle ]


h3 : List (Attribute msg) -> List (Html msg) -> Html msg
h3 =
    styled Html.h3 [ fontStyle, color colorPalette.secondaryText ]
