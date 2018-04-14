DIM SHARED Size
'$include:'../../p5js.bas'

FUNCTION p5setup
    createCanvas 400, 400
    Size = 5
    stroke 255, 255, 255
    fillA 255, 200, 0, 200
END FUNCTION

FUNCTION p5draw
    backgroundB 51

    strokeWeight Size

    p5triangle _MOUSEX, _MOUSEY, 30, _HEIGHT - 30, _WIDTH - 30, _HEIGHT - 30
END FUNCTION

FUNCTION mouseWheel
    Size = Size + p5mouseWheel * 5
    IF Size < 2 THEN Size = 2
END FUNCTION
