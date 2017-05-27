DIM SHARED myBall(10) AS Ball
'$include:'../../p5js.bas'

TYPE Ball
    vel AS vector
    pos AS vector
END TYPE

FUNCTION p5setup ()
    createCanvas 720, 400
    title "HSB Balls"
    noStroke
    frameRate = 60
    FOR i = 0 TO UBOUND(myball)
        createVector myBall(i).pos, p5random(30, 720), p5random(30, 400)
        createVector myBall(i).vel, p5random(-4, 4), p5random(-4, 4)
    NEXT
END FUNCTION

FUNCTION p5draw ()
    colorMode p5RGB
    backgroundBA 0, 20

    colorMode p5HSB
    FOR i = 0 TO UBOUND(myball)
        fill map(myBall(i).pos.x, 30, 720, 0, 255), 255, map(myBall(i).pos.y, 0, 400, 200, 50)
        p5ellipse myBall(i).pos.x, myBall(i).pos.y, 25, 25
        vector.add myBall(i).pos, myBall(i).vel
        IF myBall(i).pos.x > 720 THEN myBall(i).vel.x = -myBall(i).vel.x
        IF myBall(i).pos.x < 30 THEN myBall(i).vel.x = ABS(myBall(i).vel.x)
        IF myBall(i).pos.y > 400 THEN myBall(i).vel.y = -myBall(i).vel.y
        IF myBall(i).pos.y < 30 THEN myBall(i).vel.y = ABS(myBall(i).vel.y)
    NEXT
END FUNCTION



