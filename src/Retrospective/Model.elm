module Retrospective.Model exposing (..)

type Kind = Start | Stop | Continue
type Stage = Listing | Voting
type alias Idea = { note : String, kind: Kind, score : Int }
type alias Model = {
    stage : Stage,
    activeKind : Kind,
    wipIdea : Idea,
    ideas : List(Idea)
}

model : Model
model =
    let dummyData = [
        Idea "Defer “unknowns” and features no one can explain to us." Start 5,
        Idea "Have a postmortem to discuss tech choices." Start 1,
        Idea "Define app UI style guide" Start 0,
        Idea "Look into On-Premise monitoring" Start 1,
        Idea "Meeting Overload" Stop 2,
        Idea "Fun new projects, and variety" Continue 1,
        Idea "Learn Akka/Play Stack" Continue 1,
        Idea "Test on various browsers" Continue 1
    ]
    in
        Model Listing Start (Idea "" Start 0) dummyData

type Msg =
    Typing String
    | Change Kind
    | Step Stage
    | AddIdea Idea
    | EditIdea Idea
    | PlusScore Idea
    | MinusScore Idea