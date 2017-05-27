DIM SHARED h AS INTEGER, s AS INTEGER, b AS INTEGER
DIM SHARED Hslidery AS INTEGER, Sslidery AS INTEGER, Bslidery AS INTEGER
DIM SHARED dragging AS _BYTE

'$include:'../../p5js.bas'

FUNCTION p5setup
    createCanvas 400, 300
    title "HSB mixer"
    h = p5random(0, 255)
    s = p5random(0, 255)
    b = p5random(0, 255)
END FUNCTION

FUNCTION p5draw
    colorMode p5RGB
    backgroundB 240

    textAlign CENTER

    textSize 8
    text "HSB mixer", _WIDTH / 2, 10

    'sliders
    strokeWeight 2
    fillB 255

    textAlign LEFT

    'H
    strokeB 0
    p5line 30, 20, 30, 280
    strokeB 100
    Hslidery = map(h, 0, 255, 280, 20)
    p5ellipse 30, Hslidery, 10, 10
    text "H:" + LTRIM$(STR$(h)), 45, Hslidery

    'S
    strokeB 0
    p5line 100, 20, 100, 280
    strokeB 100
    Sslidery = map(s, 0, 255, 280, 20)
    p5ellipse 100, Sslidery, 10, 10
    text "S:" + LTRIM$(STR$(s)), 115, Sslidery

    'B
    strokeB 0
    p5line 170, 20, 170, 280
    strokeB 100
    Bslidery = map(b, 0, 255, 280, 20)
    p5ellipse 170, Bslidery, 10, 10
    text "B:" + LTRIM$(STR$(b)), 185, Bslidery

    colorMode p5HSB
    rectMode CENTER
    fill h, s, b
    p5rect 300, _HEIGHT / 2, 100, 100

END FUNCTION

FUNCTION mousePressed
    dragging = 0
    IF mouseButton = LEFT THEN
        IF dist(_MOUSEX, _MOUSEY, 30, Hslidery) < 10 THEN
            dragging = 1
        END IF

        IF dist(_MOUSEX, _MOUSEY, 100, Sslidery) < 10 THEN
            dragging = 2
        END IF

        IF dist(_MOUSEX, _MOUSEY, 170, Bslidery) < 10 THEN
            dragging = 3
        END IF
    END IF
END FUNCTION

FUNCTION mouseDragged
    IF dragging = 1 THEN
        h = constrain(map(_MOUSEY, 20, 280, 255, 0), 0, 255)
    ELSEIF dragging = 2 THEN
        s = constrain(map(_MOUSEY, 20, 280, 255, 0), 0, 255)
    ELSEIF dragging = 3 THEN
        b = constrain(map(_MOUSEY, 20, 280, 255, 0), 0, 255)
    END IF
END FUNCTION

FUNCTION mouseReleased
    dragging = 0
END FUNCTION
