module Retrospective.Model exposing (..)

type Kind = Start | Stop | Continue
type alias Idea = { note : String, kind: Kind, score : Int }
type alias Model = {
    voting : Bool,
    activeKind : Kind,
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
        Model False Start (Idea "" Start 0) dummyData

type Msg =
    Typing String
    | Change Kind
    | AddIdea Idea
    | EditIdea Idea
    | ToggleVoting
    | PlusScore Idea
    | MinusScore Idea