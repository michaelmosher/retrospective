module Retrospective.View exposing (view)

import Char
import Html exposing (Html, body, button, div, h1, input, li, section, text, ul)
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
        inputStyles = [
            ("width", "400px"),
            ("height", "100%"),
            ("margin", "auto"),
            ("border", "none")
        ]
        buttonStyles = [
            ("width", "3em"),
            ("height", "100%"),
            ("margin-left", "-20"),
            ("border", "none")
        ]
        divStyles = [
            ("min-height", "2em"),
            ("height", "2em")
        ]
    in
        section [] [
            div [style divStyles] [
                input [style inputStyles, placeholder ph, value wipNote, onEnter submit, onInput Typing] [],
                button [style buttonStyles, onClick submit] [text resString]
            ]
        ]

votingButton : Bool -> Html Msg
votingButton voting =
    let buttonText = if voting
            then "Stop Voting"
            else "Start Voting"
    in button [onClick ToggleVoting] [buttonText |> text]

ideaSection : Model -> Html Msg
ideaSection model =
    let styles = [
            ("display", "flex"),
            ("flex-direction", "row")
        ]
    in
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
        bgColor = case kind of
            Start    -> "lightgreen"
            Continue -> "lightblue"
            Stop     -> "pink"
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
    let bgColor = case i.kind of
            Start    -> "lightgreen"
            Continue -> "lightblue"
            Stop     -> "pink"
        styles = [("background", bgColor)]
    in li [style styles, onClick (EditIdea i)] [i.note |> text]

votableIdea : Idea -> Html.Html Msg
votableIdea i =
    div [] [
        button [onClick (MinusScore i)] [text "-"],
        li [] [i.note ++ " - " ++ toString i.score |> text],
        button [onClick (PlusScore i)] [text "+"]
    ]

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
