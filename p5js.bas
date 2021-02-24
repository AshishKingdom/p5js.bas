'p5js.bas by Fellippe & Ashish
'Open source - based on p5.js (https://p5js.org/)
'Requires QB64 1.2 or up

Randomize Timer

'external font rendering lib
Declare Library "falcon"
    Sub uprint_extra (ByVal x&, Byval y&, Byval chars%&, Byval length%&, Byval kern&, Byval do_render&, txt_width&, Byval charpos%&, charcount&, Byval colour~&, Byval max_width&)
    Function uprint (ByVal x&, Byval y&, chars$, Byval txt_len&, Byval colour~&, Byval max_width&)
    Function uprintwidth (chars$, Byval txt_len&, Byval max_width&)
    Function uheight& ()
    Function falcon_uspacing& Alias uspacing ()
    Function uascension& ()
End Declare

Declare Library
    Function millis~& Alias GetTicks
    Sub glutSetCursor (ByVal style&)
End Declare

'p5 constants
Const TWO_PI = 6.283185307179586
Const HALF_PI = 1.570796326794897
Const QUARTER_PI = 0.785398163397448
Const TAU = TWO_PI
Const p5POINTS = 1
Const p5LINES = 2
Const p5CLOSE = 3
Const ROUND = 0
Const SQUARE = 1
Const RADIANS = 4
Const DEGREES = 5
Const CORNER = 6
Const CORNERS = 7
Const p5RGB = 8
Const p5HSB = 9
Const CURSOR_NORMAL = 1
Const CURSOR_HAND = 2
Const CURSOR_HELP = 4
Const CURSOR_CYCLE = 7
Const CURSOR_TEXT = 8
Const CURSOR_CROSSHAIR = 3
Const CURSOR_UP_DOWN = 10
Const CURSOR_LEFT_RIGHT = 11
Const CURSOR_LEFT_RIGHT_CORNER = 16
Const CURSOR_RIGHT_LEFT_CORNER = 17
Const CURSOR_MOVE = 5
Const CURSOR_NONE = 23
Const ARC_DEFAULT = 1
Const ARC_OPEN = 3
Const ARC_CHORD = 5
Const ARC_PIE = 7
'boolean constants
Const true = -1, false = Not true

'p5 global variables
Type new_p5Canvas
    imgHandle As Long
    fontHandle As Long
    stroke As _Unsigned Long
    strokeA As _Unsigned Long
    strokeAlpha As Single
    strokeTexture As Long
    fill As _Unsigned Long
    fillA As _Unsigned Long
    fillAlpha As Single
    fillTexture As Long
    backColor As _Unsigned Long
    backColorA As _Unsigned Long
    backColorAlpha As Single
    strokeWeight As Single
    strokeCap As _Byte
    doStroke As _Byte
    doFill As _Byte
    textAlign As _Byte
    encoding As Long
    rectMode As _Byte
    xOffset As Single
    yOffset As Single
    colorMode As Integer
    angleMode As Integer
End Type

Type vector
    x As Single
    y As Single
    z As Single
End Type

Type __p5Color
    n As String * 32 'name of the color
    c As _Unsigned Long 'color value
End Type


'p5 colors table
Dim Shared p5Colors(135) As __p5Color
p5setColors

'frame rate
Dim Shared frameRate As Single

'canvas settings related variables
Dim Shared p5Canvas As new_p5Canvas, pushState As Long
ReDim Shared p5CanvasBackup(10) As new_p5Canvas

'begin shape related variables
Dim Shared FirstVertex As vector, PreviousVertex As vector, shapeStrokeBackup As _Unsigned Long
Dim Shared shapeAllow As _Byte, shapeType As Long, shapeInit As _Byte, shapeTempFill As _Unsigned Long
Dim Shared tempShapeImage As Long, p5previousDest As Long

'loops and NoLoops
Dim Shared p5Loop As _Byte, p5frameCount As _Unsigned Long
p5Loop = true 'default is true

'mouse consts and variables
Const LEFT = 1, RIGHT = 2, CENTER = 3
Dim Shared mouseIsPressed As _Byte, p5mouseWheel As Integer
Dim Shared mouseButton1 As _Byte, mouseButton2 As _Byte, mouseButton3 As _Byte
Dim Shared mouseButton As _Byte

'keyboard consts and variables
Dim Shared keyIsPressed As _Byte, keyCode As Long
Dim Shared lastKeyCode As Long, totalKeysDown As Integer
Const BACKSPACE = 8, DELETE = 21248, ENTER = 13, TAB_KEY = 9, ESCAPE = 27
Const LSHIFT = 100304, RSHIFT = 100303, LCONTROL = 100306, RCONTROL = 100307
Const LALT = 100308, RALT = 100307
Const UP_ARROW = 18432, DOWN_ARROW = 20480, LEFT_ARROW = 19200, RIGHT_ARROW = 19712

'text-related variables
Dim Shared loadedFontFile$, currentFontSize As Integer
Dim Shared p5LastRenderedCharCount As Long, p5LastRenderedLineWidth As Long
ReDim Shared p5ThisLineChars(0) As Long

'sound system
ReDim Shared loadedSounds(0) As Long
Dim Shared totalLoadedSounds As Long

'noise function related variables
Dim Shared perlin_octaves As Single, perlin_amp_falloff As Single

'timer used to gather input from user
Dim Shared p5InputTimer As Integer
p5InputTimer = _FreeTimer
On Timer(p5InputTimer, .008) gatherInput
Timer(p5InputTimer) On

'default settings
createCanvas 640, 400
_Title "p5js.bas - Untitled sketch"
_Icon
strokeB 0
fillB 255
strokeWeight 1
backgroundB 240
textAlign LEFT
textSize 16 'default builtin font
rectMode CORNER
frameRate = 30
colorMode p5RGB
angleMode RADIANS
doLoop

_Display

Dim a As _Byte 'dummy variable used to call functions that may not be there
a = p5setup
_Display

Do
    If frameRate Then _Limit frameRate
    If p5Loop Then callDrawLoop
    _Display
Loop

'######################################################################################################
'###################### 2D Rendering related methods & functions ######################################
'######################################################################################################

Sub image (img&, __x As Integer, __y As Integer)
    Dim x As Integer, y As Integer
    x = __x + p5Canvas.xOffset
    y = __y + p5Canvas.yOffset

    _PutImage (x, y), img&, 0
End Sub

Sub imageB (img&, x As Integer, y As Integer, w As Integer, h As Integer, sx As Integer, sy As Integer, sw As Integer, sh As Integer)
    _PutImage (x, y)-Step(w, h), img&, 0, (sx, sy)-Step(sw, sh)
End Sub


Sub internalp5makeTempImage
    p5previousDest = _Dest
    If p5previousDest = p5Canvas.imgHandle Then
        _Dest tempShapeImage
        Cls , 0 'clear it and make it transparent
    Else
        _FreeImage tempShapeImage
        tempShapeImage = _NewImage(_Width(p5previousDest), _Height(p5previousDest), 32)
        _Dest tempShapeImage
        Cls , 0 'clear it & make it transparent
    End If
End Sub

Sub internalp5displayTempImage
    If p5previousDest = p5Canvas.imgHandle Then
        _Dest p5previousDest
        _PutImage (0, 0), tempShapeImage
    Else
        _Dest p5previousDest
        _PutImage (0, 0), tempShapeImage
        _FreeImage tempShapeImage
        tempShapeImage = _NewImage(_Width(p5Canvas.imgHandle), _Height(p5Canvas.imgHandle), 32)
    End If
End Sub

Sub beginShape (kind As Long)
    internalp5makeTempImage
    If p5Canvas.doFill Then Cls , p5Canvas.fill
    shapeAllow = true
    shapeType = kind
    shapeStrokeBackup = p5Canvas.strokeA
    shapeTempFill = _RGB32((_Red32(p5Canvas.strokeA) + _Red32(p5Canvas.fillA)) / 2, (_Green32(p5Canvas.strokeA) + _Green32(p5Canvas.fillA)) / 2, (_Blue32(p5Canvas.strokeA) + _Blue32(p5Canvas.fillA)) / 2)
End Sub

Sub vertex (__x As Single, __y As Single)

    Dim x As Single, y As Single

    x = __x + p5Canvas.xOffset
    y = __y + p5Canvas.yOffset

    If shapeInit Then
        If shapeType = p5POINTS Then
            If p5Canvas.doStroke Then CircleFill x, y, p5Canvas.strokeWeight / 2, p5Canvas.strokeA Else CircleFill x, y, p5Canvas.strokeWeight / 2, shapeTempFill
        ElseIf shapeType = p5LINES Then
            If Not p5Canvas.doStroke Then
                Line (PreviousVertex.x, PreviousVertex.y)-(x, y), p5Canvas.strokeA
            Else
                internalp5line PreviousVertex.x, PreviousVertex.y, x, y, p5Canvas.strokeWeight, p5Canvas.strokeA
            End If
        End If
    End If
    If shapeAllow And Not shapeInit Then
        FirstVertex.x = x
        FirstVertex.y = y
        shapeInit = true
        If shapeType = p5POINTS Then
            If p5Canvas.doStroke Then CircleFill x, y, p5Canvas.strokeWeight / 2, p5Canvas.strokeA Else CircleFill x, y, p5Canvas.strokeWeight / 2, shapeTempFill
        End If
        FirstVertex.x = x
        FirstVertex.y = y
    End If
    PreviousVertex.x = x
    PreviousVertex.y = y
End Sub

Sub vertexB (v As vector)
    vertex v.x, v.y
End Sub

Sub endShape (closed)
    'do we have to close it?
    If closed = p5CLOSE And shapeType = p5LINES Then
        If Not p5Canvas.doStroke Then Line (PreviousVertex.x, PreviousVertex.y)-(FirstVertex.x, FirstVertex.y), p5Canvas.stroke Else internalp5line PreviousVertex.x, PreviousVertex.y, FirstVertex.x, FirstVertex.y, p5Canvas.strokeWeight, p5Canvas.strokeA
    End If

    'fill with color
    If p5Canvas.doFill And shapeType = p5LINES And closed = p5CLOSE Then
        _SetAlpha p5Canvas.fillAlpha, p5Canvas.fill
        _SetAlpha p5Canvas.strokeAlpha, p5Canvas.stroke
        Paint (0, 0), shapeTempFill, p5Canvas.strokeA
        Paint (_Width - 1, 0), shapeTempFill, p5Canvas.strokeA
        Paint (0, _Height - 1), shapeTempFill, p5Canvas.strokeA
        Paint (_Width - 1, _Height - 1), shapeTempFill, p5Canvas.strokeA
        _ClearColor shapeTempFill
        If Not p5Canvas.doStroke Then _ClearColor p5Canvas.strokeA
    End If
    p5Canvas.strokeA = shapeStrokeBackup
    'it's time to reset all varibles!!
    shapeAllow = false
    shapeType = 0
    shapeInit = false
    FirstVertex.x = 0
    FirstVertex.y = 0
    PreviousVertex.x = 0
    PreviousVertex.y = 0
    shapeTempFill = 0
    'place shape onto main canvas
    internalp5displayTempImage
End Sub

Sub translate (xoff As Single, yoff As Single)
    p5Canvas.xOffset = p5Canvas.xOffset + xoff
    p5Canvas.yOffset = p5Canvas.yOffset + yoff
End Sub

Sub CircleFill (x As Long, y As Long, R As Long, C As _Unsigned Long)
    Dim x0 As Single, y0 As Single
    Dim e As Single

    x0 = R
    y0 = 0
    e = -R
    Do While y0 < x0
        If e <= 0 Then
            y0 = y0 + 1
            Line (x - x0, y + y0)-(x + x0, y + y0), C, BF
            Line (x - x0, y - y0)-(x + x0, y - y0), C, BF
            e = e + 2 * y0
        Else
            Line (x - y0, y - x0)-(x + y0, y - x0), C, BF
            Line (x - y0, y + x0)-(x + y0, y + x0), C, BF
            x0 = x0 - 1
            e = e - 2 * x0
        End If
    Loop
    Line (x - R, y)-(x + R, y), C, BF
End Sub

Sub thickCircle (x As Single, y As Single, radius As Single, thickness As Single, colour As _Unsigned Long)
    'This sub from STxAxTIC at the #qb64 chatroom on freenode.net
    Dim rp As Single, rm As Single, rp2 As Single, rm2 As Single
    Dim sm As Single, rpi2 As Single, rmi2 As Single, sp As Single
    Dim i As Single

    rp = radius + thickness / 2
    rm = radius - thickness / 2
    rp2 = rp ^ 2
    rm2 = rm ^ 2
    For i = -rp To -rm Step .2
        rpi2 = rp2 - i ^ 2
        sp = Sqr(rpi2)
        Line (x + i, y)-(x + i, y + sp), colour, BF
        Line (x + i, y)-(x + i, y - sp), colour, BF
    Next
    For i = -rm To 0 Step .2
        rpi2 = rp2 - i ^ 2
        rmi2 = rm2 - i ^ 2
        sm = Sqr(rmi2)
        sp = Sqr(rpi2)
        Line (x + i, y + sm)-(x + i, y + sp), colour, BF
        Line (x - i, y + sm)-(x - i, y + sp), colour, BF
        Line (x + i, y - sm)-(x + i, y - sp), colour, BF
        Line (x - i, y - sm)-(x - i, y - sp), colour, BF
    Next
    For i = rm To rp Step .2
        rpi2 = rp2 - i ^ 2
        sp = Sqr(rpi2)
        Line (x + i, y)-(x + i, y + sp), colour, BF
        Line (x + i, y)-(x + i, y - sp), colour, BF
    Next
End Sub

Sub RoundRectFill (x As Single, y As Single, x1 As Single, y1 As Single, r As Single, c As _Unsigned Long)
    'This sub from _vince at the #qb64 chatroom on freenode.net
    Line (x, y + r)-(x1, y1 - r), c, BF

    Dim a As Single, b As Single, e As Single

    a = r
    b = 0
    e = -a

    Do While a >= b
        Line (x + r - b, y + r - a)-(x1 - r + b, y + r - a), c, BF
        Line (x + r - a, y + r - b)-(x1 - r + a, y + r - b), c, BF
        Line (x + r - b, y1 - r + a)-(x1 - r + b, y1 - r + a), c, BF
        Line (x + r - a, y1 - r + b)-(x1 - r + a, y1 - r + b), c, BF

        b = b + 1
        e = e + b + b
        If e > 0 Then
            a = a - 1
            e = e - a - a
        End If
    Loop
End Sub

Sub p5line (__x1 As Single, __y1 As Single, __x2 As Single, __y2 As Single)
    Dim x1 As Single, y1 As Single, x2 As Single, y2 As Single
    Dim a As Single, x0 As Single, y0 As Single

    If Not p5Canvas.doStroke Then Exit Sub

    x1 = __x1 + p5Canvas.xOffset
    y1 = __y1 + p5Canvas.yOffset
    x2 = __x2 + p5Canvas.xOffset
    y2 = __y2 + p5Canvas.xOffset

    If p5Canvas.strokeWeight > 1 Then
        a = _Atan2(y2 - y1, x2 - x1)
        a = a + _Pi / 2
        x0 = 0.5 * p5Canvas.strokeWeight * Cos(a)
        y0 = 0.5 * p5Canvas.strokeWeight * Sin(a)


        _MapTriangle _Seamless(0, 0)-(0, 0)-(0, 0), p5Canvas.strokeTexture To(x1 - x0, y1 - y0)-(x1 + x0, y1 + y0)-(x2 + x0, y2 + y0), , _Smooth
        _MapTriangle _Seamless(0, 0)-(0, 0)-(0, 0), p5Canvas.strokeTexture To(x1 - x0, y1 - y0)-(x2 + x0, y2 + y0)-(x2 - x0, y2 - y0), , _Smooth

        If p5Canvas.strokeCap = ROUND Then
            CircleFill x1, y1, p5Canvas.strokeWeight / 2, p5Canvas.strokeA
            CircleFill x2, y2, p5Canvas.strokeWeight / 2, p5Canvas.strokeA
        End If
    Else
        Line (x1, y1)-(x2, y2), p5Canvas.strokeA
    End If
End Sub

Sub p5point (x As Single, y As Single)
    If Not p5Canvas.doStroke Then Exit Sub

    If p5Canvas.strokeWeight > 1 Then
        CircleFill x + p5Canvas.xOffset, y + p5Canvas.yOffset, p5Canvas.strokeWeight / 2, p5Canvas.strokeA
    Else
        PSet (x + p5Canvas.xOffset, y + p5Canvas.yOffset), p5Canvas.strokeA
    End If
End Sub

Sub p5ellipse (__x As Single, __y As Single, xr As Single, yr As Single)
    Dim x As Single, y As Single

    If Not p5Canvas.doFill And Not p5Canvas.doStroke Then Exit Sub

    x = __x + p5Canvas.xOffset
    y = __y + p5Canvas.yOffset

    If xr <> yr Then
        internalp5makeTempImage
        If p5Canvas.doStroke Then
            Circle (x, y), xr + p5Canvas.strokeWeight, p5Canvas.stroke, , , xr / yr
            Paint (x, y), p5Canvas.stroke, p5Canvas.stroke
            _SetAlpha p5Canvas.strokeAlpha, p5Canvas.stroke
        End If

        If p5Canvas.doFill Then
            Circle (x, y), xr - p5Canvas.strokeWeight / 2, p5Canvas.fill, , , xr / yr
            Paint (x, y), p5Canvas.fill, p5Canvas.fill
            _SetAlpha p5Canvas.fillAlpha, p5Canvas.fill
        Else
            'no fill
            Dim tempColor~&
            If _Red32(p5Canvas.stroke) > 0 Then tempColor~& = _RGB32(_Red32(p5Canvas.stroke) - 1, _Green32(p5Canvas.stroke), _Blue32(p5Canvas.stroke)) Else tempColor~& = _RGB32(_Red32(p5Canvas.stroke) + 1, _Green32(p5Canvas.stroke), _Blue32(p5Canvas.stroke))
            Circle (x, y), xr - p5Canvas.strokeWeight / 2, tempColor~&, , , xr / yr
            Paint (x, y), tempColor~&, tempColor~&
            _ClearColor tempColor~&
        End If
        internalp5displayTempImage
    Else
        If p5Canvas.doFill Then CircleFill x, y, xr, p5Canvas.fillA
        If p5Canvas.doStroke Then thickCircle x, y, xr, p5Canvas.strokeWeight, p5Canvas.strokeA
    End If

End Sub

Sub p5triangle (__x1!, __y1!, __x2!, __y2!, __x3!, __y3!)
    Dim x1!, y1!, x2!, y2!, x3!, y3!
    If Not p5Canvas.doFill And Not p5Canvas.doStroke Then Exit Sub

    x1! = __x1! + p5Canvas.xOffset
    y1! = __y1! + p5Canvas.yOffset
    x2! = __x2! + p5Canvas.xOffset
    y2! = __y2! + p5Canvas.yOffset
    x3! = __x3! + p5Canvas.xOffset
    y3! = __y3! + p5Canvas.yOffset

    If p5Canvas.doFill Then
        _MapTriangle (0, 0)-(0, 0)-(0, 0), p5Canvas.fillTexture To(x1!, y1!)-(x2!, y2!)-(x3!, y3!), , _Smooth
    End If

    If p5Canvas.doStroke Then
        p5line __x1!, __y1!, __x2!, __y2!
        p5line __x2!, __y2!, __x3!, __y3!
        p5line __x3!, __y3!, __x1!, __y1!
    End If
End Sub

Sub p5triangleB (v1 As vector, v2 As vector, v3 As vector)
    p5triangle v1.x, v1.y, v2.x, v2.y, v3.x, v3.y
End Sub

'draw a triangle by joining 3 different angles from the center point with
'a given size
Sub p5triangleC (__centerX!, __centerY!, __ang1!, __ang2!, __ang3!, size!)
    Dim x1!, y1!, x2!, y2!, x3!, y3!
    Dim ang1!, ang2!, ang3!
    Dim centerX!, centerY!

    centerX! = __centerX! + p5Canvas.xOffset
    centerY! = __centerY! + p5Canvas.yOffset

    If p5Canvas.angleMode = RADIANS Then
        ang1! = __ang1!
        ang2! = __ang2!
        ang3! = __ang3!
    Else
        ang1! = _D2R(__ang1!)
        ang2! = _D2R(__ang2!)
        ang3! = _D2R(__ang3!)
    End If

    If ang1! < TWO_PI Then
        x1! = centerX! - size! * Cos(ang1!)
        y1! = centerY! + size! * Sin(ang1!)
    End If

    If ang2! < TWO_PI Then
        x2! = centerX! - size! * Cos(ang2!)
        y2! = centerY! - size! * Sin(ang2!)
    End If

    If ang3! < TWO_PI Then
        x3! = centerX! + size! * Cos(ang3!)
        y3! = centerY! - size! * Sin(ang3!)
    End If

    p5triangle x1!, y1!, x2!, y2!, x3!, y3!
End Sub

'draws a rectangle
Sub p5rect (x!, y!, __wi!, __he!)
    Dim wi!, he!
    Dim x1!, y1!

    If Not p5Canvas.doFill And Not p5Canvas.doStroke Then Exit Sub

    wi! = __wi!
    he! = __he!

    internalp5makeTempImage

    If p5Canvas.rectMode = CORNER Or p5Canvas.rectMode = CORNERS Then
        'default mode
        x1! = x! + p5Canvas.xOffset
        y1! = y! + p5Canvas.yOffset

        If p5Canvas.rectMode = CORNERS Then
            wi! = wi! + p5Canvas.xOffset
            he! = he! + p5Canvas.yOffset
        End If
    ElseIf p5Canvas.rectMode = CENTER Then
        x1! = x! - wi! / 2 + p5Canvas.xOffset
        y1! = y! - he! / 2 + p5Canvas.yOffset
    End If

    Dim tempColor~&
    If _Red32(p5Canvas.stroke) > 0 Then tempColor~& = _RGB32(_Red32(p5Canvas.stroke) - 1, _Green32(p5Canvas.stroke), _Blue32(p5Canvas.stroke)) Else tempColor~& = _RGB32(_Red32(p5Canvas.stroke) + 1, _Green32(p5Canvas.stroke), _Blue32(p5Canvas.stroke))

    If p5Canvas.rectMode = CORNER Or p5Canvas.rectMode = CENTER Then
        If p5Canvas.doStroke Then
            Line (x1! - _Ceil(p5Canvas.strokeWeight / 2), y1! - _Ceil(p5Canvas.strokeWeight / 2))-(x1! + wi! + _Ceil(p5Canvas.strokeWeight / 2) - 1, y1! + he! + _Ceil(p5Canvas.strokeWeight / 2) - 1), p5Canvas.strokeA, BF
            Line (x1! + _Ceil(p5Canvas.strokeWeight / 2), y1! + _Ceil(p5Canvas.strokeWeight / 2))-(x1! + wi! - _Ceil(p5Canvas.strokeWeight / 2) - 1, y1! + he! - _Ceil(p5Canvas.strokeWeight / 2) - 1), tempColor~&, BF
            _ClearColor tempColor~&
        End If

        If p5Canvas.doFill Then
            If p5Canvas.doStroke And p5Canvas.fillAlpha < 255 Then
                Line (x1!, y1!)-Step(wi! - 1, he! - 1), tempColor~&, BF
                _ClearColor tempColor~&
            End If

            Line (x1!, y1!)-Step(wi! - 1, he! - 1), p5Canvas.fillA, BF
        End If
    Else
        'CORNERS - consider width and height values as coordinates instead
        If p5Canvas.doStroke Then
            Line (x1! - _Ceil(p5Canvas.strokeWeight / 2), y1! - _Ceil(p5Canvas.strokeWeight / 2))-(wi! + _Ceil(p5Canvas.strokeWeight / 2) - 1, he! + _Ceil(p5Canvas.strokeWeight / 2) - 1), p5Canvas.strokeA, BF
            Line (x1! + _Ceil(p5Canvas.strokeWeight / 2), y1! + _Ceil(p5Canvas.strokeWeight / 2))-(wi! - _Ceil(p5Canvas.strokeWeight / 2) - 1, he! - _Ceil(p5Canvas.strokeWeight / 2) - 1), tempColor~&, BF
            _ClearColor tempColor~&
        End If

        If p5Canvas.doFill Then
            If p5Canvas.doStroke And p5Canvas.fillAlpha < 255 Then
                Line (x1!, y1!)-(wi!, he!), tempColor~&, BF
                _ClearColor tempColor~&
            End If

            Line (x1!, y1!)-(wi!, he!), p5Canvas.fillA, BF
        End If
    End If

    internalp5displayTempImage
End Sub

'draws a rectangle with rounded corners (r! is the amount)
Sub p5rectB (x!, y!, __wi!, __he!, r!)
    Dim wi!, he!
    Dim x1!, y1!

    If Not p5Canvas.doFill And Not p5Canvas.doStroke Then Exit Sub

    wi! = __wi!
    he! = __he!

    internalp5makeTempImage

    If p5Canvas.rectMode = CORNER Or p5Canvas.rectMode = CORNERS Then
        'default mode
        x1! = x! + p5Canvas.xOffset
        y1! = y! + p5Canvas.yOffset

        If p5Canvas.rectMode = CORNERS Then
            wi! = wi! + p5Canvas.xOffset
            he! = he! + p5Canvas.yOffset
        End If
    ElseIf p5Canvas.rectMode = CENTER Then
        x1! = x! - wi! / 2 + p5Canvas.xOffset
        y1! = y! - he! / 2 + p5Canvas.yOffset
    End If

    Dim tempColor~&
    If _Red32(p5Canvas.stroke) > 0 Then tempColor~& = _RGB32(_Red32(p5Canvas.stroke) - 1, _Green32(p5Canvas.stroke), _Blue32(p5Canvas.stroke)) Else tempColor~& = _RGB32(_Red32(p5Canvas.stroke) + 1, _Green32(p5Canvas.stroke), _Blue32(p5Canvas.stroke))

    If p5Canvas.rectMode = CORNER Or p5Canvas.rectMode = CENTER Then
        If p5Canvas.doStroke Then
            RoundRectFill x1! - _Ceil(p5Canvas.strokeWeight / 2), y1! - _Ceil(p5Canvas.strokeWeight / 2), x1! + wi! + _Ceil(p5Canvas.strokeWeight / 2), y1! + he! + _Ceil(p5Canvas.strokeWeight / 2), r!, p5Canvas.stroke
            _SetAlpha p5Canvas.strokeAlpha, p5Canvas.stroke

            RoundRectFill x1! + _Ceil(p5Canvas.strokeWeight / 2), y1! + _Ceil(p5Canvas.strokeWeight / 2), x1! + wi! - _Ceil(p5Canvas.strokeWeight / 2), y1! + he! - _Ceil(p5Canvas.strokeWeight / 2), r!, tempColor~&
            _ClearColor tempColor~&
        End If

        If p5Canvas.doFill Then
            If p5Canvas.doStroke And p5Canvas.fillAlpha < 255 Then
                RoundRectFill x1!, y1!, x1! + wi! - 1, he!, r!, tempColor~&
                _ClearColor tempColor~&
            End If

            RoundRectFill x1!, y1!, x1! + wi! - 1, y1! + he! - 1, r!, p5Canvas.fill
            _SetAlpha p5Canvas.fillAlpha, p5Canvas.fill
        End If
    Else
        'CORNERS - consider width and height values as coordinates instead
        If p5Canvas.doStroke Then
            RoundRectFill x1! - _Ceil(p5Canvas.strokeWeight / 2), y1! - _Ceil(p5Canvas.strokeWeight / 2), wi! + _Ceil(p5Canvas.strokeWeight / 2), he! + _Ceil(p5Canvas.strokeWeight / 2), r!, p5Canvas.stroke
            _SetAlpha p5Canvas.strokeAlpha, p5Canvas.stroke

            RoundRectFill x1! + _Ceil(p5Canvas.strokeWeight / 2), y1! + _Ceil(p5Canvas.strokeWeight / 2), wi! - _Ceil(p5Canvas.strokeWeight / 2), he! - _Ceil(p5Canvas.strokeWeight / 2), r!, tempColor~&
            _ClearColor tempColor~&
        End If

        If p5Canvas.doFill Then
            If p5Canvas.doStroke And p5Canvas.fillAlpha < 255 Then
                RoundRectFill x1!, y1!, wi!, he!, r!, tempColor~&
                _ClearColor tempColor~&
            End If

            RoundRectFill x1!, y1!, wi!, he!, r!, p5Canvas.fill
            _SetAlpha p5Canvas.fillAlpha, p5Canvas.fill
        End If
    End If

    internalp5displayTempImage
End Sub

Sub rectMode (mode As _Byte)
    p5Canvas.rectMode = mode
End Sub

'draws a quadrilateral
Sub p5quad (__x1!, __y1!, __x2!, __y2!, __x3!, __y3!, __x4!, __y4!)
    If Not p5Canvas.doStroke And Not p5Canvas.doFill Then Exit Sub

    Dim x1!, y1!, x2!, y2!, x3!, y3!, x4!, y4!
    Dim tempColor~&, tempFill~&

    x1! = __x1! + p5Canvas.xOffset
    y1! = __y1! + p5Canvas.yOffset
    x2! = __x2! + p5Canvas.xOffset
    y2! = __y2! + p5Canvas.yOffset
    x3! = __x3! + p5Canvas.xOffset
    y3! = __y3! + p5Canvas.yOffset
    x4! = __x4! + p5Canvas.xOffset
    y4! = __y4! + p5Canvas.yOffset

    If _Red32(p5Canvas.stroke) > 0 Then tempColor~& = _RGB32(_Red32(p5Canvas.stroke) - 1, _Green32(p5Canvas.stroke), _Blue32(p5Canvas.stroke)) Else tempColor~& = _RGB32(_Red32(p5Canvas.stroke) + 1, _Green32(p5Canvas.stroke), _Blue32(p5Canvas.stroke))
    If _Red32(p5Canvas.fill) > 0 Then tempFill~& = _RGB32(_Red32(p5Canvas.fill) - 1, _Green32(p5Canvas.fill), _Blue32(p5Canvas.fill)) Else tempFill~& = _RGB32(_Red32(p5Canvas.fill) + 1, _Green32(p5Canvas.fill), _Blue32(p5Canvas.fill))

    internalp5makeTempImage
    If p5Canvas.doFill Then
        Cls , p5Canvas.fill
    End If
    If p5Canvas.doStroke Then
        internalp5line x1!, y1!, x2!, y2!, p5Canvas.strokeWeight / 2, p5Canvas.stroke
        internalp5line x2!, y2!, x3!, y3!, p5Canvas.strokeWeight / 2, p5Canvas.stroke
        internalp5line x3!, y3!, x4!, y4!, p5Canvas.strokeWeight / 2, p5Canvas.stroke
        internalp5line x4!, y4!, x1!, y1!, p5Canvas.strokeWeight / 2, p5Canvas.stroke
    Else
        internalp5line x1!, y1!, x2!, y2!, p5Canvas.strokeWeight / 2, tempColor~&
        internalp5line x2!, y2!, x3!, y3!, p5Canvas.strokeWeight / 2, tempColor~&
        internalp5line x3!, y3!, x4!, y4!, p5Canvas.strokeWeight / 2, tempColor~&
        internalp5line x4!, y4!, x1!, y1!, p5Canvas.strokeWeight / 2, tempColor~&
    End If

    If p5Canvas.doFill Then
        If p5Canvas.doStroke Then
            Paint (0, 0), tempFill~&, p5Canvas.stroke
            Paint (_Width, 0), tempFill~&, p5Canvas.stroke
            Paint (0, _Height), tempFill~&, p5Canvas.stroke
            Paint (_Width, _Height), tempFill~&, p5Canvas.stroke
        Else
            Paint (0, 0), tempFill~&, tempColor~&
            Paint (_Width, 0), tempFill~&, tempColor~&
            Paint (0, _Height), tempFill~&, tempColor~&
            Paint (_Width, _Height), tempFill~&, tempColor~&
        End If
    End If

    _ClearColor tempFill~&
    _ClearColor tempColor~&

    _SetAlpha p5Canvas.strokeAlpha, p5Canvas.stroke
    _SetAlpha p5Canvas.fillAlpha, p5Canvas.fill

    internalp5displayTempImage
End Sub

'draws a bezier curve
'method by Ashish
Sub p5bezier (__x0!, __y0!, __x1!, __y1!, __x2!, __y2!, __x3!, __y3!)
    If Not p5Canvas.doStroke And Not p5Canvas.doFill Then Exit Sub

    Dim x0!, x1!, x2!, x3!
    Dim y0!, y1!, y2!, y3!
    Dim cx!, ax!, bx!
    Dim cy!, ay!, by!
    Dim tempColor~&, tempFill~&
    Dim t#, xt!, yt!

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

    Dim s As Double
    s = .001

    internalp5makeTempImage

    If _Red32(p5Canvas.stroke) > 0 Then tempColor~& = _RGB32(_Red32(p5Canvas.stroke) - 1, _Green32(p5Canvas.stroke), _Blue32(p5Canvas.stroke)) Else tempColor~& = _RGB32(_Red32(p5Canvas.stroke) + 1, _Green32(p5Canvas.stroke), _Blue32(p5Canvas.stroke))
    If _Red32(p5Canvas.fill) > 0 Then tempFill~& = _RGB32(_Red32(p5Canvas.fill) - 1, _Green32(p5Canvas.fill), _Blue32(p5Canvas.fill)) Else tempFill~& = _RGB32(_Red32(p5Canvas.fill) + 1, _Green32(p5Canvas.fill), _Blue32(p5Canvas.fill))

    If p5Canvas.doFill Then
        Cls , p5Canvas.fill
        If p5Canvas.doStroke Then Line (x0!, y0!)-(x3!, y3!), p5Canvas.stroke Else Line (x0!, y0!)-(x3!, y3!), tempColor~&
    End If

    For t# = 0 To 1 - s Step s
        xt! = ax! * (t# * t# * t#) + bx! * (t# * t#) + cx! * t# + x0!
        yt! = ay! * (t# * t# * t#) + by! * (t# * t#) + cy! * t# + y0!
        If p5Canvas.doStroke Then CircleFill xt!, yt!, p5Canvas.strokeWeight / 2, p5Canvas.stroke Else CircleFill xt!, yt!, p5Canvas.strokeWeight / 2, tempColor~&
    Next

    If p5Canvas.doFill Then
        If p5Canvas.doStroke Then
            Paint (0, 0), tempFill~&, p5Canvas.stroke
            Paint (_Width, 0), tempFill~&, p5Canvas.stroke
            Paint (0, _Height), tempFill~&, p5Canvas.stroke
            Paint (_Width, _Height), tempFill~&, p5Canvas.stroke
        Else
            Paint (0, 0), tempFill~&, tempColor~&
            Paint (_Width, 0), tempFill~&, tempColor~&
            Paint (0, _Height), tempFill~&, tempColor~&
            Paint (_Width, _Height), tempFill~&, tempColor~&
        End If
    End If

    _ClearColor tempFill~&

    If Not p5Canvas.doStroke Then _ClearColor tempColor~&: GoTo internal_p5_bezier_display

    If p5Canvas.doFill Then
        If p5Canvas.doStroke Then _ClearColor p5Canvas.stroke Else _ClearColor tempColor~&
        For t# = 0 To 1 - s Step s
            xt! = ax! * (t# * t# * t#) + bx! * (t# * t#) + cx! * t# + x0!
            yt! = ay! * (t# * t# * t#) + by! * (t# * t#) + cy! * t# + y0!
            If p5Canvas.doStroke Then CircleFill xt!, yt!, p5Canvas.strokeWeight / 2, p5Canvas.stroke Else CircleFill xt!, yt!, p5Canvas.strokeWeight / 2, tempColor~&
        Next
    End If

    internal_p5_bezier_display:::

    _SetAlpha p5Canvas.fillAlpha, p5Canvas.fill
    _SetAlpha p5Canvas.strokeAlpha, p5Canvas.stroke

    internalp5displayTempImage

End Sub

Sub p5curve (__x0!, __y0!, __x1!, __y1!, __x2!, __y2!, __x3!, __y3!)

    If Not p5Canvas.doStroke Or Not p5Canvas.doFill And Not p5Canvas.doStroke Then Exit Sub

    Dim x0!, x1!, x2!, x3!
    Dim y0!, y1!, y2!, y3!
    Dim tempFill~&
    Dim t#, xt!, yt!

    x0! = __x0! + p5Canvas.xOffset
    x1! = __x1! + p5Canvas.xOffset
    x2! = __x2! + p5Canvas.xOffset
    x3! = __x3! + p5Canvas.xOffset

    y0! = __y0! + p5Canvas.yOffset
    y1! = __y1! + p5Canvas.yOffset
    y2! = __y2! + p5Canvas.yOffset
    y3! = __y3! + p5Canvas.yOffset

    internalp5makeTempImage

    If _Red32(p5Canvas.fill) > 0 Then tempFill~& = _RGB32(_Red32(p5Canvas.fill) - 1, _Green32(p5Canvas.fill), _Blue32(p5Canvas.fill)) Else tempFill~& = _RGB32(_Red32(p5Canvas.fill) + 1, _Green32(p5Canvas.fill), _Blue32(p5Canvas.fill))

    If p5Canvas.doFill Then Cls , p5Canvas.fill: Line (x1!, y1!)-(x2!, y2!), p5Canvas.stroke
    Dim s As Double
    s = .001
    For t# = 0 To 1 - s Step s
        xt! = 0.5 * ((2 * x1!) + (-x0! + x2!) * t# + (2 * x0! - 5 * x1! + 4 * x2! - x3!) * (t# * t#) + (-x0! + 3 * x1! - 3 * x2! + x3!) * (t# * t# * t#))
        yt! = 0.5 * ((2 * y1!) + (-y0! + y2!) * t# + (2 * y0! - 5 * y1! + 4 * y2! - y3!) * (t# * t#) + (-y0! + 3 * y1! - 3 * y2! + y3!) * (t# * t# * t#))
        CircleFill xt!, yt!, p5Canvas.strokeWeight / 2, p5Canvas.stroke
    Next

    If Not p5Canvas.doFill Then GoTo internal_p5_curve_display

    If p5Canvas.doFill Then
        Paint (0, 0), tempFill~&, p5Canvas.stroke
        Paint (_Width, 0), tempFill~&, p5Canvas.stroke
        Paint (0, _Height), tempFill~&, p5Canvas.stroke
        Paint (_Width, _Height), tempFill~&, p5Canvas.stroke
    End If

    _ClearColor tempFill~&
    If p5Canvas.doFill Then
        _ClearColor p5Canvas.stroke
        For t# = 0 To 1 - s Step s
            xt! = 0.5 * ((2 * x1!) + (-x0! + x2!) * t# + (2 * x0! - 5 * x1! + 4 * x2! - x3!) * (t# * t#) + (-x0! + 3 * x1! - 3 * x2! + x3!) * (t# * t# * t#))
            yt! = 0.5 * ((2 * y1!) + (-y0! + y2!) * t# + (2 * y0! - 5 * y1! + 4 * y2! - y3!) * (t# * t#) + (-y0! + 3 * y1! - 3 * y2! + y3!) * (t# * t# * t#))
            CircleFill xt!, yt!, p5Canvas.strokeWeight / 2, p5Canvas.stroke
        Next
    End If

    internal_p5_curve_display:::

    _SetAlpha p5Canvas.strokeAlpha, p5Canvas.stroke
    _SetAlpha p5Canvas.fillAlpha, p5Canvas.fill

    internalp5displayTempImage
End Sub

Sub p5arc (__x!, __y!, w!, h!, start##, stp##, mode)
    If Not p5Canvas.doFill And Not p5Canvas.doStroke Then Exit Sub

    Dim x!, y!, spt##
    Dim x0!, y0!, x1!, y1!
    Dim xx!, yy!
    Dim i##
    Dim tempColor~&, tempFill~&

    x! = __x! + p5Canvas.xOffset
    y! = __y! + p5Canvas.yOffset

    If p5Canvas.angleMode = DEGREES Then start## = p5degrees(start##): spt## = p5degrees(spt##)

    If _Red32(p5Canvas.stroke) > 0 Then tempColor~& = _RGB32(_Red32(p5Canvas.stroke) - 1, _Green32(p5Canvas.stroke), _Blue32(p5Canvas.stroke)) Else tempColor~& = _RGB32(_Red32(p5Canvas.stroke) + 1, _Green32(p5Canvas.stroke), _Blue32(p5Canvas.stroke))
    If _Red32(p5Canvas.fill) > 0 Then tempFill~& = _RGB32(_Red32(p5Canvas.fill) - 1, _Green32(p5Canvas.fill), _Blue32(p5Canvas.fill)) Else tempFill~& = _RGB32(_Red32(p5Canvas.fill) + 1, _Green32(p5Canvas.fill), _Blue32(p5Canvas.fill))

    x0! = x! + w! * p5cos(start##)
    y0! = y! + h! * p5sin(start##)
    x1! = x! + w! * p5cos(stp##)
    y1! = y! + h! * p5sin(stp##)

    internalp5makeTempImage

    If p5Canvas.doFill Then
        Cls , p5Canvas.fill
        If p5Canvas.doStroke Then
            If mode = ARC_DEFAULT Or mode = ARC_PIE Then
                Line (x!, y!)-(x0!, y0!), p5Canvas.stroke
                Line (x!, y!)-(x1!, y1!), p5Canvas.stroke
            ElseIf mode = ARC_OPEN Or mode = ARC_CHORD Then
                Line (x0!, y0!)-(x1!, y1!), p5Canvas.stroke
            End If
        Else
            If mode = ARC_DEFAULT Or mode = ARC_PIE Then
                Line (x!, y!)-(x0!, y0!), tempColor~&
                Line (x!, y!)-(x1!, y1!), tempColor~&
            ElseIf mode = ARC_OPEN Or mode = ARC_CHORD Then
                Line (x0!, y0!)-(x1!, y1!), tempColor~&
            End If
        End If
    End If

    For i## = start## To stp## Step .001
        xx! = x! + w! * p5cos(i##)
        yy! = y! + h! * p5sin(i##)
        If p5Canvas.doStroke Then CircleFill xx!, yy!, p5Canvas.strokeWeight / 2, p5Canvas.stroke Else CircleFill xx!, yy!, p5Canvas.strokeWeight / 2, tempColor~&
    Next

    If p5Canvas.doFill Then
        If p5Canvas.doStroke Then
            Paint (0, 0), tempFill~&, p5Canvas.stroke
            Paint (_Width, 0), tempFill~&, p5Canvas.stroke
            Paint (0, _Height), tempFill~&, p5Canvas.stroke
            Paint (_Width, _Height), tempFill~&, p5Canvas.stroke
        Else
            Paint (0, 0), tempFill~&, tempColor~&
            Paint (_Width, 0), tempFill~&, tempColor~&
            Paint (0, _Height), tempFill~&, tempColor~&
            Paint (_Width, _Height), tempFill~&, tempColor~&
        End If
    End If
    _ClearColor tempFill~&

    If p5Canvas.doStroke Then
        If mode = ARC_CHORD Then internalp5line x0!, y0!, x1!, y1!, p5Canvas.strokeWeight / 2, p5Canvas.stroke
        If mode = ARC_PIE Then internalp5line x0!, y0!, x!, y!, p5Canvas.strokeWeight / 2, p5Canvas.stroke: internalp5line x1!, y1!, x!, y!, p5Canvas.strokeWeight / 2, p5Canvas.stroke
    End If

    If p5Canvas.doFill Then
        If p5Canvas.doStroke Then _ClearColor p5Canvas.stroke Else _ClearColor tempColor~&
        If p5Canvas.doStroke Then
            If mode = ARC_CHORD Then internalp5line x0!, y0!, x1!, y1!, p5Canvas.strokeWeight / 2, p5Canvas.stroke
            If mode = ARC_PIE Then internalp5line x0!, y0!, x!, y!, p5Canvas.strokeWeight / 2, p5Canvas.stroke: internalp5line x1!, y1!, x!, y!, p5Canvas.strokeWeight / 2, p5Canvas.stroke
        End If
        If Not p5Canvas.doStroke Then GoTo internal_p5_arc_display
        For i## = start## To stp## Step .001
            xx! = x! + w! * p5cos(i##)
            yy! = y! + h! * p5sin(i##)
            If p5Canvas.doStroke Then CircleFill xx!, yy!, p5Canvas.strokeWeight / 2, p5Canvas.stroke Else CircleFill xx!, yy!, p5Canvas.strokeWeight / 2, tempColor~&
        Next
    End If

    internal_p5_arc_display:::
    _SetAlpha p5Canvas.strokeAlpha, p5Canvas.stroke
    _SetAlpha p5Canvas.fillAlpha, p5Canvas.fill

    internalp5displayTempImage
End Sub

Sub internalp5line (__x0!, __y0!, __x1!, __y1!, s!, col~&)
    Dim x1 As Single, y1 As Single, x2 As Single, y2 As Single
    Dim a As Single, x0 As Single, y0 As Single
    Dim tempTexture As Long, prevDest As Long

    x1 = __x0!
    y1 = __y0!
    x2 = __x1!
    y2 = __y1!

    a = _Atan2(y2 - y1, x2 - x1)
    a = a + _Pi / 2
    x0 = 0.5 * p5Canvas.strokeWeight * Cos(a)
    y0 = 0.5 * p5Canvas.strokeWeight * Sin(a)

    tempTexture = _NewImage(1, 1, 32)
    prevDest = _Dest
    _Dest tempTexture
    PSet (0, 0), col~&
    _Dest prevDest

    _MapTriangle (0, 0)-(0, 0)-(0, 0), tempTexture To(x1 - x0, y1 - y0)-(x1 + x0, y1 + y0)-(x2 + x0, y2 + y0), , _Smooth
    _MapTriangle (0, 0)-(0, 0)-(0, 0), tempTexture To(x1 - x0, y1 - y0)-(x2 + x0, y2 + y0)-(x2 - x0, y2 - y0), , _Smooth

    If p5Canvas.strokeCap = ROUND Then
        CircleFill x1, y1, s! / 2, col~&
        CircleFill x2, y2, s! / 2, col~&
    End If

    _FreeImage tempTexture
End Sub

Sub strokeWeight (a As Single)
    If a = 0 Then
        noStroke
    Else
        p5Canvas.strokeWeight = a
    End If
End Sub

Sub strokeCap (setting As _Byte)
    p5Canvas.strokeCap = setting
End Sub

Sub background (r As Single, g As Single, b As Single)
    If p5Canvas.colorMode = p5HSB Then p5Canvas.backColor = hsb(r, g, b, 255) Else p5Canvas.backColor = _RGB32(r, g, b)
    p5Canvas.backColorAlpha = 255
    Line (0, 0)-(_Width, _Height), p5Canvas.backColor, BF
End Sub

Sub backgroundA (r As Single, g As Single, b As Single, a As Single)
    If p5Canvas.colorMode = p5HSB Then
        p5Canvas.backColor = hsb(r, g, b, a)
        p5Canvas.backColorA = hsb(r, g, b, a)
    Else
        p5Canvas.backColor = _RGB32(r, g, b)
        p5Canvas.backColorA = _RGBA32(r, g, b, a)
    End If
    p5Canvas.backColorAlpha = constrain(a, 0, 255)
    Line (0, 0)-(_Width, _Height), p5Canvas.backColorA, BF
End Sub

Sub backgroundN (c$)
    Dim c~&
    c~& = colorN(c$)
    p5Canvas.backColor = c~&
    p5Canvas.backColorA = c~&
    p5Canvas.backColorAlpha = 255
    Line (0, 0)-(_Width, _Height), p5Canvas.backColorA, BF
End Sub

Sub backgroundNA (c$, a!)
    Dim c~&
    c~& = colorNA(c$, a!)
    p5Canvas.backColor = _RGB32(_Red32(c~&), _Green32(c~&), _Blue32(c~&))
    p5Canvas.backColorA = c~&
    p5Canvas.backColorAlpha = _Alpha32(c~&)
    Line (0, 0)-(_Width, _Height), p5Canvas.backColorA, BF
End Sub

Sub backgroundB (b As Single)
    p5Canvas.backColor = _RGB32(b, b, b)
    p5Canvas.backColorAlpha = 255
    Line (0, 0)-(_Width, _Height), p5Canvas.backColor, BF
End Sub

Sub backgroundBA (b As Single, a As Single)
    p5Canvas.backColor = _RGB32(b, b, b)
    p5Canvas.backColorA = _RGBA32(b, b, b, a)
    p5Canvas.backColorAlpha = constrain(a, 0, 255)
    Line (0, 0)-(_Width, _Height), p5Canvas.backColorA, BF
End Sub

Sub backgroundC (col~&)
    p5Canvas.backColor = _RGB32(_Red32(col~&), _Green32(col~&), _Blue32(col~&))
    p5Canvas.backColorA = _RGBA32(_Red32(col~&), _Green32(col~&), _Blue32(col~&), _Alpha32(col~&))
    p5Canvas.backColorAlpha = constrain(_Alpha32(col~&), 0, 255)
    Line (0, 0)-(_Width, _Height), p5Canvas.backColorA, BF
End Sub
'#####################################################################################################
'########################## Text Rendering Related methods & functions ###############################
'#####################################################################################################

Sub textAlign (position As _Byte)
    p5Canvas.textAlign = position
End Sub

Sub textFont (font$)
    Dim tempFontHandle As Long

    If currentFontSize = 0 Then currentFontSize = 16

    If font$ <> loadedFontFile$ Then
        tempFontHandle = _LoadFont(font$, currentFontSize)

        If tempFontHandle > 0 Then
            'loading successful
            _Font tempFontHandle
            If p5Canvas.fontHandle > 0 And (p5Canvas.fontHandle <> 8 And p5Canvas.fontHandle <> 16) Then _FreeFont p5Canvas.fontHandle
            p5Canvas.fontHandle = tempFontHandle

            loadedFontFile$ = font$
        Else
            loadedFontFile$ = ""
            'built-in fonts
            If currentFontSize >= 16 Then
                _Font 16
            ElseIf currentFontSize < 16 Then
                _Font 8
            End If

            If p5Canvas.fontHandle > 0 And (p5Canvas.fontHandle <> 8 And p5Canvas.fontHandle <> 16) Then _FreeFont p5Canvas.fontHandle
            p5Canvas.fontHandle = _Font
        End If
    End If
End Sub

Sub textSize (size%)
    Dim tempFontHandle As Long

    If size% = currentFontSize Or size% <= 0 Then Exit Sub

    If loadedFontFile$ = "" Then
        'built-in fonts
        If size% >= 16 Then
            _Font 16
            p5Canvas.fontHandle = 16
        ElseIf size% < 16 Then
            _Font 8
            p5Canvas.fontHandle = 8
        End If
    Else
        tempFontHandle = _LoadFont(loadedFontFile$, size%)

        If tempFontHandle > 0 Then
            'loading successful
            _Font tempFontHandle
            If p5Canvas.fontHandle > 0 And (p5Canvas.fontHandle <> 8 And p5Canvas.fontHandle <> 16) Then _FreeFont p5Canvas.fontHandle
            p5Canvas.fontHandle = tempFontHandle

            currentFontSize = size%
        End If
    End If
End Sub

Sub text (t$, __x As Single, __y As Single)
    Dim x As Single, y As Single

    x = __x + p5Canvas.xOffset
    y = __y + p5Canvas.yOffset

    Select Case p5Canvas.textAlign
        Case LEFT
            p5PrintString x, y, t$
        Case CENTER
            p5PrintString x - PrintWidth(t$) / 2, y - uheight / 2, t$
        Case RIGHT
            p5PrintString x - PrintWidth(t$), y, t$
    End Select
End Sub

Sub p5PrintString (Left As Integer, Top As Integer, theText$)
    Dim Utf$

    If p5Canvas.encoding = 1252 Then
        Utf$ = FromCP1252$(theText$)
    Else 'Default to 437
        Utf$ = FromCP437$(theText$)
    End If

    ReDim p5ThisLineChars(Len(Utf$)) As Long
    uprint_extra Left, Top, _Offset(Utf$), Len(Utf$), true, true, p5LastRenderedLineWidth, _Offset(p5ThisLineChars()), p5LastRenderedCharCount, p5Canvas.strokeA, 0
    ReDim _Preserve p5ThisLineChars(p5LastRenderedCharCount) As Long
End Sub

Function PrintWidth& (theText$)
    PrintWidth& = uprintwidth(theText$, Len(theText$), 0)
End Function

Function textWidth& (theText$)
    textWidth& = PrintWidth&(theText$)
End Function

Function textHeight&
    textHeight& = uheight
End Function

'---------------------------------------------------------------------------------
'UTF conversion functions courtesy of Luke Ceddia.
'http://www.qb64.net/forum/index.php?topic=13981.msg121324#msg121324
Function FromCP437$ (source$)
    Static init&, table$(255)
    If init& = 0 Then
        Dim i&
        For i& = 0 To 127
            table$(i&) = Chr$(i&)
        Next i&
        table$(7) = Chr$(226) + Chr$(151) + Chr$(143) 'UTF-8 e2978f
        table$(128) = Chr$(&HE2) + Chr$(&H82) + Chr$(&HAC)
        table$(128) = Chr$(&HC3) + Chr$(&H87)
        table$(129) = Chr$(&HC3) + Chr$(&HBC)
        table$(130) = Chr$(&HC3) + Chr$(&HA9)
        table$(131) = Chr$(&HC3) + Chr$(&HA2)
        table$(132) = Chr$(&HC3) + Chr$(&HA4)
        table$(133) = Chr$(&HC3) + Chr$(&HA0)
        table$(134) = Chr$(&HC3) + Chr$(&HA5)
        table$(135) = Chr$(&HC3) + Chr$(&HA7)
        table$(136) = Chr$(&HC3) + Chr$(&HAA)
        table$(137) = Chr$(&HC3) + Chr$(&HAB)
        table$(138) = Chr$(&HC3) + Chr$(&HA8)
        table$(139) = Chr$(&HC3) + Chr$(&HAF)
        table$(140) = Chr$(&HC3) + Chr$(&HAE)
        table$(141) = Chr$(&HC3) + Chr$(&HAC)
        table$(142) = Chr$(&HC3) + Chr$(&H84)
        table$(143) = Chr$(&HC3) + Chr$(&H85)
        table$(144) = Chr$(&HC3) + Chr$(&H89)
        table$(145) = Chr$(&HC3) + Chr$(&HA6)
        table$(146) = Chr$(&HC3) + Chr$(&H86)
        table$(147) = Chr$(&HC3) + Chr$(&HB4)
        table$(148) = Chr$(&HC3) + Chr$(&HB6)
        table$(149) = Chr$(&HC3) + Chr$(&HB2)
        table$(150) = Chr$(&HC3) + Chr$(&HBB)
        table$(151) = Chr$(&HC3) + Chr$(&HB9)
        table$(152) = Chr$(&HC3) + Chr$(&HBF)
        table$(153) = Chr$(&HC3) + Chr$(&H96)
        table$(154) = Chr$(&HC3) + Chr$(&H9C)
        table$(155) = Chr$(&HC2) + Chr$(&HA2)
        table$(156) = Chr$(&HC2) + Chr$(&HA3)
        table$(157) = Chr$(&HC2) + Chr$(&HA5)
        table$(158) = Chr$(&HE2) + Chr$(&H82) + Chr$(&HA7)
        table$(159) = Chr$(&HC6) + Chr$(&H92)
        table$(160) = Chr$(&HC3) + Chr$(&HA1)
        table$(161) = Chr$(&HC3) + Chr$(&HAD)
        table$(162) = Chr$(&HC3) + Chr$(&HB3)
        table$(163) = Chr$(&HC3) + Chr$(&HBA)
        table$(164) = Chr$(&HC3) + Chr$(&HB1)
        table$(165) = Chr$(&HC3) + Chr$(&H91)
        table$(166) = Chr$(&HC2) + Chr$(&HAA)
        table$(167) = Chr$(&HC2) + Chr$(&HBA)
        table$(168) = Chr$(&HC2) + Chr$(&HBF)
        table$(169) = Chr$(&HE2) + Chr$(&H8C) + Chr$(&H90)
        table$(170) = Chr$(&HC2) + Chr$(&HAC)
        table$(171) = Chr$(&HC2) + Chr$(&HBD)
        table$(172) = Chr$(&HC2) + Chr$(&HBC)
        table$(173) = Chr$(&HC2) + Chr$(&HA1)
        table$(174) = Chr$(&HC2) + Chr$(&HAB)
        table$(175) = Chr$(&HC2) + Chr$(&HBB)
        table$(176) = Chr$(&HE2) + Chr$(&H96) + Chr$(&H91)
        table$(177) = Chr$(&HE2) + Chr$(&H96) + Chr$(&H92)
        table$(178) = Chr$(&HE2) + Chr$(&H96) + Chr$(&H93)
        table$(179) = Chr$(&HE2) + Chr$(&H94) + Chr$(&H82)
        table$(180) = Chr$(&HE2) + Chr$(&H94) + Chr$(&HA4)
        table$(181) = Chr$(&HE2) + Chr$(&H95) + Chr$(&HA1)
        table$(182) = Chr$(&HE2) + Chr$(&H95) + Chr$(&HA2)
        table$(183) = Chr$(&HE2) + Chr$(&H95) + Chr$(&H96)
        table$(184) = Chr$(&HE2) + Chr$(&H95) + Chr$(&H95)
        table$(185) = Chr$(&HE2) + Chr$(&H95) + Chr$(&HA3)
        table$(186) = Chr$(&HE2) + Chr$(&H95) + Chr$(&H91)
        table$(187) = Chr$(&HE2) + Chr$(&H95) + Chr$(&H97)
        table$(188) = Chr$(&HE2) + Chr$(&H95) + Chr$(&H9D)
        table$(189) = Chr$(&HE2) + Chr$(&H95) + Chr$(&H9C)
        table$(190) = Chr$(&HE2) + Chr$(&H95) + Chr$(&H9B)
        table$(191) = Chr$(&HE2) + Chr$(&H94) + Chr$(&H90)
        table$(192) = Chr$(&HE2) + Chr$(&H94) + Chr$(&H94)
        table$(193) = Chr$(&HE2) + Chr$(&H94) + Chr$(&HB4)
        table$(194) = Chr$(&HE2) + Chr$(&H94) + Chr$(&HAC)
        table$(195) = Chr$(&HE2) + Chr$(&H94) + Chr$(&H9C)
        table$(196) = Chr$(&HE2) + Chr$(&H94) + Chr$(&H80)
        table$(197) = Chr$(&HE2) + Chr$(&H94) + Chr$(&HBC)
        table$(198) = Chr$(&HE2) + Chr$(&H95) + Chr$(&H9E)
        table$(199) = Chr$(&HE2) + Chr$(&H95) + Chr$(&H9F)
        table$(200) = Chr$(&HE2) + Chr$(&H95) + Chr$(&H9A)
        table$(201) = Chr$(&HE2) + Chr$(&H95) + Chr$(&H94)
        table$(202) = Chr$(&HE2) + Chr$(&H95) + Chr$(&HA9)
        table$(203) = Chr$(&HE2) + Chr$(&H95) + Chr$(&HA6)
        table$(204) = Chr$(&HE2) + Chr$(&H95) + Chr$(&HA0)
        table$(205) = Chr$(&HE2) + Chr$(&H95) + Chr$(&H90)
        table$(206) = Chr$(&HE2) + Chr$(&H95) + Chr$(&HAC)
        table$(207) = Chr$(&HE2) + Chr$(&H95) + Chr$(&HA7)
        table$(208) = Chr$(&HE2) + Chr$(&H95) + Chr$(&HA8)
        table$(209) = Chr$(&HE2) + Chr$(&H95) + Chr$(&HA4)
        table$(210) = Chr$(&HE2) + Chr$(&H95) + Chr$(&HA5)
        table$(211) = Chr$(&HE2) + Chr$(&H95) + Chr$(&H99)
        table$(212) = Chr$(&HE2) + Chr$(&H95) + Chr$(&H98)
        table$(213) = Chr$(&HE2) + Chr$(&H95) + Chr$(&H92)
        table$(214) = Chr$(&HE2) + Chr$(&H95) + Chr$(&H93)
        table$(215) = Chr$(&HE2) + Chr$(&H95) + Chr$(&HAB)
        table$(216) = Chr$(&HE2) + Chr$(&H95) + Chr$(&HAA)
        table$(217) = Chr$(&HE2) + Chr$(&H94) + Chr$(&H98)
        table$(218) = Chr$(&HE2) + Chr$(&H94) + Chr$(&H8C)
        table$(219) = Chr$(&HE2) + Chr$(&H96) + Chr$(&H88)
        table$(220) = Chr$(&HE2) + Chr$(&H96) + Chr$(&H84)
        table$(221) = Chr$(&HE2) + Chr$(&H96) + Chr$(&H8C)
        table$(222) = Chr$(&HE2) + Chr$(&H96) + Chr$(&H90)
        table$(223) = Chr$(&HE2) + Chr$(&H96) + Chr$(&H80)
        table$(224) = Chr$(&HCE) + Chr$(&HB1)
        table$(225) = Chr$(&HC3) + Chr$(&H9F)
        table$(226) = Chr$(&HCE) + Chr$(&H93)
        table$(227) = Chr$(&HCF) + Chr$(&H80)
        table$(228) = Chr$(&HCE) + Chr$(&HA3)
        table$(229) = Chr$(&HCF) + Chr$(&H83)
        table$(230) = Chr$(&HC2) + Chr$(&HB5)
        table$(231) = Chr$(&HCF) + Chr$(&H84)
        table$(232) = Chr$(&HCE) + Chr$(&HA6)
        table$(233) = Chr$(&HCE) + Chr$(&H98)
        table$(234) = Chr$(&HCE) + Chr$(&HA9)
        table$(235) = Chr$(&HCE) + Chr$(&HB4)
        table$(236) = Chr$(&HE2) + Chr$(&H88) + Chr$(&H9E)
        table$(237) = Chr$(&HCF) + Chr$(&H86)
        table$(238) = Chr$(&HCE) + Chr$(&HB5)
        table$(239) = Chr$(&HE2) + Chr$(&H88) + Chr$(&HA9)
        table$(240) = Chr$(&HE2) + Chr$(&H89) + Chr$(&HA1)
        table$(241) = Chr$(&HC2) + Chr$(&HB1)
        table$(242) = Chr$(&HE2) + Chr$(&H89) + Chr$(&HA5)
        table$(243) = Chr$(&HE2) + Chr$(&H89) + Chr$(&HA4)
        table$(244) = Chr$(&HE2) + Chr$(&H8C) + Chr$(&HA0)
        table$(245) = Chr$(&HE2) + Chr$(&H8C) + Chr$(&HA1)
        table$(246) = Chr$(&HC3) + Chr$(&HB7)
        table$(247) = Chr$(&HE2) + Chr$(&H89) + Chr$(&H88)
        table$(248) = Chr$(&HC2) + Chr$(&HB0)
        table$(249) = Chr$(&HE2) + Chr$(&H88) + Chr$(&H99)
        table$(250) = Chr$(&HC2) + Chr$(&HB7)
        table$(251) = Chr$(&HE2) + Chr$(&H88) + Chr$(&H9A)
        table$(252) = Chr$(&HE2) + Chr$(&H81) + Chr$(&HBF)
        table$(253) = Chr$(&HC2) + Chr$(&HB2)
        table$(254) = Chr$(&HE2) + Chr$(&H96) + Chr$(&HA0)
        table$(255) = Chr$(&HC2) + Chr$(&HA0)
        init& = -1
    End If
    FromCP437$ = UTF8$(source$, table$())
End Function

Function FromCP1252$ (source$)
    Static init&, table$(255)
    If init& = 0 Then
        Dim i&
        For i& = 0 To 127
            table$(i&) = Chr$(i&)
        Next i&
        table$(7) = Chr$(226) + Chr$(151) + Chr$(143) 'UTF-8 e2978f
        table$(128) = Chr$(&HE2) + Chr$(&H82) + Chr$(&HAC)
        table$(130) = Chr$(&HE2) + Chr$(&H80) + Chr$(&H9A)
        table$(131) = Chr$(&HC6) + Chr$(&H92)
        table$(132) = Chr$(&HE2) + Chr$(&H80) + Chr$(&H9E)
        table$(133) = Chr$(&HE2) + Chr$(&H80) + Chr$(&HA6)
        table$(134) = Chr$(&HE2) + Chr$(&H80) + Chr$(&HA0)
        table$(135) = Chr$(&HE2) + Chr$(&H80) + Chr$(&HA1)
        table$(136) = Chr$(&HCB) + Chr$(&H86)
        table$(137) = Chr$(&HE2) + Chr$(&H80) + Chr$(&HB0)
        table$(138) = Chr$(&HC5) + Chr$(&HA0)
        table$(139) = Chr$(&HE2) + Chr$(&H80) + Chr$(&HB9)
        table$(140) = Chr$(&HC5) + Chr$(&H92)
        table$(142) = Chr$(&HC5) + Chr$(&HBD)
        table$(145) = Chr$(&HE2) + Chr$(&H80) + Chr$(&H98)
        table$(146) = Chr$(&HE2) + Chr$(&H80) + Chr$(&H99)
        table$(147) = Chr$(&HE2) + Chr$(&H80) + Chr$(&H9C)
        table$(148) = Chr$(&HE2) + Chr$(&H80) + Chr$(&H9D)
        table$(149) = Chr$(&HE2) + Chr$(&H80) + Chr$(&HA2)
        table$(150) = Chr$(&HE2) + Chr$(&H80) + Chr$(&H93)
        table$(151) = Chr$(&HE2) + Chr$(&H80) + Chr$(&H94)
        table$(152) = Chr$(&HCB) + Chr$(&H9C)
        table$(153) = Chr$(&HE2) + Chr$(&H84) + Chr$(&HA2)
        table$(154) = Chr$(&HC5) + Chr$(&HA1)
        table$(155) = Chr$(&HE2) + Chr$(&H80) + Chr$(&HBA)
        table$(156) = Chr$(&HC5) + Chr$(&H93)
        table$(158) = Chr$(&HC5) + Chr$(&HBE)
        table$(159) = Chr$(&HC5) + Chr$(&HB8)
        table$(160) = Chr$(&HC2) + Chr$(&HA0)
        table$(161) = Chr$(&HC2) + Chr$(&HA1)
        table$(162) = Chr$(&HC2) + Chr$(&HA2)
        table$(163) = Chr$(&HC2) + Chr$(&HA3)
        table$(164) = Chr$(&HC2) + Chr$(&HA4)
        table$(165) = Chr$(&HC2) + Chr$(&HA5)
        table$(166) = Chr$(&HC2) + Chr$(&HA6)
        table$(167) = Chr$(&HC2) + Chr$(&HA7)
        table$(168) = Chr$(&HC2) + Chr$(&HA8)
        table$(169) = Chr$(&HC2) + Chr$(&HA9)
        table$(170) = Chr$(&HC2) + Chr$(&HAA)
        table$(171) = Chr$(&HC2) + Chr$(&HAB)
        table$(172) = Chr$(&HC2) + Chr$(&HAC)
        table$(173) = Chr$(&HC2) + Chr$(&HAD)
        table$(174) = Chr$(&HC2) + Chr$(&HAE)
        table$(175) = Chr$(&HC2) + Chr$(&HAF)
        table$(176) = Chr$(&HC2) + Chr$(&HB0)
        table$(177) = Chr$(&HC2) + Chr$(&HB1)
        table$(178) = Chr$(&HC2) + Chr$(&HB2)
        table$(179) = Chr$(&HC2) + Chr$(&HB3)
        table$(180) = Chr$(&HC2) + Chr$(&HB4)
        table$(181) = Chr$(&HC2) + Chr$(&HB5)
        table$(182) = Chr$(&HC2) + Chr$(&HB6)
        table$(183) = Chr$(&HC2) + Chr$(&HB7)
        table$(184) = Chr$(&HC2) + Chr$(&HB8)
        table$(185) = Chr$(&HC2) + Chr$(&HB9)
        table$(186) = Chr$(&HC2) + Chr$(&HBA)
        table$(187) = Chr$(&HC2) + Chr$(&HBB)
        table$(188) = Chr$(&HC2) + Chr$(&HBC)
        table$(189) = Chr$(&HC2) + Chr$(&HBD)
        table$(190) = Chr$(&HC2) + Chr$(&HBE)
        table$(191) = Chr$(&HC2) + Chr$(&HBF)
        table$(192) = Chr$(&HC3) + Chr$(&H80)
        table$(193) = Chr$(&HC3) + Chr$(&H81)
        table$(194) = Chr$(&HC3) + Chr$(&H82)
        table$(195) = Chr$(&HC3) + Chr$(&H83)
        table$(196) = Chr$(&HC3) + Chr$(&H84)
        table$(197) = Chr$(&HC3) + Chr$(&H85)
        table$(198) = Chr$(&HC3) + Chr$(&H86)
        table$(199) = Chr$(&HC3) + Chr$(&H87)
        table$(200) = Chr$(&HC3) + Chr$(&H88)
        table$(201) = Chr$(&HC3) + Chr$(&H89)
        table$(202) = Chr$(&HC3) + Chr$(&H8A)
        table$(203) = Chr$(&HC3) + Chr$(&H8B)
        table$(204) = Chr$(&HC3) + Chr$(&H8C)
        table$(205) = Chr$(&HC3) + Chr$(&H8D)
        table$(206) = Chr$(&HC3) + Chr$(&H8E)
        table$(207) = Chr$(&HC3) + Chr$(&H8F)
        table$(208) = Chr$(&HC3) + Chr$(&H90)
        table$(209) = Chr$(&HC3) + Chr$(&H91)
        table$(210) = Chr$(&HC3) + Chr$(&H92)
        table$(211) = Chr$(&HC3) + Chr$(&H93)
        table$(212) = Chr$(&HC3) + Chr$(&H94)
        table$(213) = Chr$(&HC3) + Chr$(&H95)
        table$(214) = Chr$(&HC3) + Chr$(&H96)
        table$(215) = Chr$(&HC3) + Chr$(&H97)
        table$(216) = Chr$(&HC3) + Chr$(&H98)
        table$(217) = Chr$(&HC3) + Chr$(&H99)
        table$(218) = Chr$(&HC3) + Chr$(&H9A)
        table$(219) = Chr$(&HC3) + Chr$(&H9B)
        table$(220) = Chr$(&HC3) + Chr$(&H9C)
        table$(221) = Chr$(&HC3) + Chr$(&H9D)
        table$(222) = Chr$(&HC3) + Chr$(&H9E)
        table$(223) = Chr$(&HC3) + Chr$(&H9F)
        table$(224) = Chr$(&HC3) + Chr$(&HA0)
        table$(225) = Chr$(&HC3) + Chr$(&HA1)
        table$(226) = Chr$(&HC3) + Chr$(&HA2)
        table$(227) = Chr$(&HC3) + Chr$(&HA3)
        table$(228) = Chr$(&HC3) + Chr$(&HA4)
        table$(229) = Chr$(&HC3) + Chr$(&HA5)
        table$(230) = Chr$(&HC3) + Chr$(&HA6)
        table$(231) = Chr$(&HC3) + Chr$(&HA7)
        table$(232) = Chr$(&HC3) + Chr$(&HA8)
        table$(233) = Chr$(&HC3) + Chr$(&HA9)
        table$(234) = Chr$(&HC3) + Chr$(&HAA)
        table$(235) = Chr$(&HC3) + Chr$(&HAB)
        table$(236) = Chr$(&HC3) + Chr$(&HAC)
        table$(237) = Chr$(&HC3) + Chr$(&HAD)
        table$(238) = Chr$(&HC3) + Chr$(&HAE)
        table$(239) = Chr$(&HC3) + Chr$(&HAF)
        table$(240) = Chr$(&HC3) + Chr$(&HB0)
        table$(241) = Chr$(&HC3) + Chr$(&HB1)
        table$(242) = Chr$(&HC3) + Chr$(&HB2)
        table$(243) = Chr$(&HC3) + Chr$(&HB3)
        table$(244) = Chr$(&HC3) + Chr$(&HB4)
        table$(245) = Chr$(&HC3) + Chr$(&HB5)
        table$(246) = Chr$(&HC3) + Chr$(&HB6)
        table$(247) = Chr$(&HC3) + Chr$(&HB7)
        table$(248) = Chr$(&HC3) + Chr$(&HB8)
        table$(249) = Chr$(&HC3) + Chr$(&HB9)
        table$(250) = Chr$(&HC3) + Chr$(&HBA)
        table$(251) = Chr$(&HC3) + Chr$(&HBB)
        table$(252) = Chr$(&HC3) + Chr$(&HBC)
        table$(253) = Chr$(&HC3) + Chr$(&HBD)
        table$(254) = Chr$(&HC3) + Chr$(&HBE)
        table$(255) = Chr$(&HC3) + Chr$(&HBF)
        init& = -1
    End If
    FromCP1252$ = UTF8$(source$, table$())
End Function

Function UTF8$ (source$, table$())
    Dim i As Long, dest$
    For i = 1 To Len(source$)
        dest$ = dest$ + table$(Asc(source$, i))
    Next i
    UTF8$ = dest$
End Function

'#####################################################################################################
'########################### p5 Environment Related methods & functions ##############################
'#####################################################################################################
Sub createCanvas (w As Integer, h As Integer)
    Static CanvasSetup As _Byte

    If Not CanvasSetup Then
        p5Canvas.imgHandle = _NewImage(w, h, 32)
        Screen p5Canvas.imgHandle
        tempShapeImage = _NewImage(_Width, _Height, 32)

        p5Canvas.strokeTexture = _NewImage(1, 1, 32)
        p5Canvas.fillTexture = _NewImage(1, 1, 32)

        CanvasSetup = true
    Else
        Dim oldDest As Long
        oldDest = p5Canvas.imgHandle
        p5Canvas.imgHandle = _NewImage(w, h, 32)
        Screen p5Canvas.imgHandle
        _FreeImage oldDest

        If tempShapeImage Then
            _FreeImage tempShapeImage
            tempShapeImage = _NewImage(_Width, _Height, 32)
        End If
    End If
End Sub

Function createImage& (w As Integer, h As Integer)
    createImage& = _NewImage(w, h, 32)
End Function

Function width&
    width& = _Width
End Function

Function height&
    height& = _Height
End Function

Sub title (t$)
    _Title t$
End Sub

Sub titleB (v!)
    _Title Str$(v!)
End Sub


Sub push
    pushState = pushState + 1
    If pushState > UBound(p5CanvasBackup) Then
        ReDim _Preserve p5CanvasBackup(pushState + 9) As new_p5Canvas
    End If
    p5CanvasBackup(pushState) = p5Canvas
End Sub

Sub pop
    p5Canvas = p5CanvasBackup(pushState)
    pushState = pushState - 1
End Sub

Sub redraw
    callDrawLoop
End Sub

Sub callDrawLoop
    Dim a As _Byte, xOffsetBackup As Single, yOffsetBackup As Single

    p5frameCount = p5frameCount + 1

    'calls to translate() are reverted after the draw loop
    xOffsetBackup = p5Canvas.xOffset
    yOffsetBackup = p5Canvas.yOffset

    a = p5draw

    p5Canvas.xOffset = xOffsetBackup
    p5Canvas.yOffset = yOffsetBackup
End Sub

Function frameCount~&
    frameCount~& = p5frameCount
End Function

Sub gatherInput ()
    Dim a As _Byte

    'Keyboard input:
    keyCode = _KeyHit
    If keyCode > 0 And keyCode <> lastKeyCode Then
        lastKeyCode = keyCode
        a = keyPressed
        totalKeysDown = totalKeysDown + 1
    ElseIf keyCode < 0 Then
        totalKeysDown = totalKeysDown - 1
        If totalKeysDown <= 0 Then
            totalKeysDown = 0
            keyCode = Abs(keyCode)
            a = keyReleased
            lastKeyCode = 0
        End If
    End If

    keyIsPressed = totalKeysDown > 0

    'Mouse input (optimization by Luke Ceddia):
    p5mouseWheel = 0

    If _MouseInput Then
        p5mouseWheel = p5mouseWheel + _MouseWheel
        If _MouseButton(1) = mouseButton1 And _MouseButton(2) = mouseButton2 And _MouseButton(3) = mouseButton3 Then
            Do While _MouseInput
                p5mouseWheel = p5mouseWheel + _MouseWheel
                If Not (_MouseButton(1) = mouseButton1 And _MouseButton(2) = mouseButton2 And _MouseButton(3) = mouseButton3) Then Exit Do
            Loop
        End If
        mouseButton1 = _MouseButton(1)
        mouseButton2 = _MouseButton(2)
        mouseButton3 = _MouseButton(3)
    End If

    While _MouseInput: Wend

    If p5mouseWheel Then
        a = mouseWheel
    End If

    If mouseButton1 Then
        mouseButton = LEFT
        If Not mouseIsPressed Then
            mouseIsPressed = true
            a = mousePressed
        Else
            a = mouseDragged
        End If
    Else
        If mouseIsPressed And mouseButton = LEFT Then
            mouseIsPressed = false
            a = mouseReleased
            a = mouseClicked
        End If
    End If

    If mouseButton2 Then
        mouseButton = RIGHT
        If Not mouseIsPressed Then
            mouseIsPressed = true
            a = mousePressed
        Else
            a = mouseDragged
        End If
    Else
        If mouseIsPressed And mouseButton = RIGHT Then
            mouseIsPressed = false
            a = mouseReleased
            a = mouseClicked
        End If
    End If

    If mouseButton3 Then
        mouseButton = CENTER
        If Not mouseIsPressed Then
            mouseIsPressed = true
            a = mousePressed
        Else
            a = mouseDragged
        End If
    Else
        If mouseIsPressed And mouseButton = CENTER Then
            mouseIsPressed = false
            a = mouseReleased
            a = mouseClicked
        End If
    End If

End Sub
                                
Sub doLoop ()
    p5Loop = true
End Sub

Sub noLoop ()
    p5Loop = false
End Sub

Sub cursor (kind)
    If kind = CURSOR_NONE Then _MouseHide Else glutSetCursor kind
End Sub

'#####################################################################################################
'############################# p5 Maths & Vectors Related functions ##################################
'#####################################################################################################

Function noise! (x As Single, y As Single, z As Single)
    Static p5NoiseSetup As _Byte
    Static perlin() As Single
    Static PERLIN_YWRAPB As Single, PERLIN_YWRAP As Single
    Static PERLIN_ZWRAPB As Single, PERLIN_ZWRAP As Single
    Static PERLIN_SIZE As Single

    If Not p5NoiseSetup Then
        p5NoiseSetup = true

        PERLIN_YWRAPB = 4
        PERLIN_YWRAP = Int(1 * (2 ^ PERLIN_YWRAPB))
        PERLIN_ZWRAPB = 8
        PERLIN_ZWRAP = Int(1 * (2 ^ PERLIN_ZWRAPB))
        PERLIN_SIZE = 4095

        perlin_octaves = 4
        perlin_amp_falloff = 0.5

        ReDim perlin(PERLIN_SIZE + 1) As Single
        Dim i As Single
        For i = 0 To PERLIN_SIZE + 1
            perlin(i) = Rnd
        Next
    End If

    x = Abs(x)
    y = Abs(y)
    z = Abs(z)

    Dim xi As Single, yi As Single, zi As Single
    xi = Int(x)
    yi = Int(y)
    zi = Int(z)

    Dim xf As Single, yf As Single, zf As Single
    xf = x - xi
    yf = y - yi
    zf = z - zi

    Dim r As Single, ampl As Single, o As Single
    r = 0
    ampl = .5

    For o = 1 To perlin_octaves
        Dim of As Single, rxf As Single
        Dim ryf As Single, n1 As Single, n2 As Single, n3 As Single
        of = xi + Int(yi * (2 ^ PERLIN_YWRAPB)) + Int(zi * (2 ^ PERLIN_ZWRAPB))

        rxf = 0.5 * (1.0 - Cos(xf * _Pi))
        ryf = 0.5 * (1.0 - Cos(yf * _Pi))

        n1 = perlin(of And PERLIN_SIZE)
        n1 = n1 + rxf * (perlin((of + 1) And PERLIN_SIZE) - n1)
        n2 = perlin((of + PERLIN_YWRAP) And PERLIN_SIZE)
        n2 = n2 + rxf * (perlin((of + PERLIN_YWRAP + 1) And PERLIN_SIZE) - n2)
        n1 = n1 + ryf * (n2 - n1)

        of = of + PERLIN_ZWRAP
        n2 = perlin(of And PERLIN_SIZE)
        n2 = n2 + rxf * (perlin((of + 1) And PERLIN_SIZE) - n2)
        n3 = perlin((of + PERLIN_YWRAP) And PERLIN_SIZE)
        n3 = n3 + rxf * (perlin((of + PERLIN_YWRAP + 1) And PERLIN_SIZE) - n3)
        n2 = n2 + ryf * (n3 - n2)

        n1 = n1 + (0.5 * (1.0 - Cos(zf * _Pi))) * (n2 - n1)

        r = r + n1 * ampl
        ampl = ampl * perlin_amp_falloff
        xi = Int(xi * (2 ^ 1))
        xf = xf * 2
        yi = Int(yi * (2 ^ 1))
        yf = yf * 2
        zi = Int(zi * (2 ^ 1))
        zf = zf * 2

        If xf >= 1.0 Then xi = xi + 1: xf = xf - 1
        If yf >= 1.0 Then yi = yi + 1: yf = yf - 1
        If zf >= 1.0 Then zi = zi + 1: zf = zf - 1
    Next
    noise! = r
End Function

Sub noiseDetail (lod!, falloff!)
    If lod! > 0 Then perlin_octaves = lod!
    If falloff! > 0 Then perlin_amp_falloff = falloff!
End Sub

Function map! (value!, minRange!, maxRange!, newMinRange!, newMaxRange!)
    map! = ((value! - minRange!) / (maxRange! - minRange!)) * (newMaxRange! - newMinRange!) + newMinRange!
End Function

Sub createVector (v As vector, x As Single, y As Single)
    v.x = x
    v.y = y
End Sub

Sub vector.add (v1 As vector, v2 As vector)
    v1.x = v1.x + v2.x
    v1.y = v1.y + v2.y
    v1.z = v1.z + v2.z
End Sub

Sub vector.addB (v1 As vector, x2 As Single, y2 As Single, z2 As Single)
    v1.x = v1.x + x2
    v1.y = v1.y + y2
    v1.z = v1.z + z2
End Sub

Sub vector.sub (v1 As vector, v2 As vector)
    v1.x = v1.x - v2.x
    v1.y = v1.y - v2.y
    v1.z = v1.z - v2.z
End Sub

Sub vector.subB (v1 As vector, x2 As Single, y2 As Single, z2 As Single)
    v1.x = v1.x - x2
    v1.y = v1.y - y2
    v1.z = v1.z - z2
End Sub

Sub vector.limit (v As vector, __max!)
    Dim mSq As Single

    mSq = vector.magSq(v)
    If mSq > __max! * __max! Then
        vector.div v, Sqr(mSq)
        vector.mult v, __max!
    End If
End Sub

Function vector.magSq! (v As vector)
    vector.magSq! = v.x * v.x + v.y * v.y + v.z * v.z
End Function

Sub vector.fromAngle (v As vector, __angle!)
    Dim angle!

    If p5Canvas.angleMode = DEGREES Then angle! = _D2R(__angle!) Else angle! = __angle!

    v.x = Cos(angle!)
    v.y = Sin(angle!)
End Sub

Function vector.mag! (v As vector)
    Dim x As Single, y As Single, z As Single
    Dim magSq As Single

    x = v.x
    y = v.y
    z = v.z

    magSq = x * x + y * y + z * z
    vector.mag! = Sqr(magSq)
End Function

Sub vector.setMag (v As vector, n As Single)
    vector.normalize v
    vector.mult v, n
End Sub

Sub vector.normalize (v As vector)
    Dim theMag!

    theMag! = vector.mag(v)
    If theMag! = 0 Then Exit Sub

    vector.div v, theMag!
End Sub

Sub vector.div (v As vector, n As Single)
    v.x = v.x / n
    v.y = v.y / n
    v.z = v.z / n
End Sub

Sub vector.mult (v As vector, n As Single)
    v.x = v.x * n
    v.y = v.y * n
    v.z = v.z * n
End Sub

Sub vector.random2d (v As vector)
    Dim angle As Single

    If p5Canvas.angleMode = DEGREES Then
        angle = p5random(0, 360)
    Else
        angle = p5random(0, TWO_PI)
    End If

    vector.fromAngle v, angle
End Sub

Function p5degrees! (r!)
    p5degrees! = _R2D(r!)
End Function

Function p5radians! (d!)
    p5radians! = _D2R(d!)
End Function

Function p5sin! (angle!)
    If p5Canvas.angleMode = RADIANS Then
        p5sin! = Sin(angle!)
    Else
        p5sin! = Sin(_D2R(angle!))
    End If
End Function

Function p5cos! (angle!)
    If p5Canvas.angleMode = RADIANS Then
        p5cos! = Cos(angle!)
    Else
        p5cos! = Cos(_D2R(angle!))
    End If
End Function

Sub angleMode (kind)
    p5Canvas.angleMode = kind
End Sub

'Calculate minimum value between two values
Function min! (a!, b!)
    If a! < b! Then min! = a! Else min! = b!
End Function

'Calculate maximum value between two values
Function max! (a!, b!)
    If a! > b! Then max! = a! Else max! = b!
End Function

'Constrain a value between a minimum and maximum value.
Function constrain! (n!, low!, high!)
    constrain! = max(min(n!, high!), low!)
End Function

'Calculate the distance between two points.
Function dist! (x1!, y1!, x2!, y2!)
    dist! = _Hypot((x2! - x1!), (y2! - y1!))
End Function

Function distB! (v1 As vector, v2 As vector)
    distB! = dist!(v1.x, v1.y, v2.x, v2.y)
End Function

Function lerp! (start!, stp!, amt!)
    lerp! = amt! * (stp! - start!) + start!
End Function

Function mag! (x!, y!)
    mag! = _Hypot(x!, y!)
End Function

Function sq! (n!)
    sq! = n! * n!
End Function

Function pow! (n!, p!)
    pow! = n! ^ p!
End Function

Function p5random! (mn!, mx!)
    If mn! > mx! Then
        Swap mn!, mx!
    End If
    p5random! = Rnd * (mx! - mn!) + mn!
End Function

Function join$ (str_array$(), sep$)
    Dim i As Long
    For i = LBound(str_array$) To UBound(str_array$)
        join$ = join$ + str_array$(i) + sep$
    Next
End Function

'#####################################################################################################
'######################## p5 Date & Time Related functions ###########################################
'#####################################################################################################

Function month& ()
    month& = Val(Left$(Date$, 2))
End Function

Function day& ()
    day& = Val(Mid$(Date$, 4, 2))
End Function

Function year& ()
    year& = Val(Right$(Date$, 4))
End Function

Function hour& ()
    hour& = Val(Left$(Time$, 2))
End Function

Function minute& ()
    minute& = Val(Mid$(Time$, 4, 2))
End Function

Function seconds& ()
    seconds& = Val(Right$(Time$, 2))
End Function

'#####################################################################################################
'############################ p5 Sound Related methods &  functions ##################################
'#####################################################################################################

Function loadSound& (file$)
    If _FileExists(file$) = 0 Then Exit Function
    Dim tempHandle&

    tempHandle& = _SndOpen(file$)
    If tempHandle& > 0 Then
        totalLoadedSounds = totalLoadedSounds + 1
        ReDim _Preserve loadedSounds(totalLoadedSounds) As Long
        loadedSounds(totalLoadedSounds) = tempHandle&
        loadSound& = tempHandle&
    End If
End Function

Sub p5play (soundHandle&)
    Dim i As Long
    For i = 1 To UBound(loadedSounds)
        If loadedSounds(i) = soundHandle& Then
            _SndPlayCopy soundHandle&
        End If
    Next
End Sub

'#####################################################################################################
'############################ p5 Colors Related methods & functions ##################################
'#####################################################################################################

Sub p5setFillTexture
    Dim prevDest As Long

    prevDest = _Dest
    _Dest p5Canvas.fillTexture
    Cls , 0
    PSet (0, 0), p5Canvas.fillA
    _Dest prevDest
End Sub

Sub p5setStrokeTexture
    Dim prevDest As Long

    prevDest = _Dest
    _Dest p5Canvas.strokeTexture
    Cls , 0
    PSet (0, 0), p5Canvas.strokeA
    _Dest prevDest
End Sub

Sub fill (r As Single, g As Single, b As Single)
    p5Canvas.doFill = true
    If p5Canvas.colorMode = p5HSB Then p5Canvas.fill = hsb(r, g, b, 255) Else p5Canvas.fill = _RGB32(r, g, b)
    p5Canvas.fillA = p5Canvas.fill
    p5Canvas.fillAlpha = 255

    p5setFillTexture

    Color , p5Canvas.fill 'fill also affects text
End Sub

Sub fillN (c$)
    Dim c~&

    p5Canvas.doFill = true
    c~& = colorN(c$)
    p5Canvas.fill = c~&
    p5Canvas.fillA = c~&
    p5Canvas.fillAlpha = 255

    p5setFillTexture

    Color , p5Canvas.fill 'fill also affect the text
End Sub

Sub fillNA (c$, a!)
    Dim c~&

    p5Canvas.doFill = true
    c~& = colorNA(c$, a!)
    p5Canvas.fill = c~&
    p5Canvas.fillA = _RGBA32(_Red32(c~&), _Green32(c~&), _Blue32(c~&), a!)
    p5Canvas.fillAlpha = _Alpha32(c~&)

    p5setFillTexture

    Color , p5Canvas.fillA 'fill also affect the text
End Sub

Sub fillA (r As Single, g As Single, b As Single, a As Single)
    p5Canvas.doFill = true
    If p5Canvas.colorMode = p5HSB Then
        p5Canvas.fill = hsb(r, g, b, a)
        p5Canvas.fillA = hsb(r, g, b, a)
    Else
        p5Canvas.fill = _RGB32(r, g, b)
        p5Canvas.fillA = _RGBA32(r, g, b, a)
    End If
    p5Canvas.fillAlpha = constrain(a, 0, 255)

    p5setFillTexture

    Color , p5Canvas.fillA 'fill also affects text
End Sub

Sub fillB (b As Single)
    p5Canvas.doFill = true
    p5Canvas.fill = _RGB32(b, b, b)
    p5Canvas.fillA = p5Canvas.fill
    p5Canvas.fillAlpha = 255

    p5setFillTexture

    Color , p5Canvas.fill 'fill also affects text
End Sub

Sub fillBA (b As Single, a As Single)
    p5Canvas.doFill = true
    p5Canvas.fill = _RGB32(b, b, b)
    p5Canvas.fillA = _RGBA32(b, b, b, a)
    p5Canvas.fillAlpha = constrain(a, 0, 255)

    p5setFillTexture

    Color , p5Canvas.fillA 'fill also affects text
End Sub

Sub fillC (c As _Unsigned Long)
    p5Canvas.doFill = true
    p5Canvas.fillAlpha = _Alpha(c)
    If p5Canvas.fillAlpha < 255 Then
        p5Canvas.fill = _RGB32(_Red32(c), _Green32(c), _Blue32(c))
    Else
        p5Canvas.fill = c
    End If
    p5Canvas.fillA = c

    p5setFillTexture
End Sub

Sub stroke (r As Single, g As Single, b As Single)
    p5Canvas.doStroke = true
    If p5Canvas.colorMode = p5HSB Then p5Canvas.stroke = hsb(r, g, b, 255) Else p5Canvas.stroke = _RGB32(r, g, b)
    p5Canvas.strokeA = p5Canvas.stroke
    p5Canvas.strokeAlpha = 255

    p5setStrokeTexture

    Color p5Canvas.stroke 'stroke also affects text
End Sub

Sub strokeN (c$)
    Dim c~&

    p5Canvas.doStroke = true
    c~& = colorN(c$)
    p5Canvas.stroke = c~&
    p5Canvas.strokeA = c~&
    p5Canvas.strokeAlpha = 255

    p5setStrokeTexture

    Color p5Canvas.stroke 'stroke also affects text
End Sub

Sub strokeNA (c$, a!)
    Dim c~&

    p5Canvas.doStroke = true
    c~& = colorNA(c$, a!)
    p5Canvas.stroke = _RGB32(_Red32(c~&), _Green32(c~&), _Blue32(c~&))
    p5Canvas.strokeA = c~&
    p5Canvas.strokeAlpha = _Alpha32(c~&)

    p5setStrokeTexture

    Color p5Canvas.strokeA 'stroke also affects text
End Sub

Sub strokeA (r As Single, g As Single, b As Single, a As Single)
    p5Canvas.doStroke = true
    If p5Canvas.colorMode = p5HSB Then
        p5Canvas.stroke = hsb(r, g, b, 255)
        p5Canvas.strokeA = hsb(r, g, b, a)
    Else
        p5Canvas.stroke = _RGB32(r, g, b)
        p5Canvas.strokeA = _RGBA32(r, g, b, a)
    End If

    p5Canvas.strokeAlpha = constrain(a, 0, 255)

    p5setStrokeTexture

    Color p5Canvas.strokeA 'stroke also affects text
End Sub

Sub strokeB (b As Single)
    p5Canvas.doStroke = true
    p5Canvas.stroke = _RGB32(b, b, b)
    p5Canvas.strokeA = p5Canvas.stroke
    p5Canvas.strokeAlpha = 255

    p5setStrokeTexture

    Color p5Canvas.strokeA 'stroke also affects text
End Sub

Sub strokeBA (b As Single, a As Single)
    p5Canvas.doStroke = true
    p5Canvas.stroke = _RGB32(b, b, b)
    p5Canvas.strokeA = _RGBA32(b, b, b, a)
    p5Canvas.strokeAlpha = constrain(a, 0, 255)

    p5setStrokeTexture

    Color p5Canvas.strokeA 'stroke also affects text
End Sub

Sub strokeC (c As _Unsigned Long)
    p5Canvas.doStroke = true
    p5Canvas.strokeAlpha = _Alpha(c)
    If p5Canvas.strokeAlpha < 255 Then
        p5Canvas.stroke = _RGB32(_Red32(c), _Green32(c), _Blue32(c))
    Else
        p5Canvas.stroke = c
    End If
    p5Canvas.strokeA = c

    p5setStrokeTexture
End Sub

Sub noFill ()
    p5Canvas.doFill = false
    Color , 0 'fill also affects text
End Sub

Sub noStroke ()
    p5Canvas.doStroke = false
    Color 0 'stroke also affects text
End Sub

Function lerpColor~& (c1 As _Unsigned Long, c2 As _Unsigned Long, __v!)
    Dim v!
    v! = constrain(__v!, 0, 1)

    If p5Canvas.colorMode = p5RGB Then
        Dim r1 As Single, g1 As Single, b1 As Single
        Dim r2 As Single, g2 As Single, b2 As Single
        Dim rstep As Single, gstep As Single, bstep As Single

        r1 = _Red32(c1)
        g1 = _Green32(c1)
        b1 = _Blue32(c1)

        r2 = _Red32(c2)
        g2 = _Green32(c2)
        b2 = _Blue32(c2)

        rstep = map(v!, 0, 1, r1, r2)
        gstep = map(v!, 0, 1, g1, g2)
        bstep = map(v!, 0, 1, b1, b2)

        lerpColor~& = _RGB32(rstep, gstep, bstep)
    Else
        'p5HSB lerpColor not yet available; return either
        'of the original colors that's closer to v!
        If v! < .5 Then
            lerpColor~& = c1
        Else
            lerpColor~& = c2
        End If
    End If
End Function

Function color~& (v1 As Single, v2 As Single, v3 As Single)
    If p5Canvas.colorMode = p5RGB Then
        color~& = _RGB32(v1, v2, v3)
    ElseIf p5Canvas.colorMode = p5HSB Then
        color~& = hsb(v1, v2, v3, 255)
    End If
End Function

Function colorA~& (v1 As Single, v2 As Single, v3 As Single, a As Single)
    If p5Canvas.colorMode = p5RGB Then
        colorA~& = _RGBA32(v1, v2, v3, a)
    ElseIf p5Canvas.colorMode = p5HSB Then
        colorA~& = hsb(v1, v2, v3, a)
    End If
End Function

Function colorB~& (v1 As Single)
    If p5Canvas.colorMode = p5RGB Then
        colorB~& = _RGB32(v1, v1, v1)
    ElseIf p5Canvas.colorMode = p5HSB Then
        colorB~& = hsb(0, 0, v1, 255)
    End If
End Function

Function colorBA~& (v1 As Single, a As Single)
    If p5Canvas.colorMode = p5RGB Then
        colorBA~& = _RGBA32(v1, v1, v1, a)
    ElseIf p5Canvas.colorMode = p5HSB Then
        colorBA~& = hsb(0, 0, v1, a)
    End If
End Function

Function colorN~& (c$)
    Dim i As Long
    If Left$(c$, 1) = "#" Then
        colorN~& = hexToCol~&(c$)
    Else
        For i = 1 To UBound(p5Colors)
            If LCase$(c$) = LCase$(RTrim$(p5Colors(i).n)) Then colorN~& = p5Colors(i).c: Exit For
        Next
    End If
End Function

Function colorNA~& (c$, a!)
    Dim c~&, i As Long

    If Left$(c$, 1) = "#" Then
        c~& = hexToCol~&(c$)
        colorNA~& = _RGBA32(_Red32(c~&), _Green32(c~&), _Blue32(c~&), a!)
    Else
        For i = 1 To UBound(p5Colors)
            If LCase$(c$) = LCase$(RTrim$(p5Colors(i).n)) Then colorNA~& = _RGBA32(_Red32(p5Colors(i).c), _Green32(p5Colors(i).c), _Blue32(p5Colors(i).c), a!)
        Next
    End If
End Function
'method adapted form http://stackoverflow.com/questions/4106363/converting-rgb-to-hsb-colors
Function hsb~& (__H As _Float, __S As _Float, __B As _Float, A As _Float)
    Dim H As _Float, S As _Float, B As _Float

    H = map(__H, 0, 255, 0, 360)
    S = map(__S, 0, 255, 0, 1)
    B = map(__B, 0, 255, 0, 1)

    If S = 0 Then
        hsb~& = _RGBA32(B * 255, B * 255, B * 255, A)
        Exit Function
    End If

    Dim fmx As _Float, fmn As _Float
    Dim fmd As _Float, iSextant As Integer
    Dim imx As Integer, imd As Integer, imn As Integer

    If B > .5 Then
        fmx = B - (B * S) + S
        fmn = B + (B * S) - S
    Else
        fmx = B + (B * S)
        fmn = B - (B * S)
    End If

    iSextant = Int(H / 60)

    If H >= 300 Then
        H = H - 360
    End If

    H = H / 60
    H = H - (2 * Int(((iSextant + 1) Mod 6) / 2))

    If iSextant Mod 2 = 0 Then
        fmd = (H * (fmx - fmn)) + fmn
    Else
        fmd = fmn - (H * (fmx - fmn))
    End If

    imx = _Round(fmx * 255)
    imd = _Round(fmd * 255)
    imn = _Round(fmn * 255)

    Select Case Int(iSextant)
        Case 1
            hsb~& = _RGBA32(imd, imx, imn, A)
        Case 2
            hsb~& = _RGBA32(imn, imx, imd, A)
        Case 3
            hsb~& = _RGBA32(imn, imd, imx, A)
        Case 4
            hsb~& = _RGBA32(imd, imn, imx, A)
        Case 5
            hsb~& = _RGBA32(imx, imn, imd, A)
        Case Else
            hsb~& = _RGBA32(imx, imd, imn, A)
    End Select

End Function

Function brightness! (col~&)
    Dim r As Integer, g As Integer, b As Integer
    Dim a As Integer

    r = _Red32(col~&)
    g = _Green32(col~&)
    b = _Blue32(col~&)
    a = _Alpha32(col~&)
    brightness! = ((r + g + b + a) / (255 * 4)) * 255
End Function

Sub colorMode (kind As Integer)
    p5Canvas.colorMode = kind
End Sub

Function hue! (col~&)
    Dim r!, g!, b!, mx!, mn!, delta!

    r! = _Red32(col~&)
    g! = _Green32(col~&)
    b! = _Blue32(col~&)
    mx! = max(max(r!, g!), b!)
    mn! = min(min(r!, g!), b!)
    delta! = mx! - mn!
    If delta! <> 0 Then
        If r! = mx! Then
            hue! = (g - b) / delta!
        ElseIf g! = mx! Then
            hue! = 2 + ((b - r) / delta!)
        ElseIf b! = mx! Then
            hue! = 4 + ((r - g) / delta!)
        End If
    Else
        hue! = 0
    End If
    hue! = 60 * hue!
    If hue! < 0 Then hue! = hue! + 360
    hue! = map(hue!, 0, 360, 0, 255)
End Function

Function saturation! (col~&)
    Dim r!, g!, b!, mx!, mn!, delta!

    r! = _Red32(col~&)
    g! = _Green32(col~&)
    b! = _Blue32(col~&)
    mx! = max(max(r!, g!), b!)
    mn! = min(min(r!, g!), b!)
    delta! = mx! - mn!
    If mx! <> 0 Then
        saturation! = delta! / mx!
    Else
        saturation! = 0
    End If
    saturation! = map(saturation!, 0, 1, 0, 255)
End Function

Function lightness! (col~&)
    Dim r!, g!, b!, mx!
    r! = _Red32(col~&)
    g! = _Green32(col~&)
    b! = _Blue32(col~&)
    mx! = max(max(r!, g!), b!)
    lightness! = mx!
End Function
 
'can convert hexadecimal colors value to rgb one
'usage col~&  = hexToRgb~&("#ffdf00")
Function hexToCol~& (h$)
    If Len(h$) <> 7 Or Len(h$) = 0 Then Exit Function
    h$ = Right$(h$, Len(h$) - 1)
    If p5Canvas.colorMode = p5HSB Then hexToCol~& = hsb(Val("&h" + Left$(h$, 2)), Val("&h" + Mid$(h$, 3, 2)), Val("&h" + Right$(h$, 2)), 255) Else hexToCol~& = _RGB32(Val("&h" + Left$(h$, 2)), Val("&h" + Mid$(h$, 3, 2)), Val("&h" + Right$(h$, 2)))
End Function

Sub p5setColors
    'supports all the colors listed at http://www.rapidtables.com/web/color/RGB_Color.htm
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
End Sub

'uncomment the lines below to see a simple demo
'FUNCTION p5setup ()
'    createCanvas 400, 400
'    strokeWeight 10
'    stroke 255, 0, 0
'    strokeCap SQUARE
'END FUNCTION

'FUNCTION p5draw ()
'    backgroundBA 0, 30
'    p5line 30, 30, _MOUSEX, _MOUSEY
'END FUNCTION

