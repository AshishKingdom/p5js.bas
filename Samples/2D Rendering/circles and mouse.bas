DIM SHARED Size, mx, my, dragged AS _BYTE

'$include:'../../p5js.bas'

FUNCTION p5setup
    createCanvas 600, 600
    strokeWeight 2
    stroke 255, 255, 255
    frameRate = 40
    Size = 30
END FUNCTION

FUNCTION p5draw
    backgroundBA 0, 25
    IF NOT dragged THEN
        noFill
        _PRINTSTRING (10, _HEIGHT - _FONTHEIGHT), "Drag that circle that's trying to hide in the corner..."
        fill 255, 0, 0
    END IF

    p5ellipse mx, my, Size, Size
END FUNCTION

FUNCTION mouseDragged
    mx = _MOUSEX
    my = _MOUSEY
    dragged = true

    IF mouseButton = LEFT THEN
        fill 0, 255, 0
    ELSEIF mouseButton = RIGHT THEN
        fill 255, 0, 0
    END IF
END FUNCTION

FUNCTION mouseWheel
    Size = Size + p5mouseWheel
    IF Size <= 0 THEN Size = 1
END FUNCTION
