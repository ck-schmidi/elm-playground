module Route exposing (..)

import UrlParser as Url exposing ((</>), Parser, oneOf, parseHash, s, string)
import Html.Styled.Attributes as Attr
import Html.Styled exposing (Attribute)
import Navigation exposing (Location)


type Route
    = Home
    | Blank
    | Login
    | Tryout
    | Autocomplete
    | Remote


route : Parser (Route -> a) a
route =
    oneOf
        [ Url.map Home (s "")
        , Url.map Blank (s "blank")
        , Url.map Login (s "login")
        , Url.map Tryout (s "tryout")
        , Url.map Autocomplete (s "autocomplete")
        , Url.map Remote (s "remote")
        ]


routeToString : Route -> String
routeToString route =
    let
        parts =
            case route of
                Home ->
                    []

                Blank ->
                    [ "blank" ]

                Login ->
                    [ "login" ]

                Tryout ->
                    [ "tryout" ]

                Autocomplete ->
                    [ "autocomplete" ]

                Remote ->
                    [ "remote" ]
    in
        "/#/" ++ (parts |> String.join "/")



-- PUBLIC HELPERS --


href : Route -> Attribute msg
href =
    routeToString >> Attr.href


modifyUrl : Route -> Cmd msg
modifyUrl =
    routeToString >> Navigation.modifyUrl


fromLocation : Location -> Maybe Route
fromLocation location =
    if String.isEmpty location.hash then
        Just Home
    else
        parseHash route location
