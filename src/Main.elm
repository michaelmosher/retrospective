import Html exposing (..)
import Retrospective.Model exposing (Model, Msg)
import Retrospective.Update
import Retrospective.View

main : Program Never Model Msg
main =
    Html.beginnerProgram {
        model  = Retrospective.Model.model,
        view   = Retrospective.View.view,
        update = Retrospective.Update.update
  }
