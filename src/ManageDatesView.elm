module ManageDatesView exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import MainMessages exposing (..)
import MainModel exposing (..)
import MainMessages exposing (..)
import DateUtils exposing (displayDateWithoutTime)


view : Model -> Html Msg
view model =
    let
        toStringIgnore0 int =
            if int == 0 then
                ""
            else
                toString int

        datesInputs =
            model.dates
                |> List.indexedMap
                    (\i d ->
                        input
                            [ class "form-control pikaday-input"
                            , id ("pikaday-instance-" ++ (toString i))
                            , value (displayDateWithoutTime d)
                            ]
                            []
                    )

        column1 =
            div [ class "form-group" ]
                [ div [ class "input-group" ]
                    datesInputs
                , div [ style [ ( "margin-top", "1rem" ) ] ]
                    [ button [ class "btn btn-default", id "save-dates-btn", type_ "button" ]
                        [ text "Save Dates" ]
                    ]
                ]
    in
        div [ hidden (not model.showManageDatesUi), class "row" ]
            [ div [ class "col-md-4" ] [ column1 ]
            ]



-- TODO: add year to date string and make it so pikaday can be clicked more than once and make formatting match
