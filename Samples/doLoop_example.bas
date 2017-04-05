'$include:'../p5js.bas'
FUNCTION p5setup ()
    createCanvas 400, 400
    fill 255, 0, 0
    strokeB 255
    strokeWeight 3
END FUNCTION

FUNCTION p5draw ()
    backgroundBA 0, 30
    ellipse _MOUSEX, _MOUSEY, 30, 30
END FUNCTION

FUNCTION mouseClicked ()
    IF p5Loop THEN noLoop ELSE doLoop
END FUNCTION
