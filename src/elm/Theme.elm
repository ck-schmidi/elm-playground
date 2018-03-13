module Theme exposing (colorPalette)

import Css exposing (Color, hex)


type alias ColorPalette =
    { darkPrimary : Color
    , lightPrimary : Color
    , primary : Color
    , textIcon : Color
    , accent : Color
    , primaryText : Color
    , secondaryText : Color
    , divider : Color
    }


colorPalette : ColorPalette
colorPalette =
    c1


{-| Created by: https://www.materialpalette.com/blue/indigo
-}
c1 : ColorPalette
c1 =
    { darkPrimary = (hex "1976D2")
    , lightPrimary = (hex "BBDEFB")
    , primary = (hex "2196F3")
    , textIcon = (hex "FFFFFF")
    , accent = (hex "536DFE")
    , primaryText = (hex "212121")
    , secondaryText = (hex "757575")
    , divider = (hex "BDBDBD")
    }
