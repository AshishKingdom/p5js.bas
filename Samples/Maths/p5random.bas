DIM SHARED Sample

'$include:'../../p5js.bas'
'Adapted from https://p5js.org/reference/#/p5/random

FUNCTION p5setup
    createCanvas 400, 400
END FUNCTION

FUNCTION p5draw
    backgroundB 255

    IF Sample = 1 THEN
        FOR i = 0 TO _HEIGHT
            r = p5random(0, 200)
            strokeB r + 55
            p5line _WIDTH / 2, i, _WIDTH / 2 + r, i
        NEXT
    ELSE
        strokeB 51
        FOR i = 0 TO _HEIGHT
            r = p5random(-200, 200)
            p5line _WIDTH / 2, i, _WIDTH / 2 + r, i
        NEXT
    END IF
    noLoop
END FUNCTION

FUNCTION keyPressed
    IF keyCode = ESCAPE THEN SYSTEM
    IF Sample = 1 THEN Sample = 2 ELSE Sample = 1
    redraw
END FUNCTION

