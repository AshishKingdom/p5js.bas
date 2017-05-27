DIM SHARED xOff#, yOff#, offInc#, s, m#, inc, p AS vector
inc = 1
offInc# = .006
s = 1
m# = 1.005

'$include:'../../p5js.bas'

FUNCTION p5setup ()
    title "Solar Flares"
    createCanvas 500, 500
    noFill
    strokeA 255, 64, 8, 150
END FUNCTION

FUNCTION p5draw ()
    translate width / 2, height / 2
    IF s < 1200 THEN
        FOR n = 0 TO 10
            nPoints = INT(TWO_PI * s)
            nPoints = min(nPoints, 500)
            beginShape p5LINES
            FOR i = 0 TO nPoints
               vector.fromAngle p, i / nPoints * TWO_PI
               f# = noise(xOff# + p.x, yOff# + p.y, 0) * s
               vector.mult p, f#
			   vertex p.x, p.y
            NEXT
            endShape p5CLOSE
			xOff# = xOff# + offInc#
            yOff# = yOff# + offInc#
            s = s * m#
        NEXT
    END IF
END FUNCTION

