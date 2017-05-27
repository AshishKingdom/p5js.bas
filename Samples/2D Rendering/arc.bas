'$include:'../../p5js.bas'

FUNCTION p5setup ()
    'syntax p5arc xPosition%, yPosition%, width%, height%, startAngle##, stopAngle##, mode
    p5arc 100, 100, 50, 50, 0, _PI + QUARTER_PI, ARC_DEFAULT
    p5arc 250, 100, 50, 50, 0, _PI + QUARTER_PI, ARC_CHORD
    p5arc 400, 100, 50, 50, 0, _PI + QUARTER_PI, ARC_OPEN
    p5arc 550, 100, 50, 50, 0, _PI + QUARTER_PI, ARC_PIE
    noLoop
END FUNCTION
