'p5js.bas by Fellippe & Ashish
'Copyright <c> 2017-18
'Last update 4/4/2017

'p5 constant
CONST TWO_PI = 6.283185307179586
CONST HALF_PI = 1.570796326794897
CONST P5_POINTS = 1
CONST P5_LINES = 2
CONST P5_CLOSE = -3
'p5 Global Variables
TYPE __canvasSettings
    stroke AS LONG
    fill AS LONG
    strokeWeight AS INTEGER
    noStroke AS _BYTE
    noFill AS _BYTE
END TYPE
TYPE vertex
    x AS INTEGER
    y AS INTEGER
END TYPE
TYPE P5MouseType
    x AS INTEGER 'x-axis   :(
    y AS INTEGER 'y-axis :|
    LB AS _BYTE 'left button :)
    RB AS _BYTE 'right button ;)
    MB AS _BYTE 'middle button :D
    wheel AS INTEGER 'wheeleeeee :->
    event AS INTEGER
END TYPE
'canvas settings related variables
DIM SHARED p5Canvas AS __canvasSettings
'begin shape related variables
DIM SHARED FirstVertex AS vertex, avgVertex AS vertex, PreviousVertex AS vertex, vertexCount AS LONG
DIM SHARED shapeAllow AS _BYTE, shapeType AS INTEGER, shapeInit AS _BYTE
'mouse
DIM SHARED P5Mouse AS P5MouseType
P5Mouse.event = _FREETIMER
ON TIMER(P5Mouse.event, .013) gatherMouseData
TIMER(P5Mouse.event) ON
'default settings
p5Canvas.stroke = _RGB(255, 255, 255) 'white
p5Canvas.fill = _RGB(0, 0, 0)
p5Canvas.strokeWeight = 0
