TYPE planet
    radius AS INTEGER
    angle AS INTEGER
    speed AS INTEGER
    x AS SINGLE
    y AS SINGLE
END TYPE
DIM SHARED nop 'Number of Planet
nop = 3
DIM SHARED Revolution
Revolution = 1
DIM SHARED Planets(nop) AS planet
'.
'$include:'../../p5js.bas'

FUNCTION p5setup ()
    title "Graphing Orbit"
    createCanvas 800, 700
    angleMode DEGREES
    FOR i = 1 TO nop
        Planets(i).radius = i * 100
        Planets(i).angle = 0
        Planets(i).speed = p5random(1, 6)
        Planets(i).x = p5cos(Planets(i).angle) * Planets(i).radius + width / 2
        Planets(i).y = p5sin(Planets(i).angle) * Planets(i).radius + height / 2
    NEXT
    noFill
    strokeWeight 2
    strokeA 255, 255, 255, 50
END FUNCTION

FUNCTION p5draw ()
    FOR i = 1 TO nop
        stroke 255, 255, 255
        p5ellipse width / 2, height / 2, Planets(i).radius, Planets(i).radius
        strokeA 255, 255, 255, 50
        IF i > 1 THEN
            FOR j = i - 1 TO i
                p5line Planets(i).x, Planets(i).y, Planets(j).x, Planets(j).y
            NEXT
        END IF
        Planets(i).angle = Planets(i).angle + Planets(i).speed
        Planets(i).x = p5cos(Planets(i).angle) * Planets(i).radius + width / 2
        Planets(i).y = p5sin(Planets(i).angle) * Planets(i).radius + height / 2

    NEXT

END FUNCTION
