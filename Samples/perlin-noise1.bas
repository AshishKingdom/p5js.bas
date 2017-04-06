DIM SHARED noiseScale AS _FLOAT
noiseScale = 0.02

'$include:'..\p5js.bas'

FUNCTION p5setup
    createCanvas 300, 300
    strokeWeight 1
END FUNCTION

FUNCTION p5draw
    backgroundB 51

    'we're not creating a real shape, but adding beginShape
    'here prevents the creation of multiple tempImages,
    'which could slow things considerably.
    beginShape P5_LINES

    FOR x = 0 TO _WIDTH
        noiseVal = noise((_MOUSEX + x) * noiseScale, _MOUSEY * noiseScale, 0)
        strokeB noiseVal * 255
        p5line x, _MOUSEY + noiseVal * 80, x, _HEIGHT
    NEXT

    endShape P5_CLOSE
END FUNCTION
