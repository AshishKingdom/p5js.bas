DIM SHARED noiseScale AS _FLOAT
noiseScale = 0.02

'$include:'../../p5js.bas'

FUNCTION p5setup
    createCanvas 300, 300
    strokeWeight 1
END FUNCTION

FUNCTION p5draw
    backgroundB 51

    textAlign CENTER
    strokeb 255
    text "Move your mouse", _WIDTH / 2, _HEIGHT / 2

    FOR x = 0 TO _WIDTH
        noiseVal = noise((_MOUSEX + x) * noiseScale, _MOUSEY * noiseScale, 0)
        strokeB noiseVal * 255
        p5line x, _MOUSEY + noiseVal * 80, x, _HEIGHT
    NEXT
END FUNCTION
