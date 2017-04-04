'$include:'..\p5js.bas'

FUNCTION setup
    createCanvas 600, 600
    strokeWeight 2
    stroke 255, 255, 255
    fill 255, 0, 0
    frameRate = 40
END FUNCTION

FUNCTION p5.draw
    LINE (0, 0)-(_WIDTH, _HEIGHT), _RGBA32(0, 0, 0, 25), BF
    drawEllipse _MOUSEX, _MOUSEY, 30, 30
END FUNCTION

