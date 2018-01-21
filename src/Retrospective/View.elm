module Retrospective.View exposing (view)

import Css exposing (..)
import Html.Styled as Html exposing (Html, body, div, section, span, text)
import Html.Styled.Attributes exposing (css)
import Html.Styled.Events exposing (onClick)

import Retrospective.Model exposing (Idea, Kind(..), Model, Msg(..), Stage(..))
import Retrospective.Views.JiraReview as JiraReview
import Retrospective.Views.Listing as Listing
import Retrospective.Views.Report as Report
import Retrospective.Views.Voting as Voting

view : Model -> Html Msg
view model =
    div [css [textAlign Css.center]] [
        header model.stage,
        body model
    ]

header : Stage -> Html Msg
header activeStage =
    let stages = [Beginning, JiraReview, Listing, Voting, Report]
        styles = [
            displayFlex,
            overflow hidden,
            fontSize (em 1.25),
            marginBottom (px 20)
        ]
    in List.map (\stage -> headerTab stage activeStage) stages
        |> Html.header [css styles]

body : Model -> Html Msg
body model =
    case model.stage of
        JiraReview -> JiraReview.view model
        Voting -> Voting.view model
        Report -> Report.view model
        _      -> Listing.view model

headerTab : Stage -> Stage -> Html Msg
headerTab stage active =
    if stage == active
        then activeTab stage
        else inactiveTab stage

activeTab : Stage -> Html Msg
activeTab = renderTab theme.orange

inactiveTab : Stage -> Html Msg
inactiveTab = renderTab theme.peru

renderTab : Color -> Stage -> Html Msg
renderTab color stage =
    div [css (tabStyles color), onClick (Step stage)] [toString stage |> text]

theme : { orange : Color, peru : Color, white : Color }
theme =
    { orange = hex "FFA500"
    , peru = hex "CD853F"
    , white = hex "FFFFFF"
    }

tabStyles : Color -> List(Style)
tabStyles color =
    [
        flexGrow (num 1),
        backgroundColor color,
        position relative,
        paddingLeft (px 30),
        marginRight (px 5),
        before beforeNavigationStyles,
        after (afterNavigationStyles color)
    ]

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