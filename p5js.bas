'p5js.bas by Fellippe & Ashish
'Open source - based on p5.js (https://p5js.org/)
'Last update 4/4/2017

'p5 constant
CONST TWO_PI = 6.283185307179586
CONST HALF_PI = 1.570796326794897
CONST P5_POINTS = 1
CONST P5_LINES = 2
CONST P5_CLOSE = -3

'p5 Global Variables
TYPE __canvasSettings
    stroke AS _UNSIGNED LONG
    fill AS _UNSIGNED LONG
    strokeWeight AS INTEGER
    noStroke AS _BYTE
    noFill AS _BYTE
END TYPE

TYPE vertex
    x AS _FLOAT
    y AS _FLOAT
    z AS _FLOAT
END TYPE

DIM SHARED frameRate AS SINGLE

'canvas settings related variables
DIM SHARED p5Canvas AS __canvasSettings

'begin shape related variables
DIM SHARED FirstVertex AS vertex, avgVertex AS vertex, PreviousVertex AS vertex, vertexCount AS LONG
DIM SHARED shapeAllow AS _BYTE, shapeType AS INTEGER, shapeInit AS _BYTE

'mouse
DIM SHARED P5MouseTimer AS INTEGER
P5MouseTimer = _FREETIMER
ON TIMER(P5MouseTimer, .013) gatherMouseData
TIMER(P5MouseTimer) ON

'default settings
p5Canvas.stroke = _RGB(255, 255, 255) 'white
p5Canvas.fill = _RGB(0, 0, 0)
p5Canvas.strokeWeight = 0

a = setup

DO
    IF frameRate THEN _LIMIT frameRate
    a = p5.draw
    _DISPLAY
LOOP

SUB createCanvas (w AS INTEGER, h AS INTEGER)
    DIM oldDest AS LONG, newDest AS LONG
    oldDest = _DEST
    newDest = _NEWIMAGE(w, h, 32)
    SCREEN newDest
    IF oldDest > 0 THEN _FREEIMAGE oldDest
END SUB

FUNCTION noise## (x AS _FLOAT, y AS _FLOAT, z AS _FLOAT)
    STATIC p5.NoiseSetup AS _BYTE
    STATIC perlin() AS _FLOAT
    STATIC PERLIN_YWRAPB AS _FLOAT, PERLIN_YWRAP AS _FLOAT
    STATIC PERLIN_ZWRAPB AS _FLOAT, PERLIN_ZWRAP AS _FLOAT
    STATIC PERLIN_SIZE AS _FLOAT, perlin_octaves AS _FLOAT
    STATIC perlin_amp_falloff AS _FLOAT

    IF NOT p5.NoiseSetup THEN
        p5.NoiseSetup = -1

        PERLIN_YWRAPB = 4
        PERLIN_YWRAP = INT(1 * (2 ^ PERLIN_YWRAPB))
        PERLIN_ZWRAPB = 8
        PERLIN_ZWRAP = INT(1 * (2 ^ PERLIN_ZWRAPB))
        PERLIN_SIZE = 4095

        perlin_octaves = 4
        perlin_amp_falloff = 0.5

        REDIM perlin(PERLIN_SIZE + 1) AS _FLOAT
        RANDOMIZE TIMER
        DIM i AS _FLOAT
        FOR i = 0 TO PERLIN_SIZE + 1
            perlin(i) = RND
        NEXT
    END IF

    x = ABS(x)
    y = ABS(y)
    z = ABS(z)

    DIM xi AS _FLOAT, yi AS _FLOAT, zi AS _FLOAT
    xi = INT(x)
    yi = INT(y)
    zi = INT(z)

    DIM xf AS _FLOAT, yf AS _FLOAT, zf AS _FLOAT
    xf = x - xi
    yf = y - yi
    zf = z - zi

    DIM r AS _FLOAT, ampl AS _FLOAT, o AS _FLOAT
    r = 0
    ampl = .5

    FOR o = 1 TO perlin_octaves
        DIM of AS _FLOAT, rxf AS _FLOAT
        DIM ryf AS _FLOAT, n1 AS _FLOAT, n2 AS _FLOAT, n3 AS _FLOAT
        of = xi + INT(yi * (2 ^ PERLIN_YWRAPB)) + INT(zi * (2 ^ PERLIN_ZWRAPB))

        rxf = 0.5 * (1.0 - COS(xf * _PI))
        ryf = 0.5 * (1.0 - COS(yf * _PI))

        n1 = perlin(of AND PERLIN_SIZE)
        n1 = n1 + rxf * (perlin((of + 1) AND PERLIN_SIZE) - n1)
        n2 = perlin((of + PERLIN_YWRAP) AND PERLIN_SIZE)
        n2 = n2 + rxf * (perlin((of + PERLIN_YWRAP + 1) AND PERLIN_SIZE) - n2)
        n1 = n1 + ryf * (n2 - n1)

        of = of + PERLIN_ZWRAP
        n2 = perlin(of AND PERLIN_SIZE)
        n2 = n2 + rxf * (perlin((of + 1) AND PERLIN_SIZE) - n2)
        n3 = perlin((of + PERLIN_YWRAP) AND PERLIN_SIZE)
        n3 = n3 + rxf * (perlin((of + PERLIN_YWRAP + 1) AND PERLIN_SIZE) - n3)
        n2 = n2 + ryf * (n3 - n2)

        n1 = n1 + (0.5 * (1.0 - COS(zf * _PI))) * (n2 - n1)

        r = r + n1 * ampl
        ampl = ampl * perlin_amp_falloff
        xi = INT(xi * (2 ^ 1))
        xf = xf * 2
        yi = INT(yi * (2 ^ 1))
        yf = yf * 2
        zi = INT(zi * (2 ^ 1))
        zf = zf * 2

        IF xf >= 1.0 THEN xi = xi + 1: xf = xf - 1
        IF yf >= 1.0 THEN yi = yi + 1: yf = yf - 1
        IF zf >= 1.0 THEN zi = zi + 1: zf = zf - 1
    NEXT
    noise## = r
END FUNCTION

FUNCTION map## (value##, minRange##, maxRange##, newMinRange##, newMaxRange##)
    map## = ((value## - minRange##) / (maxRange## - minRange##)) * (newMaxRange## - newMinRange##) + newMinRange##
END FUNCTION

SUB beginShape (__type)
    shapeAllow = -1
    shapeType = __type
END SUB

SUB vertex (x, y)
    IF shapeInit THEN
        IF shapeType = P5_POINTS THEN
            CircleFill x, y, p5Canvas.strokeWeight / 2, p5Canvas.stroke
        ELSEIF shapeType = P5_LINES THEN
            IF p5Canvas.noStroke THEN LINE (PreviousVertex.x, PreviousVertex.y)-(x, y), p5Canvas.fill ELSE drawLine PreviousVertex.x, PreviousVertex.y, x, y
        END IF
    END IF
    IF shapeAllow AND NOT shapeInit THEN
        FirstVertex.x = x
        FirstVertex.y = y
        shapeInit = -1
        IF shapeType = P5_POINTS THEN
            CircleFill x, y, p5Canvas.strokeWeight / 2, p5Canvas.stroke
        END IF
        FirstVertex.x = x
        FirstVertex.y = y
    END IF
    PreviousVertex.x = x
    PreviousVertex.y = y
    avgVertex.x = avgVertex.x + x
    avgVertex.y = avgVertex.y + y
    vertexCount = vertexCount + 1
END SUB

SUB endShape (closed)
    'did we have to close?
    IF closed = P5_CLOSE AND shapeType = P5_LINES THEN
        IF p5Canvas.noStroke THEN LINE (PreviousVertex.x, PreviousVertex.y)-(FirstVertex.x, FirstVertex.y), p5Canvas.fill ELSE drawLine PreviousVertex.x, PreviousVertex.y, FirstVertex.x, FirstVertex.y
    END IF
    'filling the color
    IF NOT p5Canvas.noFill AND shapeType = P5_LINES AND closed = P5_CLOSE THEN
        avgVertex.x = avgVertex.x / vertexCount
        avgVertex.y = avgVertex.y / vertexCount
        IF p5Canvas.noStroke THEN PAINT (avgVertex.x, avgVertex.y), p5Canvas.fill, p5Canvas.fill ELSE PAINT (avgVertex.x, avgVertex.y), p5Canvas.fill, p5Canvas.stroke

    END IF
    'it's time to reset all varibles!!
    shapeAllow = 0
    shapeType = 0
    shapeInit = 0
    FirstVertex.x = 0
    FirstVertex.y = 0
    PreviousVertex.x = 0
    PreviousVertex.y = 0
    vertexCount = 0
    avgVertex.x = 0
    avgVertex.y = 0

END SUB

SUB fill (r%, g%, b%)
    p5Canvas.noFill = 0
    p5Canvas.fill = _RGB32(r%, g%, b%)
END SUB

SUB fillA (r%, g%, b%, a%)
    p5Canvas.noFill = 0
    p5Canvas.fill = _RGBA32(r%, g%, b%, a%)
END SUB

SUB stroke (r%, g%, b%)
    p5Canvas.noStroke = 0
    p5Canvas.stroke = _RGB32(r%, g%, b%)
END SUB

SUB strokeA (r%, g%, b%, a%)
    p5Canvas.noStroke = 0
    p5Canvas.stroke = _RGBA32(r%, g%, b%, a%)
END SUB

SUB noFill ()
    p5Canvas.noFill = -1
END SUB

SUB noStroke ()
    p5Canvas.noStroke = -1
END SUB

SUB strokeWeight (a%)
    p5Canvas.strokeWeight = a%
END SUB

SUB CircleFill (CX AS LONG, CY AS LONG, R AS LONG, C AS LONG)
    'This sub from here: http://www.qb64.net/forum/index.php?topic=1848.msg17254#msg17254
    DIM Radius AS LONG
    DIM RadiusError AS LONG
    DIM X AS LONG
    DIM Y AS LONG

    Radius = ABS(R)
    RadiusError = -Radius
    X = Radius
    Y = 0

    IF Radius = 0 THEN PSET (CX, CY), C: EXIT SUB

    ' Draw the middle span here so we don't draw it twice in the main loop,
    ' which would be a problem with blending turned on.
    LINE (CX - X, CY)-(CX + X, CY), C, BF

    WHILE X > Y

        RadiusError = RadiusError + Y * 2 + 1

        IF RadiusError >= 0 THEN

            IF X <> Y + 1 THEN
                LINE (CX - Y, CY - X)-(CX + Y, CY - X), C, BF
                LINE (CX - Y, CY + X)-(CX + Y, CY + X), C, BF
            END IF

            X = X - 1
            RadiusError = RadiusError - X * 2

        END IF

        Y = Y + 1

        LINE (CX - X, CY - Y)-(CX + X, CY - Y), C, BF
        LINE (CX - X, CY + Y)-(CX + X, CY + Y), C, BF

    WEND

END SUB

SUB drawLine (x1, y1, x2, y2)
    dx = x2 - x1
    dy = y2 - y1
    d = SQR(dx * dx + dy * dy)
    FOR i = 0 TO d
        CircleFill dxx + x1, dyy + y1, p5Canvas.strokeWeight / 2, p5Canvas.stroke
        dxx = dxx + dx / d
        dyy = dyy + dy / d
    NEXT
END SUB

SUB drawEllipse (x, y, xr, yr)
    IF p5Canvas.noFill AND p5Canvas.noStroke THEN EXIT SUB
    FOR i = 0 TO TWO_PI STEP .005
        xx = xr * COS(i) + x
        yy = yr * SIN(i) + y
        IF NOT p5Canvas.noFill THEN LINE (x, y)-(xx, yy), p5Canvas.fill
        IF p5Canvas.noStroke THEN CircleFill xx, yy, p5Canvas.strokeWeight / 2, p5Canvas.fill ELSE CircleFill xx, yy, p5Canvas.strokeWeight / 2, p5Canvas.stroke
    NEXT
    IF p5Canvas.noFill THEN ELSE PAINT (x, y), p5Canvas.fill, p5Canvas.stroke
END SUB

SUB gatherMouseData ()
    WHILE _MOUSEINPUT: WEND
END SUB
