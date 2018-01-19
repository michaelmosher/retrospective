module Retrospective.Model exposing (..)

type alias Idea = { note : String, score : Int }
type alias Model = {
    voting : Bool,
    wipIdea : Idea,
    ideas : List(Idea)
}

model : Model
model =
    let dummyData = [
        Idea "hello" 0,
        Idea "world" 1
    ]
    in
        Model False (Idea "" 0) dummyData

type Msg =
    Typing String
    | AddIdea Idea
    | EditIdea Idea
    | ToggleVoting
    | PlusScore Idea
    | MinusScore Idea