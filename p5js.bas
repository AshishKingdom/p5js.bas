'p5js.bas by Fellippe & Ashish
'Open source - based on p5.js (https://p5js.org/)
'Last update 4/6/2017

RANDOMIZE TIMER

'p5 constants
CONST TWO_PI = 6.283185307179586
CONST HALF_PI = 1.570796326794897
CONST QUARTER_PI = 0.785398163397448
CONST p5POINTS = 1
CONST p5LINES = 2
CONST p5CLOSE = 3
CONST p5RADIAN = 4
CONST p5DEGREE = 5
CONST CORNER = 6
CONST CORNERS = 7

'boolean constants
CONST true = -1, false = NOT true

'p5 global variables
TYPE new_p5Canvas
    imgHandle AS LONG
    stroke AS _UNSIGNED LONG
    strokeA AS _UNSIGNED LONG
    strokeAlpha AS _FLOAT
    fill AS _UNSIGNED LONG
    fillA AS _UNSIGNED LONG
    fillAlpha AS _FLOAT
    backColor AS _UNSIGNED LONG
    backColorA AS _UNSIGNED LONG
    backColorAlpha AS _FLOAT
    strokeWeight AS _FLOAT
    doStroke AS _BYTE
    doFill AS _BYTE
    textAlign AS _BYTE
    rectMode AS _BYTE
END TYPE

TYPE vector
    x AS _FLOAT
    y AS _FLOAT
    z AS _FLOAT
END TYPE

'frame rate
DIM SHARED frameRate AS SINGLE

'angle mode
DIM SHARED p5angleMode AS INTEGER
p5angleMode = p5RADIAN

'canvas settings related variables
DIM SHARED p5Canvas AS new_p5Canvas, pushState AS LONG
REDIM SHARED p5CanvasBackup(10) AS new_p5Canvas

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
DIM SHARED mouseButton1 AS _BYTE, mouseButton2 AS _BYTE, mouseButton3 AS _BYTE
DIM SHARED mouseButton AS _BYTE

'keyboard consts and variables
DIM SHARED keyIsPressed AS _BYTE, keyCode AS LONG
DIM SHARED lastKeyCode AS LONG, totalKeysDown AS INTEGER
CONST BACKSPACE = 8, DELETE = 21248, ENTER = 13, TAB_KEY = 9, ESCAPE = 27
CONST LSHIFT = 100304, RSHIFT = 100303, LCONTROL = 100306, RCONTROL = 100307
CONST LALT = 100308, RALT = 100307
CONST UP_ARROW = 18432, DOWN_ARROW = 20480, LEFT_ARROW = 19200, RIGHT_ARROW = 19712

'mouse query timer
DIM SHARED p5InputTimer AS INTEGER
p5InputTimer = _FREETIMER
ON TIMER(p5InputTimer, .008) gatherInput
TIMER(p5InputTimer) ON

'default settings
createCanvas 640, 400
_TITLE "p5js.bas - Untitled sketch"
_ICON
stroke 0, 0, 0 'white
fill 255, 255, 255
strokeWeight 1
textAlign LEFT
rectMode CORNER
frameRate = 30

DIM a AS _BYTE 'dummy variable used to call functions that may not be there
a = p5setup
a = p5draw 'run the p5draw function at least once (in case noLoop was used in p5setup)

DO
    IF frameRate THEN _LIMIT frameRate
    IF p5Loop THEN a = p5draw
    _DISPLAY
LOOP

SUB createCanvas (w AS INTEGER, h AS INTEGER)
    STATIC CanvasSetup AS _BYTE

    IF NOT CanvasSetup THEN
        p5Canvas.imgHandle = _NEWIMAGE(w, h, 32)
        SCREEN p5Canvas.imgHandle
        tempShapeImage = _NEWIMAGE(_WIDTH, _HEIGHT, 32)
        CanvasSetup = true
    ELSE
        DIM oldDest AS LONG
        oldDest = p5Canvas.imgHandle
        p5Canvas.imgHandle = _NEWIMAGE(w, h, 32)
        SCREEN p5Canvas.imgHandle
        _FREEIMAGE oldDest

        IF tempShapeImage THEN
            _FREEIMAGE tempShapeImage
            tempShapeImage = _NEWIMAGE(_WIDTH, _HEIGHT, 32)
        END IF
    END IF
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

SUB internalp5makeTempImage
    _DEST tempShapeImage
    CLS , 0 'clear it and make it transparent
END SUB

SUB internalp5displayTempImage
    _DEST 0
    _PUTIMAGE (0, 0), tempShapeImage
END SUB

SUB beginShape (kind AS LONG)
    internalp5makeTempImage
    shapeAllow = true
    shapeType = kind
END SUB

SUB vertex (x, y)
    IF shapeInit THEN
        IF shapeType = p5POINTS THEN
            IF p5Canvas.doStroke THEN CircleFill x, y, p5Canvas.strokeWeight / 2, p5Canvas.stroke
        ELSEIF shapeType = p5LINES THEN
            IF NOT p5Canvas.doStroke THEN LINE (PreviousVertex.x, PreviousVertex.y)-(x, y), p5Canvas.fillA ELSE p5line PreviousVertex.x, PreviousVertex.y, x, y
        END IF
    END IF
    IF shapeAllow AND NOT shapeInit THEN
        FirstVertex.x = x
        FirstVertex.y = y
        shapeInit = true
        IF shapeType = p5POINTS THEN
            IF p5Canvas.doStroke THEN CircleFill x, y, p5Canvas.strokeWeight / 2, p5Canvas.strokeA
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
    'do we have to close it?
    IF closed = p5CLOSE AND shapeType = p5LINES THEN
        IF NOT p5Canvas.doStroke THEN LINE (PreviousVertex.x, PreviousVertex.y)-(FirstVertex.x, FirstVertex.y), p5Canvas.fillA ELSE p5line PreviousVertex.x, PreviousVertex.y, FirstVertex.x, FirstVertex.y
    END IF

    'fill with color
    IF p5Canvas.doFill AND shapeType = p5LINES AND closed = p5CLOSE THEN
        avgVertex.x = avgVertex.x / vertexCount
        avgVertex.y = avgVertex.y / vertexCount
        IF p5Canvas.doStroke THEN
            PAINT (avgVertex.x, avgVertex.y), p5Canvas.fill, p5Canvas.strokeA
        ELSE
            PAINT (avgVertex.x, avgVertex.y), p5Canvas.fill, p5Canvas.fill
        END IF
        _SETALPHA p5Canvas.fillAlpha, p5Canvas.fill
    END IF

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

    'place shape onto main canvas
    internalp5displayTempImage
END SUB

SUB textAlign (position AS _BYTE)
    p5Canvas.textAlign = position
END SUB

SUB text (t$, x AS _FLOAT, y AS _FLOAT)
    SELECT CASE p5Canvas.textAlign
        CASE LEFT
            _PRINTSTRING (x, y), t$
        CASE CENTER
            _PRINTSTRING (x - _PRINTWIDTH(t$) / 2, y - _FONTHEIGHT / 2), t$
        CASE RIGHT
            _PRINTSTRING (x - _PRINTWIDTH(t$), y), t$
    END SELECT
END SUB

SUB fill (r AS _FLOAT, g AS _FLOAT, b AS _FLOAT)
    p5Canvas.doFill = true
    p5Canvas.fill = _RGB32(r, g, b)
    p5Canvas.fillA = p5Canvas.fill
    p5Canvas.fillAlpha = 255
    COLOR , p5Canvas.fill 'fill also affects text
END SUB

SUB fillA (r AS _FLOAT, g AS _FLOAT, b AS _FLOAT, a AS _FLOAT)
    p5Canvas.doFill = true
    p5Canvas.fill = _RGB32(r, g, b)
    p5Canvas.fillA = _RGBA32(r, g, b, a)
    p5Canvas.fillAlpha = constrain(a, 0, 255)
    COLOR , p5Canvas.fillA 'fill also affects text
END SUB

SUB fillB (b AS _FLOAT)
    p5Canvas.doFill = true
    p5Canvas.fill = _RGB32(b, b, b)
    p5Canvas.fillA = p5Canvas.fill
    p5Canvas.fillAlpha = 255
    COLOR , p5Canvas.fill 'fill also affects text
END SUB

SUB fillBA (b AS _FLOAT, a AS _FLOAT)
    p5Canvas.doFill = true
    p5Canvas.fill = _RGB32(b, b, b)
    p5Canvas.fillA = _RGBA32(b, b, b, a)
    p5Canvas.fillAlpha = constrain(a, 0, 255)
    COLOR , p5Canvas.fillA 'fill also affects text
END SUB

SUB stroke (r AS _FLOAT, g AS _FLOAT, b AS _FLOAT)
    p5Canvas.doStroke = true
    p5Canvas.stroke = _RGB32(r, g, b)
    p5Canvas.strokeA = p5Canvas.stroke
    COLOR p5Canvas.stroke 'stroke also affects text
END SUB

SUB strokeA (r AS _FLOAT, g AS _FLOAT, b AS _FLOAT, a AS _FLOAT)
    p5Canvas.doStroke = true
    p5Canvas.stroke = _RGB32(r, g, b)
    p5Canvas.strokeA = _RGBA32(r, g, b, a)
    p5Canvas.strokeAlpha = constrain(a, 0, 255)
    COLOR p5Canvas.strokeA 'stroke also affects text
END SUB

SUB strokeB (b AS _FLOAT)
    p5Canvas.doStroke = true
    p5Canvas.stroke = _RGB32(b, b, b)
    p5Canvas.strokeA = p5Canvas.stroke
    p5Canvas.strokeAlpha = 255
    COLOR p5Canvas.stroke 'stroke also affects text
END SUB

SUB strokeBA (b AS _FLOAT, a AS _FLOAT)
    p5Canvas.doStroke = true
    p5Canvas.stroke = _RGB32(b, b, b)
    p5Canvas.strokeA = _RGBA32(b, b, b, a)
    p5Canvas.strokeAlpha = constrain(a, 0, 255)
    COLOR p5Canvas.strokeA 'stroke also affects text
END SUB

SUB push
    pushState = pushState + 1
    IF pushState > UBOUND(p5CanvasBackup) THEN
        REDIM _PRESERVE p5CanvasBackup(pushState + 9) AS new_p5Canvas
    END IF
    p5CanvasBackup(pushState) = p5Canvas
END SUB

SUB pop
    p5Canvas = p5CanvasBackup(pushState)
    pushState = pushState - 1
END SUB

SUB redraw
    DIM a AS _BYTE
    a = p5draw
END SUB

SUB noFill ()
    p5Canvas.doFill = false
    COLOR , 0 'fill also affects text
END SUB

SUB noStroke ()
    p5Canvas.doStroke = false
    COLOR 0 'stroke also affects text
END SUB

SUB strokeWeight (a AS _FLOAT)
    IF a = 0 THEN
        noStroke
    ELSE
        p5Canvas.strokeWeight = a
    END IF
END SUB

SUB CircleFill (CX AS LONG, CY AS LONG, R AS LONG, C AS _UNSIGNED LONG)
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

SUB RoundRectFill (x AS _FLOAT, y AS _FLOAT, x1 AS _FLOAT, y1 AS _FLOAT, r AS _FLOAT, c AS _UNSIGNED LONG)
    'This sub from _vincent at the #qb64 chatroom on freenode.net
    LINE (x, y + r)-(x1, y1 - r), c, BF

    a = r
    b = 0
    e = -a

    DO WHILE a >= b
        LINE (x + r - b, y + r - a)-(x1 - r + b, y + r - a), c, BF
        LINE (x + r - a, y + r - b)-(x1 - r + a, y + r - b), c, BF
        LINE (x + r - b, y1 - r + a)-(x1 - r + b, y1 - r + a), c, BF
        LINE (x + r - a, y1 - r + b)-(x1 - r + a, y1 - r + b), c, BF

        b = b + 1
        e = e + b + b
        IF e > 0 THEN
            a = a - 1
            e = e - a - a
        END IF
    LOOP
END SUB

SUB p5line (x1 AS _FLOAT, y1 AS _FLOAT, x2 AS _FLOAT, y2 AS _FLOAT)
    DIM dx AS _FLOAT, dy AS _FLOAT, d AS _FLOAT
    DIM dxx AS _FLOAT, dyy AS _FLOAT
    DIM i AS _FLOAT

    IF NOT p5Canvas.doStroke THEN EXIT SUB

    dx = x2 - x1
    dy = y2 - y1
    d = SQR(dx * dx + dy * dy)
    FOR i = 0 TO d
        CircleFill dxx + x1, dyy + y1, p5Canvas.strokeWeight / 2, p5Canvas.strokeA
        dxx = dxx + dx / d
        dyy = dyy + dy / d
    NEXT
END SUB

SUB p5point (x AS _FLOAT, y AS _FLOAT)
    IF NOT p5Canvas.doStroke THEN EXIT SUB

    PSET (x, y), p5Canvas.strokeA
END SUB

SUB p5ellipse (x AS _FLOAT, y AS _FLOAT, xr AS _FLOAT, yr AS _FLOAT)
    DIM i AS _FLOAT
    DIM xx AS _FLOAT, yy AS _FLOAT

    IF NOT p5Canvas.doFill AND NOT p5Canvas.doStroke THEN EXIT SUB

    IF p5Canvas.doStroke THEN
        IF xr <> yr THEN
            CIRCLE (x, y), xr + p5Canvas.strokeWeight / 2, p5Canvas.stroke, , , xr / yr
            PAINT (x, y), p5Canvas.stroke, p5Canvas.stroke
            _SETALPHA p5Canvas.strokeAlpha, p5Canvas.stroke
        ELSE
            CircleFill x, y, xr + p5Canvas.strokeWeight / 2, p5Canvas.strokeA
        END IF
    END IF

    IF p5Canvas.doFill THEN
        IF xr <> yr THEN
            CIRCLE (x, y), xr - p5Canvas.strokeWeight / 2, p5Canvas.fill, , , xr / yr
            PAINT (x, y), p5Canvas.fill, p5Canvas.fill
            _SETALPHA p5Canvas.fillAlpha, p5Canvas.fill
        ELSE
            CircleFill x, y, xr - p5Canvas.strokeWeight / 2, p5Canvas.fillA
        END IF
    ELSE
        'no fill
        DIM tempColor~&
        tempColor~& = _RGB32(_RED32(p5Canvas.stroke) - 1, _GREEN32(p5Canvas.stroke) - 1, _BLUE32(p5Canvas.stroke) - 1)
        IF xr <> yr THEN
            CIRCLE (x, y), xr - p5Canvas.strokeWeight / 2, tempColor~&, , , xr / yr
            PAINT (x, y), tempColor~&, tempColor~&
        ELSE
            CircleFill x, y, xr - p5Canvas.strokeWeight / 2, tempColor~&
        END IF
        _CLEARCOLOR tempColor~&
    END IF
END SUB

'draw a triangle by joining 3 differents location
SUB p5triangle (x1##, y1##, x2##, y2##, x3##, y3##)
    IF NOT p5Canvas.doFill AND NOT p5Canvas.doStroke THEN EXIT SUB

    DIM bc AS _UNSIGNED LONG

    internalp5makeTempImage

    IF p5Canvas.doStroke THEN
        p5line x1##, y1##, x2##, y2##
        p5line x2##, y2##, x3##, y3##
        p5line x3##, y3##, x1##, y1##
    ELSE
        p5Canvas.strokeA = p5Canvas.fill
        p5Canvas.doStroke = true
        p5line x1##, y1##, x2##, y2##
        p5line x2##, y2##, x3##, y3##
        p5line x3##, y3##, x1##, y1##
        noStroke
    END IF

    IF p5Canvas.doFill THEN
        avgX## = (x1## + x2## + x3##) / 3
        IF avgX## > _WIDTH - 1 THEN avgX## = _WIDTH - 1
        IF avgX## < 0 THEN avgX## = 0

        avgY## = (y1## + y2## + y3##) / 3
        IF avgY## > _HEIGHT - 1 THEN avgY## = _HEIGHT - 1
        IF avgY## < 0 THEN avgY## = 0

        IF p5Canvas.doStroke THEN
            PAINT (avgX##, avgY##), p5Canvas.fill, p5Canvas.stroke
        ELSE
            PAINT (avgX##, avgY##), p5Canvas.fill, p5Canvas.fill
        END IF
        _SETALPHA p5Canvas.fillAlpha, p5Canvas.fill
    END IF

    internalp5displayTempImage
END SUB

'draw a triangle by joining 3 different angles from the center point with
'a given size
SUB p5triangleB (centerX##, centerY##, __ang1##, __ang2##, __ang3##, size##)
    DIM x1##, y1##, x2##, y2##, x3##, y3##
    DIM ang1##, ang2##, ang3##

    IF p5angleMode = p5RADIAN THEN
        ang1## = __ang1##
        ang2## = __ang2##
        ang3## = __ang3##
    ELSE
        ang1## = _D2R(__ang1##)
        ang2## = _D2R(__ang2##)
        ang3## = _D2R(__ang3##)
    END IF

    IF ang1## < _PI THEN
        x1## = centerX## - size## * COS(ang1##)
        y1## = centerY## + size## * SIN(ang1##)
    END IF

    IF ang2## < _PI THEN
        x2## = centerX## - size## * COS(ang2##)
        y2## = centerY## - size## * SIN(ang2##)
    END IF

    IF ang3## < _PI THEN
        x3## = centerX## + size## * COS(ang3##)
        y3## = centerY## - size## * SIN(ang3##)
    END IF

    p5triangle x1##, y1##, x2##, y2##, x3##, y3##
END SUB

'draws a rectangle
SUB p5rect (x##, y##, width##, height##)
    IF NOT p5Canvas.doFill AND NOT p5Canvas.doStroke THEN EXIT SUB

    internalp5makeTempImage

    IF p5Canvas.rectMode = CORNER OR p5Canvas.rectMode = CORNERS THEN
        'default mode
        x1## = x##
        y1## = y##
    ELSEIF p5Canvas.rectMode = CENTER THEN
        x1## = x## - width## / 2
        y1## = y## - height## / 2
    END IF

    DIM tempColor~&
    tempColor~& = _RGB32(_RED32(p5Canvas.stroke) - 1, _GREEN32(p5Canvas.stroke) - 1, _BLUE32(p5Canvas.stroke) - 1)

    IF p5Canvas.rectMode = CORNER OR p5Canvas.rectMode = CENTER THEN
        IF p5Canvas.doStroke THEN
            LINE (x1## - INT(p5Canvas.strokeWeight / 2), y1## - INT(p5Canvas.strokeWeight / 2))-(x1## + width## + INT(p5Canvas.strokeWeight / 2), y1## + height## + INT(p5Canvas.strokeWeight / 2)), p5Canvas.strokeA, BF
            LINE (x1## + INT(p5Canvas.strokeWeight / 2), y1## + INT(p5Canvas.strokeWeight / 2))-(x1## + width## - INT(p5Canvas.strokeWeight / 2), y1## + height## - INT(p5Canvas.strokeWeight / 2)), tempColor~&, BF
            _CLEARCOLOR tempColor~&
        END IF

        IF p5Canvas.doFill THEN
            IF p5Canvas.doStroke AND p5Canvas.fillAlpha < 255 THEN
                LINE (x1##, y1##)-STEP(width## - 1, height## - 1), tempColor~&, BF
                _CLEARCOLOR tempColor~&
            END IF

            LINE (x1##, y1##)-STEP(width## - 1, height## - 1), p5Canvas.fillA, BF
        END IF
    ELSE
        'CORNERS - consider width and height values as coordinates instead
        IF p5Canvas.doStroke THEN
            LINE (x1## - INT(p5Canvas.strokeWeight / 2), y1## - INT(p5Canvas.strokeWeight / 2))-(width## + INT(p5Canvas.strokeWeight / 2), height## + INT(p5Canvas.strokeWeight / 2)), p5Canvas.strokeA, BF
            LINE (x1## + INT(p5Canvas.strokeWeight / 2), y1## + INT(p5Canvas.strokeWeight / 2))-(width## - INT(p5Canvas.strokeWeight / 2), height## - INT(p5Canvas.strokeWeight / 2)), tempColor~&, BF
            _CLEARCOLOR tempColor~&
        END IF

        IF p5Canvas.doFill THEN
            IF p5Canvas.doStroke AND p5Canvas.fillAlpha < 255 THEN
                LINE (x1##, y1##)-(width##, height##), tempColor~&, BF
                _CLEARCOLOR tempColor~&
            END IF

            LINE (x1##, y1##)-(width##, height##), p5Canvas.fillA, BF
        END IF
    END IF

    internalp5displayTempImage
END SUB

'draws a rectangle with rounded corners (r## is the amount)
SUB p5rectB (x##, y##, width##, height##, r##)
    IF NOT p5Canvas.doFill AND NOT p5Canvas.doStroke THEN EXIT SUB

    internalp5makeTempImage

    IF p5Canvas.rectMode = CORNER OR p5Canvas.rectMode = CORNERS THEN
        'default mode
        x1## = x##
        y1## = y##
    ELSEIF p5Canvas.rectMode = CENTER THEN
        x1## = x## - width## / 2
        y1## = y## - height## / 2
    END IF

    DIM tempColor~&
    tempColor~& = _RGB32(_RED32(p5Canvas.stroke) - 1, _GREEN32(p5Canvas.stroke) - 1, _BLUE32(p5Canvas.stroke) - 1)

    IF p5Canvas.rectMode = CORNER OR p5Canvas.rectMode = CENTER THEN
        IF p5Canvas.doStroke THEN
            RoundRectFill x1## - INT(p5Canvas.strokeWeight / 2), y1## - INT(p5Canvas.strokeWeight / 2), x1## + width## + INT(p5Canvas.strokeWeight / 2), y1## + height## + INT(p5Canvas.strokeWeight / 2), r##, p5Canvas.stroke
            _SETALPHA p5Canvas.strokeAlpha, p5Canvas.stroke

            RoundRectFill x1## + INT(p5Canvas.strokeWeight / 2), y1## + INT(p5Canvas.strokeWeight / 2), x1## + width## - INT(p5Canvas.strokeWeight / 2), y1## + height## - INT(p5Canvas.strokeWeight / 2), r##, tempColor~&
            _CLEARCOLOR tempColor~&
        END IF

        IF p5Canvas.doFill THEN
            IF p5Canvas.doStroke AND p5Canvas.fillAlpha < 255 THEN
                RoundRectFill x1##, y1##, x1## + width## - 1, height##, r##, tempColor~&
                _CLEARCOLOR tempColor~&
            END IF

            RoundRectFill x1##, y1##, x1## + width## - 1, y1## + height## - 1, r##, p5Canvas.fill
            _SETALPHA p5Canvas.fillAlpha, p5Canvas.fill
        END IF
    ELSE
        'CORNERS - consider width and height values as coordinates instead
        IF p5Canvas.doStroke THEN
            RoundRectFill x1## - INT(p5Canvas.strokeWeight / 2), y1## - INT(p5Canvas.strokeWeight / 2), width## + INT(p5Canvas.strokeWeight / 2), height## + INT(p5Canvas.strokeWeight / 2), r##, p5Canvas.stroke
            _SETALPHA p5Canvas.strokeAlpha, p5Canvas.stroke

            RoundRectFill x1## + INT(p5Canvas.strokeWeight / 2), y1## + INT(p5Canvas.strokeWeight / 2), width## - INT(p5Canvas.strokeWeight / 2), height## - INT(p5Canvas.strokeWeight / 2), r##, tempColor~&
            _CLEARCOLOR tempColor~&
        END IF

        IF p5Canvas.doFill THEN
            IF p5Canvas.doStroke AND p5Canvas.fillAlpha < 255 THEN
                RoundRectFill x1##, y1##, width##, height##, r##, tempColor~&
                _CLEARCOLOR tempColor~&
            END IF

            RoundRectFill x1##, y1##, width##, height##, r##, p5Canvas.fill
            _SETALPHA p5Canvas.fillAlpha, p5Canvas.fill
        END IF
    END IF

    internalp5displayTempImage
END SUB

SUB rectMode (mode AS _BYTE)
    p5Canvas.rectMode = mode
END SUB

'draws a quadrilateral
SUB p5quad (x1##, y1##, x2##, y2##, x3##, y3##, x4##, y4##)
    beginShape p5LINES
    vertex x1##, y1##
    vertex x2##, y2##
    vertex x3##, y3##
    vertex x4##, y4##
    endShape p5CLOSE
END SUB

SUB gatherInput ()
    DIM a AS _BYTE

    'Keyboard input:
    keyCode = _KEYHIT
    IF keyCode > 0 AND keyCode <> lastKeyCode THEN
        lastKeyCode = keyCode
        a = keyPressed
        totalKeysDown = totalKeysDown + 1
    ELSEIF keyCode < 0 THEN
        totalKeysDown = totalKeysDown - 1
        IF totalKeysDown <= 0 THEN
            totalKeysDown = 0
            keyCode = ABS(keyCode)
            a = keyReleased
            lastKeyCode = 0
        END IF
    END IF

    keyIsPressed = totalKeysDown > 0

    'Mouse input (optimization by Luke Ceddia):
    p5mouseWheel = 0

    IF _MOUSEINPUT THEN
        p5mouseWheel = p5mouseWheel + _MOUSEWHEEL
        IF _MOUSEBUTTON(1) = mouseButton1 AND _MOUSEBUTTON(2) = mouseButton2 AND _MOUSEBUTTON(3) = mouseButton3 THEN
            DO WHILE _MOUSEINPUT
                p5mouseWheel = p5mouseWheel + _MOUSEWHEEL
                IF NOT (_MOUSEBUTTON(1) = mouseButton1 AND _MOUSEBUTTON(2) = mouseButton2 AND _MOUSEBUTTON(3) = mouseButton3) THEN EXIT DO
            LOOP
        END IF
        mouseButton1 = _MOUSEBUTTON(1)
        mouseButton2 = _MOUSEBUTTON(2)
        mouseButton3 = _MOUSEBUTTON(3)
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

    IF mouseButton3 THEN
        mouseButton = CENTER
        IF NOT mouseIsPressed THEN
            mouseIsPressed = true
            a = mousePressed
        ELSE
            a = mouseDragged
        END IF
    ELSE
        IF mouseIsPressed AND mouseButton = CENTER THEN
            mouseIsPressed = false
            a = mouseReleased
            a = mouseClicked
        END IF
    END IF

END SUB

SUB background (r AS _FLOAT, g AS _FLOAT, b AS _FLOAT)
    p5Canvas.backColor = _RGB32(r, g, b)
    p5Canvas.backColorAlpha = 255
    LINE (0, 0)-(_WIDTH, _HEIGHT), p5Canvas.backColor, BF
END SUB

SUB backgroundA (r AS _FLOAT, g AS _FLOAT, b AS _FLOAT, a AS _FLOAT)
    p5Canvas.backColor = _RGB32(r, g, b)
    p5Canvas.backColorA = _RGBA32(r, g, b, a)
    p5Canvas.backColorAlpha = constrain(a, 0, 255)
    LINE (0, 0)-(_WIDTH, _HEIGHT), p5Canvas.backColorA, BF
END SUB

SUB backgroundB (b AS _FLOAT)
    p5Canvas.backColor = _RGB32(b, b, b)
    p5Canvas.backColorAlpha = 255
    LINE (0, 0)-(_WIDTH, _HEIGHT), p5Canvas.backColor, BF
END SUB

SUB backgroundBA (b AS _FLOAT, a AS _FLOAT)
    p5Canvas.backColor = _RGB32(b, b, b)
    p5Canvas.backColorA = _RGBA32(b, b, b, a)
    p5Canvas.backColorAlpha = constrain(a, 0, 255)
    LINE (0, 0)-(_WIDTH, _HEIGHT), p5Canvas.backColorA, BF
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

SUB createVector (v AS vector, x AS _FLOAT, y AS _FLOAT)
    v.x = x
    v.y = y
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
    IF p5angleMode = p5DEGREE THEN angle## = _D2R(__angle##) ELSE angle## = __angle##

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

'Use QB64's builtin _R2D
'FUNCTION degrees## (r##)
'    degrees## = r## * (180 / _PI)
'END FUNCTION

'Use QB64's builtin _D2R
'FUNCTION radians## (d##)
'    radians## = d## * (_PI / 180)
'END FUNCTION

FUNCTION p5sin## (angle##)
    IF p5angleMode = p5RADIAN THEN
        p5.sin## = SIN(angle##)
    ELSE
        p5.sin## = SIN(_D2R(angle##))
    END IF
END FUNCTION

FUNCTION p5cos## (angle##)
    IF p5angleMode = p5RADIAN THEN
        p5.cos## = COS(angle##)
    ELSE
        p5.cos## = COS(_D2R(angle##))
    END IF
END FUNCTION

SUB angleMode (kind)
    p5angleMode = kind
END SUB

'Calculate minimum value between two values
FUNCTION min## (a##, b##)
    IF a## < b## THEN min## = a## ELSE min## = b##
END FUNCTION

'Calculate maximum value between two values
FUNCTION max## (a##, b##)
    IF a## > b## THEN max## = a## ELSE max## = b##
END FUNCTION

'Constrain a value between a minimum and maximum value.
FUNCTION constrain## (n##, low##, high##)
    constrain## = max(min(n##, high##), low##)
END FUNCTION

'Calculate the distance between two points.
FUNCTION dist## (x1##, y1##, x2##, y2##)
    IF x2## > x1## THEN dx## = x2## - x1## ELSE dx## = x1## - x2##
    IF y2## > y1## THEN dy## = y2## - y1## ELSE dy## = y1## - y2##
    dist## = SQR(dx## * dx## + dy## * dy##)
END FUNCTION

FUNCTION distB## (v1 AS vector, v2 AS vector)
    IF v2.x## > v1.x## THEN dx## = v2.x## - v1.x## ELSE dx## = v1.x## - v2.x##
    IF v2.y## > v1.y## THEN dy## = v2.y## - v1.y## ELSE dy## = v1.y## - v2.y##
    distB## = SQR(dx## * dx## + dy## * dy##)
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
    FOR i = LBOUND(str_array$) TO UBOUND(str_array$)
        join$ = join$ + str_array$(i) + sep$
    NEXT
END FUNCTION

'uncomment these lines below to see a simple demo
'FUNCTION p5setup ()
'    createCanvas 400, 400
'    strokeWeight 2
'    fill 255, 0, 0
'END FUNCTION

'FUNCTION p5draw ()
'    backgroundBA 0, 30
'    p5ellipse _MOUSEX, _MOUSEY, 20, 20
'END FUNCTION
