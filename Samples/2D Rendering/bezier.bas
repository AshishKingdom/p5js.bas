'$include:'../../p5js.bas'

FUNCTION p5setup ()
    'Syntax :- p5bezier startX%, startY%, controlPointX1%, controlPointY1%, controlPointX2%, controlPointY2%, endX%. endY%
    strokeB 0
    strokeWeight 5
    noFill
    backgroundB 170
    text "Click to mark start, end and curve points.", 0, 0
END FUNCTION

FUNCTION p5draw () STATIC
    IF setup = 0 THEN setup = -1: v = 0
    IF _MOUSEBUTTON(1) THEN
        WHILE _MOUSEBUTTON(1): i = _MOUSEINPUT: WEND
        v = v + 1
        SELECT CASE v
            CASE 1
                x = _MOUSEX
                y = _MOUSEY
                p5point x, y
            CASE 2
                x2 = _MOUSEX
                y2 = _MOUSEY
                p5point x2, y2
            CASE 3
                ctx1 = _MOUSEX
                cty1 = _MOUSEY
                p5point ctx1, cty1
            CASE 4
                ctx2 = _MOUSEX
                cty2 = _MOUSEY
                p5point ctx2, cty2
                text "Click to clear and start over...", 0, 20
            CASE 5
                v = 0
                backgroundB 170
        END SELECT
    END IF

    IF v = 4 THEN
        p5bezier x, y, ctx1, cty1, ctx2, cty2, x2, y2
    END IF
END FUNCTION
