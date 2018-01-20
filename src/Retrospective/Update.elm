module Retrospective.Update exposing (update)

import Retrospective.Model exposing (Idea, Kind, Model, Msg(..))

update : Msg -> Model -> Model
update msg model =
    case msg of
        Typing s -> let newWIPIdea = model.wipIdea |> setNote s
            in { model | wipIdea = newWIPIdea }
        Change k -> let newWIPIdea = model.wipIdea |> setKind k
            in { model | activeKind = k, wipIdea = newWIPIdea}
        AddIdea i -> appendItem model i
        EditIdea i -> editIdea model i
        ToggleVoting -> { model | voting = not model.voting }
        PlusScore i -> plusScore model i
        MinusScore i -> minusScore model i

appendItem : Model -> Idea -> Model
appendItem model i =
    let ideas = model.ideas ++ [i]
    in
        case i.note of
            "" -> model
            _ -> {model | wipIdea = Idea "" i.kind 0, ideas = ideas}

editIdea : Model -> Idea -> Model
editIdea model i =
    let ideas = List.partition (\x -> x == i) model.ideas |> Tuple.second
    in
        { model | wipIdea = i, ideas = ideas }

plusScore : Model -> Idea -> Model
plusScore = vote 1

minusScore : Model -> Idea -> Model
minusScore = vote -1

vote : Int -> Model -> Idea -> Model
vote adjustment model idea =
    let lambda i = if i == idea
            then i |> setScore (idea.score + adjustment)
            else i
        ideas = List.map lambda model.ideas
    in
        { model | ideas = ideas }

setNote : String -> Idea -> Idea
setNote n idea =
    { idea | note = n }

setKind : Kind -> Idea -> Idea
setKind k idea =
    { idea | kind = k }

setScore : Int -> Idea -> Idea
setScore n idea =
    { idea | score = n }
