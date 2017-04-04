SCREEN _NEWIMAGE(600, 600, 32)
'$include:'p5js_header.bas'
strokeWeight 2
stroke 255, 255, 255
fill 255, 0, 0
DO
    drawEllipse P5Mouse.x, P5Mouse.y, 30, 30
    _DISPLAY
    _LIMIT 40
LOOP
'$include:'p5js.bas'
