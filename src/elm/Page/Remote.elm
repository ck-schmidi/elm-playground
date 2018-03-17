module Page.Remote exposing (..)

import Html.Styled exposing (Html, div, text, ul, li, styled)
import Html.Styled.Events exposing (onClick, onInput)
import Html.Styled.Attributes exposing (value)
import Data.Task
import Page.Errored exposing (PageLoadError, pageLoadError)
import Request.Task
import Views.Page as Page
import Http
import Task
import Views.Components exposing (button, input)
import Css exposing (margin, pt, marginLeft)


-- MODEL --


type alias Model =
    { tasks : List Data.Task.Task
    , title : String
    }


init : Task.Task PageLoadError Model
init =
    Request.Task.getAll Nothing
        |> Http.toTask
        |> Task.mapError (\_ -> pageLoadError Page.Other "Tasks are currently unavailable.")
        |> Task.map initialModel


initialModel : List Data.Task.Task -> Model
initialModel tasks =
    { tasks = tasks
    , title = ""
    }



-- VIEW --


view : Model -> Html Msg
view model =
    styled div
        [ margin (pt 10) ]
        []
        [ input [ onInput TitleChanged, value model.title ] []
        , styled button
            [ marginLeft (pt 10) ]
            [ onClick CreateTask ]
            [ "add task" |> text ]
        , ul []
            (List.map
                (\t ->
                    li []
                        [ t.title
                            |> text
                        ]
                )
                model.tasks
            )
        ]



-- UPDATE


type Msg
    = TitleChanged String
    | CreateTask
    | Response (Result Http.Error Data.Task.Task)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        TitleChanged title ->
            { model | title = title } ! []

        Response (Err err) ->
            model ! []

        Response (Ok task) ->
            { model | tasks = List.append model.tasks [ task ] } ! []

        CreateTask ->
            let
                task =
                    { id = Data.Task.TaskId 0
                    , duration = 0
                    , urgency = 0
                    , title = model.title
                    }

                request =
                    (Request.Task.create Nothing task) |> Http.send Response
            in
                { model | title = "" } ! [ request ]
