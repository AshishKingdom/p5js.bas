'p5js.bas by Fellippe & Ashish
'Open source - based on p5.js (https://p5js.org/)
'Last update 4/4/2017

'p5 constant
RANDOMIZE TIMER

CONST TWO_PI = 6.283185307179586
CONST HALF_PI = 1.570796326794897
CONST QUARTER_PI = 0.785398163397448
CONST P5_POINTS = 1
CONST P5_LINES = 2
CONST P5_CLOSE = -3
CONST P5_RADIAN = 4
CONST P5_DEGREE = 5
CONST true = -1, false = NOT true

'p5 Global Variables
TYPE p5canvasSettings
    stroke AS _UNSIGNED LONG
    fill AS _UNSIGNED LONG
    strokeWeight AS _FLOAT
    noStroke AS _BYTE
    noFill AS _BYTE
END TYPE

TYPE vector
    x AS _FLOAT
    y AS _FLOAT
    z AS _FLOAT
END TYPE
'frame rate
DIM SHARED frameRate AS SINGLE
'angle mode
DIM SHARED p5_Angle_Mode AS INTEGER
p5_Angle_Mode = P5_RADIAN
'canvas settings related variables
DIM SHARED p5Canvas AS p5canvasSettings

'begin shape related variables
DIM SHARED FirstVertex AS vector, avgVertex AS vector, PreviousVertex AS vector, vertexCount AS LONG
DIM SHARED shapeAllow AS _BYTE, shapeType AS LONG, shapeInit AS _BYTE
DIM SHARED tempShapeImage AS LONG

'loops and NoLoops
DIM SHARED p5Loop AS _BYTE
p5Loop = true 'default is true

'mouse consts and variables
CONST LEFT = 1, RIGHT = 2, CENTER = 3
DIM SHARED mouseIsPressed AS _BYTE, p5mouseWheel AS INTEGER
DIM SHARED mouseButton1 AS _BYTE, mouseButton2 AS _BYTE
DIM SHARED mouseButton AS _BYTE

'mouse query timer
DIM SHARED p5MouseTimer AS INTEGER
p5MouseTimer = _FREETIMER
ON TIMER(p5MouseTimer, .008) gatherMouseData
TIMER(p5MouseTimer) ON

'default settings
SCREEN _NEWIMAGE(300, 300, 32)
p5Canvas.stroke = _RGB32(255, 255, 255) 'white
p5Canvas.fill = _RGB32(0, 0, 0)
p5Canvas.strokeWeight = 0
frameRate = 30

DIM a AS _BYTE
a = p5setup

DO
    IF frameRate THEN _LIMIT frameRate
    IF p5Loop THEN a = p5draw
    _DISPLAY
LOOP

SUB createCanvas (w AS INTEGER, h AS INTEGER)
    DIM oldDest AS LONG
    oldDest = _DEST
    SCREEN _NEWIMAGE(w, h, 32)
    _FREEIMAGE oldDest
END SUB

FUNCTION noise## (x AS _FLOAT, y AS _FLOAT, z AS _FLOAT)
    STATIC p5NoiseSetup AS _BYTE
    STATIC perlin() AS _FLOAT
    STATIC PERLIN_YWRAPB AS _FLOAT, PERLIN_YWRAP AS _FLOAT
    STATIC PERLIN_ZWRAPB AS _FLOAT, PERLIN_ZWRAP AS _FLOAT
    STATIC PERLIN_SIZE AS _FLOAT, perlin_octaves AS _FLOAT
    STATIC perlin_amp_falloff AS _FLOAT

    IF NOT p5NoiseSetup THEN
        p5NoiseSetup = true

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

SUB beginShape (kind AS LONG)
    tempShapeImage = _NEWIMAGE(_WIDTH, _HEIGHT, 32)
    _DEST tempShapeImage
    CLS , 0
    shapeAllow = true
    shapeType = kind
END SUB

SUB vertex (x, y)
    IF shapeInit THEN
        IF shapeType = P5_POINTS THEN
            CircleFill x, y, p5Canvas.strokeWeight / 2, p5Canvas.stroke
        ELSEIF shapeType = P5_LINES THEN
            IF p5Canvas.noStroke THEN LINE (PreviousVertex.x, PreviousVertex.y)-(x, y), p5Canvas.fill ELSE p5line PreviousVertex.x, PreviousVertex.y, x, y
        END IF
    END IF
    IF shapeAllow AND NOT shapeInit THEN
        FirstVertex.x = x
        FirstVertex.y = y
        shapeInit = true
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
        IF p5Canvas.noStroke THEN LINE (PreviousVertex.x, PreviousVertex.y)-(FirstVertex.x, FirstVertex.y), p5Canvas.fill ELSE p5line PreviousVertex.x, PreviousVertex.y, FirstVertex.x, FirstVertex.y
    END IF

    'filling the color
    IF NOT p5Canvas.noFill AND shapeType = P5_LINES AND closed = P5_CLOSE THEN
        avgVertex.x = avgVertex.x / vertexCount
        avgVertex.y = avgVertex.y / vertexCount
        IF p5Canvas.noStroke THEN PAINT (avgVertex.x, avgVertex.y), p5Canvas.fill, p5Canvas.fill ELSE PAINT (avgVertex.x, avgVertex.y), p5Canvas.fill, p5Canvas.stroke

    END IF

    'place shape onto main canvas
    _DEST 0
    _PUTIMAGE (0, 0), tempShapeImage
    _FREEIMAGE tempShapeImage

    'it's time to reset all varibles!!
    shapeAllow = false
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

SUB fill (r AS _FLOAT, g AS _FLOAT, b AS _FLOAT)
    p5Canvas.noFill = false
    p5Canvas.fill = _RGB32(r, g, b)
END SUB

SUB fillA (r AS _FLOAT, g AS _FLOAT, b AS _FLOAT, a AS _FLOAT)
    p5Canvas.noFill = false
    p5Canvas.fill = _RGBA32(r, g, b, a)
END SUB

SUB fillB (b AS _FLOAT)
    p5Canvas.noFill = false
    p5Canvas.fill = _RGB32(b, b, b)
END SUB

SUB fillBA (b AS _FLOAT, a AS _FLOAT)
    p5Canvas.noFill = false
    p5Canvas.fill = _RGBA32(b, b, b, a)
END SUB

SUB stroke (r AS _FLOAT, g AS _FLOAT, b AS _FLOAT)
    p5Canvas.noStroke = false
    p5Canvas.stroke = _RGB32(r, g, b)
END SUB

SUB strokeA (r AS _FLOAT, g AS _FLOAT, b AS _FLOAT, a AS _FLOAT)
    p5Canvas.noStroke = false
    p5Canvas.stroke = _RGBA32(r, g, b, a)
END SUB

SUB strokeB (b AS _FLOAT)
    p5Canvas.noStroke = false
    p5Canvas.stroke = _RGB32(b, b, b)
END SUB

SUB strokeBA (b AS _FLOAT, a AS _FLOAT)
    p5Canvas.noStroke = false
    p5Canvas.stroke = _RGBA32(b, b, b, a)
END SUB

SUB noFill ()
    p5Canvas.noFill = true
END SUB

SUB noStroke ()
    p5Canvas.noStroke = true
END SUB

SUB strokeWeight (a AS _FLOAT)
    p5Canvas.strokeWeight = a
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

SUB p5line (x1 AS _FLOAT, y1 AS _FLOAT, x2 AS _FLOAT, y2 AS _FLOAT)
    DIM dx AS _FLOAT, dy AS _FLOAT, d AS _FLOAT
    DIM dxx AS _FLOAT, dyy AS _FLOAT
    DIM i AS _FLOAT

    dx = x2 - x1
    dy = y2 - y1
    d = SQR(dx * dx + dy * dy)
    FOR i = 0 TO d
        CircleFill dxx + x1, dyy + y1, p5Canvas.strokeWeight / 2, p5Canvas.stroke
        dxx = dxx + dx / d
        dyy = dyy + dy / d
    NEXT
END SUB

SUB p5point (x AS _FLOAT, y AS _FLOAT)
    IF p5Canvas.noStroke THEN EXIT SUB

    PSET (x, y), p5Canvas.stroke
    ' CircleFill x, y, p5Canvas.strokeWeight, p5Canvas.stroke
END SUB

SUB ellipse (x AS _FLOAT, y AS _FLOAT, xr AS _FLOAT, yr AS _FLOAT)
    DIM i AS _FLOAT, tempImage AS LONG
    DIM xx AS _FLOAT, yy AS _FLOAT
    IF p5Canvas.noFill AND p5Canvas.noStroke THEN EXIT SUB

    tempImage = _NEWIMAGE(_WIDTH, _HEIGHT, 32)
    _DEST tempImage
    CLS , 0
    FOR i = 0 TO TWO_PI STEP .0025
        xx = xr * COS(i) + x
        yy = yr * SIN(i) + y
        IF p5Canvas.noStroke THEN CircleFill xx, yy, p5Canvas.strokeWeight / 2, p5Canvas.fill ELSE CircleFill xx, yy, p5Canvas.strokeWeight / 2, p5Canvas.stroke
    NEXT
    IF NOT p5Canvas.noFill THEN
        IF p5Canvas.noStroke THEN PAINT (x, y), p5Canvas.fill, p5Canvas.fill ELSE PAINT (x, y), p5Canvas.fill, p5Canvas.stroke
    END IF
    _DEST 0
    _PUTIMAGE (0, 0), tempImage
    _FREEIMAGE tempImage
END SUB

SUB gatherMouseData ()
    DIM a AS _BYTE

    'Mouse input (optimization by Luke Ceddia):
    p5mouseWheel = 0
    IF _MOUSEINPUT THEN
        p5mouseWheel = p5mouseWheel + _MOUSEWHEEL
        IF _MOUSEBUTTON(1) = mouseButton1 AND _MOUSEBUTTON(2) = mouseButton2 THEN
            DO WHILE _MOUSEINPUT
                p5mouseWheel = p5mouseWheel + _MOUSEWHEEL
                IF NOT (_MOUSEBUTTON(1) = mouseButton1 AND _MOUSEBUTTON(2) = mouseButton2) THEN EXIT DO
            LOOP
        END IF
        mouseButton1 = _MOUSEBUTTON(1)
        mouseButton2 = _MOUSEBUTTON(2)
    END IF
    WHILE _MOUSEINPUT: WEND

    IF p5mouseWheel THEN
        a = mouseWheel
    END IF

    IF mouseButton1 THEN
        mouseButton = LEFT
        IF NOT mouseIsPressed THEN
            mouseIsPressed = true
            a = mousePressed
        ELSE
            a = mouseDragged
        END IF
    ELSE
        IF mouseIsPressed AND mouseButton = LEFT THEN
            mouseIsPressed = false
            a = mouseReleased
            a = mouseClicked
        END IF
    END IF

    IF mouseButton2 THEN
        mouseButton = RIGHT
        IF NOT mouseIsPressed THEN
            mouseIsPressed = true
            a = mousePressed
        ELSE
            a = mouseDragged
        END IF
    ELSE
        IF mouseIsPressed AND mouseButton = RIGHT THEN
            mouseIsPressed = false
            a = mouseReleased
            a = mouseClicked
        END IF
    END IF
END SUB

SUB background (r AS _FLOAT, g AS _FLOAT, b AS _FLOAT)
    LINE (0, 0)-(_WIDTH, _HEIGHT), _RGB32(r, g, b), BF
END SUB

SUB backgroundA (r AS _FLOAT, g AS _FLOAT, b AS _FLOAT, a AS _FLOAT)
    LINE (0, 0)-(_WIDTH, _HEIGHT), _RGBA32(r, g, b, a), BF
END SUB

SUB backgroundB (b AS _FLOAT)
    LINE (0, 0)-(_WIDTH, _HEIGHT), _RGB32(b, b, b), BF
END SUB

SUB backgroundBA (b AS _FLOAT, a AS _FLOAT)
    LINE (0, 0)-(_WIDTH, _HEIGHT), _RGBA32(b, b, b, a), BF
END SUB
                                
SUB doLoop ()
    p5Loop = true
END SUB

SUB noLoop ()
    p5Loop = false
END SUB

FUNCTION month& ()
    month& = VAL(LEFT$(DATE$, 2))
END FUNCTION

FUNCTION day& ()
    day& = VAL(MID$(DATE$, 4, 2))
END FUNCTION

FUNCTION year& ()
    year& = VAL(RIGHT$(DATE$, 4))
END FUNCTION

FUNCTION hour& ()
    hour& = VAL(LEFT$(TIME$, 2))
END FUNCTION

FUNCTION minute& ()
    minute& = VAL(MID$(TIME$, 4, 2))
END FUNCTION

FUNCTION seconds& ()
    seconds& = VAL(RIGHT$(TIME$, 2))
END SUB

SUB vector.add (v1 AS vector, v2 AS vector)
    v1.x = v1.x + v2.x
    v1.y = v1.y + v2.y
    v1.z = v1.z + v2.z
END SUB

SUB vector.addB (v1 AS vector, x2 AS _FLOAT, y2 AS _FLOAT, z2 AS _FLOAT)
    v1.x = v1.x + x2
    v1.y = v1.y + y2
    v1.z = v1.z + z2
END SUB

SUB vector.sub (v1 AS vector, v2 AS vector)
    v1.x = v1.x - v2.x
    v1.y = v1.y - v2.y
    v1.z = v1.z - v2.z
END SUB

SUB vector.subB (v1 AS vector, x2 AS _FLOAT, y2 AS _FLOAT, z2 AS _FLOAT)
    v1.x = v1.x - x2
    v1.y = v1.y - y2
    v1.z = v1.z - z2
END SUB

SUB vector.limit (v AS vector, __max##)
    mSq = vector.magSq(v)
    IF mSq > __max## * __max## THEN
        vector.div v, SQR(mSq)
        vector.mult v, __max##
    END IF
END SUB

FUNCTION vector.magSq## (v AS vector)
    vector.magSq## = v.x * v.x + v.y * v.y + v.z * v.z
END FUNCTION

SUB vector.fromAngle (v AS vector, __angle##)
    angle## = _D2R(__angle##)
    v.x = COS(angle##)
    v.y = SIN(angle##)
END SUB

FUNCTION vector.mag## (v AS vector)
    x = v.x
    y = v.y
    z = v.z

    magSq = x * x + y * y + z * z
    vector.mag## = SQR(magSq)
END FUNCTION

SUB vector.setMag (v AS vector, n AS _FLOAT)
    vector.normalize v
    vector.mult v, n
END SUB

SUB vector.normalize (v AS vector)
    theMag## = vector.mag(v)
    IF theMag## = 0 THEN EXIT SUB

    vector.div v, theMag##
END SUB

SUB vector.div (v AS vector, n AS _FLOAT)
    v.x = v.x / n
    v.y = v.y / n
    v.z = v.z / n
END SUB

SUB vector.mult (v AS vector, n AS _FLOAT)
    v.x = v.x * n
    v.y = v.y * n
    v.z = v.z * n
END SUB

FUNCTION degrees## (r##)
    degrees## = r## * (180 / _PI)
END FUNCTION

FUNCTION radians## (d##)
    radians## = d## * (_PI / 180)
END FUNCTION

FUNCTION p5sin## (angle##)
    IF p5_Angle_Mode = P5_RADIAN THEN p5.sin## = SIN(angle##) ELSE p5.sin## = SIN(radians(angle##))
END FUNCTION

FUNCTION p5cos## (angle##)
    IF p5_Angle_Mode = P5_RADIAN THEN p5.cos## = COS(angle##) ELSE p5.cos## = COS(radians(angle##))
END FUNCTION
SUB angleMode (kind)
    IF kind = P5_RADIAN THEN p5_Angle_Mode = P5_RADIAN
    IF kind = P5_DEGREE THEN p5_Angle_Mode = P5_DEGREE
END SUB

'Calculate minimum value between two value
FUNCTION min## (a##, b##)
    IF a## < b## THEN min## = a## ELSE min## = b##
END FUNCTION

'Calculate maximum value between two value
FUNCTION max## (a##, b##)
    IF a## > b## THEN max## = a## ELSE max## = b##
END FUNCTION

'* Constrains a value between a minimum and maximum value.
FUNCTION constrain## (n##, low##, high##)
    constrain## = max(min(n##, high##), low##)
END FUNCTION

' * Calculates the distance between two points.
FUNCTION dist## (x1##, y1##, x2##, y2##)
    IF x2## > x1## THEN dx## = x2## - x1## ELSE dx## = x1## - x2##
    IF y2## > y1## THEN dy## = y2## - y1## ELSE dy## = y1## - y2##
    dist## = SQR(dx## * dx## + dy## * dy##)
END FUNCTION

FUNCTION lerp## (start##, stp##, amt##)
    lerp## = amt## * (stp## - start##) + start##
END FUNCTION

FUNCTION mag## (x##, y##)
    mag## = _HYPOT(x##, y##)
END FUNCTION

FUNCTION sq## (n##)
    sq## = n## * n##
END FUNCTION

FUNCTION random2d## (mn##, mx##)
    IF mn## > mx## THEN
        tmp## = mn##
        mn## = mx##
        mx## = tmp##
    END IF
    random2d## = RND * (mx## - mn##) + mn##
END FUNCTION

FUNCTION join$ (str_array$(), sep$)
    FOR i = 0 TO UBOUND(str_array$)
        join$ = join$ + str_array$(i) + sep$
    NEXT
END FUNCTION
'uncomment these below to see a simple demo
'FUNCTION p5setup ()
'createCanvas 400, 400
'strokeWeight 2
'fill 255, 0, 0
'END FUNCTION

'FUNCTION p5draw ()
'backgroundBA 0, 30
'ellipse _MOUSEX, _MOUSEY, 20, 20
'END FUNCTION


