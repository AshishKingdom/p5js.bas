'$include:'../p5js.bas'

FUNCTION p5setup ()
    createCanvas 600, 600 'create 600x600 canvas
    strokeWeight 3 '3 is enough
    colorMode p5hsb 'switch to HSB color mode
    angleMode DEGREES 'switch to degree mode
END FUNCTION

FUNCTION p5draw ()
    FOR i = 0 TO 360 '0deg to 360deg
        stroke map(i, 0, 360, 0, 255), 255, 125
        ax## = 200 * p5cos(i) + 300 'calculate x location
        ay## = 200 * p5sin(i) + 300 'calculate y location
        p5line 300, 300, ax##, ay## 'draws a line
    NEXT
    noLoop 'we don't want to draw it again and again.
END FUNCTION
