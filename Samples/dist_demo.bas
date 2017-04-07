'$include:'../p5js.bas'

FUNCTION p5setup ()
    createCanvas 400, 400
    COLOR _RGB(0, 0, 0), _RGB(200, 200, 200)
END FUNCTION

FUNCTION p5draw ()
    backgroundB 200

    strokeWeight 2
    strokeB 0
    p5line 50, 350, _MOUSEX, _MOUSEY

    fillB 0
    p5ellipse 50, 350, 10, 10
    p5ellipse _MOUSEX, _MOUSEY, 10, 10

    d = dist(50, 350, _MOUSEX, _MOUSEY)
    noFill
    _PRINTSTRING (20, 20), "Distance : " + STR$(d)
END FUNCTION
