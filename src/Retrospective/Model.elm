module Retrospective.Model exposing (..)

type Kind = Start | Stop | Continue
type alias Idea = { note : String, kind: Kind, score : Int }
type alias Model = {
    voting : Bool,
    wipIdea : Idea,
    ideas : List(Idea)
}

model : Model
model =
    let dummyData = [
        Idea "hello" Start 0,
        Idea "world" Continue 1,
        Idea "foobar" Stop 0
    ]
    in
        Model False (Idea "" Start 0) dummyData

type Msg =
    Typing String
    | AddIdea Idea
    | EditIdea Idea
    | ToggleVoting
    | PlusScore Idea
    | MinusScore Idea