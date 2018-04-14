DIM SHARED x

'$include:'../../p5js.bas'

'Adapted from https://p5js.org/reference/#/p5/redraw
'Description:
'Executes the code within draw() one time. This functions
'allows the program to update the display window only when
'necessary, for example when an event registered by
'mousePressed() occurs.

FUNCTION p5setup ()
    createCanvas 400, 400
    x = 10
END FUNCTION

FUNCTION p5draw ()
    backgroundB 204
    p5line x, 0, x, _HEIGHT
    noLoop
END FUNCTION

FUNCTION mousePressed
    x = x + 1
    redraw
END FUNCTION
