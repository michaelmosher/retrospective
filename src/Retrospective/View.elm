module Retrospective.View exposing (view)

import Html exposing (Html, body, div, h1, section, text)
import Html.Attributes exposing (style)

import Retrospective.Model exposing (Idea, Kind(..), Model, Msg(..), Stage(..))
import Retrospective.Views.Listing as Views

view : Model -> Html Msg
view model =
    div [style [("text-align", "center")]] [
        header,
        body model
    ]

header : Html Msg
header = h1 [] [text "Retrospective!"]

body : Model -> Html Msg
body model =
    case model.stage of
        _ -> Views.listing model
