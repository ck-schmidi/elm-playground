module Page.Autocomplete exposing (..)

import String exposing (filter, contains, toLower, trim)
import Html.Styled as Html exposing (Html, div, text, fromUnstyled, toUnstyled, ul, li)
import Html.Styled.Attributes exposing (class, classList, id, value)
import Html.Styled.Events exposing (..)
import Html.Attributes as Attr
import Views.Components exposing (input)
import Autocomplete


-- MODEL --


type alias Person =
    { id : Int
    , firstName : String
    , lastName : String
    }


fullName : Person -> String
fullName p =
    p.firstName ++ " " ++ p.lastName


type alias Model =
    { autoState : Autocomplete.State
    , query : String
    , value : String
    , showMenu : Bool
    , members : List Person
    }


members : List Person
members =
    [ Person 0 "Markus" "Schmidinger"
    , Person 1 "Astrid" "Dober"
    , Person 2 "Daniel" "Dober"
    ]


init : Model
init =
    { autoState = Autocomplete.empty
    , query = ""
    , value = ""
    , showMenu = False
    , members = members
    }


acceptableMembers : String -> List Person -> List Person
acceptableMembers query people =
    let
        contains =
            (toLower << trim) query |> String.contains
    in
        List.filter (contains << toLower << fullName) people



-- VIEW --


view : Model -> Html Msg
view model =
    div []
        [ viewEditor model
        , if model.showMenu then
            viewMenu model
          else
            div [] []
        ]


viewEditor : Model -> Html Msg
viewEditor model =
    input
        [ onInput SetValue
        , value model.value
        ]
        []


viewMenu : Model -> Html Msg
viewMenu model =
    div [ class "autocomplete-menu" ]
        [ Html.map SetAutoState
            (fromUnstyled
                (Autocomplete.view
                    viewConfig
                    5
                    model.autoState
                    (acceptableMembers model.query model.members)
                )
            )
        ]


viewConfig : Autocomplete.ViewConfig Person
viewConfig =
    let
        customizedLi keySelected mouseSelected person =
            { attributes =
                [ Attr.classList
                    [ ( "autocomplete-item", True )
                    , ( "key-selected", keySelected || mouseSelected )
                    ]
                , Attr.id (person.id |> toString)
                ]
            , children =
                [ person
                    |> (fullName >> Html.text >> toUnstyled)
                ]
            }
    in
        Autocomplete.viewConfig
            { toId = (.id >> toString)
            , ul = [ Attr.class "autocomplete-list" ]
            , li = customizedLi
            }



-- UPDATE


type Msg
    = NoOp
    | SetAutoState Autocomplete.Msg
    | SelectPerson String
    | SetValue String
    | Reset Bool


update : Msg -> Model -> ( Model, Cmd msg )
update msg model =
    case Debug.log "autocomplet msg" msg of
        NoOp ->
            model ! []

        SetValue value ->
            let
                query =
                    value

                showMenu =
                    (acceptableMembers query model.members) |> (not << List.isEmpty)
            in
                { model | value = value, query = value, showMenu = showMenu } ! []

        Reset toTop ->
            model ! []

        SelectPerson id ->
            let
                selectedPerson =
                    List.filter (\person -> toString person.id == id) model.members
                        |> List.head

                query =
                    case selectedPerson of
                        Nothing ->
                            ""

                        Just person ->
                            fullName person
            in
                { model
                    | query = query
                    , value = query
                    , autoState = Autocomplete.empty
                    , showMenu = False
                }
                    ! []

        SetAutoState autoMsg ->
            let
                ( newState, maybeMsg ) =
                    Autocomplete.update updateConfig autoMsg 5 model.autoState (acceptableMembers model.query model.members)

                newModel =
                    { model | autoState = newState }
            in
                case maybeMsg of
                    Nothing ->
                        newModel ! []

                    Just updateMsg ->
                        update updateMsg newModel


updateConfig : Autocomplete.UpdateConfig Msg Person
updateConfig =
    Autocomplete.updateConfig
        { toId = .id >> toString
        , onKeyDown =
            \code maybeId ->
                if code == 38 || code == 40 then
                    Nothing
                else if code == 13 then
                    Maybe.map SelectPerson maybeId
                else
                    Just <| Reset False
        , onTooLow = Just <| Reset True
        , onTooHigh = Just <| Reset False
        , onMouseEnter = \_ -> Nothing
        , onMouseLeave = \_ -> Nothing
        , onMouseClick = \id -> Just <| SelectPerson id
        , separateSelections = False
        }
