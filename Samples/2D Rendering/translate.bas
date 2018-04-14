'$include:'../../p5js.bas'
'Adapted from https://p5js.org/reference/#/p5/keyIsPressed

FUNCTION p5setup ()
    createCanvas 300, 300
    strokeWeight 4
END FUNCTION

FUNCTION p5draw ()
    backgroundB 240
    rectMode CENTER
    IF keyIsPressed OR mouseIsPressed THEN translate _WIDTH / 2, _HEIGHT / 2
    p5rect 0, 0, 55, 55
    textAlign CENTER
    text "Press any key or click to translate", _WIDTH / 2, _HEIGHT / 2 - textHeight / 2
    text "coordinates 0,0 to the center", _WIDTH / 2, _HEIGHT / 2 + textHeight / 2
END FUNCTION

FUNCTION keyPressed
    IF keyCode = ESCAPE THEN SYSTEM
END FUNCTION

