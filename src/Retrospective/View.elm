module Retrospective.View exposing (view)

import Char
import Html exposing (Html, body, button, div, h1, input, li, section, span, text, ul)
import Html.Attributes exposing (placeholder, style, value)
import Html.Events exposing (on, onClick, onInput)
import Json.Decode as Json
import Retrospective.Model exposing (Idea, Kind(..), Model, Msg(..))

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
    div [] [
        ideaBox model,
        ideaSection model,
        votingButton model.voting
    ]

ideaBox : Model -> Html Msg
ideaBox model =
    let submit = AddIdea model.wipIdea
        wipNote = model.wipIdea.note
        ph = "Ideas to start, stop, or continue"
        resString = String.fromChar (Char.fromCode 9654)
        borderColor = kindColor model.activeKind
        inputStyles = [
            ("width", "500px"),
            ("height", "4em"),
            ("margin", "auto"),
            ("padding", "5px"),
            ("border", "solid " ++ borderColor),
            ("border-width", "3px")
        ]
        divStyles = [
            ("width", "500px"),
            ("height", "2em"),
            ("line-height", "2em"),
            ("margin", "auto"),
            ("display", "flex"),
            ("justify-content", "center")
        ]
    in
        section [] [
            div [style divStyles] [
                ideaTab Start,
                ideaTab Stop,
                ideaTab Continue
            ],
            input [style inputStyles, placeholder ph, value wipNote, onEnter submit, onInput Typing] []
        ]

ideaTab : Kind -> Html Msg
ideaTab kind =
    let bgColor = kindColor kind
        styles = [
            ("background", bgColor),
            ("flex-grow", "1"),
            ("flex-basis", "0")
        ]
    in span [style styles, onClick (Change kind)] [toString kind |> text]

votingButton : Bool -> Html Msg
votingButton voting =
    let buttonText = if voting
            then "Stop Voting"
            else "Start Voting"
    in button [onClick ToggleVoting] [buttonText |> text]

ideaSection : Model -> Html Msg
ideaSection model =
    section [style [("display", "flex")]] [
        startIdeaList model.ideas model.voting,
        stopIdeaList model.ideas model.voting,
        continueIdeaList model.ideas model.voting
    ]

startIdeaList : List(Idea) -> Bool -> Html Msg
startIdeaList = ideaList Start

stopIdeaList : List(Idea) -> Bool -> Html Msg
stopIdeaList = ideaList Stop

continueIdeaList : List(Idea) -> Bool -> Html Msg
continueIdeaList = ideaList Continue

ideaList : Kind -> List(Idea) -> Bool -> Html Msg
ideaList kind ideas voting =
    let ideas_ = List.filter (\i -> i.kind == kind) ideas
        bgColor = kindColor kind
        styles = [
            ("text-align", "left"),
            ("background", bgColor),
            ("width", "33%"),
            ("min-height", "3em")
        ]
    in ideas_ |> List.map (renderIdea voting) |> ul [style styles]

renderIdea : Bool -> Idea -> Html.Html Msg
renderIdea voting i =
    case voting of
        True  -> votableIdea i
        False -> editableIdea i

editableIdea : Idea -> Html.Html Msg
editableIdea i =
    li [onClick (EditIdea i)] [i.note |> text]

votableIdea : Idea -> Html.Html Msg
votableIdea i =
    div [] [
        button [onClick (MinusScore i)] [text "-"],
        li [] [i.note ++ " - " ++ toString i.score |> text],
        button [onClick (PlusScore i)] [text "+"]
    ]

kindColor : Kind -> String
kindColor kind =
    case kind of
        Start    -> "lightgreen"
        Continue -> "lightblue"
        Stop     -> "pink"

-- borrowed from elm-todomvc
-- ref: https://github.com/evancz/elm-todomvc/blob/166e5f2afc704629ee6d03de00deac892dfaeed0/Todo.elm#L237-L246
onEnter : Msg -> Html.Attribute Msg
onEnter msg =
    let
        isEnter code =
            if code == 13 then
                Json.succeed msg
            else
                Json.fail "not ENTER"
    in
        on "keydown" (Json.andThen isEnter Html.Events.keyCode)
