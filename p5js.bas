'p5js.bas by Fellippe & Ashish
'Open source - based on p5.js (https://p5js.org/)
'Last update 5/26/2017

RANDOMIZE TIMER

'external font rendering lib
DECLARE LIBRARY "falcon"
    SUB uprint_extra (BYVAL x&, BYVAL y&, BYVAL chars%&, BYVAL length%&, BYVAL kern&, BYVAL do_render&, txt_width&, BYVAL charpos%&, charcount&, BYVAL colour~&, BYVAL max_width&)
    FUNCTION uprint (BYVAL x&, BYVAL y&, chars$, BYVAL txt_len&, BYVAL colour~&, BYVAL max_width&)
    FUNCTION uprintwidth (chars$, BYVAL txt_len&, BYVAL max_width&)
    FUNCTION uheight& ()
    FUNCTION falcon_uspacing& ALIAS uspacing ()
    FUNCTION uascension& ()
END DECLARE

DECLARE LIBRARY
    FUNCTION millis~& ALIAS GetTicks
    SUB glutSetCursor (BYVAL style&)
END DECLARE

'p5 constants
CONST TWO_PI = 6.283185307179586
CONST HALF_PI = 1.570796326794897
CONST QUARTER_PI = 0.785398163397448
CONST TAU = TWO_PI
CONST p5POINTS = 1
CONST p5LINES = 2
CONST p5CLOSE = 3
CONST RADIANS = 4
CONST DEGREES = 5
CONST CORNER = 6
CONST CORNERS = 7
CONST p5RGB = 8
CONST p5HSB = 9
CONST CURSOR_NORMAL = 1
CONST CURSOR_HAND = 2
CONST CURSOR_HELP = 4
CONST CURSOR_CYCLE = 7
CONST CURSOR_TEXT = 8
CONST CURSOR_CROSSHAIR = 3
CONST CURSOR_UP_DOWN = 10
CONST CURSOR_LEFT_RIGHT = 11
CONST CURSOR_LEFT_RIGHT_CORNER = 16
CONST CURSOR_RIGHT_LEFT_CORNER = 17
CONST CURSOR_MOVE = 5
CONST CURSOR_NONE = 23
CONST ARC_DEFAULT = 1
CONST ARC_OPEN = 3
CONST ARC_CHORD = 5
CONST ARC_PIE = 7
'boolean constants
CONST true = -1, false = NOT true

'p5 global variables
TYPE new_p5Canvas
    imgHandle AS LONG
    fontHandle AS LONG
    stroke AS _UNSIGNED LONG
    strokeA AS _UNSIGNED LONG
    strokeAlpha AS SINGLE
    fill AS _UNSIGNED LONG
    fillA AS _UNSIGNED LONG
    fillAlpha AS SINGLE
    backColor AS _UNSIGNED LONG
    backColorA AS _UNSIGNED LONG
    backColorAlpha AS SINGLE
    strokeWeight AS SINGLE
    doStroke AS _BYTE
    doFill AS _BYTE
    textAlign AS _BYTE
    encoding AS LONG
    rectMode AS _BYTE
    xOffset AS SINGLE
    yOffset AS SINGLE
    colorMode AS INTEGER
    angleMode AS INTEGER
END TYPE

TYPE new_SoundHandle
    handle AS LONG
    sync AS _BYTE
END TYPE

TYPE vector
    x AS SINGLE
    y AS SINGLE
    z AS SINGLE
END TYPE

TYPE __p5Color
    n AS STRING * 32 'name of the color
    c AS _UNSIGNED LONG 'color value
END TYPE


'p5 colors table
DIM SHARED p5Colors(135) AS __p5Color
'support all the colors listed here - http://www.rapidtables.com/web/color/RGB_Color.htm
p5Colors(1).n = "black"
p5Colors(1).c = _RGB32(0, 0, 0)
p5Colors(2).n = "white"
p5Colors(2).c = _RGB32(255, 255, 255)
p5Colors(3).n = "red"
p5Colors(3).c = _RGB32(255, 0, 0)
p5Colors(4).n = "lime"
p5Colors(4).c = _RGB32(0, 255, 0)
p5Colors(5).n = "blue"
p5Colors(5).c = _RGB32(0, 0, 255)
p5Colors(6).n = "yellow"
p5Colors(6).c = _RGB32(255, 255, 0)
p5Colors(7).n = "cyan"
p5Colors(7).c = _RGB32(0, 255, 255)
p5Colors(8).n = "aqua"
p5Colors(8).c = _RGB32(0, 255, 255)
p5Colors(9).n = "magenta"
p5Colors(9).c = _RGB32(255, 0, 255)
p5Colors(10).n = "fuchsia"
p5Colors(10).c = _RGB32(255, 0, 255)
p5Colors(11).n = "silver"
p5Colors(11).c = _RGB32(192, 192, 192)
p5Colors(12).n = "gray"
p5Colors(12).c = _RGB32(128, 128, 128)
p5Colors(13).n = "maroon"
p5Colors(13).c = _RGB32(128, 0, 0)
p5Colors(14).n = "olive"
p5Colors(14).c = _RGB32(128, 128, 0)
p5Colors(15).n = "green"
p5Colors(15).c = _RGB32(0, 128, 0)
p5Colors(16).n = "purple"
p5Colors(16).c = _RGB32(128, 0, 128)
p5Colors(17).n = "teal"
p5Colors(17).c = _RGB32(0, 128, 128)
p5Colors(18).n = "navy"
p5Colors(18).c = _RGB32(0, 0, 128)
p5Colors(19).n = "dark red"
p5Colors(19).c = _RGB32(139, 0, 0)
p5Colors(20).n = "brown"
p5Colors(20).c = _RGB32(165, 42, 42)
p5Colors(21).n = "firebrick"
p5Colors(21).c = _RGB32(178, 34, 34)
p5Colors(22).n = "crimson"
p5Colors(22).c = _RGB32(220, 20, 60)
p5Colors(23).n = "tomato"
p5Colors(23).c = _RGB32(255, 99, 71)
p5Colors(24).n = "coral"
p5Colors(24).c = _RGB32(255, 127, 80)
p5Colors(25).n = "indian red"
p5Colors(25).c = _RGB32(205, 92, 92)
p5Colors(26).n = "light coral"
p5Colors(26).c = _RGB32(240, 128, 128)
p5Colors(27).n = "dark salmon"
p5Colors(27).c = _RGB32(233, 150, 122)
p5Colors(28).n = "orange red"
p5Colors(28).c = _RGB32(255, 69, 0)
p5Colors(29).n = "dark orange"
p5Colors(29).c = _RGB32(255, 140, 0)
p5Colors(30).n = "orange"
p5Colors(30).c = _RGB32(255, 165, 0)
p5Colors(31).n = "gold"
p5Colors(31).c = _RGB32(255, 215, 0)
p5Colors(32).n = "dark golden rod"
p5Colors(32).c = _RGB32(184, 134, 11)
p5Colors(33).n = "golden rod"
p5Colors(33).c = _RGB32(218, 165, 32)
p5Colors(34).n = "pale golden rode"
p5Colors(34).c = _RGB32(238, 232, 170)
p5Colors(35).n = "dark khaki"
p5Colors(35).c = _RGB32(189, 183, 107)
p5Colors(36).n = "khaki"
p5Colors(36).c = _RGB32(240, 240, 140)
p5Colors(37).n = "yellow green"
p5Colors(37).c = _RGB32(154, 205, 50)
p5Colors(38).n = "dark olive green"
p5Colors(38).c = _RGB32(85, 107, 47)
p5Colors(39).n = "olive drab"
p5Colors(39).c = _RGB32(107, 142, 35)
p5Colors(40).n = "lawn green"
p5Colors(40).c = _RGB32(124, 252, 0)
p5Colors(41).n = "chart reuse"
p5Colors(41).c = _RGB32(127, 255, 0)
p5Colors(42).n = "green yellow"
p5Colors(42).c = _RGB32(173, 255, 47)
p5Colors(43).n = "dark green"
p5Colors(43).c = _RGB32(0, 100, 0)
p5Colors(44).n = "forest green"
p5Colors(44).c = _RGB32(34, 139, 34)
p5Colors(45).n = "lime green"
p5Colors(45).c = _RGB32(50, 205, 50)
p5Colors(46).n = "light green"
p5Colors(46).c = _RGB32(144, 238, 144)
p5Colors(47).n = "pale green"
p5Colors(47).c = _RGB32(152, 251, 152)
p5Colors(48).n = "dark sea green"
p5Colors(48).c = _RGB32(143, 188, 143)
p5Colors(49).n = "medium spring green"
p5Colors(49).c = _RGB32(0, 250, 154)
p5Colors(50).n = "spring green"
p5Colors(50).c = _RGB32(0, 255, 127)
p5Colors(51).n = "sea green"
p5Colors(51).c = _RGB32(46, 139, 87)
p5Colors(52).n = "medium aqua marine"
p5Colors(52).c = _RGB32(102, 205, 170)
p5Colors(53).n = "medium sea green"
p5Colors(53).c = _RGB32(60, 179, 113)
p5Colors(54).n = "light sea green"
p5Colors(54).c = _RGB32(60, 178, 170)
p5Colors(55).n = "dark slate grey"
p5Colors(55).c = _RGB32(47, 79, 79)
p5Colors(56).n = "dark cyan"
p5Colors(56).c = _RGB32(0, 139, 139)
p5Colors(57).n = "light cyan"
p5Colors(57).c = _RGB32(224, 255, 255)
p5Colors(58).n = "dark turquoise"
p5Colors(58).c = _RGB32(0, 206, 209)
p5Colors(59).n = "medium turquoise"
p5Colors(59).c = _RGB32(72, 209, 204)
p5Colors(60).n = "pale turquoise"
p5Colors(60).c = _RGB32(175, 238, 238)
p5Colors(61).n = "aqua marine"
p5Colors(61).c = _RGB32(127, 255, 212)
p5Colors(62).n = "powder blue"
p5Colors(62).c = _RGB32(176, 224, 230)
p5Colors(63).n = "cadet blue"
p5Colors(63).c = _RGB32(95, 158, 160)
p5Colors(64).n = "steel blue"
p5Colors(64).c = _RGB32(70, 130, 180)
p5Colors(65).n = "corn flower blue"
p5Colors(65).c = _RGB32(100, 149, 237)
p5Colors(66).n = "deep sky blue"
p5Colors(66).c = _RGB32(0, 191, 255)
p5Colors(67).n = "dodger blue"
p5Colors(67).c = _RGB32(30, 144, 255)
p5Colors(68).n = "light blue"
p5Colors(68).c = _RGB32(173, 216, 230)
p5Colors(69).n = "sky blue"
p5Colors(69).c = _RGB32(135, 206, 235)
p5Colors(70).n = "light sky blue"
p5Colors(70).c = _RGB32(135, 206, 250)
p5Colors(71).n = "midnight blue"
p5Colors(71).c = _RGB32(25, 25, 112)
p5Colors(72).n = "dark blue"
p5Colors(72).c = _RGB32(0, 0, 139)
p5Colors(73).n = "royal blue"
p5Colors(73).c = _RGB32(65, 105, 225)
p5Colors(74).n = "blue violet"
p5Colors(74).c = _RGB32(138, 43, 226)
p5Colors(75).n = "indigo"
p5Colors(75).c = _RGB32(75, 0, 130)
p5Colors(76).n = "dark slate blue"
p5Colors(76).c = _RGB32(72, 61, 139)
p5Colors(77).n = "slate blue"
p5Colors(77).c = _RGB32(106, 90, 205)
p5Colors(78).n = "medium slate blue"
p5Colors(78).c = _RGB32(123, 104, 238)
p5Colors(79).n = "medium purple"
p5Colors(79).c = _RGB32(147, 112, 219)
p5Colors(80).n = "dark magenta"
p5Colors(80).c = _RGB32(139, 0, 139)
p5Colors(81).n = "dark violet"
p5Colors(81).c = _RGB32(148, 0, 211)
p5Colors(82).n = "dark orchid"
p5Colors(82).c = _RGB32(153, 50, 204)
p5Colors(83).n = "medium orchid"
p5Colors(83).c = _RGB32(186, 85, 211)
p5Colors(84).n = "purple"
p5Colors(84).c = _RGB32(128, 0, 128)
p5Colors(85).n = "thistle"
p5Colors(85).c = _RGB32(216, 191, 216)
p5Colors(86).n = "plum"
p5Colors(86).c = _RGB32(221, 160, 221)
p5Colors(87).n = "violet"
p5Colors(87).c = _RGB32(238, 130, 238)
p5Colors(88).n = "orchid"
p5Colors(88).c = _RGB32(218, 112, 214)
p5Colors(89).n = "medium violet red"
p5Colors(89).c = _RGB32(199, 21, 133)
p5Colors(90).n = "pale violet red"
p5Colors(90).c = _RGB32(219, 112, 147)
p5Colors(91).n = "deep pink"
p5Colors(91).c = _RGB32(255, 20, 147)
p5Colors(92).n = "hot pink"
p5Colors(92).c = _RGB32(255, 105, 180)
p5Colors(93).n = "light pink"
p5Colors(93).c = _RGB32(255, 182, 193)
p5Colors(94).n = "pink"
p5Colors(94).c = _RGB32(255, 192, 203)
p5Colors(95).n = "atique white"
p5Colors(95).c = _RGB32(250, 235, 215)
p5Colors(96).n = "beige"
p5Colors(96).c = _RGB32(245, 245, 220)
p5Colors(97).n = "bisque"
p5Colors(97).c = _RGB32(225, 228, 196)
p5Colors(98).n = "blanched almond"
p5Colors(98).c = _RGB32(255, 235, 205)
p5Colors(99).n = "wheat"
p5Colors(99).c = _RGB32(245, 222, 179)
p5Colors(100).n = "corn silk"
p5Colors(100).c = _RGB32(255, 248, 220)
p5Colors(101).n = "lemon chiffon"
p5Colors(101).c = _RGB32(255, 250, 205)
p5Colors(102).n = "light golden rod yellow"
p5Colors(102).c = _RGB32(250, 250, 210)
p5Colors(103).n = "light yellow"
p5Colors(103).c = _RGB32(255, 255, 224)
p5Colors(104).n = "saddle brown"
p5Colors(104).c = _RGB32(139, 69, 19)
p5Colors(105).n = "sienna"
p5Colors(105).c = _RGB32(160, 82, 45)
p5Colors(106).n = "chocolate"
p5Colors(106).c = _RGB32(210, 105, 30)
p5Colors(107).n = "peru"
p5Colors(107).c = _RGB32(205, 133, 63)
p5Colors(108).n = "sandy brown"
p5Colors(108).c = _RGB32(244, 164, 96)
p5Colors(109).n = "burly wood"
p5Colors(109).c = _RGB32(222, 184, 135)
p5Colors(110).n = "tan"
p5Colors(110).c = _RGB32(210, 180, 140)
p5Colors(111).n = "rosy brown"
p5Colors(111).c = _RGB32(188, 143, 143)
p5Colors(112).n = "moccasin"
p5Colors(112).c = _RGB32(255, 228, 181)
p5Colors(113).n = "navajo white"
p5Colors(113).c = _RGB32(255, 222, 173)
p5Colors(114).n = "peach puff"
p5Colors(114).c = _RGB32(255, 218, 185)
p5Colors(115).n = "misty rose"
p5Colors(115).c = _RGB32(255, 228, 225)
p5Colors(116).n = "lavender blush"
p5Colors(116).c = _RGB32(255, 240, 245)
p5Colors(117).n = "linen"
p5Colors(117).c = _RGB32(250, 240, 230)
p5Colors(118).n = "old lace"
p5Colors(118).c = _RGB32(253, 245, 230)
p5Colors(119).n = "papaya whip"
p5Colors(119).c = _RGB32(255, 239, 213)
p5Colors(120).n = "sea sell"
p5Colors(120).c = _RGB32(255, 245, 238)
p5Colors(121).n = "mint cream"
p5Colors(121).c = _RGB32(245, 255, 250)
p5Colors(122).n = "slate gray"
p5Colors(122).c = _RGB32(112, 128, 144)
p5Colors(123).n = "light slate gray"
p5Colors(123).c = _RGB32(119, 136, 153)
p5Colors(124).n = "light steel blue"
p5Colors(124).c = _RGB32(176, 196, 222)
p5Colors(125).n = "lavender"
p5Colors(125).c = _RGB32(230, 230, 250)
p5Colors(126).n = "floral white"
p5Colors(126).c = _RGB32(255, 250, 240)
p5Colors(127).n = "alice blue"
p5Colors(127).c = _RGB32(240, 248, 255)
p5Colors(128).n = "ghost white"
p5Colors(128).c = _RGB32(248, 248, 255)
p5Colors(129).n = "honeydew"
p5Colors(129).c = _RGB32(240, 255, 240)
p5Colors(130).n = "ivory"
p5Colors(130).c = _RGB32(255, 255, 240)
p5Colors(131).n = "azure"
p5Colors(131).c = _RGB32(240, 255, 255)
p5Colors(132).n = "snow"
p5Colors(132).c = _RGB32(255, 250, 250)
p5Colors(133).n = "dim gray"
p5Colors(133).c = _RGB32(105, 105, 105)
p5Colors(134).n = "gainsboro"
p5Colors(134).c = _RGB32(220, 220, 220)
p5Colors(135).n = "white smoke"
p5Colors(135).c = _RGB32(245, 245, 245)

'frame rate
DIM SHARED frameRate AS SINGLE

'canvas settings related variables
DIM SHARED p5Canvas AS new_p5Canvas, pushState AS LONG
REDIM SHARED p5CanvasBackup(10) AS new_p5Canvas

'begin shape related variables
DIM SHARED FirstVertex AS vector, PreviousVertex AS vector, shapeStrokeBackup AS _UNSIGNED LONG
DIM SHARED shapeAllow AS _BYTE, shapeType AS LONG, shapeInit AS _BYTE, shapeTempFill AS _UNSIGNED LONG
DIM SHARED tempShapeImage AS LONG, p5previousDest AS LONG

'loops and NoLoops
DIM SHARED p5Loop AS _BYTE, p5frameCount AS _UNSIGNED LONG
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

'text-related variables
DIM SHARED loadedFontFile$, currentFontSize AS INTEGER
DIM SHARED p5LastRenderedCharCount AS LONG, p5LastRenderedLineWidth AS LONG
REDIM SHARED p5ThisLineChars(0) AS LONG

'sound system
REDIM SHARED loadedSounds(0) AS new_SoundHandle
DIM SHARED totalLoadedSounds AS LONG

'timer used to gather input from user
DIM SHARED p5InputTimer AS INTEGER
p5InputTimer = _FREETIMER
ON TIMER(p5InputTimer, .008) gatherInput
TIMER(p5InputTimer) ON

'default settings
createCanvas 640, 400
_TITLE "p5js.bas - Untitled sketch"
_ICON
stroke 0, 0, 0
fill 255, 255, 255 'white
strokeWeight 1
backgroundB 240
textAlign LEFT
textSize 16 'default builtin font
rectMode CORNER
frameRate = 30
colorMode p5RGB
angleMode RADIANS
doLoop

_DISPLAY

DIM a AS _BYTE 'dummy variable used to call functions that may not be there
a = p5setup
_DISPLAY

DO
    IF frameRate THEN _LIMIT frameRate
    IF p5Loop THEN callDrawLoop
    _DISPLAY
LOOP

'######################################################################################################
'###################### 2D Rendering related methods & functions ######################################
'######################################################################################################
SUB image (img&, __x AS INTEGER, __y AS INTEGER)
    x = __x + p5Canvas.xOffset
    y = __y + p5Canvas.yOffset

    _PUTIMAGE (x, y), img&, 0
END SUB

SUB imageB (img&, x AS INTEGER, y AS INTEGER, w AS INTEGER, h AS INTEGER, sx AS INTEGER, sy AS INTEGER, sw AS INTEGER, sh AS INTEGER)
    _PUTIMAGE (x, y)-STEP(w, h), img&, 0, (sx, sy)-STEP(sw, sh)
END SUB


SUB internalp5makeTempImage
    p5previousDest = _DEST
    IF p5previousDest = p5Canvas.imgHandle THEN
        _DEST tempShapeImage
        CLS , 0 'clear it and make it transparent
    END IF
END SUB

SUB internalp5displayTempImage
    IF p5previousDest = p5Canvas.imgHandle THEN
        _DEST p5previousDest
        _PUTIMAGE (0, 0), tempShapeImage
    END IF
END SUB

SUB beginShape (kind AS LONG)
    internalp5makeTempImage
    IF p5Canvas.doFill THEN CLS , p5Canvas.fill
    shapeAllow = true
    shapeType = kind
    shapeStrokeBackup = p5Canvas.strokeA
    shapeTempFill = _RGB32((_RED32(p5Canvas.strokeA) + _RED32(p5Canvas.fillA)) / 2, (_GREEN32(p5Canvas.strokeA) + _GREEN32(p5Canvas.fillA)) / 2, (_BLUE32(p5Canvas.strokeA) + _BLUE32(p5Canvas.fillA)) / 2)
END SUB

SUB vertex (__x AS SINGLE, __y AS SINGLE)

    DIM x AS SINGLE, y AS SINGLE

    x = __x + p5Canvas.xOffset
    y = __y + p5Canvas.yOffset

    IF shapeInit THEN
        IF shapeType = p5POINTS THEN
            IF p5Canvas.doStroke THEN CircleFill x, y, p5Canvas.strokeWeight / 2, p5Canvas.strokeA ELSE CircleFill x, y, p5Canvas.strokeWeight / 2, shapeTempFill
            'p5point x, y
        ELSEIF shapeType = p5LINES THEN
            IF NOT p5Canvas.doStroke THEN
                LINE (PreviousVertex.x, PreviousVertex.y)-(x, y), p5Canvas.strokeA
            ELSE
                dx = PreviousVertex.x - x
                dy = PreviousVertex.y - y
                d = SQR(dx * dx + dy * dy)
                FOR i = 0 TO d
                    CircleFill dxx + x, dyy + y, p5Canvas.strokeWeight / 2, p5Canvas.strokeA
                    dxx = dxx + dx / d
                    dyy = dyy + dy / d
                NEXT
            END IF
        END IF
    END IF
    IF shapeAllow AND NOT shapeInit THEN
        FirstVertex.x = x
        FirstVertex.y = y
        shapeInit = true
        IF shapeType = p5POINTS THEN
            IF p5Canvas.doStroke THEN CircleFill x, y, p5Canvas.strokeWeight / 2, p5Canvas.strokeA ELSE CircleFill x, y, p5Canvas.strokeWeight / 2, shapeTempFill
        END IF
        FirstVertex.x = x
        FirstVertex.y = y
    END IF
    PreviousVertex.x = x
    PreviousVertex.y = y
END SUB

SUB vertexB (v AS vector)
    vertex v.x, v.y
END SUB

SUB endShape (closed)
    'do we have to close it?
    IF closed = p5CLOSE AND shapeType = p5LINES THEN
        IF NOT p5Canvas.doStroke THEN LINE (PreviousVertex.x, PreviousVertex.y)-(FirstVertex.x, FirstVertex.y), p5Canvas.stroke ELSE p5line PreviousVertex.x, PreviousVertex.y, FirstVertex.x, FirstVertex.y
    END IF

    'fill with color
    IF p5Canvas.doFill AND shapeType = p5LINES AND closed = p5CLOSE THEN
        _SETALPHA p5Canvas.fillAlpha, p5Canvas.fill
        _SETALPHA p5Canvas.strokeAlpha, p5Canvas.stroke
        PAINT (0, 0), shapeTempFill, p5Canvas.strokeA
        PAINT (_WIDTH - 1, 0), shapeTempFill, p5Canvas.strokeA
        PAINT (0, _HEIGHT - 1), shapeTempFill, p5Canvas.strokeA
        PAINT (_WIDTH - 1, _HEIGHT - 1), shapeTempFill, p5Canvas.strokeA
        _CLEARCOLOR shapeTempFill
        IF NOT p5Canvas.doStroke THEN _CLEARCOLOR p5Canvas.strokeA
    END IF
    p5Canvas.strokeA = shapeStrokeBackup
    'it's time to reset all varibles!!
    shapeAllow = false
    shapeType = 0
    shapeInit = 0
    FirstVertex.x = 0
    FirstVertex.y = 0
    PreviousVertex.x = 0
    PreviousVertex.y = 0
    shapeTempFill = 0
    'place shape onto main canvas
    internalp5displayTempImage
END SUB

SUB translate (xoff AS SINGLE, yoff AS SINGLE)
    p5Canvas.xOffset = p5Canvas.xOffset + xoff
    p5Canvas.yOffset = p5Canvas.yOffset + yoff
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

SUB RoundRectFill (x AS SINGLE, y AS SINGLE, x1 AS SINGLE, y1 AS SINGLE, r AS SINGLE, c AS _UNSIGNED LONG)
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

SUB p5line (__x1 AS SINGLE, __y1 AS SINGLE, __x2 AS SINGLE, __y2 AS SINGLE)
    DIM x1 AS SINGLE, y1 AS SINGLE, x2 AS SINGLE, y2 AS SINGLE
    DIM dx AS SINGLE, dy AS SINGLE, d AS SINGLE
    DIM dxx AS SINGLE, dyy AS SINGLE
    DIM i AS SINGLE

    IF NOT p5Canvas.doStroke THEN EXIT SUB

    x1 = __x1 + p5Canvas.xOffset
    y1 = __y1 + p5Canvas.yOffset
    x2 = __x2 + p5Canvas.xOffset
    y2 = __y2 + p5Canvas.xOffset

    dx = x2 - x1
    dy = y2 - y1
    d = SQR(dx * dx + dy * dy)
    FOR i = 0 TO d
        CircleFill dxx + x1, dyy + y1, p5Canvas.strokeWeight / 2, p5Canvas.strokeA
        dxx = dxx + dx / d
        dyy = dyy + dy / d
    NEXT
END SUB

SUB p5point (x AS SINGLE, y AS SINGLE)
    IF NOT p5Canvas.doStroke THEN EXIT SUB

    CircleFill x + p5Canvas.xOffset, y + p5Canvas.yOffset, p5Canvas.strokeWeight / 2, p5Canvas.strokeA
END SUB

SUB p5ellipse (__x AS SINGLE, __y AS SINGLE, xr AS SINGLE, yr AS SINGLE)
    DIM i AS SINGLE
    DIM x AS SINGLE, y AS SINGLE
    DIM xx AS SINGLE, yy AS SINGLE

    IF NOT p5Canvas.doFill AND NOT p5Canvas.doStroke THEN EXIT SUB

    x = __x + p5Canvas.xOffset
    y = __y + p5Canvas.yOffset

    internalp5makeTempImage

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
        IF _RED32(p5Canvas.stroke) > 0 THEN tempColor~& = _RGB32(_RED32(p5Canvas.stroke) - 1, _GREEN32(p5Canvas.stroke), _BLUE32(p5Canvas.stroke)) ELSE tempColor~& = _RGB32(_RED32(p5Canvas.stroke) + 1, _GREEN32(p5Canvas.stroke), _BLUE32(p5Canvas.stroke))
        IF xr <> yr THEN
            CIRCLE (x, y), xr - p5Canvas.strokeWeight / 2, tempColor~&, , , xr / yr
            PAINT (x, y), tempColor~&, tempColor~&
        ELSE
            CircleFill x, y, xr - p5Canvas.strokeWeight / 2, tempColor~&
        END IF
        _CLEARCOLOR tempColor~&
    END IF

    internalp5displayTempImage

END SUB

'draw a triangle by joining 3 differents location
SUB p5triangle (__x1!, __y1!, __x2!, __y2!, __x3!, __y3!)
    DIM x1!, y1!, x2!, y2!, x3!, y3!
    IF NOT p5Canvas.doFill AND NOT p5Canvas.doStroke THEN EXIT SUB

    DIM bc AS _UNSIGNED LONG

    x1! = __x1! + p5Canvas.xOffset
    y1! = __y1! + p5Canvas.yOffset
    x2! = __x2! + p5Canvas.xOffset
    y2! = __y2! + p5Canvas.yOffset
    x3! = __x3! + p5Canvas.xOffset
    y3! = __y3! + p5Canvas.yOffset

    internalp5makeTempImage

    IF p5Canvas.doStroke THEN
        p5line __x1!, __y1!, __x2!, __y2!
        p5line __x2!, __y2!, __x3!, __y3!
        p5line __x3!, __y3!, __x1!, __y1!
    ELSE
        p5Canvas.strokeA = p5Canvas.fill
        p5Canvas.doStroke = true
        p5line __x1!, __y1!, __x2!, __y2!
        p5line __x2!, __y2!, __x3!, __y3!
        p5line __x3!, __y3!, __x1!, __y1!
        noStroke
    END IF

    IF p5Canvas.doFill THEN
        avgX! = (x1! + x2! + x3!) / 3
        IF avgX! > _WIDTH - 1 THEN avgX! = _WIDTH - 1
        IF avgX! < 0 THEN avgX! = 0

        avgY! = (y1! + y2! + y3!) / 3
        IF avgY! > _HEIGHT - 1 THEN avgY! = _HEIGHT - 1
        IF avgY! < 0 THEN avgY! = 0

        IF p5Canvas.doStroke THEN
            PAINT (avgX!, avgY!), p5Canvas.fill, p5Canvas.stroke
        ELSE
            PAINT (avgX!, avgY!), p5Canvas.fill, p5Canvas.fill
        END IF
        _SETALPHA p5Canvas.fillAlpha, p5Canvas.fill
    END IF

    internalp5displayTempImage

END SUB

SUB p5triangleB (v1 AS vector, v2 AS vector, v3 AS vector)
    p5triangle v1.x, v1.y, v2.x, v2.y, v3.x, v3.y
END SUB

'draw a triangle by joining 3 different angles from the center point with
'a given size
SUB p5triangleC (__centerX!, __centerY!, __ang1!, __ang2!, __ang3!, size!)
    DIM x1!, y1!, x2!, y2!, x3!, y3!
    DIM ang1!, ang2!, ang3!
    DIM centerX!, centerY!

    centerX! = __centerX! + p5Canvas.xOffset
    centerY! = __centerY! + p5Canvas.yOffset

    IF p5Canvas.angleMode = RADIANS THEN
        ang1! = __ang1!
        ang2! = __ang2!
        ang3! = __ang3!
    ELSE
        ang1! = _D2R(__ang1!)
        ang2! = _D2R(__ang2!)
        ang3! = _D2R(__ang3!)
    END IF

    IF ang1! < TWO_PI THEN
        x1! = centerX! - size! * COS(ang1!)
        y1! = centerY! + size! * SIN(ang1!)
    END IF

    IF ang2! < TWO_PI THEN
        x2! = centerX! - size! * COS(ang2!)
        y2! = centerY! - size! * SIN(ang2!)
    END IF

    IF ang3! < TWO_PI THEN
        x3! = centerX! + size! * COS(ang3!)
        y3! = centerY! - size! * SIN(ang3!)
    END IF

    p5triangle x1!, y1!, x2!, y2!, x3!, y3!
END SUB

'draws a rectangle
SUB p5rect (x!, y!, __wi!, __he!)
    DIM wi!, he!

    IF NOT p5Canvas.doFill AND NOT p5Canvas.doStroke THEN EXIT SUB

    wi! = __wi!
    he! = __he!

    internalp5makeTempImage

    IF p5Canvas.rectMode = CORNER OR p5Canvas.rectMode = CORNERS THEN
        'default mode
        x1! = x! + p5Canvas.xOffset
        y1! = y! + p5Canvas.yOffset

        IF p5Canvas.rectMode = CORNERS THEN
            wi! = wi! + p5Canvas.xOffset
            he! = he! + p5Canvas.yOffset
        END IF
    ELSEIF p5Canvas.rectMode = CENTER THEN
        x1! = x! - wi! / 2 + p5Canvas.xOffset
        y1! = y! - he! / 2 + p5Canvas.yOffset
    END IF

    DIM tempColor~&
    IF _RED32(p5Canvas.stroke) > 0 THEN tempColor~& = _RGB32(_RED32(p5Canvas.stroke) - 1, _GREEN32(p5Canvas.stroke), _BLUE32(p5Canvas.stroke)) ELSE tempColor~& = _RGB32(_RED32(p5Canvas.stroke) + 1, _GREEN32(p5Canvas.stroke), _BLUE32(p5Canvas.stroke))

    IF p5Canvas.rectMode = CORNER OR p5Canvas.rectMode = CENTER THEN
        IF p5Canvas.doStroke THEN
            LINE (x1! - _CEIL(p5Canvas.strokeWeight / 2), y1! - _CEIL(p5Canvas.strokeWeight / 2))-(x1! + wi! + _CEIL(p5Canvas.strokeWeight / 2) - 1, y1! + he! + _CEIL(p5Canvas.strokeWeight / 2) - 1), p5Canvas.strokeA, BF
            LINE (x1! + _CEIL(p5Canvas.strokeWeight / 2), y1! + _CEIL(p5Canvas.strokeWeight / 2))-(x1! + wi! - _CEIL(p5Canvas.strokeWeight / 2) - 1, y1! + he! - _CEIL(p5Canvas.strokeWeight / 2) - 1), tempColor~&, BF
            _CLEARCOLOR tempColor~&
        END IF

        IF p5Canvas.doFill THEN
            IF p5Canvas.doStroke AND p5Canvas.fillAlpha < 255 THEN
                LINE (x1!, y1!)-STEP(wi! - 1, he! - 1), tempColor~&, BF
                _CLEARCOLOR tempColor~&
            END IF

            LINE (x1!, y1!)-STEP(wi! - 1, he! - 1), p5Canvas.fillA, BF
        END IF
    ELSE
        'CORNERS - consider width and height values as coordinates instead
        IF p5Canvas.doStroke THEN
            LINE (x1! - _CEIL(p5Canvas.strokeWeight / 2), y1! - _CEIL(p5Canvas.strokeWeight / 2))-(wi! + _CEIL(p5Canvas.strokeWeight / 2) - 1, he! + _CEIL(p5Canvas.strokeWeight / 2) - 1), p5Canvas.strokeA, BF
            LINE (x1! + _CEIL(p5Canvas.strokeWeight / 2), y1! + _CEIL(p5Canvas.strokeWeight / 2))-(wi! - _CEIL(p5Canvas.strokeWeight / 2) - 1, he! - _CEIL(p5Canvas.strokeWeight / 2) - 1), tempColor~&, BF
            _CLEARCOLOR tempColor~&
        END IF

        IF p5Canvas.doFill THEN
            IF p5Canvas.doStroke AND p5Canvas.fillAlpha < 255 THEN
                LINE (x1!, y1!)-(wi!, he!), tempColor~&, BF
                _CLEARCOLOR tempColor~&
            END IF

            LINE (x1!, y1!)-(wi!, he!), p5Canvas.fillA, BF
        END IF
    END IF

    internalp5displayTempImage
END SUB

'draws a rectangle with rounded corners (r! is the amount)
SUB p5rectB (x!, y!, __wi!, __he!, r!)
    DIM wi!, he!

    IF NOT p5Canvas.doFill AND NOT p5Canvas.doStroke THEN EXIT SUB

    wi! = __wi!
    he! = __he!

    internalp5makeTempImage

    IF p5Canvas.rectMode = CORNER OR p5Canvas.rectMode = CORNERS THEN
        'default mode
        x1! = x! + p5Canvas.xOffset
        y1! = y! + p5Canvas.yOffset

        IF p5Canvas.rectMode = CORNERS THEN
            wi! = wi! + p5Canvas.xOffset
            he! = he! + p5Canvas.yOffset
        END IF
    ELSEIF p5Canvas.rectMode = CENTER THEN
        x1! = x! - wi! / 2 + p5Canvas.xOffset
        y1! = y! - he! / 2 + p5Canvas.yOffset
    END IF

    DIM tempColor~&
    IF _RED32(p5Canvas.stroke) > 0 THEN tempColor~& = _RGB32(_RED32(p5Canvas.stroke) - 1, _GREEN32(p5Canvas.stroke), _BLUE32(p5Canvas.stroke)) ELSE tempColor~& = _RGB32(_RED32(p5Canvas.stroke) + 1, _GREEN32(p5Canvas.stroke), _BLUE32(p5Canvas.stroke))

    IF p5Canvas.rectMode = CORNER OR p5Canvas.rectMode = CENTER THEN
        IF p5Canvas.doStroke THEN
            RoundRectFill x1! - _CEIL(p5Canvas.strokeWeight / 2), y1! - _CEIL(p5Canvas.strokeWeight / 2), x1! + wi! + _CEIL(p5Canvas.strokeWeight / 2), y1! + he! + _CEIL(p5Canvas.strokeWeight / 2), r!, p5Canvas.stroke
            _SETALPHA p5Canvas.strokeAlpha, p5Canvas.stroke

            RoundRectFill x1! + _CEIL(p5Canvas.strokeWeight / 2), y1! + _CEIL(p5Canvas.strokeWeight / 2), x1! + wi! - _CEIL(p5Canvas.strokeWeight / 2), y1! + he! - _CEIL(p5Canvas.strokeWeight / 2), r!, tempColor~&
            _CLEARCOLOR tempColor~&
        END IF

        IF p5Canvas.doFill THEN
            IF p5Canvas.doStroke AND p5Canvas.fillAlpha < 255 THEN
                RoundRectFill x1!, y1!, x1! + wi! - 1, he!, r!, tempColor~&
                _CLEARCOLOR tempColor~&
            END IF

            RoundRectFill x1!, y1!, x1! + wi! - 1, y1! + he! - 1, r!, p5Canvas.fill
            _SETALPHA p5Canvas.fillAlpha, p5Canvas.fill
        END IF
    ELSE
        'CORNERS - consider width and height values as coordinates instead
        IF p5Canvas.doStroke THEN
            RoundRectFill x1! - _CEIL(p5Canvas.strokeWeight / 2), y1! - _CEIL(p5Canvas.strokeWeight / 2), wi! + _CEIL(p5Canvas.strokeWeight / 2), he! + _CEIL(p5Canvas.strokeWeight / 2), r!, p5Canvas.stroke
            _SETALPHA p5Canvas.strokeAlpha, p5Canvas.stroke

            RoundRectFill x1! + _CEIL(p5Canvas.strokeWeight / 2), y1! + _CEIL(p5Canvas.strokeWeight / 2), wi! - _CEIL(p5Canvas.strokeWeight / 2), he! - _CEIL(p5Canvas.strokeWeight / 2), r!, tempColor~&
            _CLEARCOLOR tempColor~&
        END IF

        IF p5Canvas.doFill THEN
            IF p5Canvas.doStroke AND p5Canvas.fillAlpha < 255 THEN
                RoundRectFill x1!, y1!, wi!, he!, r!, tempColor~&
                _CLEARCOLOR tempColor~&
            END IF

            RoundRectFill x1!, y1!, wi!, he!, r!, p5Canvas.fill
            _SETALPHA p5Canvas.fillAlpha, p5Canvas.fill
        END IF
    END IF

    internalp5displayTempImage
END SUB

SUB rectMode (mode AS _BYTE)
    p5Canvas.rectMode = mode
END SUB

'draws a quadrilateral
SUB p5quad (__x1!, __y1!, __x2!, __y2!, __x3!, __y3!, __x4!, __y4!)
    IF NOT p5Canvas.doStroke AND NOT p5Canvas.doFill THEN EXIT SUB
    
    DIM x1!, y1!, x2!, y2!, x3!, y3!, x4!, y4!

    x1! = __x1! + p5Canvas.xOffset
    y1! = __y1! + p5Canvas.yOffset
    x2! = __x2! + p5Canvas.xOffset
    y2! = __y2! + p5Canvas.yOffset
    x3! = __x3! + p5Canvas.xOffset
    y3! = __y3! + p5Canvas.yOffset
    x4! = __x4! + p5Canvas.xOffset
    y4! = __y4! + p5Canvas.yOffset
    
    IF _RED32(p5Canvas.stroke) > 0 THEN tempColor~& = _RGB32(_RED32(p5Canvas.stroke) - 1, _GREEN32(p5Canvas.stroke), _BLUE32(p5Canvas.stroke)) ELSE tempColor~& = _RGB32(_RED32(p5Canvas.stroke) + 1, _GREEN32(p5Canvas.stroke), _BLUE32(p5Canvas.stroke))
    IF _RED32(p5Canvas.fill) > 0 THEN tempFill~& = _RGB32(_RED32(p5Canvas.fill) - 1, _GREEN32(p5Canvas.fill), _BLUE32(p5Canvas.fill)) ELSE tempFill~& = _RGB32(_RED32(p5Canvas.fill) + 1, _GREEN32(p5Canvas.fill), _BLUE32(p5Canvas.fill))

    internalp5makeTempImage
    IF p5Canvas.doFill THEN
        CLS , p5Canvas.fill
    END IF
    IF p5Canvas.doStroke THEN
        internalp5line x1!, y1!, x2!, y2!, p5Canvas.strokeWeight / 2, p5Canvas.stroke
        internalp5line x2!, y2!, x3!, y3!, p5Canvas.strokeWeight / 2, p5Canvas.stroke
        internalp5line x3!, y3!, x4!, y4!, p5Canvas.strokeWeight / 2, p5Canvas.stroke
        internalp5line x4!, y4!, x1!, y1!, p5Canvas.strokeWeight / 2, p5Canvas.stroke
    ELSE
        internalp5line x1!, y1!, x2!, y2!, p5Canvas.strokeWeight / 2, tempColor~&
        internalp5line x2!, y2!, x3!, y3!, p5Canvas.strokeWeight / 2, tempColor~&
        internalp5line x3!, y3!, x4!, y4!, p5Canvas.strokeWeight / 2, tempColor~&
        internalp5line x4!, y4!, x1!, y1!, p5Canvas.strokeWeight / 2, tempColor~&
    END IF
    
    IF p5Canvas.doFill THEN
        IF p5Canvas.doStroke THEN
            PAINT (0, 0), tempFill~&, p5Canvas.stroke
            PAINT (_WIDTH, 0), tempFill~&, p5Canvas.stroke
            PAINT (0, _HEIGHT), tempFill~&, p5Canvas.stroke
            PAINT (_WIDTH, _HEIGHT), tempFill~&, p5Canvas.stroke
        ELSE
            PAINT (0, 0), tempFill~&, tempColor~&
            PAINT (_WIDTH, 0), tempFill~&, tempColor~&
            PAINT (0, _HEIGHT), tempFill~&, tempColor~&
            PAINT (_WIDTH, _HEIGHT), tempFill~&, tempColor~&
        END IF
    END IF
    
    _CLEARCOLOR tempFill~&
    _CLEARCOLOR tempColor~&
    
    _SETALPHA p5Canvas.strokeAlpha, p5Canvas.stroke
    _SETALPHA p5Canvas.fillAlpha, p5Canvas.fill
    
    internalp5displayTempImage
END SUB

'draws a bezier curve
'method by Ashish
SUB p5bezier (__x0!, __y0!, __x1!, __y1!, __x2!, __y2!, __x3!, __y3!)
    IF NOT p5Canvas.doStroke AND NOT p5Canvas.doFill THEN EXIT SUB
    
    x0! = __x0! + p5Canvas.xOffset
    x1! = __x1! + p5Canvas.xOffset
    x2! = __x2! + p5Canvas.xOffset
    x3! = __x3! + p5Canvas.xOffset
    
    y0! = __y0! + p5Canvas.yOffset
    y1! = __y1! + p5Canvas.yOffset
    y2! = __y2! + p5Canvas.yOffset
    y3! = __y3! + p5Canvas.yOffset
    
    cx! = 3 * (x1! - x0!)
    bx! = 3 * (x2! - x1!) - cx!
    ax! = x3! - x0! - cx! - bx!
    
    cy! = 3 * (y1! - y0!)
    by! = 3 * (y2! - y1!) - cy!
    ay! = y3! - y0! - cy! - by!
    
    DIM s AS DOUBLE
    s = .001
    
    internalp5makeTempImage
    
    IF _RED32(p5Canvas.stroke) > 0 THEN tempColor~& = _RGB32(_RED32(p5Canvas.stroke) - 1, _GREEN32(p5Canvas.stroke), _BLUE32(p5Canvas.stroke)) ELSE tempColor~& = _RGB32(_RED32(p5Canvas.stroke) + 1, _GREEN32(p5Canvas.stroke), _BLUE32(p5Canvas.stroke))
    IF _RED32(p5Canvas.fill) > 0 THEN tempFill~& = _RGB32(_RED32(p5Canvas.fill) - 1, _GREEN32(p5Canvas.fill), _BLUE32(p5Canvas.fill)) ELSE tempFill~& = _RGB32(_RED32(p5Canvas.fill) + 1, _GREEN32(p5Canvas.fill), _BLUE32(p5Canvas.fill))
    
    IF p5Canvas.doFill THEN
        CLS , p5Canvas.fill
        IF p5Canvas.doStroke THEN LINE (x0!, y0!)-(x3!, y3!), p5Canvas.stroke ELSE LINE (x0!, y0!)-(x3!, y3!), tempColor~&
    END IF

    FOR t# = 0 TO 1 - s STEP s
        xt! = ax! * (t# * t# * t#) + bx! * (t# * t#) + cx! * t# + x0!
        yt! = ay! * (t# * t# * t#) + by! * (t# * t#) + cy! * t# + y0!
        IF p5Canvas.doStroke THEN CircleFill xt!, yt!, p5Canvas.strokeWeight / 2, p5Canvas.stroke ELSE CircleFill xt!, yt!, p5Canvas.strokeWeight / 2, tempColor~&
    NEXT

    IF p5Canvas.doFill THEN
        IF p5Canvas.doStroke THEN
            PAINT (0, 0), tempFill~&, p5Canvas.stroke
            PAINT (_WIDTH, 0), tempFill~&, p5Canvas.stroke
            PAINT (0, _HEIGHT), tempFill~&, p5Canvas.stroke
            PAINT (_WIDTH, _HEIGHT), tempFill~&, p5Canvas.stroke
        ELSE
            PAINT (0, 0), tempFill~&, tempColor~&
            PAINT (_WIDTH, 0), tempFill~&, tempColor~&
            PAINT (0, _HEIGHT), tempFill~&, tempColor~&
            PAINT (_WIDTH, _HEIGHT), tempFill~&, tempColor~&
        END IF
    END IF

    _CLEARCOLOR tempFill~&

    IF NOT p5Canvas.doStroke THEN _CLEARCOLOR tempColor~&: GOTO internal_p5_bezier_display

    IF p5Canvas.doFill THEN
        IF p5Canvas.doStroke THEN _CLEARCOLOR p5Canvas.stroke ELSE _CLEARCOLOR tempColor~&
        FOR t# = 0 TO 1 - s STEP s
            xt! = ax! * (t# * t# * t#) + bx! * (t# * t#) + cx! * t# + x0!
            yt! = ay! * (t# * t# * t#) + by! * (t# * t#) + cy! * t# + y0!
            IF p5Canvas.doStroke THEN CircleFill xt!, yt!, p5Canvas.strokeWeight / 2, p5Canvas.stroke ELSE CircleFill xt!, yt!, p5Canvas.strokeWeight / 2, tempColor~&
        NEXT
    END IF

    internal_p5_bezier_display:::

    _SETALPHA p5Canvas.fillAlpha, p5Canvas.fill
    _SETALPHA p5Canvas.strokeAlpha, p5Canvas.stroke

    internalp5displayTempImage

END SUB

SUB p5curve (__x0!, __y0!, __x1!, __y1!, __x2!, __y2!, __x3!, __y3!)
    
    IF NOT p5Canvas.doStroke OR NOT p5Canvas.doFill AND NOT p5Canvas.doStroke THEN EXIT SUB
    
    x0! = __x0! + p5Canvas.xOffset
    x1! = __x1! + p5Canvas.xOffset
    x2! = __x2! + p5Canvas.xOffset
    x3! = __x3! + p5Canvas.xOffset
    
    y0! = __y0! + p5Canvas.yOffset
    y1! = __y1! + p5Canvas.yOffset
    y2! = __y2! + p5Canvas.yOffset
    y3! = __y3! + p5Canvas.yOffset
    
    internalp5makeTempImage
    
    IF _RED32(p5Canvas.fill) > 0 THEN tempFill~& = _RGB32(_RED32(p5Canvas.fill) - 1, _GREEN32(p5Canvas.fill), _BLUE32(p5Canvas.fill)) ELSE tempFill~& = _RGB32(_RED32(p5Canvas.fill) + 1, _GREEN32(p5Canvas.fill), _BLUE32(p5Canvas.fill))
    
    IF p5Canvas.doFill THEN CLS , p5Canvas.fill: LINE (x1!, y1!)-(x2!, y2!), p5Canvas.stroke
    DIM s AS DOUBLE
    s = .001
    FOR t# = 0 TO 1 - s STEP s
        xt! = 0.5 * ((2 * x1!) + (-x0! + x2!) * t# + (2 * x0! - 5 * x1! + 4 * x2! - x3!) * (t# * t#) + (-x0! + 3 * x1! - 3 * x2! + x3!) * (t# * t# * t#))
        yt! = 0.5 * ((2 * y1!) + (-y0! + y2!) * t# + (2 * y0! - 5 * y1! + 4 * y2! - y3!) * (t# * t#) + (-y0! + 3 * y1! - 3 * y2! + y3!) * (t# * t# * t#))
        CircleFill xt!, yt!, p5Canvas.strokeWeight / 2, p5Canvas.stroke
    NEXT

    IF NOT p5Canvas.doFill THEN GOTO internal_p5_curve_display
    
    IF p5Canvas.doFill THEN
        PAINT (0, 0), tempFill~&, p5Canvas.stroke
        PAINT (_WIDTH, 0), tempFill~&, p5Canvas.stroke
        PAINT (0, _HEIGHT), tempFill~&, p5Canvas.stroke
        PAINT (_WIDTH, _HEIGHT), tempFill~&, p5Canvas.stroke
    END IF
    
    _CLEARCOLOR tempFill~&
    IF p5Canvas.doFill THEN
        _CLEARCOLOR p5Canvas.stroke
        FOR t# = 0 TO 1 STEP .01
            xt! = 0.5 * ((2 * x1!) + (-x0! + x2!) * t# + (2 * x0! - 5 * x1! + 4 * x2! - x3!) * (t# * t#) + (-x0! + 3 * x1! - 3 * x2! + x3!) * (t# * t# * t#))
            yt! = 0.5 * ((2 * y1!) + (-y0! + y2!) * t# + (2 * y0! - 5 * y1! + 4 * y2! - y3!) * (t# * t#) + (-y0! + 3 * y1! - 3 * y2! + y3!) * (t# * t# * t#))
            CircleFill xt!, yt!, p5Canvas.strokeWeight / 2, p5Canvas.stroke
        NEXT
    END IF
    
    internal_p5_curve_display:::
    
    _SETALPHA p5Canvas.strokeAlpha, p5Canvas.stroke
    _SETALPHA p5Canvas.fillAlpha, p5Canvas.fill
    
    internalp5displayTempImage
END SUB

SUB p5arc (__x!, __y!, w!, h!, start##, stp##, mode)
    IF NOT p5Canvas.doFill AND NOT p5Canvas.doStroke THEN EXIT SUB
    
    x! = __x! + p5Canvas.xOffset
    y! = __y! + p5Canvas.yOffset
    
    IF p5Canvas.angleMode = DEGREES THEN start## = p5degrees(start##): spt## = p5degrees(spt##)
    
    IF _RED32(p5Canvas.stroke) > 0 THEN tempColor~& = _RGB32(_RED32(p5Canvas.stroke) - 1, _GREEN32(p5Canvas.stroke), _BLUE32(p5Canvas.stroke)) ELSE tempColor~& = _RGB32(_RED32(p5Canvas.stroke) + 1, _GREEN32(p5Canvas.stroke), _BLUE32(p5Canvas.stroke))
    IF _RED32(p5Canvas.fill) > 0 THEN tempFill~& = _RGB32(_RED32(p5Canvas.fill) - 1, _GREEN32(p5Canvas.fill), _BLUE32(p5Canvas.fill)) ELSE tempFill~& = _RGB32(_RED32(p5Canvas.fill) + 1, _GREEN32(p5Canvas.fill), _BLUE32(p5Canvas.fill))
    
    x0! = x! + w! * p5cos(start##)
    y0! = y! + h! * p5sin(start##)
    x1! = x! + w! * p5cos(stp##)
    y1! = y! + h! * p5sin(stp##)
    
    internalp5makeTempImage
    
    IF p5Canvas.doFill THEN
        CLS , p5Canvas.fill
        IF p5Canvas.doStroke THEN
            IF mode = ARC_DEFAULT OR mode = ARC_PIE THEN
                LINE (x!, y!)-(x0!, y0!), p5Canvas.stroke
                LINE (x!, y!)-(x1!, y1!), p5Canvas.stroke
            ELSEIF mode = ARC_OPEN OR mode = ARC_CHORD THEN
                LINE (x0!, y0!)-(x1!, y1!), p5Canvas.stroke
            END IF
        ELSE
            IF mode = ARC_DEFAULT OR mode = ARC_PIE THEN
                LINE (x!, y!)-(x0!, y0!), tempColor~&
                LINE (x!, y!)-(x1!, y1!), tempColor~&
            ELSEIF mode = ARC_OPEN OR mode = ARC_CHORD THEN
                LINE (x0!, y0!)-(x1!, y1!), tempColor~&
            END IF
        END IF
    END IF

    FOR i## = start## TO stp## STEP .001
        xx! = x! + w! * p5cos(i##)
        yy! = y! + h! * p5sin(i##)
        IF p5Canvas.doStroke THEN CircleFill xx!, yy!, p5Canvas.strokeWeight / 2, p5Canvas.stroke ELSE CircleFill xx!, yy!, p5Canvas.strokeWeight / 2, tempColor~&
    NEXT

    IF p5Canvas.doFill THEN
        IF p5Canvas.doStroke THEN
            PAINT (0, 0), tempFill~&, p5Canvas.stroke
            PAINT (_WIDTH, 0), tempFill~&, p5Canvas.stroke
            PAINT (0, _HEIGHT), tempFill~&, p5Canvas.stroke
            PAINT (_WIDTH, _HEIGHT), tempFill~&, p5Canvas.stroke
        ELSE
            PAINT (0, 0), tempFill~&, tempColor~&
            PAINT (_WIDTH, 0), tempFill~&, tempColor~&
            PAINT (0, _HEIGHT), tempFill~&, tempColor~&
            PAINT (_WIDTH, _HEIGHT), tempFill~&, tempColor~&
        END IF
    END IF
    _CLEARCOLOR tempFill~&

    IF p5Canvas.doStroke THEN
        IF mode = ARC_CHORD THEN internalp5line x0!, y0!, x1!, y1!, p5Canvas.strokeWeight / 2, p5Canvas.stroke
        IF mode = ARC_PIE THEN internalp5line x0!, y0!, x!, y!, p5Canvas.strokeWeight / 2, p5Canvas.stroke: internalp5line x1!, y1!, x!, y!, p5Canvas.strokeWeight / 2, p5Canvas.stroke
    END IF

    IF p5Canvas.doFill THEN
        IF p5Canvas.doStroke THEN _CLEARCOLOR p5Canvas.stroke ELSE _CLEARCOLOR tempColor~&
        IF p5Canvas.doStroke THEN
            IF mode = ARC_CHORD THEN internalp5line x0!, y0!, x1!, y1!, p5Canvas.strokeWeight / 2, p5Canvas.stroke
            IF mode = ARC_PIE THEN internalp5line x0!, y0!, x!, y!, p5Canvas.strokeWeight / 2, p5Canvas.stroke: internalp5line x1!, y1!, x!, y!, p5Canvas.strokeWeight / 2, p5Canvas.stroke
        END IF
        IF NOT p5Canvas.doStroke THEN GOTO internal_p5_arc_display
        FOR i## = start## TO stp## STEP .001
            xx! = x! + w! * p5cos(i##)
            yy! = y! + h! * p5sin(i##)
            IF p5Canvas.doStroke THEN CircleFill xx!, yy!, p5Canvas.strokeWeight / 2, p5Canvas.stroke ELSE CircleFill xx!, yy!, p5Canvas.strokeWeight / 2, tempColor~&
        NEXT
    END IF
    
    internal_p5_arc_display:::
    _SETALPHA p5Canvas.strokeAlpha, p5Canvas.stroke
    _SETALPHA p5Canvas.fillAlpha, p5Canvas.fill
    
    internalp5displayTempImage
END SUB

SUB internalp5line (x0!, y0!, x1!, y1!, s!, col~&)
    dx! = x1! - x0!
    dy! = y1! - y0!
    d! = SQR(dx! * dx! + dy! * dy!)
    FOR i = 0 TO d!
        CircleFill x0! + dxx!, y0! + dyy!, s!, col~&
        dxx! = dxx! + dx! / d!
        dyy! = dyy! + dy! / d!
    NEXT
END SUB

SUB strokeWeight (a AS SINGLE)
    IF a = 0 THEN
        noStroke
    ELSE
        p5Canvas.strokeWeight = a
    END IF
END SUB

SUB background (r AS SINGLE, g AS SINGLE, b AS SINGLE)
    IF p5Canvas.colorMode = p5HSB THEN p5Canvas.backColor = hsb(r, g, b, 255) ELSE p5Canvas.backColor = _RGB32(r, g, b)
    p5Canvas.backColorAlpha = 255
    LINE (0, 0)-(_WIDTH, _HEIGHT), p5Canvas.backColor, BF
END SUB

SUB backgroundA (r AS SINGLE, g AS SINGLE, b AS SINGLE, a AS SINGLE)
    IF p5Canvas.colorMode = p5HSB THEN
        p5Canvas.backColor = hsb(r, g, b, a)
        p5Canvas.backColorA = hsb(r, g, b, a)
    ELSE
        p5Canvas.backColor = _RGB32(r, g, b)
        p5Canvas.backColorA = _RGBA32(r, g, b, a)
    END IF
    p5Canvas.backColorAlpha = constrain(a, 0, 255)
    LINE (0, 0)-(_WIDTH, _HEIGHT), p5Canvas.backColorA, BF
END SUB

SUB backgroundN (c$)
    c~& = colorN(c$)
    p5Canvas.backColor = c~&
    p5Canvas.backColorA = c~&
    p5Canvas.backColorAlpha = 255
    LINE (0, 0)-(_WIDTH, _HEIGHT), p5Canvas.backColorA, BF
END SUB

SUB backgroundNA (c$, a!)
    c~& = colorNA(c$, a!)
    p5Canvas.backColor = _RGB32(_RED32(c~&), _GREEN32(c~&), _BLUE32(c~&))
    p5Canvas.backColorA = c~&
    p5Canvas.backColorAlpha = _ALPHA32(c~&)
    LINE (0, 0)-(_WIDTH, _HEIGHT), p5Canvas.backColorA, BF
END SUB

SUB backgroundB (b AS SINGLE)
    p5Canvas.backColor = _RGB32(b, b, b)
    p5Canvas.backColorAlpha = 255
    LINE (0, 0)-(_WIDTH, _HEIGHT), p5Canvas.backColor, BF
END SUB

SUB backgroundBA (b AS SINGLE, a AS SINGLE)
    p5Canvas.backColor = _RGB32(b, b, b)
    p5Canvas.backColorA = _RGBA32(b, b, b, a)
    p5Canvas.backColorAlpha = constrain(a, 0, 255)
    LINE (0, 0)-(_WIDTH, _HEIGHT), p5Canvas.backColorA, BF
END SUB

SUB backgroundC (col~&)
    p5Canvas.backColor = _RGB32(_RED32(col~&), _GREEN32(col~&), _BLUE32(col~&))
    p5Canvas.backColorA = _RGBA32(_RED32(col~&), _GREEN32(col~&), _BLUE32(col~&), _ALPHA32(col~&))
    p5Canvas.backColorAlpha = constrain(_ALPHA32(col~&), 0, 255)
    LINE (0, 0)-(_WIDTH, _HEIGHT), p5Canvas.backColorA, BF
END SUB
'#####################################################################################################
'########################## Text Rendering Related methods & functions ###############################
'#####################################################################################################

SUB textAlign (position AS _BYTE)
    p5Canvas.textAlign = position
END SUB

SUB textFont (font$)
    DIM tempFontHandle AS LONG

    IF currentFontSize = 0 THEN currentFontSize = 16

    IF font$ <> loadedFontFile$ THEN
        tempFontHandle = _LOADFONT(font$, currentFontSize)

        IF tempFontHandle > 0 THEN
            'loading successful
            _FONT tempFontHandle
            IF p5Canvas.fontHandle > 0 AND (p5Canvas.fontHandle <> 8 AND p5Canvas.fontHandle <> 16) THEN _FREEFONT p5Canvas.fontHandle
            p5Canvas.fontHandle = tempFontHandle

            loadedFontFile$ = font$
        ELSE
            loadedFontFile$ = ""
            'built-in fonts
            IF currentFontSize >= 16 THEN
                _FONT 16
            ELSEIF currentFontSize < 16 THEN
                _FONT 8
            END IF

            IF p5Canvas.fontHandle > 0 AND (p5Canvas.fontHandle <> 8 AND p5Canvas.fontHandle <> 16) THEN _FREEFONT p5Canvas.fontHandle
            p5Canvas.fontHandle = _FONT
        END IF
    END IF
END SUB

SUB textSize (size%)
    DIM tempFontHandle AS LONG

    IF size% = currentFontSize OR size% <= 0 THEN EXIT SUB

    IF loadedFontFile$ = "" THEN
        'built-in fonts
        IF size% >= 16 THEN
            _FONT 16
            p5Canvas.fontHandle = 16
        ELSEIF size% < 16 THEN
            _FONT 8
            p5Canvas.fontHandle = 8
        END IF
    ELSE
        tempFontHandle = _LOADFONT(loadedFontFile$, size%)

        IF tempFontHandle > 0 THEN
            'loading successful
            _FONT tempFontHandle
            IF p5Canvas.fontHandle > 0 AND (p5Canvas.fontHandle <> 8 AND p5Canvas.fontHandle <> 16) THEN _FREEFONT p5Canvas.fontHandle
            p5Canvas.fontHandle = tempFontHandle

            currentFontSize = size%
        END IF
    END IF
END SUB

SUB text (t$, __x AS SINGLE, __y AS SINGLE)
    DIM x AS SINGLE, y AS SINGLE

    x = __x + p5Canvas.xOffset
    y = __y + p5Canvas.yOffset

    SELECT CASE p5Canvas.textAlign
        CASE LEFT
            p5PrintString x, y, t$
        CASE CENTER
            p5PrintString x - PrintWidth(t$) / 2, y - uheight / 2, t$
        CASE RIGHT
            p5PrintString x - PrintWidth(t$), y, t$
    END SELECT
END SUB

SUB p5PrintString (Left AS INTEGER, Top AS INTEGER, theText$)
    DIM Utf$

    IF p5Canvas.encoding = 1252 THEN
        Utf$ = FromCP1252$(theText$)
    ELSE 'Default to 437
        Utf$ = FromCP437$(theText$)
    END IF

    REDIM p5ThisLineChars(LEN(Utf$)) AS LONG
    uprint_extra Left, Top, _OFFSET(Utf$), LEN(Utf$), true, true, p5LastRenderedLineWidth, _OFFSET(p5ThisLineChars()), p5LastRenderedCharCount, p5Canvas.strokeA, 0
    REDIM _PRESERVE p5ThisLineChars(p5LastRenderedCharCount) AS LONG
END SUB

FUNCTION PrintWidth& (theText$)
    PrintWidth& = uprintwidth(theText$, LEN(theText$), 0)
END FUNCTION

FUNCTION textWidth& (theText$)
    textWidth& = PrintWidth&(theText$)
END FUNCTION

FUNCTION textHeight&
    textHeight& = uheight
END FUNCTION

'---------------------------------------------------------------------------------
'UTF conversion functions courtesy of Luke Ceddia.
'http://www.qb64.net/forum/index.php?topic=13981.msg121324#msg121324
FUNCTION FromCP437$ (source$)
    STATIC init&, table$(255)
    IF init& = 0 THEN
        DIM i&
        FOR i& = 0 TO 127
            table$(i&) = CHR$(i&)
        NEXT i&
        table$(7) = CHR$(226) + CHR$(151) + CHR$(143) 'UTF-8 e2978f
        table$(128) = CHR$(&HE2) + CHR$(&H82) + CHR$(&HAC)
        table$(128) = CHR$(&HC3) + CHR$(&H87)
        table$(129) = CHR$(&HC3) + CHR$(&HBC)
        table$(130) = CHR$(&HC3) + CHR$(&HA9)
        table$(131) = CHR$(&HC3) + CHR$(&HA2)
        table$(132) = CHR$(&HC3) + CHR$(&HA4)
        table$(133) = CHR$(&HC3) + CHR$(&HA0)
        table$(134) = CHR$(&HC3) + CHR$(&HA5)
        table$(135) = CHR$(&HC3) + CHR$(&HA7)
        table$(136) = CHR$(&HC3) + CHR$(&HAA)
        table$(137) = CHR$(&HC3) + CHR$(&HAB)
        table$(138) = CHR$(&HC3) + CHR$(&HA8)
        table$(139) = CHR$(&HC3) + CHR$(&HAF)
        table$(140) = CHR$(&HC3) + CHR$(&HAE)
        table$(141) = CHR$(&HC3) + CHR$(&HAC)
        table$(142) = CHR$(&HC3) + CHR$(&H84)
        table$(143) = CHR$(&HC3) + CHR$(&H85)
        table$(144) = CHR$(&HC3) + CHR$(&H89)
        table$(145) = CHR$(&HC3) + CHR$(&HA6)
        table$(146) = CHR$(&HC3) + CHR$(&H86)
        table$(147) = CHR$(&HC3) + CHR$(&HB4)
        table$(148) = CHR$(&HC3) + CHR$(&HB6)
        table$(149) = CHR$(&HC3) + CHR$(&HB2)
        table$(150) = CHR$(&HC3) + CHR$(&HBB)
        table$(151) = CHR$(&HC3) + CHR$(&HB9)
        table$(152) = CHR$(&HC3) + CHR$(&HBF)
        table$(153) = CHR$(&HC3) + CHR$(&H96)
        table$(154) = CHR$(&HC3) + CHR$(&H9C)
        table$(155) = CHR$(&HC2) + CHR$(&HA2)
        table$(156) = CHR$(&HC2) + CHR$(&HA3)
        table$(157) = CHR$(&HC2) + CHR$(&HA5)
        table$(158) = CHR$(&HE2) + CHR$(&H82) + CHR$(&HA7)
        table$(159) = CHR$(&HC6) + CHR$(&H92)
        table$(160) = CHR$(&HC3) + CHR$(&HA1)
        table$(161) = CHR$(&HC3) + CHR$(&HAD)
        table$(162) = CHR$(&HC3) + CHR$(&HB3)
        table$(163) = CHR$(&HC3) + CHR$(&HBA)
        table$(164) = CHR$(&HC3) + CHR$(&HB1)
        table$(165) = CHR$(&HC3) + CHR$(&H91)
        table$(166) = CHR$(&HC2) + CHR$(&HAA)
        table$(167) = CHR$(&HC2) + CHR$(&HBA)
        table$(168) = CHR$(&HC2) + CHR$(&HBF)
        table$(169) = CHR$(&HE2) + CHR$(&H8C) + CHR$(&H90)
        table$(170) = CHR$(&HC2) + CHR$(&HAC)
        table$(171) = CHR$(&HC2) + CHR$(&HBD)
        table$(172) = CHR$(&HC2) + CHR$(&HBC)
        table$(173) = CHR$(&HC2) + CHR$(&HA1)
        table$(174) = CHR$(&HC2) + CHR$(&HAB)
        table$(175) = CHR$(&HC2) + CHR$(&HBB)
        table$(176) = CHR$(&HE2) + CHR$(&H96) + CHR$(&H91)
        table$(177) = CHR$(&HE2) + CHR$(&H96) + CHR$(&H92)
        table$(178) = CHR$(&HE2) + CHR$(&H96) + CHR$(&H93)
        table$(179) = CHR$(&HE2) + CHR$(&H94) + CHR$(&H82)
        table$(180) = CHR$(&HE2) + CHR$(&H94) + CHR$(&HA4)
        table$(181) = CHR$(&HE2) + CHR$(&H95) + CHR$(&HA1)
        table$(182) = CHR$(&HE2) + CHR$(&H95) + CHR$(&HA2)
        table$(183) = CHR$(&HE2) + CHR$(&H95) + CHR$(&H96)
        table$(184) = CHR$(&HE2) + CHR$(&H95) + CHR$(&H95)
        table$(185) = CHR$(&HE2) + CHR$(&H95) + CHR$(&HA3)
        table$(186) = CHR$(&HE2) + CHR$(&H95) + CHR$(&H91)
        table$(187) = CHR$(&HE2) + CHR$(&H95) + CHR$(&H97)
        table$(188) = CHR$(&HE2) + CHR$(&H95) + CHR$(&H9D)
        table$(189) = CHR$(&HE2) + CHR$(&H95) + CHR$(&H9C)
        table$(190) = CHR$(&HE2) + CHR$(&H95) + CHR$(&H9B)
        table$(191) = CHR$(&HE2) + CHR$(&H94) + CHR$(&H90)
        table$(192) = CHR$(&HE2) + CHR$(&H94) + CHR$(&H94)
        table$(193) = CHR$(&HE2) + CHR$(&H94) + CHR$(&HB4)
        table$(194) = CHR$(&HE2) + CHR$(&H94) + CHR$(&HAC)
        table$(195) = CHR$(&HE2) + CHR$(&H94) + CHR$(&H9C)
        table$(196) = CHR$(&HE2) + CHR$(&H94) + CHR$(&H80)
        table$(197) = CHR$(&HE2) + CHR$(&H94) + CHR$(&HBC)
        table$(198) = CHR$(&HE2) + CHR$(&H95) + CHR$(&H9E)
        table$(199) = CHR$(&HE2) + CHR$(&H95) + CHR$(&H9F)
        table$(200) = CHR$(&HE2) + CHR$(&H95) + CHR$(&H9A)
        table$(201) = CHR$(&HE2) + CHR$(&H95) + CHR$(&H94)
        table$(202) = CHR$(&HE2) + CHR$(&H95) + CHR$(&HA9)
        table$(203) = CHR$(&HE2) + CHR$(&H95) + CHR$(&HA6)
        table$(204) = CHR$(&HE2) + CHR$(&H95) + CHR$(&HA0)
        table$(205) = CHR$(&HE2) + CHR$(&H95) + CHR$(&H90)
        table$(206) = CHR$(&HE2) + CHR$(&H95) + CHR$(&HAC)
        table$(207) = CHR$(&HE2) + CHR$(&H95) + CHR$(&HA7)
        table$(208) = CHR$(&HE2) + CHR$(&H95) + CHR$(&HA8)
        table$(209) = CHR$(&HE2) + CHR$(&H95) + CHR$(&HA4)
        table$(210) = CHR$(&HE2) + CHR$(&H95) + CHR$(&HA5)
        table$(211) = CHR$(&HE2) + CHR$(&H95) + CHR$(&H99)
        table$(212) = CHR$(&HE2) + CHR$(&H95) + CHR$(&H98)
        table$(213) = CHR$(&HE2) + CHR$(&H95) + CHR$(&H92)
        table$(214) = CHR$(&HE2) + CHR$(&H95) + CHR$(&H93)
        table$(215) = CHR$(&HE2) + CHR$(&H95) + CHR$(&HAB)
        table$(216) = CHR$(&HE2) + CHR$(&H95) + CHR$(&HAA)
        table$(217) = CHR$(&HE2) + CHR$(&H94) + CHR$(&H98)
        table$(218) = CHR$(&HE2) + CHR$(&H94) + CHR$(&H8C)
        table$(219) = CHR$(&HE2) + CHR$(&H96) + CHR$(&H88)
        table$(220) = CHR$(&HE2) + CHR$(&H96) + CHR$(&H84)
        table$(221) = CHR$(&HE2) + CHR$(&H96) + CHR$(&H8C)
        table$(222) = CHR$(&HE2) + CHR$(&H96) + CHR$(&H90)
        table$(223) = CHR$(&HE2) + CHR$(&H96) + CHR$(&H80)
        table$(224) = CHR$(&HCE) + CHR$(&HB1)
        table$(225) = CHR$(&HC3) + CHR$(&H9F)
        table$(226) = CHR$(&HCE) + CHR$(&H93)
        table$(227) = CHR$(&HCF) + CHR$(&H80)
        table$(228) = CHR$(&HCE) + CHR$(&HA3)
        table$(229) = CHR$(&HCF) + CHR$(&H83)
        table$(230) = CHR$(&HC2) + CHR$(&HB5)
        table$(231) = CHR$(&HCF) + CHR$(&H84)
        table$(232) = CHR$(&HCE) + CHR$(&HA6)
        table$(233) = CHR$(&HCE) + CHR$(&H98)
        table$(234) = CHR$(&HCE) + CHR$(&HA9)
        table$(235) = CHR$(&HCE) + CHR$(&HB4)
        table$(236) = CHR$(&HE2) + CHR$(&H88) + CHR$(&H9E)
        table$(237) = CHR$(&HCF) + CHR$(&H86)
        table$(238) = CHR$(&HCE) + CHR$(&HB5)
        table$(239) = CHR$(&HE2) + CHR$(&H88) + CHR$(&HA9)
        table$(240) = CHR$(&HE2) + CHR$(&H89) + CHR$(&HA1)
        table$(241) = CHR$(&HC2) + CHR$(&HB1)
        table$(242) = CHR$(&HE2) + CHR$(&H89) + CHR$(&HA5)
        table$(243) = CHR$(&HE2) + CHR$(&H89) + CHR$(&HA4)
        table$(244) = CHR$(&HE2) + CHR$(&H8C) + CHR$(&HA0)
        table$(245) = CHR$(&HE2) + CHR$(&H8C) + CHR$(&HA1)
        table$(246) = CHR$(&HC3) + CHR$(&HB7)
        table$(247) = CHR$(&HE2) + CHR$(&H89) + CHR$(&H88)
        table$(248) = CHR$(&HC2) + CHR$(&HB0)
        table$(249) = CHR$(&HE2) + CHR$(&H88) + CHR$(&H99)
        table$(250) = CHR$(&HC2) + CHR$(&HB7)
        table$(251) = CHR$(&HE2) + CHR$(&H88) + CHR$(&H9A)
        table$(252) = CHR$(&HE2) + CHR$(&H81) + CHR$(&HBF)
        table$(253) = CHR$(&HC2) + CHR$(&HB2)
        table$(254) = CHR$(&HE2) + CHR$(&H96) + CHR$(&HA0)
        table$(255) = CHR$(&HC2) + CHR$(&HA0)
        init& = -1
    END IF
    FromCP437$ = UTF8$(source$, table$())
END FUNCTION

FUNCTION FromCP1252$ (source$)
    STATIC init&, table$(255)
    IF init& = 0 THEN
        DIM i&
        FOR i& = 0 TO 127
            table$(i&) = CHR$(i&)
        NEXT i&
        table$(7) = CHR$(226) + CHR$(151) + CHR$(143) 'UTF-8 e2978f
        table$(128) = CHR$(&HE2) + CHR$(&H82) + CHR$(&HAC)
        table$(130) = CHR$(&HE2) + CHR$(&H80) + CHR$(&H9A)
        table$(131) = CHR$(&HC6) + CHR$(&H92)
        table$(132) = CHR$(&HE2) + CHR$(&H80) + CHR$(&H9E)
        table$(133) = CHR$(&HE2) + CHR$(&H80) + CHR$(&HA6)
        table$(134) = CHR$(&HE2) + CHR$(&H80) + CHR$(&HA0)
        table$(135) = CHR$(&HE2) + CHR$(&H80) + CHR$(&HA1)
        table$(136) = CHR$(&HCB) + CHR$(&H86)
        table$(137) = CHR$(&HE2) + CHR$(&H80) + CHR$(&HB0)
        table$(138) = CHR$(&HC5) + CHR$(&HA0)
        table$(139) = CHR$(&HE2) + CHR$(&H80) + CHR$(&HB9)
        table$(140) = CHR$(&HC5) + CHR$(&H92)
        table$(142) = CHR$(&HC5) + CHR$(&HBD)
        table$(145) = CHR$(&HE2) + CHR$(&H80) + CHR$(&H98)
        table$(146) = CHR$(&HE2) + CHR$(&H80) + CHR$(&H99)
        table$(147) = CHR$(&HE2) + CHR$(&H80) + CHR$(&H9C)
        table$(148) = CHR$(&HE2) + CHR$(&H80) + CHR$(&H9D)
        table$(149) = CHR$(&HE2) + CHR$(&H80) + CHR$(&HA2)
        table$(150) = CHR$(&HE2) + CHR$(&H80) + CHR$(&H93)
        table$(151) = CHR$(&HE2) + CHR$(&H80) + CHR$(&H94)
        table$(152) = CHR$(&HCB) + CHR$(&H9C)
        table$(153) = CHR$(&HE2) + CHR$(&H84) + CHR$(&HA2)
        table$(154) = CHR$(&HC5) + CHR$(&HA1)
        table$(155) = CHR$(&HE2) + CHR$(&H80) + CHR$(&HBA)
        table$(156) = CHR$(&HC5) + CHR$(&H93)
        table$(158) = CHR$(&HC5) + CHR$(&HBE)
        table$(159) = CHR$(&HC5) + CHR$(&HB8)
        table$(160) = CHR$(&HC2) + CHR$(&HA0)
        table$(161) = CHR$(&HC2) + CHR$(&HA1)
        table$(162) = CHR$(&HC2) + CHR$(&HA2)
        table$(163) = CHR$(&HC2) + CHR$(&HA3)
        table$(164) = CHR$(&HC2) + CHR$(&HA4)
        table$(165) = CHR$(&HC2) + CHR$(&HA5)
        table$(166) = CHR$(&HC2) + CHR$(&HA6)
        table$(167) = CHR$(&HC2) + CHR$(&HA7)
        table$(168) = CHR$(&HC2) + CHR$(&HA8)
        table$(169) = CHR$(&HC2) + CHR$(&HA9)
        table$(170) = CHR$(&HC2) + CHR$(&HAA)
        table$(171) = CHR$(&HC2) + CHR$(&HAB)
        table$(172) = CHR$(&HC2) + CHR$(&HAC)
        table$(173) = CHR$(&HC2) + CHR$(&HAD)
        table$(174) = CHR$(&HC2) + CHR$(&HAE)
        table$(175) = CHR$(&HC2) + CHR$(&HAF)
        table$(176) = CHR$(&HC2) + CHR$(&HB0)
        table$(177) = CHR$(&HC2) + CHR$(&HB1)
        table$(178) = CHR$(&HC2) + CHR$(&HB2)
        table$(179) = CHR$(&HC2) + CHR$(&HB3)
        table$(180) = CHR$(&HC2) + CHR$(&HB4)
        table$(181) = CHR$(&HC2) + CHR$(&HB5)
        table$(182) = CHR$(&HC2) + CHR$(&HB6)
        table$(183) = CHR$(&HC2) + CHR$(&HB7)
        table$(184) = CHR$(&HC2) + CHR$(&HB8)
        table$(185) = CHR$(&HC2) + CHR$(&HB9)
        table$(186) = CHR$(&HC2) + CHR$(&HBA)
        table$(187) = CHR$(&HC2) + CHR$(&HBB)
        table$(188) = CHR$(&HC2) + CHR$(&HBC)
        table$(189) = CHR$(&HC2) + CHR$(&HBD)
        table$(190) = CHR$(&HC2) + CHR$(&HBE)
        table$(191) = CHR$(&HC2) + CHR$(&HBF)
        table$(192) = CHR$(&HC3) + CHR$(&H80)
        table$(193) = CHR$(&HC3) + CHR$(&H81)
        table$(194) = CHR$(&HC3) + CHR$(&H82)
        table$(195) = CHR$(&HC3) + CHR$(&H83)
        table$(196) = CHR$(&HC3) + CHR$(&H84)
        table$(197) = CHR$(&HC3) + CHR$(&H85)
        table$(198) = CHR$(&HC3) + CHR$(&H86)
        table$(199) = CHR$(&HC3) + CHR$(&H87)
        table$(200) = CHR$(&HC3) + CHR$(&H88)
        table$(201) = CHR$(&HC3) + CHR$(&H89)
        table$(202) = CHR$(&HC3) + CHR$(&H8A)
        table$(203) = CHR$(&HC3) + CHR$(&H8B)
        table$(204) = CHR$(&HC3) + CHR$(&H8C)
        table$(205) = CHR$(&HC3) + CHR$(&H8D)
        table$(206) = CHR$(&HC3) + CHR$(&H8E)
        table$(207) = CHR$(&HC3) + CHR$(&H8F)
        table$(208) = CHR$(&HC3) + CHR$(&H90)
        table$(209) = CHR$(&HC3) + CHR$(&H91)
        table$(210) = CHR$(&HC3) + CHR$(&H92)
        table$(211) = CHR$(&HC3) + CHR$(&H93)
        table$(212) = CHR$(&HC3) + CHR$(&H94)
        table$(213) = CHR$(&HC3) + CHR$(&H95)
        table$(214) = CHR$(&HC3) + CHR$(&H96)
        table$(215) = CHR$(&HC3) + CHR$(&H97)
        table$(216) = CHR$(&HC3) + CHR$(&H98)
        table$(217) = CHR$(&HC3) + CHR$(&H99)
        table$(218) = CHR$(&HC3) + CHR$(&H9A)
        table$(219) = CHR$(&HC3) + CHR$(&H9B)
        table$(220) = CHR$(&HC3) + CHR$(&H9C)
        table$(221) = CHR$(&HC3) + CHR$(&H9D)
        table$(222) = CHR$(&HC3) + CHR$(&H9E)
        table$(223) = CHR$(&HC3) + CHR$(&H9F)
        table$(224) = CHR$(&HC3) + CHR$(&HA0)
        table$(225) = CHR$(&HC3) + CHR$(&HA1)
        table$(226) = CHR$(&HC3) + CHR$(&HA2)
        table$(227) = CHR$(&HC3) + CHR$(&HA3)
        table$(228) = CHR$(&HC3) + CHR$(&HA4)
        table$(229) = CHR$(&HC3) + CHR$(&HA5)
        table$(230) = CHR$(&HC3) + CHR$(&HA6)
        table$(231) = CHR$(&HC3) + CHR$(&HA7)
        table$(232) = CHR$(&HC3) + CHR$(&HA8)
        table$(233) = CHR$(&HC3) + CHR$(&HA9)
        table$(234) = CHR$(&HC3) + CHR$(&HAA)
        table$(235) = CHR$(&HC3) + CHR$(&HAB)
        table$(236) = CHR$(&HC3) + CHR$(&HAC)
        table$(237) = CHR$(&HC3) + CHR$(&HAD)
        table$(238) = CHR$(&HC3) + CHR$(&HAE)
        table$(239) = CHR$(&HC3) + CHR$(&HAF)
        table$(240) = CHR$(&HC3) + CHR$(&HB0)
        table$(241) = CHR$(&HC3) + CHR$(&HB1)
        table$(242) = CHR$(&HC3) + CHR$(&HB2)
        table$(243) = CHR$(&HC3) + CHR$(&HB3)
        table$(244) = CHR$(&HC3) + CHR$(&HB4)
        table$(245) = CHR$(&HC3) + CHR$(&HB5)
        table$(246) = CHR$(&HC3) + CHR$(&HB6)
        table$(247) = CHR$(&HC3) + CHR$(&HB7)
        table$(248) = CHR$(&HC3) + CHR$(&HB8)
        table$(249) = CHR$(&HC3) + CHR$(&HB9)
        table$(250) = CHR$(&HC3) + CHR$(&HBA)
        table$(251) = CHR$(&HC3) + CHR$(&HBB)
        table$(252) = CHR$(&HC3) + CHR$(&HBC)
        table$(253) = CHR$(&HC3) + CHR$(&HBD)
        table$(254) = CHR$(&HC3) + CHR$(&HBE)
        table$(255) = CHR$(&HC3) + CHR$(&HBF)
        init& = -1
    END IF
    FromCP1252$ = UTF8$(source$, table$())
END FUNCTION

FUNCTION UTF8$ (source$, table$())
    DIM i AS LONG, dest$
    FOR i = 1 TO LEN(source$)
        dest$ = dest$ + table$(ASC(source$, i))
    NEXT i
    UTF8$ = dest$
END FUNCTION

'#####################################################################################################
'########################### p5 Environment Related methods & functions ##############################
'#####################################################################################################
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

FUNCTION createImage& (w AS INTEGER, h AS INTEGER)
    createImage& = _NEWIMAGE(w, h, 32)
END FUNCTION

FUNCTION width&
    width& = _WIDTH
END FUNCTION

FUNCTION height&
    height& = _HEIGHT
END FUNCTION

SUB title (t$)
    _TITLE t$
END SUB

SUB titleB (v!)
    _TITLE STR$(v!)
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
    callDrawLoop
END SUB

SUB callDrawLoop
    DIM a AS _BYTE, xOffsetBackup AS SINGLE, yOffsetBackup AS SINGLE

    p5frameCount = p5frameCount + 1

    'calls to translate() are reverted after the draw loop
    xOffsetBackup = p5Canvas.xOffset
    yOffsetBackup = p5Canvas.yOffset

    a = p5draw

    p5Canvas.xOffset = xOffsetBackup
    p5Canvas.yOffset = yOffsetBackup
END SUB

FUNCTION frameCount~&
    frameCount~& = p5frameCount
END FUNCTION

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
                                
SUB doLoop ()
    p5Loop = true
END SUB

SUB noLoop ()
    p5Loop = false
END SUB

SUB cursor (kind)
    IF kind = CURSOR_NONE THEN _MOUSEHIDE ELSE glutSetCursor kind
END SUB

'#####################################################################################################
'############################# p5 Maths & Vectors Related functions ##################################
'#####################################################################################################

FUNCTION noise! (x AS SINGLE, y AS SINGLE, z AS SINGLE)
    STATIC p5NoiseSetup AS _BYTE
    STATIC perlin() AS SINGLE
    STATIC PERLIN_YWRAPB AS SINGLE, PERLIN_YWRAP AS SINGLE
    STATIC PERLIN_ZWRAPB AS SINGLE, PERLIN_ZWRAP AS SINGLE
    STATIC PERLIN_SIZE AS SINGLE, perlin_octaves AS SINGLE
    STATIC perlin_amp_falloff AS SINGLE

    IF NOT p5NoiseSetup THEN
        p5NoiseSetup = true

        PERLIN_YWRAPB = 4
        PERLIN_YWRAP = INT(1 * (2 ^ PERLIN_YWRAPB))
        PERLIN_ZWRAPB = 8
        PERLIN_ZWRAP = INT(1 * (2 ^ PERLIN_ZWRAPB))
        PERLIN_SIZE = 4095

        perlin_octaves = 4
        perlin_amp_falloff = 0.5

        REDIM perlin(PERLIN_SIZE + 1) AS SINGLE
        DIM i AS SINGLE
        FOR i = 0 TO PERLIN_SIZE + 1
            perlin(i) = RND
        NEXT
    END IF

    x = ABS(x)
    y = ABS(y)
    z = ABS(z)

    DIM xi AS SINGLE, yi AS SINGLE, zi AS SINGLE
    xi = INT(x)
    yi = INT(y)
    zi = INT(z)

    DIM xf AS SINGLE, yf AS SINGLE, zf AS SINGLE
    xf = x - xi
    yf = y - yi
    zf = z - zi

    DIM r AS SINGLE, ampl AS SINGLE, o AS SINGLE
    r = 0
    ampl = .5

    FOR o = 1 TO perlin_octaves
        DIM of AS SINGLE, rxf AS SINGLE
        DIM ryf AS SINGLE, n1 AS SINGLE, n2 AS SINGLE, n3 AS SINGLE
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
    noise! = r
END FUNCTION

FUNCTION map! (value!, minRange!, maxRange!, newMinRange!, newMaxRange!)
    map! = ((value! - minRange!) / (maxRange! - minRange!)) * (newMaxRange! - newMinRange!) + newMinRange!
END FUNCTION

SUB createVector (v AS vector, x AS SINGLE, y AS SINGLE)
    v.x = x
    v.y = y
END SUB

SUB vector.add (v1 AS vector, v2 AS vector)
    v1.x = v1.x + v2.x
    v1.y = v1.y + v2.y
    v1.z = v1.z + v2.z
END SUB

SUB vector.addB (v1 AS vector, x2 AS SINGLE, y2 AS SINGLE, z2 AS SINGLE)
    v1.x = v1.x + x2
    v1.y = v1.y + y2
    v1.z = v1.z + z2
END SUB

SUB vector.sub (v1 AS vector, v2 AS vector)
    v1.x = v1.x - v2.x
    v1.y = v1.y - v2.y
    v1.z = v1.z - v2.z
END SUB

SUB vector.subB (v1 AS vector, x2 AS SINGLE, y2 AS SINGLE, z2 AS SINGLE)
    v1.x = v1.x - x2
    v1.y = v1.y - y2
    v1.z = v1.z - z2
END SUB

SUB vector.limit (v AS vector, __max!)
    mSq = vector.magSq(v)
    IF mSq > __max! * __max! THEN
        vector.div v, SQR(mSq)
        vector.mult v, __max!
    END IF
END SUB

FUNCTION vector.magSq! (v AS vector)
    vector.magSq! = v.x * v.x + v.y * v.y + v.z * v.z
END FUNCTION

SUB vector.fromAngle (v AS vector, __angle!)
    IF p5Canvas.angleMode = DEGREES THEN angle! = _D2R(__angle!) ELSE angle! = __angle!

    v.x = COS(angle!)
    v.y = SIN(angle!)
END SUB

FUNCTION vector.mag! (v AS vector)
    x = v.x
    y = v.y
    z = v.z

    magSq = x * x + y * y + z * z
    vector.mag! = SQR(magSq)
END FUNCTION

SUB vector.setMag (v AS vector, n AS SINGLE)
    vector.normalize v
    vector.mult v, n
END SUB

SUB vector.normalize (v AS vector)
    theMag! = vector.mag(v)
    IF theMag! = 0 THEN EXIT SUB

    vector.div v, theMag!
END SUB

SUB vector.div (v AS vector, n AS SINGLE)
    v.x = v.x / n
    v.y = v.y / n
    v.z = v.z / n
END SUB

SUB vector.mult (v AS vector, n AS SINGLE)
    v.x = v.x * n
    v.y = v.y * n
    v.z = v.z * n
END SUB

SUB vector.random2d (v AS vector)
    DIM angle AS SINGLE

    IF p5Canvas.angleMode = DEGREES THEN
        angle = p5random(0, 360)
    ELSE
        angle = p5random(0, TWO_PI)
    END IF

    vector.fromAngle v, angle
END SUB

FUNCTION p5degrees! (r!)
    p5degrees! = _R2D(r!)
END FUNCTION

FUNCTION p5radians! (d!)
    p5radians! = _D2R(d!)
END FUNCTION

FUNCTION p5sin! (angle!)
    IF p5Canvas.angleMode = RADIANS THEN
        p5sin! = SIN(angle!)
    ELSE
        p5sin! = SIN(_D2R(angle!))
    END IF
END FUNCTION

FUNCTION p5cos! (angle!)
    IF p5Canvas.angleMode = RADIANS THEN
        p5cos! = COS(angle!)
    ELSE
        p5cos! = COS(_D2R(angle!))
    END IF
END FUNCTION

SUB angleMode (kind)
    p5Canvas.angleMode = kind
END SUB

'Calculate minimum value between two values
FUNCTION min! (a!, b!)
    IF a! < b! THEN min! = a! ELSE min! = b!
END FUNCTION

'Calculate maximum value between two values
FUNCTION max! (a!, b!)
    IF a! > b! THEN max! = a! ELSE max! = b!
END FUNCTION

'Constrain a value between a minimum and maximum value.
FUNCTION constrain! (n!, low!, high!)
    constrain! = max(min(n!, high!), low!)
END FUNCTION

'Calculate the distance between two points.
FUNCTION dist! (x1!, y1!, x2!, y2!)
    dist! = SQR((x2! - x1!) ^ 2 + (y2! - y1!) ^ 2)
END FUNCTION

FUNCTION distB! (v1 AS vector, v2 AS vector)
    distB! = dist!(v1.x, v1.y, v2.x, v2.y)
END FUNCTION

FUNCTION lerp! (start!, stp!, amt!)
    lerp! = amt! * (stp! - start!) + start!
END FUNCTION

FUNCTION mag! (x!, y!)
    mag! = _HYPOT(x!, y!)
END FUNCTION

FUNCTION sq! (n!)
    sq! = n! * n!
END FUNCTION

FUNCTION pow! (n!, p!)
    pow! = n! ^ p!
END FUNCTION

FUNCTION p5random! (mn!, mx!)
    IF mn! > mx! THEN
        SWAP mn!, mx!
    END IF
    p5random! = RND * (mx! - mn!) + mn!
END FUNCTION

FUNCTION join$ (str_array$(), sep$)
    FOR i = LBOUND(str_array$) TO UBOUND(str_array$)
        join$ = join$ + str_array$(i) + sep$
    NEXT
END FUNCTION

'#####################################################################################################
'######################## p5 Date & Time Related functions ###########################################
'#####################################################################################################

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

'#####################################################################################################
'############################ p5 Sound Related methods &  functions ##################################
'#####################################################################################################

FUNCTION loadSound& (file$)
    IF _FILEEXISTS(file$) = 0 THEN EXIT FUNCTION
    DIM tempHandle&, setting$

    setting$ = "vol"

    SELECT CASE UCASE$(RIGHT$(file$, 4))
        CASE ".WAV", ".OGG", ".AIF", ".RIF", ".VOC"
            setting$ = "vol,sync,len,pause"
        CASE ".MP3"
            setting$ = "vol,pause,setpos"
    END SELECT

    tempHandle& = _SNDOPEN(file$, setting$)
    IF tempHandle& > 0 THEN
        totalLoadedSounds = totalLoadedSounds + 1
        REDIM _PRESERVE loadedSounds(totalLoadedSounds) AS new_SoundHandle
        loadedSounds(totalLoadedSounds).handle = tempHandle&
        loadedSounds(totalLoadedSounds).sync = INSTR(setting$, "sync") > 0
        loadSound& = tempHandle&
    END IF
END FUNCTION

SUB p5play (soundHandle&)
    DIM i AS LONG
    FOR i = 1 TO UBOUND(loadedSounds)
        IF loadedSounds(i).handle = soundHandle& THEN
            IF loadedSounds(i).sync THEN
                _SNDPLAYCOPY soundHandle&
            ELSE
                IF NOT _SNDPLAYING(soundHandle&) THEN _SNDPLAY soundHandle&
            END IF
        END IF
    NEXT
END SUB

'#####################################################################################################
'############################ p5 Colors Related methods & functions ##################################
'#####################################################################################################

SUB fill (r AS SINGLE, g AS SINGLE, b AS SINGLE)
    p5Canvas.doFill = true
    IF p5Canvas.colorMode = p5HSB THEN p5Canvas.fill = hsb(r, g, b, 255) ELSE p5Canvas.fill = _RGB32(r, g, b)
    p5Canvas.fillA = p5Canvas.fill
    p5Canvas.fillAlpha = 255
    COLOR , p5Canvas.fill 'fill also affects text
END SUB

SUB fillN (c$)
    p5Canvas.doFill = true
    c~& = colorN(c$)
    p5Canvas.fill = c~&
    p5Canvas.fillA = c~&
    p5Canvas.fillAlpha = 255
    COLOR , p5Canvas.fill 'fill also affect the text
END SUB

SUB fillNA (c$, a!)
    p5Canvas.doFill = true
    c~& = colorNA(c$, a!)
    p5Canvas.fill = c~&
    p5Canvas.fillA = _RGBA32(_RED32(c~&), _GREEN32(c~&), _BLUE32(c~&), a!)
    p5Canvas.fillAlpha = _ALPHA32(c~&)
    COLOR , p5Canvas.fillA 'fill also affect the text
END SUB

SUB fillA (r AS SINGLE, g AS SINGLE, b AS SINGLE, a AS SINGLE)
    p5Canvas.doFill = true
    IF p5Canvas.colorMode = p5HSB THEN
        p5Canvas.fill = hsb(r, g, b, a)
        p5Canvas.fillA = hsb(r, g, b, a)
    ELSE
        p5Canvas.fill = _RGB32(r, g, b)
        p5Canvas.fillA = _RGBA32(r, g, b, a)
    END IF
    p5Canvas.fillAlpha = constrain(a, 0, 255)
    COLOR , p5Canvas.fillA 'fill also affects text
END SUB

SUB fillB (b AS SINGLE)
    p5Canvas.doFill = true
    p5Canvas.fill = _RGB32(b, b, b)
    p5Canvas.fillA = p5Canvas.fill
    p5Canvas.fillAlpha = 255
    COLOR , p5Canvas.fill 'fill also affects text
END SUB

SUB fillBA (b AS SINGLE, a AS SINGLE)
    p5Canvas.doFill = true
    p5Canvas.fill = _RGB32(b, b, b)
    p5Canvas.fillA = _RGBA32(b, b, b, a)
    p5Canvas.fillAlpha = constrain(a, 0, 255)
    COLOR , p5Canvas.fillA 'fill also affects text
END SUB

SUB fillC (c AS _UNSIGNED LONG)
    p5Canvas.doFill = true
    p5Canvas.fillAlpha = _ALPHA(c)
    IF p5Canvas.fillAlpha < 255 THEN
        p5Canvas.fill = _RGB32(_RED32(c), _GREEN32(c), _BLUE32(c))
    ELSE
        p5Canvas.fill = c
    END IF
    p5Canvas.fillA = c
END SUB

SUB stroke (r AS SINGLE, g AS SINGLE, b AS SINGLE)
    p5Canvas.doStroke = true
    IF p5Canvas.colorMode = p5HSB THEN p5Canvas.stroke = hsb(r, g, b, 255) ELSE p5Canvas.stroke = _RGB32(r, g, b)
    p5Canvas.strokeA = p5Canvas.stroke
    p5Canvas.strokeAlpha = 255
    COLOR p5Canvas.stroke 'stroke also affects text
END SUB

SUB strokeN (c$)
    p5Canvas.doStroke = true
    c~& = colorN(c$)
    p5Canvas.stroke = c~&
    p5Canvas.strokeA = c~&
    p5Canvas.strokeAlpha = 255
    COLOR p5Canvas.stroke 'stroke also affects text
END SUB

SUB strokeNA (c$, a!)
    p5Canvas.doStroke = true
    c~& = colorNA(c$, a!)
    p5Canvas.stroke = _RGB32(_RED32(c~&), _GREEN32(c~&), _BLUE32(c~&))
    p5Canvas.strokeA = c~&
    p5Canvas.strokeAlpha = _ALPHA32(c~&)
    COLOR p5Canvas.strokeA 'stroke also affects text
END SUB

SUB strokeA (r AS SINGLE, g AS SINGLE, b AS SINGLE, a AS SINGLE)
    p5Canvas.doStroke = true
    IF p5Canvas.colorMode = p5HSB THEN
        p5Canvas.stroke = hsb(r, g, b, 255)
        p5Canvas.strokeA = hsb(r, g, b, a)
    ELSE
        p5Canvas.stroke = _RGB32(r, g, b)
        p5Canvas.strokeA = _RGBA32(r, g, b, a)
    END IF

    p5Canvas.strokeAlpha = constrain(a, 0, 255)
    COLOR p5Canvas.strokeA 'stroke also affects text
END SUB

SUB strokeB (b AS SINGLE)
    p5Canvas.doStroke = true
    p5Canvas.stroke = _RGB32(b, b, b)
    p5Canvas.strokeA = p5Canvas.stroke
    p5Canvas.strokeAlpha = 255
    COLOR p5Canvas.strokeA 'stroke also affects text
END SUB

SUB strokeBA (b AS SINGLE, a AS SINGLE)
    p5Canvas.doStroke = true
    p5Canvas.stroke = _RGB32(b, b, b)
    p5Canvas.strokeA = _RGBA32(b, b, b, a)
    p5Canvas.strokeAlpha = constrain(a, 0, 255)
    COLOR p5Canvas.strokeA 'stroke also affects text
END SUB

SUB strokeC (c AS _UNSIGNED LONG)
    p5Canvas.doStroke = true
    p5Canvas.strokeAlpha = _ALPHA(c)
    IF p5Canvas.strokeAlpha < 255 THEN
        p5Canvas.stroke = _RGB32(_RED32(c), _GREEN32(c), _BLUE32(c))
    ELSE
        p5Canvas.stroke = c
    END IF
    p5Canvas.strokeA = c
END SUB

SUB noFill ()
    p5Canvas.doFill = false
    COLOR , 0 'fill also affects text
END SUB

SUB noStroke ()
    p5Canvas.doStroke = false
    COLOR 0 'stroke also affects text
END SUB

FUNCTION lerpColor~& (c1 AS _UNSIGNED LONG, c2 AS _UNSIGNED LONG, __v!)
    DIM v!
    v! = constrain(__v!, 0, 1)

    IF p5Canvas.colorMode = p5RGB THEN
        DIM r1 AS SINGLE, g1 AS SINGLE, b1 AS SINGLE
        DIM r2 AS SINGLE, g2 AS SINGLE, b2 AS SINGLE
        DIM rstep AS SINGLE, gstep AS SINGLE, bstep AS SINGLE

        r1 = _RED32(c1)
        g1 = _GREEN32(c1)
        b1 = _BLUE32(c1)

        r2 = _RED32(c2)
        g2 = _GREEN32(c2)
        b2 = _BLUE32(c2)

        rstep = map(v!, 0, 1, r1, r2)
        gstep = map(v!, 0, 1, g1, g2)
        bstep = map(v!, 0, 1, b1, b2)

        lerpColor~& = _RGB32(rstep, gstep, bstep)
    ELSE
        'p5HSB lerpColor not yet available; return either
        'of the original colors that's closer to v!
        IF v! < .5 THEN
            lerpColor~& = c1
        ELSE
            lerpColor~& = c2
        END IF
    END IF
END FUNCTION

FUNCTION color~& (v1 AS SINGLE, v2 AS SINGLE, v3 AS SINGLE)
    IF p5Canvas.colorMode = p5RGB THEN
        color~& = _RGB32(v1, v2, v3)
    ELSEIF p5Canvas.colorMode = p5HSB THEN
        color~& = hsb(v1, v2, v3, 255)
    END IF
END FUNCTION

FUNCTION colorA~& (v1 AS SINGLE, v2 AS SINGLE, v3 AS SINGLE, a AS SINGLE)
    IF p5Canvas.colorMode = p5RGB THEN
        colorA~& = _RGBA32(v1, v2, v3, a)
    ELSEIF p5Canvas.colorMode = p5HSB THEN
        colorA~& = hsb(v1, v2, v3, a)
    END IF
END FUNCTION

FUNCTION colorB~& (v1 AS SINGLE)
    IF p5Canvas.colorMode = p5RGB THEN
        colorB~& = _RGB32(v1, v1, v1)
    ELSEIF p5Canvas.colorMode = p5HSB THEN
        colorB~& = hsb(0, 0, v1, 255)
    END IF
END FUNCTION

FUNCTION colorBA~& (v1 AS SINGLE, a AS SINGLE)
    IF p5Canvas.colorMode = p5RGB THEN
        colorBA~& = _RGBA32(v1, v1, v1, a)
    ELSEIF p5Canvas.colorMode = p5HSB THEN
        colorBA~& = hsb(0, 0, v1, a)
    END IF
END FUNCTION

FUNCTION colorN~& (c$)
    IF LEFT$(c$, 1) = "#" THEN
        colorN~& = hexToCol~&(c$)
    ELSE
        FOR i = 1 TO UBOUND(p5Colors)
            IF LCASE$(c$) = LCASE$(RTRIM$(p5Colors(i).n)) THEN colorN~& = p5Colors(i).c: EXIT FOR
        NEXT
    END IF
END FUNCTION

FUNCTION colorNA~& (c$, a!)
    IF LEFT$(c$, 1) = "#" THEN
        colorNA~& = hexToCol~&(c$)
    ELSE
        FOR i = 1 TO UBOUND(p5Colors)
            IF LCASE$(c$) = LCASE$(RTRIM$(p5Colors(i).n)) THEN colorNA~& = _RGBA32(_RED32(p5Colors(i).c), _GREEN32(p5Colors(i).c), _BLUE32(p5Colors(i).c), a!)
        NEXT
    END IF
END FUNCTION
'method adapted form http://stackoverflow.com/questions/4106363/converting-rgb-to-hsb-colors
FUNCTION hsb~& (__H AS _FLOAT, __S AS _FLOAT, __B AS _FLOAT, A AS _FLOAT)
    DIM H AS _FLOAT, S AS _FLOAT, B AS _FLOAT

    H = map(__H, 0, 255, 0, 360)
    S = map(__S, 0, 255, 0, 1)
    B = map(__B, 0, 255, 0, 1)

    IF S = 0 THEN
        hsb~& = _RGBA32(B * 255, B * 255, B * 255, A)
        EXIT FUNCTION
    END IF

    DIM fmx AS _FLOAT, fmn AS _FLOAT
    DIM fmd AS _FLOAT, iSextant AS INTEGER
    DIM imx AS INTEGER, imd AS INTEGER, imn AS INTEGER

    IF B > .5 THEN
        fmx = B - (B * S) + S
        fmn = B + (B * S) - S
    ELSE
        fmx = B + (B * S)
        fmn = B - (B * S)
    END IF

    iSextant = INT(H / 60)

    IF H >= 300 THEN
        H = H - 360
    END IF

    H = H / 60
    H = H - (2 * INT(((iSextant + 1) MOD 6) / 2))

    IF iSextant MOD 2 = 0 THEN
        fmd = (H * (fmx - fmn)) + fmn
    ELSE
        fmd = fmn - (H * (fmx - fmn))
    END IF

    imx = _ROUND(fmx * 255)
    imd = _ROUND(fmd * 255)
    imn = _ROUND(fmn * 255)

    SELECT CASE INT(iSextant)
        CASE 1
            hsb~& = _RGBA32(imd, imx, imn, A)
        CASE 2
            hsb~& = _RGBA32(imn, imx, imd, A)
        CASE 3
            hsb~& = _RGBA32(imn, imd, imx, A)
        CASE 4
            hsb~& = _RGBA32(imd, imn, imx, A)
        CASE 5
            hsb~& = _RGBA32(imx, imn, imd, A)
        CASE ELSE
            hsb~& = _RGBA32(imx, imd, imn, A)
    END SELECT

END FUNCTION

FUNCTION brightness! (col~&)
    r = _RED32(col~&)
    g = _GREEN32(col~&)
    b = _BLUE32(col~&)
    a = _ALPHA32(col~&)
    brightness! = ((r + g + b + a) / (255 * 4)) * 255
END FUNCTION

SUB colorMode (kind AS INTEGER)
    p5Canvas.colorMode = kind
END SUB

FUNCTION hue! (col~&)
    r! = _RED32(col~&)
    g! = _GREEN32(col~&)
    b! = _BLUE32(col~&)
    mx! = max(max(r!, g!), b!)
    mn! = min(min(r!, g!), b!)
    delta! = mx! - mn!
    IF delta! <> 0 THEN
        IF r! = mx! THEN
            hue! = (g - b) / delta!
        ELSEIF g! = mx! THEN
            hue! = 2 + ((b - r) / delta!)
        ELSEIF b! = mx! THEN
            hue! = 4 + ((r - g) / delta!)
        END IF
    ELSE
        hue! = 0
    END IF
    hue! = 60 * hue!
    IF hue! < 0 THEN hue! = hue! + 360
    hue! = map(hue!, 0, 360, 0, 255)
END FUNCTION

FUNCTION saturation! (col~&)
    r! = _RED32(col~&)
    g! = _GREEN32(col~&)
    b! = _BLUE32(col~&)
    mx! = max(max(r!, g!), b!)
    mn! = min(min(r!, g!), b!)
    delta! = mx! - mn!
    IF mx! <> 0 THEN
        saturation! = delta! / mx!
    ELSE
        saturation! = 0
    END IF
    saturation! = map(saturation!, 0, 1, 0, 255)
END FUNCTION

FUNCTION lightness! (col~&)
    r! = _RED32(col~&)
    g! = _GREEN32(col~&)
    b! = _BLUE32(col~&)
    mx! = max(max(r!, g!), b!)
    lightness! = mx!
END FUNCTION
 
'can convert hexadecimal colors value to rgb one
'usage col~&  = hexToRgb~&("#ffdf00")
FUNCTION hexToCol~& (h$)
    IF LEN(h$) <> 7 OR LEN(h$) = 0 THEN EXIT FUNCTION
    h$ = RIGHT$(h$, LEN(h$) - 1)
    IF p5Canvas.colorMode = p5HSB THEN hexToCol~& = hsb(VAL("&h" + LEFT$(h$, 2)), VAL("&h" + MID$(h$, 3, 2)), VAL("&h" + RIGHT$(h$, 2)), 255) ELSE hexToCol~& = _RGB32(VAL("&h" + LEFT$(h$, 2)), VAL("&h" + MID$(h$, 3, 2)), VAL("&h" + RIGHT$(h$, 2)))
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
