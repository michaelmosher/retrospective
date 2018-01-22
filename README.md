# Retrospective

This is a stateless web app meant to facilitate a **Start-Stop-Continue** style retrospective meeting.

It is hosted on [Github Pages](https://michaelmosher.github.io/retrospective/).

## Development

The app is written in [Elm](http://elm-lang.org/).
If you are unfamiliar with Elm,
the [official guide](https://guide.elm-lang.org/) is a great place to get started.
Elm installation steps can be found [here](https://guide.elm-lang.org/install.html).

### Elm Commands

Descriptions from help text:

- `elm-package`: "install and publish elm packages"
  - use `elm-package install`) is used to install local dependencies
- `elm-make` "build Elm projects"
  - The Makefile in the repo runs elm-make with proper args when using the `make` command
- `elm-reactor` "Interactive development tool that makes it easy to develop and debug Elm
  programs."
  - When browsing Elm files, it will recomiple code at page load
- `elm-repl`: "Read-eval-print-loop (REPL) for digging deep into Elm projects."
