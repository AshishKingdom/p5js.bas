DIM SHARED r AS INTEGER, g AS INTEGER, b AS INTEGER
DIM SHARED Rslidery AS INTEGER, Gslidery AS INTEGER, Bslidery AS INTEGER
DIM SHARED dragging AS _BYTE

'$include:'../../p5js.bas'

FUNCTION p5setup
    createCanvas 400, 300
    title "RGB mixer"
    r = p5random(0, 255)
    g = p5random(0, 255)
    b = p5random(0, 255)
END FUNCTION

FUNCTION p5draw
    backgroundB 240

    textAlign CENTER

    textSize 8
    text "RGB mixer", _WIDTH / 2, 10

    'sliders
    strokeWeight 2
    fillB 255

    textAlign LEFT

    'R
    strokeB 0
    p5line 30, 20, 30, 280
    strokeB 100
    Rslidery = map(r, 0, 255, 280, 20)
    p5ellipse 30, Rslidery, 10, 10
    text "R:" + LTRIM$(STR$(r)), 45, Rslidery

    'G
    strokeB 0
    p5line 100, 20, 100, 280
    strokeB 100
    Gslidery = map(g, 0, 255, 280, 20)
    p5ellipse 100, Gslidery, 10, 10
    text "G:" + LTRIM$(STR$(g)), 115, Gslidery

    'B
    strokeB 0
    p5line 170, 20, 170, 280
    strokeB 100
    Bslidery = map(b, 0, 255, 280, 20)
    p5ellipse 170, Bslidery, 10, 10
    text "B:" + LTRIM$(STR$(b)), 185, Bslidery

    rectMode CENTER
    fill r, g, b
    p5rect 300, _HEIGHT / 2, 100, 100

END FUNCTION

FUNCTION mousePressed
    dragging = 0
    IF mouseButton = LEFT THEN
        IF dist(_MOUSEX, _MOUSEY, 30, Rslidery) < 10 THEN
            dragging = 1
        END IF

        IF dist(_MOUSEX, _MOUSEY, 100, Gslidery) < 10 THEN
            dragging = 2
        END IF

        IF dist(_MOUSEX, _MOUSEY, 170, Bslidery) < 10 THEN
            dragging = 3
        END IF
    END IF
END FUNCTION

FUNCTION mouseDragged
    IF dragging = 1 THEN
        r = constrain(map(_MOUSEY, 20, 280, 255, 0), 0, 255)
    ELSEIF dragging = 2 THEN
        g = constrain(map(_MOUSEY, 20, 280, 255, 0), 0, 255)
    ELSEIF dragging = 3 THEN
        b = constrain(map(_MOUSEY, 20, 280, 255, 0), 0, 255)
    END IF
END FUNCTION

FUNCTION mouseReleased
    dragging = 0
END FUNCTION
