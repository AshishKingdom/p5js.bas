DIM SHARED clouds~&, fade~&, further~&, closer~&, mist~&, kk&

'original code in javaScript is at last
'coded in Qb64 by Ashish
'https://www.openprocessing.org/sketch/179401
'$include:'../../p5js.bas'

FUNCTION p5setup ()
    createCanvas 800, 400 'create a 800x400 canvas
    title "Blue Mountains" 'give title to our sketch
    kk& = createImage(800, 400) 'create a new image
    'color settings
    clouds~& = _RGB(200, 200, 200)
    fade~& = _RGB(100, 100, 100)
    further~& = _RGB(170, 170, 255)
    closer~& = _RGB(50, 50, 100)
    mist~& = _RGB(255, 255, 255)
END FUNCTION

FUNCTION p5draw ()
    image kk&, 0, 0
    strokeB 255
    textAlign CENTER
    text "Generating view...", _WIDTH / 2, _HEIGHT / 2 + textHeight
    _DISPLAY
    _DEST kk& 'we'll draw our mountains on here
    background 162, 63.75, 229.5
    fadeB fade~&
    mountains closer~&, further~&, mist~&
    cloudsB clouds~&
    _DEST 0 'now, it's time to show them to user
    image kk&, 0, 0
    makeSmooth 'applying anti-aliasing
    strokeC lerpColor(further~&, closer~&, .1)
    textAlign RIGHT
    text "Click to draw new mountains", _WIDTH, _HEIGHT - textHeight
    noLoop 'turn off drawing loop
END FUNCTION

FUNCTION mousePressed ()
    doLoop 'turn on drawing loop
END FUNCTION

SUB makeSmooth ()
    FOR y = 0 TO _HEIGHT - 1
        FOR x = 0 TO _WIDTH - 1
            r = 0
            g = 0
            b = 0
            col~& = POINT(x, y)
            r = r + _RED(col~&)
            g = g + _GREEN(col~&)
            b = b + _BLUE(col~&)
            col~& = POINT(x + 1, y)
            r = r + _RED(col~&)
            g = g + _GREEN(col~&)
            b = b + _BLUE(col~&)
            col~& = POINT(x, y + 1)
            r = r + _RED(col~&)
            g = g + _GREEN(col~&)
            b = b + _BLUE(col~&)
            col~& = POINT(x + 1, y + 1)
            r = r + _RED(col~&)
            g = g + _GREEN(col~&)
            b = b + _BLUE(col~&)
            PSET (x, y), _RGB(r / 4, g / 4, b / 4)
        NEXT
    NEXT
END SUB

SUB fadeB (col&)
    FOR i = 0 TO _HEIGHT / 3
        alpha = map(i, 0, _HEIGHT / 3, 360, 0)
        strokeWeight 1
        strokeA _RED(col&), _GREEN(col&), _BLUE(col&), alpha
        p5line 0, i, _WIDTH, i
    NEXT
END SUB

SUB cloudsB (col&)
    begin = RND * 250
    DIM j AS _FLOAT, i AS _FLOAT
    FOR x = 0 TO _WIDTH STEP 2
        j = 0
        FOR y = 0 TO _HEIGHT / 3 STEP 2
            alphamax = map(y, 0, _HEIGHT / 4, 520, 0)
            alpha = noise(begin + i, begin + j, 0)
            alpha = map(alpha, .4, 1, 0, alphamax)
            strokeWeight 2
            strokeA _RED(col&), _GREEN(col&), _BLUE(col&), alpha
            p5point x, y
            j = j + .06
        NEXT
        i = i + .01
    NEXT
END SUB

SUB mountains (c&, f&, m&)
    DIM y0 AS _FLOAT
    DIM i0 AS INTEGER
    i0 = 30
    y0 = _WIDTH - 400
    DIM cy(10) AS _FLOAT
    FOR j = 0 TO 10 STEP -1
        cy(9 - j) = y0
        y0 = y0 - i0 / pow(1.2, j)
    NEXT
    DIM dx AS _FLOAT
    dx = 0
    DIM a AS _FLOAT
    DIM b AS _FLOAT
    DIM c AS _FLOAT
    DIM d AS _FLOAT
    DIM e AS _FLOAT
    DIM y AS _FLOAT
    FOR j = 1 TO 10
        a = p5random(-_WIDTH / 2, _WIDTH / 2)
        b = p5random(-_WIDTH / 2, _WIDTH / 2)
        c = p5random(2, 4)
        d = p5random(40, 50)
        e = p5random(-_WIDTH / 2, _WIDTH / 2)
        strokeWeight 2
        FOR x = 0 TO _WIDTH
            y = cy(j)
            y = y + (10 * j * p5sin(2 * dx / j + a))
            y = y + (c * j * p5sin(5 * dx / j + b))
            y = y + (d * j * noise(1.2 * dx / j + e, 0, 0))
            y = y + (1.7 * j * noise(10 * dx, 0, 0))
            strokeC lerpColor(f&, c&, j / 9)
            p5line x, y, x, _HEIGHT
            dx = dx + .02
        NEXT
        backgroundBA 255, 25
    NEXT
END SUB

'originally in javaScript
'color cClouds,  cFade, cFurther, cCloser, cMist;
'void setup()
'{
'  size(800, 600);
'  smooth();

'  //define the colors
'  colorMode(HSB, 360, 100, 100);
'  cClouds = color(330, 25, 100);  //light rose for the clouds
'  cFade = color(220, 50, 50); // purplish saturated medium blue for the fade of the sky
'  cFurther = color(230, 25, 90);  //purplish unsaturated light bluse for the further mountains
'  cCloser = color(210, 70, 10);  //greeny saturated dark blue for the closer mountains
'  cMist = color(360); //white for the mist
'}
'/*------------------------------------*/
'void draw()
'{
'  noLoop();
'  background(230, 25, 90);

'  fade(cFade);
'  clouds(cClouds);
'  mountains(cCloser, cFurther, cMist);
'}
'/*------------------------------------*/
'void mousePressed()
'{
'  loop();
'}
'/*------------------------------------*/
'void keyPressed()  //save the framme when we press the letter s
'{
'  if (key == 's' || key =='S')
'  {
'    saveFrame("landscape-###.png");
'  }
'}
'/*------------------------------------*/
'void fade(color fadeColor)
'{
'  for(int i = 0; i < height/3; i++)
'  {
'    float alfa = map(i, 0, height/3, 360, 0);

'    strokeWeight(1);
'    stroke(fadeColor, alfa);
'    line(0, i, width, i);
'  }
'}
'/*------------------------------------*/
'void clouds(color cloudColor)
'{
'  float begin = random(50); //changes the begin of noise each time

'  float i = 0;

'  for(int x = 0; x < width; x += 2)
'  {
'    float j = 0;

'    for(int y = 0; y < height/3; y += 2)
'    {
'      float alfaMax = map(y, 0, height/4, 520, 0);  //the clouds become transparent as they become near to the mountains
'      float alfa = noise(begin + i, begin + j);
'      alfa = map(alfa, 0.4, 1, 0, alfaMax);

'      noStroke();
'      fill(cloudColor, alfa);
'      ellipse(x, y, 2, 2);

'      j += 0.06; //increase j faster than i so the clouds look horizontal
'    }

'    i += 0.01;
'  }
'}
'/*------------------------------------*/
'void mountains(color closerColor, color furtherColor, color mistColor)
'{
'  //FIND THE REFERENCE Y OF EACH MOUNTAIN:
'  float y0 = width - 500;  //fist reference y
'  int i0 = 30;  //initial interval

'  float[] cy = new float[10]; //initialize the reference y array
'  for (int j = 0; j < 10; j++)
'  {
'    cy[9-j] = y0;
'    y0 -= i0 / pow(1.2, j);
'  }


'  //DRAW THE MOUNTAINS/
'  float dx = 0;

'  for (int j = 1; j <  10; j++)
'  {
'    float a = random(-width/2, width/2);  //random discrepancy between the sin waves
'    float b = random(-width/2, width/2);  //random discrepancy between the sin waves
'    float c = random(2, 4);  //random amplitude for the second sin wave
'    float d = random(40, 50);  //noise function amplitude
'    float e = random(-width/2, width/2);  //adds a discrepancy between the noise of each mountain

'    for (int x = 0; x < width; x ++)
'    {
'      float y = cy[j]; //y = reference y
'      y += 10*j*sin(2*dx/j + a);  //first sin wave oscillates according to j (the closer the mountain, the bigger the amplitude and smaller the frequency)
'      y += c*j*sin(5*dx/j + b);   //second sin wave has a random medium amplitude (affects more the further mountains) and bigger frequenc
'      y += d*j*noise(1.2*dx/j +e);  //first noise function adds randomness to the mountains, amplitude depends on a random number and increases with j, frequency decrases with j
'      y += 1.7*j*noise(10*dx);  //second noise function simulates the canopy, it has high frequency and small amplitude depending on j so it is smoother on the further mountains

'      strokeWeight(2);  //mountains look smoother with stroke weight of 2
'      stroke(lerpColor(furtherColor, closerColor, j/9));
'      line(x, y, x, height);

'      dx += 0.02;
'    }


'    //ADD MIST
'    for (int i =  height; i > cy[j]; i -= 3)
'    {
'      float alfa = map(i, cy[j], height, 0, 360/(j+1));  //alfa is begins bigger for the further mountains
'      strokeWeight(3);  //interval of 3 for faster rendering
'      stroke(mistColor, alfa);
'      line(0, i, width, i);
'    }
'  }
'}
