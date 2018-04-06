DIM SHARED prt&, particles(500) AS particle

'$include:'../../p5js.bas'

TYPE particle
    pos AS vector
    vel AS vector
    life AS INTEGER
    death AS INTEGER
END TYPE

FUNCTION p5setup ()
    title "Glowing Particles"
    createCanvas 500, 500
    FOR i = 0 TO UBOUND(particles)
        particles(i).pos.x = _MOUSEX
        particles(i).pos.y = _MOUSEY
        particles(i).vel.x = COS(p5random(-2, 2))
        particles(i).vel.y = SIN(p5random(-2, 3))
        particles(i).death = p5random(50, 100)
    NEXT
    prt& = _LOADIMAGE("sprite.png", 33)
END FUNCTION

FUNCTION p5draw ()
    FOR i = 0 TO UBOUND(particles)
        vector.add particles(i).pos, particles(i).vel
        _PUTIMAGE (particles(i).pos.x - 16, particles(i).pos.y - 16)-STEP(32, 32), prt&
        particles(i).life = particles(i).life + 1
        particles(i).vel.y = particles(i).vel.y + .1
        IF particles(i).life > particles(i).death THEN
            particles(i).life = 0
            particles(i).pos.x = _MOUSEX
            particles(i).pos.y = _MOUSEY
            particles(i).vel.x = COS(p5random(-2, 2))
            particles(i).vel.y = SIN(p5random(-2, 3))
            particles(i).death = p5random(100, 300)
        END IF
    NEXT
END FUNCTION
