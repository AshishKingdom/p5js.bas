'$include:'../../p5js.bas'

function p5setup()
    title "Using color Names"
	createCanvas 400,400
end function

function p5draw()
    backgroundNA "#ffffff", 30 'NA = Name & Alpha, N = Name, they are in short form
    strokeN "red"
	fillN "yellow green"
	strokeWeight 2
	p5ellipse _mousex, _mousey, 30,30
end function 