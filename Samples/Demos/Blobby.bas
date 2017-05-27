DIM SHARED yoff AS _FLOAT
'from https://youtu.be/Cl_Gjj80gPE
'$include:'../../p5js.bas'

FUNCTION p5setup ()
    title "Blobby"
    createCanvas 400, 400
    stroke 255, 255, 255
    strokeWeight 2
    fill 200, 0, 200
    angleMode DEGREES
END FUNCTION

FUNCTION p5draw ()
    backgroundB 0
    radius = 150
    xoff## = 0
    beginShape p5LINES
    FOR i = 0 TO 355 STEP 3
        offset = map(noise(xoff, yoff, 0), 0, 1, -30, 30)
        r = radius + offset
        x = r * p5cos(i) + 200
        y = r * p5sin(i) + 200
        vertex x, y
        xoff = xoff + .1
    NEXT
    endShape p5CLOSE
    yoff = yoff + .01

END SUB
