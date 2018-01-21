module Retrospective.Model exposing (..)

type Stage = Beginning | JiraReview | Listing | Voting | Report
type Kind = Start | Stop | Continue

type alias Participant = {
    name : String,
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
    votesRemaining : Int,
    wipParticipant : String,
    participants : List(Participant)
}

model : Model
model =
    let dummyParticipants = [
        Participant "Michael" False
    ]
        dummyIdeas = [
            Idea "Defer “unknowns” and features no one can explain to us." Start 5 0,
            Idea "Have a postmortem to discuss tech choices." Start 1 0,
            Idea "Define app UI style guide" Start 0 0,
            Idea "Look into On-Premise monitoring" Start 1 0,
            Idea "Meeting Overload" Stop 2 0,
            Idea "Fun new projects, and variety" Continue 1 0,
            Idea "Learn Akka/Play Stack" Continue 1 0,
            Idea "Test on various browsers" Continue 1 0
        ]
    in
        Model Beginning Start (Idea "" Start 0 0) dummyIdeas 3 "" dummyParticipants

type Msg =
    Typing String
    | Change Kind
    | Step Stage
    | AddIdea Idea
    | EditIdea Idea
    | Upvote Idea
    | Downvote Idea
    | AddParticipant String
    | NoOp
