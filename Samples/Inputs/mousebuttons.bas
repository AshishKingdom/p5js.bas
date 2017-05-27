REDIM SHARED clicks(100) AS c, totalClicks AS LONG

'$include:'../../p5js.bas'

TYPE c
    pos AS vector
    button AS _BYTE
END TYPE

FUNCTION p5setup
    createCanvas 400, 400
    title "Mouse buttons test"
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
        p5ellipse clicks(i).pos.x, clicks(i).pos.y, 20, 20
    NEXT

    'add color reference to the bottom
    strokeB 255
    noFill
    IF totalClicks >= 0 THEN
        text STR$(totalClicks + 1), 0, 0
    ELSE
        text "Click away...", 0, 0
    END IF

    stroke 255, 0, 0
    text "Left", 15, _HEIGHT - _FONTHEIGHT

    stroke 0, 255, 0
    text "Middle", 60, _HEIGHT - _FONTHEIGHT

    stroke 0, 255, 255
    text "Right", 120, _HEIGHT - _FONTHEIGHT

    noFill
    strokeB 255
    text "Wheel to change strokeWeight", 175, _HEIGHT - _FONTHEIGHT

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
