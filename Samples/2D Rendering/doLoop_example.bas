'$include:'../../p5js.bas'

FUNCTION p5setup ()
    createCanvas 400, 400
    strokeB 255
    strokeWeight 3
END FUNCTION

FUNCTION p5draw ()
    backgroundBA 0, 30

    fill 255, 0, 0
    p5ellipse _MOUSEX, _MOUSEY, 30, 30

    noFill
    _PRINTSTRING (10, _HEIGHT - _FONTHEIGHT), "Click to toggle the p5draw loop on/off."
END FUNCTION

FUNCTION mouseClicked ()
    IF p5Loop THEN noLoop ELSE doLoop
END FUNCTION
