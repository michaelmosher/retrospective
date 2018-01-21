import Html
import Html.Styled as Styled
import Retrospective.Model exposing (Model, Msg)
import Retrospective.Update
import Retrospective.View

main : Program Never Model Msg
main =
    Html.beginnerProgram {
        model  = Retrospective.Model.model,
        view   = Retrospective.View.view >> Styled.toUnstyled,
        update = Retrospective.Update.update
  }
