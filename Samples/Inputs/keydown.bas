DIM SHARED x, y

'$include:'../../p5js.bas'
'Adapted from https://p5js.org/reference/#/p5/keyIsPressed

FUNCTION p5setup ()
    createCanvas 512, 512
    strokeWeight 10
    x = _WIDTH / 2
    y = _HEIGHT / 2
END FUNCTION

FUNCTION p5draw ()
    IF _KEYDOWN(LEFT_ARROW) THEN x = x - 5
    IF _KEYDOWN(RIGHT_ARROW) THEN x = x + 5
    IF _KEYDOWN(UP_ARROW) THEN y = y - 5
    IF _KEYDOWN(DOWN_ARROW) THEN y = y + 5

    fill 255, 0, 0
    strokeB 255
    backgroundB 200
    p5ellipse x, y, 50, 50

    strokeB 0
    noFill
    text "Use your keyboard to move:" + STR$(x) + STR$(y), 0, 0
END FUNCTION

FUNCTION keyPressed
    IF keyCode = ESCAPE THEN SYSTEM
END FUNCTION
