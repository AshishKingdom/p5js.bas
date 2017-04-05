DIM SHARED dots(100) AS vector
DIM SHARED di AS INTEGER

'$include:'..\p5js.bas'

FUNCTION p5setup
    _TITLE "Polygon drawing"
    createCanvas 600, 600
    stroke 255, 255, 255
    strokeWeight 2
    fill 255, 0, 0
    frameRate = 40
END FUNCTION

FUNCTION p5draw
    backgroundB 0

    IF di <= 2 THEN
        _PRINTSTRING (0, 0), "Click away..."
    ELSE
        _PRINTSTRING (0, 0), "Your mouse wheel can control the stroke weight..."
    END IF

    beginShape P5_LINES
    FOR i = 1 TO 100
        IF dots(i).x > 0 AND dots(i).y > 0 THEN
            vertex dots(i).x, dots(i).y
        END IF
    NEXT
    endShape P5_CLOSE
END FUNCTION

FUNCTION mouseClicked
    IF mouseButton = LEFT THEN
        di = di + 1
        IF di > 100 THEN EXIT FUNCTION
        dots(di).x = _MOUSEX
        dots(di).y = _MOUSEY
    END IF
END FUNCTION

FUNCTION mouseWheel
    strokeWeight p5Canvas.stroke + p5mouseWheel
END FUNCTION
