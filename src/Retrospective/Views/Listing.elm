module Retrospective.Views.Listing exposing (view)

import Html.Styled exposing (Html, article, body, button, div, h1, input, li, section, span, text, ul)
import Html.Styled.Attributes exposing (placeholder, style, value)
import Html.Styled.Events exposing (on, onClick, onInput)
import Json.Decode as Json

import Retrospective.Model exposing (..)
import Retrospective.Views.Shared exposing (ideaSection)

view : Model -> Html Msg
view model =
    article [] [
        ideaBox model,
        ideaSection renderIdea model,
        votingButton
    ]

ideaBox : Model -> Html Msg
ideaBox model =
    section [] [
        ideaHeader,
        ideaBody model
    ]

ideaHeader : Html Msg
ideaHeader =
    let styles = [
            ("width", "600px"),
            ("height", "2em"),
            ("line-height", "2em"),
            ("margin", "auto"),
            ("display", "flex"),
            ("justify-content", "center")
    ]
    in div [style styles] [
            ideaTab Start,
            ideaTab Stop,
            ideaTab Continue
        ]

ideaBody : Model -> Html Msg
ideaBody model =
    let wipNote = model.wipIdea.note
        borderColor = kindColor model.activeKind

        inputStyles = [
            ("width", "600px"),
            ("height", "4em"),
            ("resize", "none"),
            ("margin", "auto"),
            ("padding", "5px"),
            ("border-width", "5px"),
            ("border-style", "solid"),
            ("border-color", borderColor),
            ("font-size", "1em")
        ]

        attributes = [
            style inputStyles,
            placeholder "Ideas to start, stop, or continue",
            value wipNote,
            onEnter (AddIdea model.wipIdea),
            onInput Typing
        ]
    in input attributes []

ideaTab : Kind -> Html Msg
ideaTab kind =
    let bgColor = kindColor kind
        styles = [
            ("background", bgColor),
            ("flex-grow", "1"),
            ("flex-basis", "0")
        ]
    in span [style styles, onClick (Change kind)] [toString kind |> text]

votingButton : Html Msg
votingButton =
    button [onClick (Step Voting)] [text "Start Voting"]

renderIdea : Idea -> Html Msg
renderIdea i =
    li [onClick (EditIdea i)] [i.note |> text]


kindColor : Kind -> String
kindColor kind =
    case kind of
        Start    -> "lightgreen"
        Continue -> "lightblue"
        Stop     -> "pink"

-- adjusted from elm-todomvc
-- ref: https://github.com/evancz/elm-todomvc/blob/166e5f2afc704629ee6d03de00deac892dfaeed0/Todo.elm#L237-L246
onEnter : Msg -> Html.Styled.Attribute Msg
onEnter msg =
    let
        isEnter code =
            if code == 13 then
                Json.succeed msg
            else
                Json.fail "not ENTER"
    in
        on "keydown" (Json.andThen isEnter Html.Styled.Events.keyCode)
