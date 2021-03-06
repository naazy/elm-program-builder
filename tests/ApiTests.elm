module ApiTests exposing (..)

import Test exposing (..)
import Expect
import Api
import Json.Decode
import MainModel exposing (ApiUpdateGet, Session, Submission, Track, Column, DateWithoutTime, Location, Chair, SavedInfo)
import Fuzz exposing (int, intRange, string)


all : Test
all =
    describe "Api functions"
        [ fuzz4 string
            string
            int
            (intRange 1 12)
            "apiUpdateDecoder should decode JSON from server into an ApiUpdate"
          <|
            \sessionName sessionDescription sessionYear sessionMonth ->
                let
                    apiJson =
                        createApiJson sessionName sessionDescription sessionYear sessionMonth

                    decodedApiJson =
                        case Json.Decode.decodeString Api.apiUpdateGetDecoder (Debug.log "apiJson" apiJson) of
                            Err str ->
                                Debug.crash str

                            Ok decodedUpdate ->
                                decodedUpdate

                    apiUpdate =
                        createApiUpdate sessionName sessionDescription sessionYear sessionMonth
                in
                    Expect.equal (apiUpdate) (decodedApiJson)
        ]


createApiJson : String -> String -> Int -> Int -> String
createApiJson sessionName sessionDescription sessionYear sessionMonth =
    """{
    "datesWithSessions": [
        {"date": {"year":2017, "month": 1, "day": 1},
        "sessions": [
          {
            "id": 1,
            "name": """ ++ (toString sessionName) ++ """,
            "description": """ ++ (toString sessionDescription) ++ """,
            "startTime": {
              "hour": 9,
              "minute": 0
            },
            "endTime": {
              "hour": 9,
              "minute": 30
            },
            "sessionColumn": 1,
            "trackId": 1,
            "chairId": 1,
            "locationId": 1,
            "submissions": []
          }
        ]
      }
  ],
  "chairs":[
    {
      "id" : 1,
      "name" : "Ines Teles"
    }
  ],
  "locations":[
    {
      "id" : 1,
      "name" : "london"
    }
  ],
  "tracks": [
    {
      "id": 1,
      "name": "track 1",
      "description": "track 1 description"
    }
  ],
  "columns": [
    {
      "id": 1,
      "name": "column 1"
    }
  ],
"submissions": [
  {"id": 1,
  "title": "Title",
  "programmeCode": "P01"}
],
"published": false,
"savedInfo":[
  {"id":0,
  "filelink":"",
  "filename": "",
  "infoTitle":"",
  "infoDescription":""}],
"hasSecureProgrammeBuilder":false
}"""


createApiUpdate : String -> String -> Int -> Int -> ApiUpdateGet
createApiUpdate sessionName sessionDescription sessionYear sessionMonth =
    ApiUpdateGet
        [ { date = { year = 2017, month = 1, day = 1 }
          , sessions = [ createSession sessionName sessionDescription sessionYear sessionMonth ]
          }
        ]
        [ Track 1 "track 1" "track 1 description" ]
        [ Location 1 "london" ]
        [ Chair 1 "Ines Teles" ]
        [ Column 1 "column 1" ]
        [ Submission 1 "Title" "P01" ]
        False
        [ SavedInfo 0 "" "" "" "" ]
        False


createSession : String -> String -> Int -> Int -> Session
createSession sessionName sessionDescription sessionYear sessionMonth =
    Session
        1
        sessionName
        sessionDescription
        { hour = 9
        , minute = 0
        }
        { hour = 9
        , minute = 30
        }
        (MainModel.ColumnId 1)
        (Just 1)
        (Just 1)
        (Just 1)
        []
