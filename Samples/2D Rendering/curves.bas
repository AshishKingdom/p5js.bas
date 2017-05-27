'$include:'../../p5js.bas'

FUNCTION p5setup ()
    'Syntax :- p5curve controlPointX1%, controlPointY1%, startX%, startY%, endX%, endY%, controlPointX2%, controlPointY2%
    strokeWeight 2
    p5curve 100, 100, 300, 200, 500, 50, 10, 50
    fill 200, 0, 200
    p5curve 100, 100, 100, 200, 300, 50, 10, 50
    noLoop
END FUNCTION
