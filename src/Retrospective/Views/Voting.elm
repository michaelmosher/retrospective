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
    let votersRemaining = List.filter (\p -> not p.hasVoted) model.participants
    in case List.head votersRemaining of
        Nothing -> noVoterView model
        Just p  -> voterView model p

voterView : Model -> Participant -> Html Msg
voterView model p =
    article [] [
        span [] [p.name ++ ": Please place your votes below" |> text],
        votesBox p.votesRemaining,
        ideaSection (renderVotableIdea p) model,
        submitButton p
    ]

noVoterView : Model -> Html Msg
noVoterView model =
    article [] [
        span [] [text "Everyone has voted. Click proceed to see results."],
        ideaSection renderFixedIdea model,
        proceedButton
    ]

submitButton : Participant -> Html Msg
submitButton p =
    button [onClick (SubmitVotes p)] [text "Submit Votes"]

proceedButton : Html Msg
proceedButton =
    button [onClick (Step Report)] [text "Proceed"]

renderVotableIdea : Participant -> Idea -> Html Msg
renderVotableIdea p i =
    div [] [
        li [onClick (Upvote p i)] [i.note |> text],
        div [css [displayFlex, minHeight (px 45)]] (votes (Downvote p i) i.votes)
    ]

renderFixedIdea : Idea -> Html Msg
renderFixedIdea i =
    div [] [
        li [] [i.note |> text]
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