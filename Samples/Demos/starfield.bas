DIM SHARED Star(800) AS vector, speed, px AS _FLOAT, py AS _FLOAT

'$include:'../../p5js.bas'
'Adapted from https://www.youtube.com/watch?v=17WoOqgXsRM

FUNCTION p5setup
    createCanvas 800, 800

    title "Starfield"

    FOR i = 0 TO UBOUND(Star)
        createStar Star(i)
    NEXT
END FUNCTION

FUNCTION p5draw
    speed = map(_MOUSEX, 0, _WIDTH, 0, 25)

    backgroundBA 0, map(speed, 0, 25, 255, 50)

    IF millis < 7000 THEN
        strokeBA 255, map(millis, 0, 7000, 255, 0)
        textAlign CENTER
        text "Your mouse controls the warp speed", _WIDTH / 2, _HEIGHT / 2
    END IF

    translate _WIDTH / 2, _HEIGHT / 2
    FOR i = 0 TO UBOUND(Star)
        update Star(i)
        show Star(i)
    NEXT
END FUNCTION

SUB createStar (this AS vector)
    this.x = p5random(-_WIDTH, _WIDTH)
    this.y = p5random(-_HEIGHT, _HEIGHT)
    this.z = p5random(0, _WIDTH)
END SUB

SUB update (this AS vector)
    this.z = this.z - speed
    IF this.z < 1 THEN
        createStar this
    END IF
END SUB

SUB show (this AS vector)
    fillB 255
    noStroke

    DIM sx AS _FLOAT, sy AS _FLOAT, r AS _FLOAT

    sx = map(this.x / this.z, 0, 1, 0, _WIDTH)
    sy = map(this.y / this.z, 0, 1, 0, _HEIGHT)

    r = map(this.z, 0, _WIDTH, 3, 0)
    p5ellipse sx, sy, r, r
END SUB
