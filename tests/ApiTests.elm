module ApiTests exposing (..)

import Test exposing (..)
import Expect
import Api
import Json.Decode
import MainModel exposing (ApiUpdate, Session, Track, Column, DateWithoutTime)
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
                        case Json.Decode.decodeString Api.apiUpdateDecoder apiJson of
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
  "sessions": [
    {
      "id": 1,
      "name": """ ++ (toString sessionName) ++ """,
      "description": """ ++ (toString sessionDescription) ++ """,
      "date": {
        "year":  """ ++ (toString sessionYear) ++ """,
        "month": """ ++ (toString sessionMonth) ++ """,
        "day": 1
      },
      "startTime": {
        "hour": 9,
        "minute": 0
      },
      "endTime": {
        "hour": 9,
        "minute": 30
      },
      "columnId": 1,
      "trackId": 1,
      "location": "This is the location",
      "submissionIds": [],
      "chair": "This is the chair"
    }
  ],
  "tracks": [
    {
      "id": 1,
      "name": "track 1"
    }
  ],
  "columns": [
    {
      "id": 1,
      "name": "column 1"
    }
  ],
  "dates": [
    {
      "year": """ ++ (toString sessionYear) ++ """,
      "month":  """ ++ (toString sessionMonth) ++ """,
      "day": 1
    }
  ]
}"""


createApiUpdate : String -> String -> Int -> Int -> ApiUpdate
createApiUpdate sessionName sessionDescription sessionYear sessionMonth =
    ApiUpdate
        [ createSession sessionName sessionDescription sessionYear sessionMonth ]
        [ Track 1 "track 1" ]
        [ Column 1 "column 1" ]
        [ DateWithoutTime sessionYear sessionMonth 1 ]


createSession : String -> String -> Int -> Int -> Session
createSession sessionName sessionDescription sessionYear sessionMonth =
    Session
        1
        sessionName
        sessionDescription
        { year = sessionYear
        , month = sessionMonth
        , day = 1
        }
        { hour = 9
        , minute = 0
        }
        { hour = 9
        , minute = 30
        }
        1
        1
        "This is the location"
        []
        "This is the chair"