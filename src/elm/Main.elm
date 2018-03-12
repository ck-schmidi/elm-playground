port module Application exposing (..)

import Html.Styled exposing (Html, div, program, toUnstyled)
import Html.Styled as Html
import Utils exposing ((=>))
import Page.Login as Login
import Page.Home as Home
import Page.Errored as Errored exposing (PageLoadError)
import Route exposing (Route)
import Views.Page exposing (frame)
import Task
import Navigation exposing (Location)
import Json.Decode as Decode exposing (Value)


main : Program Value Model Msg
main =
    Navigation.programWithFlags (Route.fromLocation >> SetRoute)
        { init = init
        , view = (view >> toUnstyled)
        , update = update
        , subscriptions = subscriptions
        }


init : Value -> Location -> ( Model, Cmd Msg )
init val location =
    setRoute (Route.fromLocation location) model


initialPage : Page
initialPage =
    Home Home.initialModel



-- PORT


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- MODEL


type Page
    = Blank
    | Home Home.Model
    | Login Login.Model


type PageState
    = Loaded Page
    | TransitioningFrom Page


type alias Model =
    { pageState : PageState
    }


model : Model
model =
    { pageState = Loaded (Login Login.initialModel)
    }



-- ACTIONS


type Msg
    = SetRoute (Maybe Route)
    | HomeLoaded (Result PageLoadError Home.Model)
    | LoginMsg Login.Msg
    | HomeMsg Home.Msg



-- UPDATE


setRoute : Maybe Route -> Model -> ( Model, Cmd Msg )
setRoute maybeRoute model =
    let
        transition toMsg task =
            { model | pageState = TransitioningFrom (getPage model) }
                => Task.attempt toMsg task
    in
        case maybeRoute of
            Nothing ->
                { model | pageState = Loaded (Home Home.initialModel) } => Cmd.none

            Just (Route.Home) ->
                { model | pageState = Loaded (Home Home.initialModel) } => Cmd.none

            Just (Route.Login) ->
                { model | pageState = Loaded (Login Login.initialModel) } => Cmd.none


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        page =
            getPage model
    in
        case ( msg, page ) of
            ( SetRoute route, _ ) ->
                setRoute route model

            ( HomeMsg a, Home subModel ) ->
                model => Cmd.none

            ( LoginMsg a, Login subModel ) ->
                let
                    ( newModel, cmd ) =
                        Login.update a subModel
                in
                    { model | pageState = Loaded (Login newModel) }
                        => (Cmd.map LoginMsg cmd)

            ( _, _ ) ->
                model => Cmd.none



-- VIEW


getPage : Model -> Page
getPage model =
    case model.pageState of
        Loaded page ->
            page

        TransitioningFrom page ->
            page


view : Model -> Html Msg
view =
    getPage >> viewPage


viewPage : Page -> Html Msg
viewPage page =
    div []
        [ case page of
            Login subModel ->
                Login.view subModel
                    |> Html.map LoginMsg
                    |> frame

            Home subModel ->
                Home.view subModel
                    |> Html.map HomeMsg
                    |> frame

            Blank ->
                div [] []
        ]
