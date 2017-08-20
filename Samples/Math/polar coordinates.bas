'$include:'../../p5js.bas'
'Adapted from https://www.youtube.com/watch?v=N633bLi_YCw
FUNCTION p5setup
    createCanvas 400, 400
    angleMode DEGREES
END FUNCTION

FUNCTION p5draw
    _DEFINE A-Z AS _FLOAT
    backgroundB 51

    x = 100
    y = 200

    strokeB 255
    strokeWeight 8
    p5point x, y

    angle = map(_MOUSEX, 0, _WIDTH - 1, -90, 90)
    r = 100

    dx = r * p5cos(angle)
    dy = r * p5sin(angle)

    p5line x, y, x + dx, y + dy

    text STR$(INT(angle)), x + dx + 10, y + dy
END FUNCTION

FUNCTION keyPressed
    IF keyCode = ESCAPE THEN SYSTEM
END FUNCTION
