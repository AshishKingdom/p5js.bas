'$include:'../../p5js.bas'

FUNCTION p5setup
    createCanvas 400, 400
    strokeWeight 4
    stroke 255, 255, 255
    frameRate = 15
    backgroundB 51
END FUNCTION

FUNCTION p5draw
    fillA RND * 255, RND * 255, RND * 255, 200
    p5triangle RND * _WIDTH / 2, RND * _HEIGHT / 2, _WIDTH - RND * (_WIDTH / 2), _HEIGHT - RND * (_HEIGHT / 2), RND * _WIDTH, RND * _HEIGHT
END FUNCTION

