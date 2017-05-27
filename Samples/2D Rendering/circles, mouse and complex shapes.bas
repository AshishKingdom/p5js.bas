DIM SHARED Size
'$include:'../../p5js.bas'

FUNCTION p5setup
    createCanvas 400, 400
    title "Complex shapes interaction"
    strokeWeight 2
    Size = 30
END FUNCTION

FUNCTION p5draw
    backgroundBA 0, 25

    stroke 255, 255, 255
    fill 0, 255, 0
    p5ellipse _MOUSEX, _MOUSEY, Size, Size

    fill 150, 0, 200
    beginShape p5LINES
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
    endShape p5CLOSE
END FUNCTION

FUNCTION mouseWheel
    Size = Size + p5mouseWheel * 5
    IF Size <= 0 THEN Size = 1
END FUNCTION
