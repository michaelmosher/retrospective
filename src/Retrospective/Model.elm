module Retrospective.Model exposing (..)

type Stage = Beginning | JiraReview | Listing | Voting | Report
type Kind = Start | Stop | Continue

type alias Participant = {
    name : String,
    votesRemaining: Int,
    hasVoted : Bool
}
type alias Idea = {
    note : String,
    kind: Kind,
    totalScore : Int,
    votes : Int
}

type alias Model = {
    stage : Stage,
    activeKind : Kind,
    wipIdea : Idea,
    ideas : List(Idea),
    wipParticipant : String,
    participants : List(Participant)
}

model : Model
model =
    Model Beginning Start (Idea "" Start 0 0) [] "" []

type Msg =
    Typing String
    | Change Kind
    | Step Stage
    | AddIdea Idea
    | EditIdea Idea
    | Upvote Participant Idea
    | Downvote Participant Idea
    | AddParticipant String
    | SubmitVotes Participant
    | NoOp
