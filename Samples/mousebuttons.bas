REDIM SHARED clicks(100) AS c, totalClicks AS LONG

'$include:'p5js.bas'

TYPE c
    pos AS vector
    button AS _BYTE
END TYPE

FUNCTION p5setup
    createCanvas 400, 400
    _TITLE "Mouse buttons test"
    strokeWeight 2
    totalClicks = -1
END FUNCTION

FUNCTION p5draw
    backgroundB 51

    strokeB 255
    FOR i = 0 TO totalClicks
        SELECT CASE clicks(i).button
            CASE LEFT: fill 255, 0, 0
            CASE CENTER: fill 0, 255, 0
            CASE RIGHT: fill 0, 255, 255
        END SELECT
        ellipse clicks(i).pos.x, clicks(i).pos.y, 20, 20
    NEXT

    'add color reference to the bottom
    strokeB 255
    noFill
    IF totalClicks >= 0 THEN
        _PRINTSTRING (0, 0), STR$(totalClicks + 1)
    ELSE
        _PRINTSTRING (0, 0), "Click away..."
    END IF

    fill 255, 0, 0
    _PRINTSTRING (15, _HEIGHT - _FONTHEIGHT), "Left"

    fill 0, 255, 0
    strokeB 0
    _PRINTSTRING (60, _HEIGHT - _FONTHEIGHT), "Middle"

    fill 0, 255, 255
    strokeB 0
    _PRINTSTRING (120, _HEIGHT - _FONTHEIGHT), "Right"

    noFill
    strokeB 255
    _PRINTSTRING (175, _HEIGHT - _FONTHEIGHT), "Wheel to change strokeWeight"

END FUNCTION

FUNCTION mouseClicked
    totalClicks = totalClicks + 1
    IF totalClicks > UBOUND(clicks) THEN REDIM _PRESERVE clicks(UBOUND(clicks) + 100) AS vector

    clicks(totalClicks).pos.x = _MOUSEX
    clicks(totalClicks).pos.y = _MOUSEY
    clicks(totalClicks).button = mouseButton
END FUNCTION

FUNCTION mouseWheel
    strokeWeight p5Canvas.strokeWeight + p5mouseWheel

    IF p5Canvas.strokeWeight < 1 THEN strokeWeight 1
END FUNCTION
