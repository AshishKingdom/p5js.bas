'$include:'../../p5js.bas'

FUNCTION p5setup ()
    'Syntax :- p5bezier startX%, startY%, controlPointX1%, controlPointY1%, controlPointX2%, controlPointY2%, endX%. endY%
    strokeB 255
    noFill
END FUNCTION

FUNCTION p5draw () STATIC
    backgroundB 51

    IF radius <= 0 THEN radius = 20
    theStep = .5

    size = size + p5mouseWheel
    IF size <= 5 THEN size = 5
    IF size > 20 THEN size = 20

    strokeWeight size

    IF _MOUSEBUTTON(1) THEN
        IF mouseDown = false THEN
            mouseDown = true
            v = v + 1
            IF v = 5 THEN v = 0
        END IF

        IF mouseDown THEN
            SELECT CASE v
                CASE 1
                    x = _MOUSEX
                    y = _MOUSEY
                CASE 2
                    x2 = _MOUSEX
                    y2 = _MOUSEY
                CASE 3
                    ctx1 = _MOUSEX
                    cty1 = _MOUSEY
                CASE 4
                    ctx2 = _MOUSEX
                    cty2 = _MOUSEY
            END SELECT
        END IF
    ELSE
        mouseDown = false
        radius = 20
    END IF

    IF v = 0 THEN
        text "Click to mark the beginning of the line...", 0, 0
    ELSEIF v = 1 THEN
        IF mouseDown THEN
            text "Release to mark the beginning of the line...", 0, 0
        ELSE
            IF m = false THEN
                text "Click to mark the end of the line (try dragging)...", 0, 0
            ELSE
                text "Click to mark the end of the line...", 0, 0
            END IF
        END IF
        p5point x, y
        IF mouseDown THEN CIRCLE (x, y), radius: radius = radius - theStep
    ELSEIF v = 2 THEN
        IF mouseDown THEN
            text "Release to mark the end of the line...", 0, 0
        ELSE
            text "Click to place the first control point...", 0, 0
        END IF
        p5line x, y, x2, y2
        IF mouseDown THEN CIRCLE (x2, y2), radius: radius = radius - theStep
    ELSEIF v = 3 THEN
        IF mouseDown THEN
            text "Release to place the first control point...", 0, 0
        ELSE
            text "Click to place the second control point...", 0, 0
        END IF
        p5bezier x, y, ctx1, cty1, ctx1, cty1, x2, y2
        IF mouseDown THEN CIRCLE (ctx1, cty1), radius: radius = radius - theStep
    ELSEIF v = 4 THEN
        stroke 100, 194, 94
        text "Voila! Such a nice bezier curve!", 0, 0
        IF NOT mouseDown THEN text "Click to clear and start over...", 0, 20
        IF mouseDown THEN CIRCLE (ctx2, cty2), radius: radius = radius - theStep
        p5bezier x, y, ctx1, cty1, ctx2, cty2, x2, y2
        strokeB 255
        m = true
    END IF
END FUNCTION
