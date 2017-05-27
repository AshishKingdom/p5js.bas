REDIM SHARED particles(100) AS Particle
DIM SHARED systemOrigin AS vector

'Adapted from https://p5js.org/examples/simulate-particle-system.html
'$include:'../../p5js.bas'

TYPE Particle
    acc AS vector
    vel AS vector
    pos AS vector
    lifespan AS INTEGER
END TYPE

FUNCTION p5setup ()
    createCanvas 720, 400
    title "Simple particle system"
    systemOrigin.x = _WIDTH / 2
    systemOrigin.y = 50
    strokeWeight 4
    frameRate = 60
END FUNCTION

FUNCTION p5draw ()
    STATIC msgAlpha AS INTEGER
    backgroundB 0

    IF _MOUSEX = 0 AND _MOUSEY = 0 THEN
        msgAlpha = 255
    END IF

    IF msgAlpha > 0 THEN
        noFill
        strokeBA 255, msgAlpha
        textAlign CENTER
        text "Move your mouse", _WIDTH / 2, _HEIGHT / 2
        msgAlpha = msgAlpha - 2
    END IF

    system.addParticle
    updateSystem
END FUNCTION

SUB updateSystem
    FOR i = UBOUND(particles) TO 0 STEP -1
        particle.update particles(i)
        strokeBA 200, particles(i).lifespan
        fillBA 127, particles(i).lifespan
        p5ellipse particles(i).pos.x, particles(i).pos.y, 7, 7
    NEXT
END SUB

SUB particle.update (p AS Particle)
    vector.add p.vel, p.acc
    vector.add p.pos, p.vel
    p.lifespan = p.lifespan - 2
END SUB

SUB system.addParticle
    FOR i = 0 TO UBOUND(particles)
        IF particles(i).lifespan <= 0 THEN
            'add new:
            createVector particles(i).acc, 0, .05
            createVector particles(i).vel, p5random(-1, 1), p5random(-1, 0)
            'particles(i).pos = systemOrigin
            createVector particles(i).pos, _MOUSEX, _MOUSEY
            particles(i).lifespan = 255
            EXIT SUB
        END IF
    NEXT

    'need more particles, increase array
    new = UBOUND(particles) + 1
    REDIM _PRESERVE particles(UBOUND(particles) + 100) AS Particle
    createVector particles(new).acc, 0, .05
    createVector particles(new).vel, p5random(-1, 1), p5random(-1, 0)
    particles(new).pos = systemOrigin
    particles(new).lifespan = 255
END SUB

