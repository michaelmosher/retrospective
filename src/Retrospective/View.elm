module Retrospective.View exposing (view)

import Html exposing (Html, body, button, div, h1, input, li, ol, text)
import Html.Attributes exposing (value)
import Html.Events exposing (on, onClick, onInput)
import Json.Decode as Json
import Retrospective.Model exposing (Idea, Model, Msg(..))

view : Model -> Html Msg
view model =
    div [] [
        header,
        body model
    ]

header : Html Msg
header = h1 [] [text "Retrospective!"]

body : Model -> Html Msg
body model =
    div [] [
        ideaBox model,
        votingButton model.voting,
        ideaList model.ideas model.voting
    ]

ideaBox : Model -> Html Msg
ideaBox model =
    let submit = AddIdea model.wipIdea
        wipNote = model.wipIdea.note
    in
        div [] [
            input [value wipNote, onEnter submit, onInput Typing] [],
            button [onClick submit] [text "Add"]
        ]

votingButton : Bool -> Html Msg
votingButton voting =
    let buttonText = if voting
            then "Stop Voting"
            else "Start Voting"
    in button [onClick ToggleVoting] [buttonText |> text]

ideaList : List(Idea) -> Bool -> Html Msg
ideaList ideas voting =
    ideas |> List.map (renderIdea voting) |> ol []

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
