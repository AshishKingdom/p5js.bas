'$include:'../p5js.bas'
FUNCTION p5setup ()
    _TITLE "Shapes"
    createCanvas 400, 400
    strokeWeight 4
    strokeB 255
    fill 255, 0, 0
END FUNCTION

FUNCTION p5draw ()
    beginShape P5_LINES
    vertex 195, 27
    vertex 157, 146
    vertex 35, 150
    vertex 131, 223
    vertex 97, 341
    vertex 195, 273
    vertex 294, 341
    vertex 259, 224
    vertex 354, 150
    vertex 234, 147
    endShape P5_CLOSE
    noLoop
END FUNCTION
