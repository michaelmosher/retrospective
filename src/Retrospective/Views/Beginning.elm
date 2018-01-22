module Retrospective.Views.Beginning exposing (view)

import Css exposing (..)
import Html.Styled exposing (Html, article, button, input, ul, li, text)
import Html.Styled.Attributes exposing (css, placeholder, value)
import Html.Styled.Events exposing (onClick, onInput)

import Retrospective.Model exposing (..)
import Retrospective.Views.Shared exposing (onEnter, participantList)


view : Model -> Html Msg
view model =
    article [] [
        participantInput model,
        participantList model.participants,
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
