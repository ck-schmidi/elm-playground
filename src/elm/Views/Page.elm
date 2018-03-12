module Views.Page exposing (frame, ActivePage)

import Color
import Html.Styled as Html exposing (Html, div, text, ul, li, a, styled, span)
import Svg.Styled as Svg exposing (Svg, fromUnstyled)
import Css
    exposing
        ( pt
        , pct
        , width
        , height
        , backgroundColor
        , displayFlex
        , flexDirection
        , row
        , alignItems
        , center
        , px
        , padding
        , paddingRight
        , textDecoration
        , none
        , color
        , hex
        , margin
        )
import Route exposing (Route)
import Theme exposing (colorPalette)


--import Material.Icons.Action exposing (account_balance)
--import Material.Icons.Navigation exposing (unfold_less)
--import Material.Icons.Device exposing (sd_storage)


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
    let
        headerStyle =
            Css.batch
                [ width (pct 100)
                , height (pt 40)
                , backgroundColor colorPalette.primary
                , displayFlex
                , flexDirection row
                , alignItems center
                ]

        menuItemStyle =
            Css.batch
                [ margin (pt 15)
                , textDecoration none
                , color colorPalette.textIcon
                ]

        menuItem =
            styled a [ menuItemStyle ]
    in
        styled div
            [ headerStyle ]
            []
            [ menuItem [ Route.href Route.Home ] [ text "Home" ]
            , menuItem [ Route.href Route.Login ] [ text "Login" ]
            ]
