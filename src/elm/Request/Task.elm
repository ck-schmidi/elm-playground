module Request.Task exposing (..)

import Data.Task as Task exposing (Task, TaskId(..))
import Data.AuthToken exposing (AuthToken, withAuthorization)
import Http
import HttpBuilder exposing (RequestBuilder, withBody, withExpect, withQueryParams)
import Json.Decode as Decode exposing (Decoder)


apiUrl : String -> String
apiUrl =
    (++) "http://localhost:3001/"


tasksApi : String
tasksApi =
    apiUrl "tasks/"


expectTask : RequestBuilder a -> RequestBuilder Task
expectTask =
    Task.decoder
        |> Http.expectJson
        |> HttpBuilder.withExpect


expectTaskList : RequestBuilder a -> RequestBuilder (List Task)
expectTaskList =
    (Decode.list Task.decoder)
        |> Http.expectJson
        |> HttpBuilder.withExpect


get : TaskId -> Maybe AuthToken -> Http.Request Task
get (TaskId id) maybeToken =
    (tasksApi ++ toString id)
        |> HttpBuilder.get
        |> HttpBuilder.withExpect (Http.expectJson Task.decoder)
        |> withAuthorization maybeToken
        |> HttpBuilder.toRequest


getAll : Maybe AuthToken -> Http.Request (List Task)
getAll maybeToken =
    tasksApi
        |> HttpBuilder.get
        |> expectTaskList
        |> withAuthorization maybeToken
        |> HttpBuilder.toRequest


create : Maybe AuthToken -> Task -> Http.Request Task
create maybeToken task =
    let
        body =
            task
                |> Task.encode
                |> Http.jsonBody
    in
        tasksApi
            |> HttpBuilder.post
            |> withAuthorization maybeToken
            |> expectTask
            |> HttpBuilder.withBody body
            |> HttpBuilder.toRequest
