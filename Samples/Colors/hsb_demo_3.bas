'$include:'../../p5js.bas'

FUNCTION p5setup
    createCanvas 256, 256
    colorMode p5HSB
    FOR i = 0 TO 255
        FOR j = 0 TO 255
            stroke i, j, constrain(map(j, 0, 255, 255, 0), 127, 255)
            p5point i, j
    NEXT j, i
END FUNCTION

