'$include:'../../p5js.bas'

FUNCTION p5setup ()
    createCanvas 150, 150
END FUNCTION

FUNCTION p5draw () STATIC
    FOR y = 0 TO height
        FOR x = 0 TO width / 2
            noiseDetail 2, 0.2
            noiseVal = noise(_MOUSEX + x * .02, _MOUSEY + y * .02, 0)
            strokeB noiseVal * 255
            p5point x, y
            noiseDetail 8, 0.65
            noiseVal = noise((_MOUSEX + x + width / 2) * 0.02, (_MOUSEY + y) * 0.02, 0)
            strokeB noiseVal * 255
            p5point x + width / 2, y
        NEXT
    NEXT
END FUNCTION
