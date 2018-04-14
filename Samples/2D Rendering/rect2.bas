DIM SHARED Size, isRound AS _BYTE

'$include:'../../p5js.bas'

FUNCTION p5setup
    createCanvas 400, 400
    strokeWeight 10
    Size = 100
END FUNCTION

FUNCTION p5draw
    backgroundB 51

    noFill
    textAlign CENTER
    strokeB 255
    text "Click to toggle between rect() and rectB()", _WIDTH / 2, _HEIGHT / 2

    strokeA 255, 255, 255, 230
    fillA 255, 200, 0, 200

    IF isRound THEN
        p5rectB _MOUSEX, _MOUSEY, Size, Size / 2, 10
    ELSE
        p5rect _MOUSEX, _MOUSEY, Size, Size / 2
    END IF
END FUNCTION

FUNCTION mouseWheel
    Size = Size + p5mouseWheel * 5
END FUNCTION

FUNCTION mouseClicked
    IF mouseButton = LEFT THEN
        isRound = NOT isRound
    END IF
END FUNCTION
