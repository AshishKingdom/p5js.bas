'$include:'../p5js.bas'
'Adapted from https://p5js.org/reference/#/p5/keyIsPressed

FUNCTION p5setup ()
    createCanvas 300, 300
    strokeWeight 4
END FUNCTION

FUNCTION p5draw ()
    backgroundB 240
    rectMode CENTER
    IF keyIsPressed THEN translate _WIDTH / 2, _HEIGHT / 2
    p5rect 0, 0, 55, 55
END FUNCTION

FUNCTION keyPressed
    IF keyCode = ESCAPE THEN SYSTEM
END FUNCTION
