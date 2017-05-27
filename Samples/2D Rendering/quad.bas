'$include:'../../p5js.bas'

FUNCTION p5setup
    createCanvas 100, 100
    strokeWeight 2
    stroke 255, 255, 255
    fill 255, 0, 0
    frameRate = 40
END FUNCTION

FUNCTION p5draw
    backgroundBA 0, 25
    p5quad 38, 31, 86, 20, 69, 63, 30, 76
    noLoop
END FUNCTION

