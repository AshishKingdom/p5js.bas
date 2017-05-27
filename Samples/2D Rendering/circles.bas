'$include:'../../p5js.bas'

FUNCTION p5setup
    createCanvas 600, 600
    strokeWeight 2
    stroke 255, 255, 255
    fill 255, 0, 0
    frameRate = 40
END FUNCTION

FUNCTION p5draw
    backgroundBA 0, 25
    p5ellipse _MOUSEX, _MOUSEY, 30, 30
END FUNCTION

