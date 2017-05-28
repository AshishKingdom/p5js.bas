dim shared prt&, particles(10000) as particle

'$include:'p5js.bas'

type particle
    pos as vector
	vel as vector
	life as integer
	death as integer
end type 

function p5setup()
    title "Glowing Particles"
    createCanvas 500,500
	for i = 0 to ubound(particles)
	    particles(i).pos.x = _mousex
		particles(i).pos.y = _mousey
		particles(i).vel.x = p5random(-2,2)
		particles(i).vel.y = p5random(-2,3)
		particles(i).death = p5random(50,100)
	next
	prt& = _loadimage("sprite.png",33)
end function

function p5draw()
    for i = 0 to ubound(particles)
	    vector.add particles(i).pos, particles(i).vel
		_putimage (particles(i).pos.x-16, particles(i).pos.y-16)-step(32,32),prt&,,,_smooth
		particles(i).life = particles(i).life+1
		particles(i).vel.y = particles(i).vel.y + .1
		if particles(i).life>particles(i).death then
		    particles(i).life = 0
		    particles(i).pos.x = _mousex
			particles(i).pos.y = _mousey
			particles(i).vel.x = p5random(-2,2)
			particles(i).vel.y = p5random(-2,3)
			particles(i).death = p5random(100,300)
		end if
	next
end function 