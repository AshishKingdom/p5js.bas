'Processing Network by BLACK
'rewritten for p5js.bas by Fellippe Heitor
'Original: https://www.openprocessing.org/sketch/111878

DIM SHARED poop(1 TO 50) AS new_Particle
DIM SHARED flag AS _BYTE
DIM SHARED distance AS INTEGER
CONST speed = .01

'$include:'../../p5js.bas'

TYPE new_Particle
    pos AS vector
    r AS _FLOAT
    color AS _UNSIGNED LONG
    i AS INTEGER
    j AS INTEGER
END TYPE

FUNCTION p5setup
    createCanvas 800, 300
    distance = 50

    FOR i = 1 TO UBOUND(poop)
        createParticle poop(i)
    NEXT

    frameRate = 120 '60
END FUNCTION

FUNCTION p5draw
    backgroundB 255
    FOR i = 1 TO UBOUND(poop)
        display poop(i)
        update poop(i)

        FOR j = i + 1 TO UBOUND(poop)
            update poop(j)
            IF distB(poop(i).pos, poop(j).pos) < distance THEN
                FOR k = j + 1 TO UBOUND(poop)
                    IF distB(poop(k).pos, poop(j).pos) < distance THEN
                        IF flag THEN
                            noStroke
                            strokeBA 255, 10
                            fillC poop(k).color
                        ELSE
                            noFill
                            strokeWeight 1
                            strokeBA 0, 20
                        END IF

                        'beginShape p5LINES
                        'vertexB poop(i).pos
                        'vertexB poop(j).pos
                        'vertexB poop(k).pos
                        'endShape p5CLOSE

                        p5triangleB poop(i).pos, poop(j).pos, poop(k).pos
                    END IF
                    update poop(k)
                NEXT
            END IF
        NEXT
    NEXT
END FUNCTION

SUB createParticle (this AS new_Particle)
    this.pos.x = p5random(0, _WIDTH)
    this.pos.y = p5random(0, _HEIGHT)
    this.r = p5random(1, 5)
    this.j = INT(p5random(0, 4))
    this.i = 5
    SELECT CASE this.j
        CASE 0: this.color = _RGB32(5, 205, 229)
        CASE 1: this.color = _RGB32(255, 184, 3)
        CASE 2: this.color = _RGB32(255, 3, 91)
        CASE 3: this.color = _RGB32(61, 62, 62)
    END SELECT
END SUB

SUB display (this AS new_Particle)
    push
    noStroke
    fillC this.color
    p5ellipse this.pos.x, this.pos.y, this.r, this.r
    pop
END SUB

SUB update (this AS new_Particle)
    this.pos.x = this.pos.x + this.j * speed
    this.pos.y = this.pos.y + this.i * speed
    IF this.pos.y > _HEIGHT - this.r THEN this.i = this.i - 1
    IF this.pos.y < 0 + this.r THEN this.i = 1
    IF this.pos.x > _WIDTH - this.r THEN this.j = this.j - 1
    IF this.pos.x < 0 + this.r THEN this.j = 1
END SUB

FUNCTION keyPressed
    IF keyCode = ESCAPE THEN SYSTEM
    'flag = NOT flag
END FUNCTION

