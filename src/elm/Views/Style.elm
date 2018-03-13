module Views.Style exposing (..)

import Css exposing (..)
import Css.Colors exposing (blue, navy, white, red)
import Theme exposing (colorPalette)


borderRadiusStyle : Style
borderRadiusStyle =
    borderRadius (px 5)


paddingStyle : Style
paddingStyle =
    padding (px 12)


fontStyle : Style
fontStyle =
    fontFamilies [ "Roboto" ]


menuItemStyle : Style
menuItemStyle =
    batch
        [ margin (pt 15)
        , textDecoration none
        , textTransform uppercase
        , color colorPalette.textIcon
        , fontStyle
        , hover
            [ color colorPalette.textIcon
            ]
        ]


buttonStyle : Style
buttonStyle =
    batch
        [ textAlign center
        , backgroundColor colorPalette.primary
        , border3 (px 1) solid transparent
        , color colorPalette.textIcon
        , display inlineBlock
        , textTransform uppercase
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
