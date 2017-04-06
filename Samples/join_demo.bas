'$include:'../p5js.bas'

FUNCTION p5setup ()
    createCanvas 400, 400

    DIM strings$(1)
    strings$(0) = "QB64"
    strings$(1) = "Rocks!"
    message$ = join(strings$(), " ")

    PRINT message$

    noLoop
END FUNCTION
