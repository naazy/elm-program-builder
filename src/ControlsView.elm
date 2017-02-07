module ControlsView exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import MainMessages exposing (..)
import MainModel exposing (..)
import NewSessionView exposing (NewSessionContext, view)
import NewColumnView
import NewTrackView


view : Model -> Html Msg
view model =
    let
        context =
            case model.idOfSessionBeingEdited of
                Just id ->
                    NewSessionContext "Edit session" EditSession model.editSession

                Nothing ->
                    NewSessionContext "New session" CreateNewSession model.newSession
    in
        div []
            [ viewUiButtons model
            , NewSessionView.view context model
            , NewColumnView.view model
            , NewTrackView.view model
            ]


viewUiButtons : Model -> Html Msg
viewUiButtons model =
    let
        toggleNewSessionClass =
            if model.showNewSessionUi && model.idOfSessionBeingEdited == Nothing then
                "btn btn-default active"
            else
                "btn btn-default"

        toggleNewColumnClass =
            if model.showNewColumnUi then
                "btn btn-default active"
            else
                "btn btn-default"

        toggleNewTrackClass =
            if model.showNewTrackUi then
                "btn btn-default active"
            else
                "btn btn-default"
    in
        div [ class "btn-toolbar", attribute "role" "toolbar", style [ ( "margin", "3rem" ) ] ]
            [ div [ class "btn-group btn-group-lg", attribute "role" "group" ]
                [ button [ class toggleNewSessionClass, type_ "button", onClick ToggleNewSessionUi ]
                    [ text "New Session" ]
                , button [ class toggleNewTrackClass, type_ "button", onClick ToggleNewTrackUi ]
                    [ text "New Track" ]
                , button [ class toggleNewColumnClass, type_ "button", onClick ToggleNewColumnUi ]
                    [ text "New Column" ]
                ]
            ]
