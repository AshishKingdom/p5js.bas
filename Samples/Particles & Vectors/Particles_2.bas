DIM SHARED particles(10000) AS Particle
DIM SHARED gravity AS vector, MaxAddition

'$include:'../../p5js.bas'

TYPE Particle
    pos AS vector
    vel AS vector
    active AS _BYTE
    col AS SINGLE
END TYPE

FUNCTION p5setup ()
    title "Particles"
    createCanvas 500, 500
    stroke 255, 255, 0
    strokeWeight 2
    createVector gravity, 0, .05
    frameRate = 60
    MaxAddition = 20
    colorMode p5HSB 'switch to HSB color mode
END FUNCTION

FUNCTION p5draw ()
    backgroundBA 0, 30
    addParticles _MOUSEX, _MOUSEY
    updateParticles
END FUNCTION

SUB addParticles (x##, y##)
    FOR i = 0 TO UBOUND(particles)
        IF particles(i).active = 0 THEN
            createVector particles(i).pos, x##, y##
            createVector particles(i).vel, p5random(-2, 2), p5random(-3, 2)
            particles(i).col = 255
            particles(i).active = -1
            IF n >= MaxAddition THEN EXIT SUB
            n = n + 1
        END IF
    NEXT
END SUB

SUB updateParticles ()
    FOR i = 0 TO UBOUND(particles)
        IF particles(i).active THEN
            IF particles(i).col < 0 THEN particles(i).col = 255
            stroke particles(i).col, 255, 100
            p5point particles(i).pos.x, particles(i).pos.y
            particles(i).col = particles(i).col - 2
            vector.add particles(i).pos, particles(i).vel
            vector.add particles(i).vel, gravity
            IF particles(i).pos.x < 0 OR particles(i).pos.y < 0 OR particles(i).pos.x > _WIDTH OR particles(i).pos.y > _HEIGHT THEN particles(i).active = 0
        END IF
    NEXT
END SUB
