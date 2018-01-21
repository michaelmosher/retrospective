module Retrospective.Views.Shared exposing (ideaSection)

import Css exposing (..)
import Html.Styled exposing (Html, section, ul)
import Html.Styled.Attributes exposing (css)

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
