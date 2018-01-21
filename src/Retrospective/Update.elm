module Retrospective.Update exposing (update)

import Retrospective.Model exposing (Idea, Kind, Model, Msg(..))

update : Msg -> Model -> Model
update msg model =
    case msg of
        Typing s -> let newWIPIdea = model.wipIdea |> setNote s
            in { model | wipIdea = newWIPIdea }
        Change k -> let newWIPIdea = model.wipIdea |> setKind k
            in { model | activeKind = k, wipIdea = newWIPIdea}
        Step s -> { model | stage = s }
        AddIdea i -> appendItem model i
        EditIdea i -> editIdea model i
        Upvote i -> upvoteIdea model i
        Downvote i -> downvoteIdea model i
        _ -> model

appendItem : Model -> Idea -> Model
appendItem model i =
    let ideas = model.ideas ++ [i]
    in
        case i.note of
            "" -> model
            _ -> {model | wipIdea = Idea "" i.kind 0 0, ideas = ideas}

editIdea : Model -> Idea -> Model
editIdea model i =
    let ideas = List.partition (\x -> x == i) model.ideas |> Tuple.second
    in
        { model | wipIdea = i, activeKind = i.kind, ideas = ideas }

upvoteIdea : Model -> Idea -> Model
upvoteIdea model idea =
    let ideas = modifyIdea upvote model.ideas idea
    in case model.votesRemaining of
        0 -> model
        _ -> { model | ideas = ideas, votesRemaining = model.votesRemaining - 1}

downvoteIdea : Model -> Idea -> Model
downvoteIdea model idea =
    let ideas = modifyIdea downvote model.ideas idea
    in { model | ideas = ideas, votesRemaining = model.votesRemaining + 1}

modifyIdea : (Idea -> Idea) -> List(Idea) -> Idea -> List(Idea)
modifyIdea modFn ideas idea =
    let lambda i = if idea == i
            then modFn i
            else i
    in List.map lambda ideas

setNote : String -> Idea -> Idea
setNote n i = { i | note = n }

setKind : Kind -> Idea -> Idea
setKind k i = { i | kind = k }

upvote : Idea -> Idea
upvote i = { i | votes = i.votes + 1}

downvote : Idea -> Idea
downvote i = { i | votes = i.votes - 1}

setScore : Int -> Idea -> Idea
setScore n i = { i | totalScore = n }