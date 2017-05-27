_DEFINE A-Z AS _FLOAT

REDIM SHARED firework(2000) AS new_Particle
DIM SHARED gravity AS vector, totalFireworks AS LONG
DIM SHARED explosion AS LONG

'$include:'../../p5js.bas'
'Adapted from https://www.youtube.com/watch?v=CKeyIbT3vXI

TYPE new_Particle
    pos AS vector
    vel AS vector
    acc AS vector
    state AS _BYTE
    hu AS INTEGER
    lifespan AS SINGLE
END TYPE

FUNCTION p5setup
    createCanvas 640, 480
    title "Fireworks display"
    strokeWeight 2
    createVector gravity, 0, .2

    explosion = loadSound("distant.ogg")

    'start with a sequence of fireworks from left to right
    FOR i = 10 TO _WIDTH - 10 STEP ((_WIDTH - 20) / 10)
        addFirework i, _HEIGHT, 0, true
    NEXT
END FUNCTION

FUNCTION p5draw
    colorMode p5RGB
    backgroundBA 10, 30

    IF p5random(0, 1) < .06 THEN
        addFirework p5random(0, _WIDTH), _HEIGHT, 0, true
    END IF

    FOR i = 0 TO UBOUND(firework)
        IF firework(i).state > 0 THEN
            applyForce firework(i).acc, gravity
            update firework(i)
            colorMode p5HSB
            show firework(i)

            IF firework(i).vel.y > 0 AND firework(i).state = 1 THEN
                explode firework(i)
                firework(i).state = 0
                colorMode p5RGB
                'sky lights up
                IF firework(i).pos.x < 100 OR firework(i).pos.x > 540 THEN
                    backgroundBA 255, 30
                ELSE
                    backgroundBA 255, 70
                END IF
                p5play explosion
            ELSEIF (firework(i).pos.y > _HEIGHT OR firework(i).lifespan <= 0) AND firework(i).state = 2 THEN
                firework(i).state = 0
            END IF
        END IF
    NEXT
END FUNCTION

SUB explode (this AS new_Particle)
    FOR i = 0 TO 100
        addFirework this.pos.x, this.pos.y, this.hu, false
    NEXT
END SUB

SUB update (this AS new_Particle)
    IF this.state = 2 THEN
        vector.mult this.vel, .9
        this.lifespan = this.lifespan - 4
    END IF

    vector.add this.vel, this.acc
    vector.add this.pos, this.vel
    vector.mult this.acc, 0
END SUB

SUB applyForce (this AS vector, force AS vector)
    vector.add this, force
END SUB

SUB show (this AS new_Particle)
    IF this.state = 1 THEN
        stroke this.hu, 255, 255
    ELSEIF this.state = 2 THEN
        strokeA this.hu, 255, map(this.lifespan, 100, 255, 127, 255), this.lifespan
    END IF

    p5point this.pos.x, this.pos.y
END SUB

SUB addFirework (x AS _FLOAT, y AS _FLOAT, hu AS INTEGER, fromGround AS _BYTE)
    DIM searchSlot AS LONG, i AS LONG

    i = -1
    FOR searchSlot = 0 TO UBOUND(firework)
        IF firework(searchSlot).state = 0 THEN i = searchSlot: EXIT FOR
    NEXT

    IF i = -1 THEN
        i = UBOUND(firework) + 1
        REDIM _PRESERVE firework(i + 999) AS new_Particle
    END IF

    createVector firework(i).pos, x, y
    IF fromGround THEN
        createVector firework(i).vel, p5random(-2, 2), p5random(-14, -8)
        firework(i).state = 1
        firework(i).hu = p5random(0, 255)
    ELSE
        vector.random2d firework(i).vel
        vector.mult firework(i).vel, p5random(2, 10)
        firework(i).hu = hu
        firework(i).state = 2
    END IF
    firework(i).lifespan = 255
END SUB

FUNCTION keyPressed
    IF keyCode = ESCAPE THEN SYSTEM
END FUNCTION
