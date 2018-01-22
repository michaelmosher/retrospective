module Retrospective.Views.JiraReview exposing (view)

import Css exposing (..)
import Html.Styled exposing (Html, button, article, h1, p, span, text)
import Html.Styled.Attributes exposing (css)
import Html.Styled.Events exposing (onClick)

import Retrospective.Model exposing (..)

view : Model -> Html Msg
view _ =
    let pStyles = [
        textAlign justify,
        width (px 400),
        margin auto
    ]
    in article [] [
        h1 [] [text "Jira Review"],
        p [css pStyles] reviewSteps,
        button [css [fontSize (em 1.1)], onClick (Step Listing)] [text "proceed"]
    ]

reviewSteps : List(Html Msg)
reviewSteps =
    [
        text "Take a moment to go to Jira, close out the current sprint ",
        text "and review the burndown graph. Then, click proceed to move on."
    ]
