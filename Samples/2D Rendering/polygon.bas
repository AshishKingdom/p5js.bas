DIM SHARED dots(100) AS vector
DIM SHARED di AS INTEGER

'$include:'../../p5js.bas'

FUNCTION p5setup
    title "Polygon drawing"
    createCanvas 600, 600
    stroke 255, 255, 255
    strokeWeight 2
    frameRate = 40
END FUNCTION

FUNCTION p5draw
    backgroundB 0

    IF di <= 2 THEN
        text "Click away...", 0, 0
    ELSE
        text "Your mouse wheel can control the stroke weight...", 0, 0
    END IF

    fill 255, 0, 0
    beginShape p5LINES
    FOR i = 1 TO 100
        IF dots(i).x > 0 AND dots(i).y > 0 THEN
            vertex dots(i).x, dots(i).y
        END IF
    NEXT
    endShape p5CLOSE
END FUNCTION

FUNCTION mouseClicked
    IF mouseButton = LEFT THEN
        di = di + 1
        IF di > 100 THEN EXIT FUNCTION
        dots(di).x = _MOUSEX
        dots(di).y = _MOUSEY
    END IF
END FUNCTION

FUNCTION mouseWheel STATIC
    IF size = 0 THEN size = 2
    size = size + p5mouseWheel
    IF size < 2 THEN size = 2

    strokeWeight size
END FUNCTION
