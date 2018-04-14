DIM SHARED yoff AS _FLOAT
yoff = 0.0

'$include:'../../p5js.bas'

FUNCTION p5setup
    createCanvas 710, 400
    frameRate = 60
    strokeWeight 1
END FUNCTION

FUNCTION p5draw
    DIM xoff AS _FLOAT

    backgroundB 0

    xoff = 0

    FOR x = 0 TO _WIDTH
        y = map(noise(xoff, yoff, 0), 0, 1, 100, 250)
        strokeB 255
        p5point x, y
        FOR i = y + 1 TO _HEIGHT
            b = map(i, y + 1, _HEIGHT, 255, 0)
            IF b < 1 THEN EXIT FOR
            stroke 0, 20, b
            p5point x, i
        NEXT
        xoff = xoff + .005
    NEXT
    yoff = yoff + .01
END FUNCTION

