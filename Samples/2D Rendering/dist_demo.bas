'$include:'../../p5js.bas'

FUNCTION p5setup ()
    createCanvas 400, 400
    COLOR _RGB(0, 0, 0), _RGB(200, 200, 200)
END FUNCTION

FUNCTION p5draw ()
    backgroundB 51

    strokeWeight 2
    stroke 255, 255, 0
    p5line 50, 350, _MOUSEX, _MOUSEY

    fill 255, 150, 0
    p5ellipse 50, 350, 10, 10
    p5ellipse _MOUSEX, _MOUSEY, 10, 10

    d = dist(50, 350, _MOUSEX, _MOUSEY)
    noFill
    strokeB 255
    text "Distance : " + STR$(d), 20, 20
END FUNCTION
