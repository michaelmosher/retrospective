module Retrospective.Views.Voting exposing (..)

import Char
import Html exposing (Html, div, text)
import Html.Attributes exposing (style)

import Retrospective.Model exposing (..)


votableIdea : Idea -> Html Msg
votableIdea i =
    div [] []
    --     button [onClick (MinusScore i)] [text "-"],
    --     li [] [i.note ++ " - " ++ toString i.score |> text],
    --     button [onClick (PlusScore i)] [text "+"]
    -- ]

votesBox : Html Msg
votesBox =
    let styles = [
            ("display", "flex")
        ]
    in div [style styles] [
            vote, vote, vote
        ]

vote : Html.Html Msg
vote =
    let styles = [
        ("width", "40px"),
        ("height", "40px"),
        ("line-height", "1em"),
        ("background", "green"),
        ("color", "white"),
        ("border-radius", "20px")
    ]
    in div [style styles] [checkMark |> text]

checkMark : String
checkMark = String.fromChar (Char.fromCode 10004)