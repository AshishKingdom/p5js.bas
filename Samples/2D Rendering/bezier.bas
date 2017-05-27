'$include:'../../p5js.bas'

FUNCTION p5setup ()
    'Syntax :- p5bezier startX%, startY%, controlPointX1%, controlPointY1%, controlPointX2%, controlPointY2%, endX%. endY%
    p5bezier 200, 200, 10, 300, 450, 400, 400, 300
END FUNCTION
