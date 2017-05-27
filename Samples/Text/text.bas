'$include:'../../p5js.bas'

FUNCTION p5setup ()
    createCanvas 512, 512
END FUNCTION

FUNCTION p5draw ()
    backgroundB 240

    textAlign CENTER

    strokeB 0
    noFill

    translate 0, 120

    textFont "arial.ttf"
    textSize 12
    text "Arial 12", _WIDTH / 2, 20

    textSize 36
    text "Arial 36", _WIDTH / 2, 50

    textFont "cour.ttf"
    textSize 12
    text "Courier 12", _WIDTH / 2, 80

    textSize 48
    text "Courier 48", _WIDTH / 2, 110

    textFont "cyberbit.ttf"
    textSize 12
    text "Cyberbit 12", _WIDTH / 2, 140

    textSize 96
    text "Cyberbit 96", _WIDTH / 2, 180

    noLoop
END FUNCTION

FUNCTION keyPressed
    IF keyCode = ESCAPE THEN SYSTEM
END FUNCTION
