module Retrospective.Views.Voting exposing (view)

import Char
import Css exposing (..)
import Html.Styled exposing (Html, article, button, div, li, section, span, text)
import Html.Styled.Attributes exposing (css, style)

import Retrospective.Model exposing (..)
import Retrospective.Views.Shared exposing (ideaSection)

view : Model -> Html Msg
view model =
    article [] [
        span [] [text "Click ideas below to vote"],
        votesBox,
        ideaSection renderIdea model,
        submitButton
    ]

submitButton : Html Msg
submitButton =
    button [] [text "Submit Votes"]

renderIdea : Idea -> Html Msg
renderIdea i =
    div [] [
        li [] [i.note |> text],
        div [css [minHeight (px 45)]] []
    ]

votesBox : Html Msg
votesBox =
    let styles = [
            displayFlex,
            justifyContent center,
            width (px 100),
            margin auto
        ]
    in div [css styles] [
            vote, vote, vote
        ]

vote : Html Msg
vote =
    let styles = [
        width (px 30),
        height (px 30),
        fontSize (em 1.35),
        lineHeight (em 1),
        backgroundColor (hex "008000"), -- "green"
        color (hex "ffffff"), -- "white"
        borderRadius (px 20)
    ]
    in div [css styles] [checkMark |> text]

checkMark : String
checkMark = String.fromChar (Char.fromCode 10004)