'draws a radial ball

'$include:'../../p5js.bas'

function p5setup()
    createCanvas 600,600
    noFill
    strokeWeight 2
    colorMode p5HSB
end function

function p5draw()
    for i = 0 to 255
        stroke i, 200, 100
        p5ellipse 300,300,i,i
    next
    noLoop
end function
