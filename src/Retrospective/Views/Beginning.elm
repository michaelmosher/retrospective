module Retrospective.Views.Beginning exposing (view)

import Css exposing (..)
import Html.Styled exposing (Html, article, button, input, ul, li, text)
import Html.Styled.Attributes exposing (css, placeholder, value)
import Html.Styled.Events exposing (onClick, onInput)

import Retrospective.Model exposing (..)
import Retrospective.Views.Shared exposing (onEnter)


view : Model -> Html Msg
view model =
    let listStyles = [
            textAlign left,
            width (px 300),
            margin2 (px 10) auto
        ]
    in article [] [
            participantInput model,
            List.map renderParticipant model.participants |> ul [css listStyles],
            button [onClick (Step JiraReview)] [text "proceed"]
        ]

participantInput : Model -> Html Msg
participantInput model =
    let styles = [
            width (px 400),
            height (em 2),
            lineHeight (em 2),
            fontSize (em 1)
        ]
        attributes = [
            css styles,
            placeholder "Input retrospective participants here...",
            value model.wipParticipant,
            onEnter (AddParticipant model.wipParticipant),
            onInput Typing
        ]
    in input attributes []

renderParticipant : Participant -> Html Msg
renderParticipant participant =
    li [css [fontSize (em 1.5)]] [text participant.name]