port module Application exposing (..)

import Html.Styled exposing (Html, div, program, toUnstyled)
import Html.Styled as Html
import Utils exposing ((=>))
import Page.Login as Login
import Page.Home as Home
import Page.Tryout as Tryout
import Page.Errored as Errored exposing (PageLoadError)
import Route exposing (Route)
import Views.Page exposing (frame)
import Task
import Navigation exposing (Location)
import Json.Decode as Decode exposing (Value)


{-| Current browser url gets injected and handled by
  | Navigation.programWithFlags and internal message
  | SetRoute. Since we use elm-css and there is no drop in
  | replacement for Navigation.programWithFlags style translation
  | is done manually.
-}
main : Program Value Model Msg
main =
    Navigation.programWithFlags (Route.fromLocation >> SetRoute)
        { init = init
        , view = (view >> toUnstyled)
        , update = update
        , subscriptions = subscriptions
        }


{-| Set initial route from startup
-}
init : Value -> Location -> ( Model, Cmd Msg )
init val location =
    setRoute (Route.fromLocation location)
        { pageState = Loaded (Home Home.initialModel) }


{-| Currently no subscriptions are used
-}
subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



-- MODEL


{-| A Page defines a single page which can be shown by the application.
  | There is one Page value for each page with its attached model.
-}
type Page
    = Blank
    | Home Home.Model
    | Login Login.Model
    | Tryout Tryout.Model


{-| A Page can be either loaded or there is a transition from a current
  | page to a new page.
-}
type PageState
    = Loaded Page
    | TransitioningFrom Page


{-| Application model holds the current pageState.
-}
type alias Model =
    { pageState : PageState
    }



-- ACTIONS


type Msg
    = SetRoute (Maybe Route)
    | HomeLoaded (Result PageLoadError Home.Model)
    | LoginMsg Login.Msg
    | HomeMsg Home.Msg
    | TryoutMsg Tryout.Msg



-- UPDATE


transition : Model -> (Result x a -> msg) -> Task.Task x a -> ( Model, Cmd msg )
transition model toMsg task =
    { model | pageState = TransitioningFrom (getPage model) }
        => Task.attempt toMsg task


{-| Maps the requested root to according page or get init tasks from
  | requested page modules.
-}
setRoute : Maybe Route -> Model -> ( Model, Cmd Msg )
setRoute maybeRoute model =
    case maybeRoute of
        Nothing ->
            { model | pageState = Loaded (Home Home.initialModel) } => Cmd.none

        Just (Route.Home) ->
            { model | pageState = Loaded (Home Home.initialModel) } => Cmd.none

        Just (Route.Login) ->
            { model | pageState = Loaded (Login Login.initialModel) } => Cmd.none

        Just (Route.Tryout) ->
            { model | pageState = Loaded (Tryout Tryout.initialModel) } => Cmd.none


{-| Handles routing messages and does dispatching of
  | child module update functions.
-}
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

            ( TryoutMsg a, Tryout subModel ) ->
                let
                    ( newModel, cmd ) =
                        Tryout.update a subModel
                in
                    { model | pageState = Loaded (Tryout newModel) }
                        => (Cmd.map TryoutMsg cmd)

            ( _, _ ) ->
                model => Cmd.none



-- VIEW


{-| get current page from model (removes loaded/transitioning information)
-}
getPage : Model -> Page
getPage model =
    case model.pageState of
        Loaded page ->
            page

        TransitioningFrom page ->
            page


{-| -}
view : Model -> Html Msg
view =
    getPage >> viewPage


{-| Renders child page within a globally used frame.
-}
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

            Tryout subModel ->
                Tryout.view subModel
                    |> Html.map TryoutMsg
                    |> frame

            Blank ->
                div [] []
        ]
