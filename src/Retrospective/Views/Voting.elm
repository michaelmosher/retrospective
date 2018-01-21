module Retrospective.Views.Voting exposing (view)

import Char
import Css exposing (..)
import Html.Styled exposing (Html, article, button, div, li, section, span, text)
import Html.Styled.Attributes exposing (css, style)
import Html.Styled.Events exposing (onClick)

import Retrospective.Model exposing (..)
import Retrospective.Views.Shared exposing (ideaSection)

view : Model -> Html Msg
view model =
    article [] [
        span [] [text "Click ideas below to vote"],
        votesBox model.votesRemaining,
        ideaSection renderIdea model,
        submitButton
    ]

submitButton : Html Msg
submitButton =
    button [] [text "Submit Votes"]

renderIdea : Idea -> Html Msg
renderIdea i =
    div [] [
        li [onClick (Upvote i)] [i.note |> text],
        div [css [displayFlex, minHeight (px 45)]] (votes (Downvote i) i.votes)
    ]

votesBox : Int -> Html Msg
votesBox n =
    let styles = [
            displayFlex,
            justifyContent center,
            width (px 100),
            margin auto
        ]
    in div [css styles] (votes NoOp n)

votes : Msg -> Int -> List(Html Msg)
votes msg n =
    List.range 1 n |> List.map (\_ -> vote msg)

vote : Msg -> Html Msg
vote msg =
    let styles = [
        width (px 30),
        height (px 30),
        textAlign center,
        fontSize (em 1.35),
        lineHeight (em 1),
        backgroundColor (hex "008000"), -- "green"
        color (hex "ffffff"), -- "white"
        borderRadius (px 20)
    ]
    in div [css styles, onClick msg] [checkMark |> text]

checkMark : String
checkMark = String.fromChar (Char.fromCode 10004)