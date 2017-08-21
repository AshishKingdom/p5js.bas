'$include:'../../p5js.bas'

FUNCTION p5setup ()
    createCanvas 400, 400

    DIM strings$(1)
    strings$(0) = "QB64"
    strings$(1) = "Rocks!"
    message$ = join(strings$(), " ")

    strokeB 255

    textAlign CENTER
    text message$, _WIDTH / 2, _HEIGHT / 2

    noLoop
END FUNCTION
