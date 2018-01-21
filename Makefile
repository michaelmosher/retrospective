public/retrospective.js: $(wildcard src/**/*) $(wildcard src/**/**/*)
		elm-make src/Main.elm --output public/retrospective.js