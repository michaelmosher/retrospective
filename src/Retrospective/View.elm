module Retrospective.View exposing (view)

import Css exposing (..)
import Html.Styled as Html exposing (Html, body, div, section, span, text)
import Html.Styled.Attributes exposing (css)

import Retrospective.Model exposing (Idea, Kind(..), Model, Msg(..), Stage(..))
import Retrospective.Views.Listing as Views

view : Model -> Html Msg
view model =
    div [css [textAlign Css.center]] [
        header model.stage,
        body model
    ]

header : Stage -> Html Msg
header active =
    let styles = [
        displayFlex,
        overflow hidden,
        fontSize (em 1.25),
        marginBottom (px 20)
    ]
    in Html.header [css styles] [
        headerTab Beginning active,
        headerTab JiraReview active,
        headerTab Listing active,
        headerTab Voting active,
        headerTab Report active
    ]

body : Model -> Html Msg
body model =
    case model.stage of
        _ -> Views.listing model

headerTab : Stage -> Stage -> Html Msg
headerTab stage active =
    let color = if stage == active
            then theme.orange
            else theme.peru
        styles = [
        flexGrow (num 1),
        backgroundColor color,
        position relative,
        paddingLeft (px 30),
        marginRight (px 5),
        before beforeNavigationStyles,
        after (afterNavigationStyles color)
    ]
    in div [css styles] [toString stage |> text]

theme : { orange : Color, peru : Color, white : Color }
theme =
    { orange = hex "FFA500"
    , peru = hex "CD853F"
    , white = hex "FFFFFF"
    }

afterNavigationStyles : Color -> List(Style)
afterNavigationStyles color =
    sharedNavigationStyles ++ [
        borderLeft3 (px 30) solid color,
        zIndex (int 2)
    ]

beforeNavigationStyles : List(Style)
beforeNavigationStyles =
    sharedNavigationStyles ++ [
        borderLeft3 (px 30) solid theme.white,
        marginLeft (px 5),
        zIndex (int 1)
    ]

sharedNavigationStyles : List(Style)
sharedNavigationStyles = [
        property "content" "' '",
        borderTop3 (px 50) solid transparent,
        borderBottom3 (px 50) solid transparent,
        position absolute,
        top (pct 50),
        left (pct 100),
        marginTop (px -50)
    ]