DIM SHARED inc AS _FLOAT

'$include:'../../p5js.bas'

FUNCTION p5setup
    createCanvas 400, 400

    title "Graphing Perlin noise"

    strokeWeight 3
    stroke 255, 255, 255
    fill 255, 0, 0
    frameRate = 60
    colorMode p5HSB
    inc = .01
END FUNCTION

FUNCTION p5draw
    STATIC start AS _FLOAT, xoff AS _FLOAT
    DIM x AS _FLOAT, y AS _FLOAT

    backgroundB 51

    xoff = start

    FOR x = 0 TO _WIDTH
        y = noise(xoff, 0, 0) * _HEIGHT
        IF x > 0 THEN
            stroke map(y, 0, _HEIGHT, 0, 255), 255, 100
            p5line px, py, x, y
        END IF

        px = x
        py = y

        xoff = xoff + inc
    NEXT

    start = start + inc
END FUNCTION
