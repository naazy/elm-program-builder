module ManageInformationView exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput, onBlur)
import MainMessages exposing (..)
import MainModel exposing (..)
import MainMessages exposing (..)
import GetWarning exposing (..)
import Json.Decode
import Json.Decode.Pipeline exposing (required, optional, decode)


-- import Ports exposing (FilePortData, fileSelected, fileContentRead)

import Html.Events exposing (on)


view : Model -> Html Msg
view model =
    let
        displayDiv =
            if (not model.showManageInformationUi) then
                "none"
            else
                "block"

        savedInformationDivs =
            List.map (\f -> div [] [ a [ href f.filelink ] [ text f.filetitle ] ]) model.savedFiles

        filesToSaveDivs =
            model.filesToSave
                |> List.map
                    (\f ->
                        div []
                            [ div [ class "form__question-sub-section form__question-sub-section--table" ]
                                [ input
                                    [ class "form__input"
                                    , type_ "text"
                                    , placeholder "File title"
                                    , id ("file-title-" ++ (toString f.id))
                                    ]
                                    []
                                ]
                            , div
                                [ class "form__question-sub-section form__question-sub-section--table" ]
                                [ input
                                    [ id (toString f.id)
                                    , type_ "file"
                                    , on "change"
                                        (Json.Decode.succeed (FileSelected f.id))
                                    ]
                                    []
                                ]
                            ]
                    )
    in
        div [ class "form form--add-to-view", style [ ( "display", displayDiv ) ] ]
            [ div [] savedInformationDivs
            , div [] filesToSaveDivs
            , div [ class "bar bar--button" ]
                [ button
                    [ class "button button--tertiary button--wider"
                    , type_ "button"
                    , onClick AddNewInformation
                    ]
                    [ text "Add New Information" ]
                , button [ class "button button--primary button--wider", type_ "button", onClick SaveFiles ]
                    [ text "Save" ]
                ]
            ]
