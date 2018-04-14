DIM SHARED Size
'$include:'../../p5js.bas'

FUNCTION p5setup
    createCanvas 400, 400
    Size = 5
    fill 100, 200, 0
END FUNCTION

FUNCTION p5draw STATIC
    IF i = 0 THEN i = .05

    IF mouseIsPressed THEN
        IF reverse = false THEN
            fill 200, 200, 0
            reverse = true
            i = i * -1
        END IF
    ELSE
        IF reverse THEN
            fill 100, 200, 0
            reverse = false
            i = i * -1
        END IF
    END IF

    angle! = angle! + i
    IF angle! > _PI(2) THEN angle! = angle! - _PI(2)

    backgroundBA 51, 150

    strokeWeight Size

    x = _WIDTH / 2
    y = _HEIGHT / 2


    stroke 255, 255, 255
    p5triangle x + COS(angle!) * 200, y + SIN(angle!) * 200, x + COS(angle! + _D2R(90)) * 200, y + SIN(angle! + _D2R(90)) * 200, x + COS(angle! + _D2R(170)) * 200, y + SIN(angle! + _D2R(170)) * 200

    IF reverse THEN
        m$ = "Release to reverse"
        stroke 0, 0, 255
        text m$, -_PRINTWIDTH(m$) / 2 + 1 + x + COS(angle!) * 50, 1 + y + SIN(angle!) * 50
        strokeB 255
        text m$, -_PRINTWIDTH(m$) / 2 + x + COS(angle!) * 50, y + SIN(angle!) * 50
    ELSE
        m$ = "Click and hold to reverse"
        stroke 0, 0, 255
        text m$, -_PRINTWIDTH(m$) / 2 + 1 + x + COS(angle!) * 50, 1 + y + SIN(angle!) * 50
        strokeB 255
        text m$, -_PRINTWIDTH(m$) / 2 + x + COS(angle!) * 50, y + SIN(angle!) * 50
    END IF
END FUNCTION

FUNCTION mouseWheel
    Size = Size + p5mouseWheel * 5
    IF Size < 2 THEN Size = 2
END FUNCTION
