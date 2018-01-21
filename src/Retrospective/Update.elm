module Retrospective.Update exposing (update)

import Retrospective.Model exposing (Idea, Kind, Model, Msg(..), Participant, Stage(..))

update : Msg -> Model -> Model
update msg model =
    case msg of
        Typing s -> updateWIPField model s
        Change k -> let newWIPIdea = model.wipIdea |> setKind k
            in { model | activeKind = k, wipIdea = newWIPIdea}
        Step s -> { model | stage = s, wipParticipant = "" }
        AddParticipant s -> appendParticipant model s
        AddIdea i -> appendItem model i
        EditIdea i -> editIdea model i
        Upvote i -> upvoteIdea model i
        Downvote i -> downvoteIdea model i
        _ -> model

updateWIPField : Model -> String -> Model
updateWIPField model text =
    case model.stage of
        Beginning -> { model | wipParticipant = text }
        Listing -> let newWIPIdea = model.wipIdea |> setNote text
            in { model | wipIdea = newWIPIdea }
        _ -> model

appendParticipant : Model -> String -> Model
appendParticipant model name =
    let participants = model.participants ++ [Participant name False]
    in case name of
        "" -> model
        _  -> { model | wipParticipant = "", participants = participants }

appendItem : Model -> Idea -> Model
appendItem model i =
    let ideas = model.ideas ++ [i]
    in
        case i.note of
            "" -> model
            _ -> { model | wipIdea = Idea "" i.kind 0 0, ideas = ideas }

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
        _ -> { model | ideas = ideas, votesRemaining = model.votesRemaining - 1 }

downvoteIdea : Model -> Idea -> Model
downvoteIdea model idea =
    let ideas = modifyIdea downvote model.ideas idea
    in { model | ideas = ideas, votesRemaining = model.votesRemaining + 1 }

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
upvote i = { i | totalScore = i.totalScore + 1, votes = i.votes + 1 }

downvote : Idea -> Idea
downvote i = { i | totalScore = i.totalScore - 1, votes = i.votes - 1 }