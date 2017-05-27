'$include:'../../p5js.bas'

'Sample adapted from https://p5js.org/reference/#/p5/push
'Description:
'The push() function saves the current drawing style settings
'and transformations, while pop() restores these settings.
'Note that these functions are always used together. They allow
'you to change the style and transformation settings and later
'return to what you had. When a new state is started with push(),
'it builds on the current style and transform information. The
'push() and pop() functions can be embedded to provide more control.

FUNCTION p5setup
    createCanvas 200, 100
END FUNCTION

FUNCTION p5draw
    backgroundB 150
    p5ellipse 0, 50, 33, 33 'Left circle

    push 'Start a new drawing state
    strokeWeight 10
    fill 204, 153, 0
    p5ellipse 33, 50, 33, 33 'Left-middle circle

    push 'Start another new drawing state

    stroke 0, 102, 153
    p5ellipse 66, 50, 33, 33 'Right-middle circle
    pop 'Restore previous state

    pop 'Restore original state

    p5ellipse 100, 50, 33, 33 'Right circle
END FUNCTION
