'$include:'../../p5js.bas'

FUNCTION p5setup ()
    title "Star or double diamond?"
    createCanvas 400, 400
    strokeWeight 4
    strokeB 255
    fill 255, 0, 0
END FUNCTION

FUNCTION p5draw ()
    beginShape p5LINES
    vertex 196, 18
    vertex 154, 151
    vertex 22, 193
    vertex 155, 235
    vertex 154, 235
    vertex 196, 368
    vertex 238, 232
    vertex 368, 193
    vertex 239, 151
    endShape p5CLOSE
    noLoop
END FUNCTION
