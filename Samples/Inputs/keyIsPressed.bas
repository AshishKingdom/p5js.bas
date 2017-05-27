'$include:'../../p5js.bas'
'Adapted from https://p5js.org/reference/#/p5/keyIsPressed

FUNCTION p5setup ()
    createCanvas 400, 400
END FUNCTION

FUNCTION p5draw ()
    backgroundB 200

    IF keyIsPressed THEN
        fillB 0
        strokeB 255
        m$ = LTRIM$(STR$(totalKeysDown)) + " key(s) pressed!"
    ELSE
        fillB 255
        strokeB 0
        m$ = ""
    END IF

    rectMode CENTER
    p5rect _WIDTH / 2, _HEIGHT / 2, 250, 200

    textAlign CENTER
    text "Test your keyboard!", _WIDTH / 2, _HEIGHT / 2
    text m$, _WIDTH / 2, _HEIGHT / 2 + _FONTHEIGHT
    IF lastKeyCode THEN text STR$(lastKeyCode), _WIDTH / 2, _HEIGHT / 2 + _FONTHEIGHT * 2
END FUNCTION

FUNCTION keyReleased
    IF keyCode = ESCAPE THEN SYSTEM
END FUNCTION
