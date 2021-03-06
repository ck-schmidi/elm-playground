module Page.Login exposing (..)

import Html.Styled exposing (Html, div, text, form, styled, a, li, ul, span)
import Html.Styled.Attributes exposing (placeholder, value)
import Html.Styled.Events exposing (onInput, onSubmit)
import Views.Components as Components exposing (button, input, h1, h3)
import Css exposing (width, px, pct, pt, margin, cursor, pointer, textAlign, center, color, hex, textDecoration, none)
import Utils exposing ((=>))
import Validate exposing (Validator, ifBlank, ifInvalidEmail, validate)
import Route exposing (Route, href)
import Theme exposing (colorPalette)


--import Json.Decode as Decode exposing (Decoder, decodeString, field, string)
--import Json.Decode.Pipeline exposing (decode, optional)
-- MODEL --


type alias Model =
    { errors : List Error
    , email : String
    , password : String
    }


init : Model
init =
    { errors = []
    , email = ""
    , password = ""
    }



-- VIEW --


view : Model -> Html Msg
view model =
    let
        width =
            Css.width (pct 100)

        margin =
            Css.margin (px 5)
    in
        styled div
            [ Css.width (pt 400)
            , Css.displayFlex
            , Css.flexDirection Css.column
            ]
            []
            [ styled div [ textAlign center, color colorPalette.primaryText ] [] [ h1 [] [ "Sign in " |> text ] ]
            , styled a [ textAlign center, textDecoration none ] [ href Route.Home ] [ h3 [] [ "Need an account?" |> text ] ]
            , form
                [ onSubmit SubmitForm ]
                [ styled Components.input
                    [ width, margin ]
                    [ placeholder "Email", onInput SetEmail, value model.email ]
                    []
                , viewFormError Email model.errors
                , styled Components.password
                    [ width, margin ]
                    [ placeholder "Password", onInput SetPassword, value model.password ]
                    []
                , viewFormError Password model.errors
                , styled button
                    [ width, margin, cursor pointer ]
                    []
                    [ "Login" |> text ]
                ]
            ]


viewFormError : FormField -> List Error -> Html msg
viewFormError field errors =
    errors
        |> List.filter (\( fieldError, _ ) -> fieldError == field)
        |> List.map
            (\( _, error ) ->
                li []
                    [ error |> Components.error ]
            )
        |> ul []



-- UPDATE --


type Msg
    = SubmitForm
    | SetEmail String
    | SetPassword String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        SubmitForm ->
            case validate modelValidator model of
                [] ->
                    { model | errors = [], email = "", password = "" } => Cmd.none

                errors ->
                    { model | errors = errors } => Cmd.none

        SetEmail str ->
            { model | email = str } ! []

        SetPassword str ->
            { model | password = str } ! []



-- VALIDATION


type FormField
    = Email
    | Password


type alias Error =
    ( FormField, String )


modelValidator : Validator Error Model
modelValidator =
    Validate.all
        [ Validate.firstError
            [ ifBlank .email (Email => "Email can't be blank.")
            , ifInvalidEmail .email (\email -> Email => ("Unfortunately, \"" ++ email ++ "\" is not a valid e-mail adress."))
            ]
        , ifBlank .password (Password => "Password can't be blank.")
        ]
