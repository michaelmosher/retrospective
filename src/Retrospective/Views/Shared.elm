module Retrospective.Views.Shared exposing (ideaSection, onEnter)

import Css exposing (..)
import Html.Styled exposing (Html, section, ul)
import Html.Styled.Attributes exposing (css)
import Html.Styled.Events exposing (on)
import Json.Decode as Json

import Retrospective.Model exposing (..)

ideaSection : (Idea -> Html Msg) -> Model -> Html Msg
ideaSection renderFn model =
    let kinds = [Start, Stop, Continue]
    in List.map (\k -> ideaList k renderFn model.ideas) kinds
        |> section [css [displayFlex]]

ideaList : Kind -> (Idea -> Html Msg) -> List(Idea) -> Html Msg
ideaList kind renderFn ideas =
    let ideas_ = List.filter (\i -> i.kind == kind) ideas
        bgColor = kindColor kind
    in ideas_ |> List.map renderFn |> ul [css (ideaListStyles bgColor)]

ideaListStyles : Color -> List(Style)
ideaListStyles color =
    [
        width (pct 33),
        textAlign left,
        backgroundColor color,
        paddingTop (px 10),
        paddingBottom (px 10),
        paddingRight (px 5),
        minHeight (em 3)
    ]

kindColor : Kind -> Color
kindColor kind =
    case kind of
        Start    -> hex "90EE90" -- "lightgreen"
        Continue -> hex "ADD8E6" -- "lightblue"
        Stop     -> hex "FFC0CB" -- "pink"

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