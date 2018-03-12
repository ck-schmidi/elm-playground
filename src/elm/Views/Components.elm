module Views.Components exposing (..)

import Css exposing (..)
import Css.Colors exposing (blue, navy, white, red)
import Html.Styled as Html exposing (..)
import Html.Styled.Attributes exposing (type_)


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
    styled Html.h1 [ theme.font ]


h2 : List (Attribute msg) -> List (Html msg) -> Html msg
h2 =
    styled Html.h2 [ theme.font ]


h3 : List (Attribute msg) -> List (Html msg) -> Html msg
h3 =
    styled Html.h3 [ theme.font, color theme.primary ]


theme :
    { primary : Color
    , secondary : Color
    , text : Color
    , error : Color
    , font : Style
    }
theme =
    { primary = blue
    , secondary = navy
    , text = white
    , error = red
    , font = fontFamilies [ "Roboto" ]
    }



-- Style


borderRadiusStyle : Style
borderRadiusStyle =
    borderRadius (px 5)


paddingStyle : Style
paddingStyle =
    padding (px 12)


buttonStyle : Style
buttonStyle =
    Css.batch
        [ textAlign center
        , backgroundColor theme.primary
        , border3 (px 1) solid transparent
        , color theme.text
        , display inlineBlock
        , hover [ backgroundColor theme.secondary ]
          --
        , theme.font
        , borderRadiusStyle
        , paddingStyle
        ]


inputStyle : Style
inputStyle =
    Css.batch
        [ backgroundColor white
        , border3 (px 1) solid (rgba 0 0 0 0.2)
          --
        , theme.font
        , borderRadiusStyle
        , paddingStyle
        ]
