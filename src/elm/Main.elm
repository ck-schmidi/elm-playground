port module Application exposing (..)

import Html.Styled exposing (Html, div, program)
import Html.Styled as Html
import Utils exposing ((=>))
import Page.Login as Login
import Page.Home as Home


main : Program Never Model Msg
main =
    program
        { init = model ! []
        , view = view
        , subscriptions = subscriptions
        , update = update
        }



-- PORT


port foo : String -> Cmd msg


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
    { login : Login.Model
    , pageState : PageState
    }


model : Model
model =
    { login = Login.initialModel
    , pageState = Loaded (Login Login.initialModel)
    }



-- ACTIONS


type Msg
    = LoginMsg Login.Msg
    | HomeMsg Home.Msg



-- UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    let
        page =
            getPage model
    in
        case ( msg, page ) of
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
                Login.view subModel |> Html.map LoginMsg

            Home subModel ->
                Home.view subModel |> Html.map HomeMsg

            Blank ->
                div [] []
        ]
