module Data.Task exposing (..)

import Json.Decode as Decode exposing (Decoder)
import Json.Decode.Extra
import Json.Decode.Pipeline exposing (custom, decode, hardcoded, required)
import Utils exposing ((=>))
import Json.Encode as Encode exposing (Value)


type alias Task =
    { id : TaskId
    , title : String
    , duration : Int
    , urgency : Int
    }



-- SERIALIZATION --


decoder : Decoder Task
decoder =
    decode Task
        |> required "id" taskIdDecoder
        |> required "title" Decode.string
        |> required "duration" Decode.int
        |> required "urgency" Decode.int


encode : Task -> Value
encode task =
    Encode.object
        [ "id" => Encode.int (taskIdToInt task.id)
        , "title" => Encode.string task.title
        , "duration" => Encode.int task.duration
        , "urgency" => Encode.int task.urgency
        ]



-- IDENTIFIERS --


type TaskId
    = TaskId Int


taskIdDecoder : Decoder TaskId
taskIdDecoder =
    Decode.map TaskId Decode.int


taskIdToInt : TaskId -> Int
taskIdToInt (TaskId id) =
    id
