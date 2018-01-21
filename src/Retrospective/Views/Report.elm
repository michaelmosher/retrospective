module Retrospective.Views.Report exposing (view)

import Css exposing (..)
import Html.Styled exposing (Html, article, li, text, textarea)
import Html.Styled.Attributes exposing (css, placeholder)

import Retrospective.Model exposing (..)
import Retrospective.Views.Shared exposing (ideaSection)

-- TODO
-- sort model.ideas
-- bold top results
view : Model -> Html Msg
view model =
    let sorted = sortIdeasByScore model.ideas
        scores = List.map .totalScore sorted
        topScores = List.take 3 scores
        renderIdea = renderIdea_ topScores
    in article [] [
        ideaSection renderIdea { model | ideas = sorted },
        textarea [
            css [fontSize (em 1.5), minWidth (px 636), minHeight (px 200)],
            placeholder "Use this area to record action items"
        ] []
    ]

sortIdeasByScore : List(Idea) -> List(Idea)
sortIdeasByScore ideas = List.sortBy .totalScore ideas |> List.reverse

renderIdea_ : List(Int) -> Idea -> Html Msg
renderIdea_ topScores i =
    let weight = if List.member i.totalScore topScores
            then (int 700)
            else (int 400)
        styles = [
            fontWeight weight
        ]
    in li [css styles] [i.note ++ " - " ++ toString i.totalScore|> text]
