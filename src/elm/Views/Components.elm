module Views.Components exposing (..)

import Css exposing (..)
import Css.Colors exposing (blue, navy, white, red)
import Html.Styled as Html exposing (..)
import Html.Styled.Attributes exposing (type_)
import Theme exposing (colorPalette)


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
    styled Html.h3 [ fontStyle, color colorPalette.textIcon ]



-- Style


borderRadiusStyle : Style
borderRadiusStyle =
    borderRadius (px 5)


paddingStyle : Style
paddingStyle =
    padding (px 12)


fontStyle : Style
fontStyle =
    fontFamilies [ "Roboto" ]


buttonStyle : Style
buttonStyle =
    Css.batch
        [ textAlign center
        , backgroundColor colorPalette.primary
        , border3 (px 1) solid transparent
        , color colorPalette.textIcon
        , display inlineBlock
        , hover [ backgroundColor colorPalette.accent ]
          --
        , fontStyle
        , borderRadiusStyle
        , paddingStyle
        ]


inputStyle : Style
inputStyle =
    Css.batch
        [ backgroundColor white
        , border3 (px 1) solid (rgba 0 0 0 0.2)
          --
        , fontStyle
        , borderRadiusStyle
        , paddingStyle
        ]
