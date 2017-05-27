'Coded in QB64 By Ashish
'Adapted from https://www.openprocessing.org/sketch/429617
'original code is at below

DIM SHARED points
points = 20
DIM SHARED startX AS _FLOAT, startY AS _FLOAT, Patterns(points) AS pattern

'$include:'../../p5js.bas'

TYPE pattern
    x AS SINGLE
    y AS SINGLE
    x2 AS SINGLE
    y2 AS SINGLE
    vx AS SINGLE
    vy AS SINGLE
    speed AS SINGLE
    angle AS SINGLE
END TYPE

FUNCTION p5setup ()
    title "Shower Sponge"
    createCanvas 700, 700
    startX = width / 2
    startY = height / 2
    strokeWeight 1
    FOR i = 0 TO points
        Patterns(i).x = startX
        Patterns(i).y = startY
        Patterns(i).vx = p5random(-1, 1)
        Patterns(i).vy = p5random(-1, 1)
        Patterns(i).x2 = 0
        Patterns(i).y2 = 0
        Patterns(i).speed = RND * 5
        Patterns(i).angle = points + 0.01 * Patterns(i).speed * frameCount + RND * TWO_PI
    NEXT
    backgroundB 255
END FUNCTION

FUNCTION p5draw ()
    limit = 600
    r## = 50
    border## = 100
    FOR i = 0 TO points
        Patterns(i).x = Patterns(i).x + Patterns(i).vx
        Patterns(i).y = Patterns(i).y + Patterns(i).vy
        Patterns(i).angle = points + 0.01 * Patterns(i).speed * frameCount
        IF Patterns(i).x < border## OR Patterns(i).x > width - border## OR Patterns(i).y < border## OR Patterns(i).y > height - border## THEN
            Patterns(i).x = startX
            Patterns(i).y = startY
            Patterns(i).vx = p5random(-1, 1)
            Patterns(i).vy = p5random(-1, 1)
            Patterns(i).x = Patterns(i).x + Patterns(i).vx
            Patterns(i).y = Patterns(i).y + Patterns(i).vy
        END IF
        Patterns(i).x2 = Patterns(i).x + r## * p5cos(Patterns(i).angle)
        Patterns(i).y2 = Patterns(i).y + r## * p5sin(Patterns(i).angle)
        'p5point Patterns(i).x, Patterns(i).y
    NEXT
    
    FOR i = 0 TO points
        FOR j = 0 TO points
            d## = dist(Patterns(i).x2, Patterns(i).y2, Patterns(j).x2, Patterns(j).y2)
            IF d## < limit THEN
                strokeA map(d##, 0, 200, 0, 255), map(d##, 0, 100, 255, 0), 255, map(d##, 0, 100, 100, 0)
                p5line Patterns(i).x2, Patterns(i).y2, Patterns(j).x2, Patterns(j).y2
            END IF
        NEXT
    NEXT
END FUNCTION

' //emitter
' //number of dots
' //make x,y,vx,vy array
' //make circle around array elements
' //make a distance
' //make limit
' //if distance is smaller then limit
' //draw a line between circle point
' //change their color based on the distance to the border
' int points = 20;

' float startX;
' float startY;
' float[] x;
' float[] y;
' float[] vx;
' float[] vy;
' float[] x2;
' float[] y2;
' float[] speed;
' float[] angle;
' float limit;

' void setup() {
' background(255);
' size(800, 800);

' startX = width/2;
' startY = height/2;

' for (int i = 0; i < points; i++) {
' x = new float[points];
' y = new float[points];
' vx = new float[points];
' vy = new float[points];
' x2 = new float[points];
' y2 = new float[points];
' speed = new float[points];
' angle = new float[points];
' }

' for (int i = 0; i < points; i++) {
' x[i] = startX;
' y[i] = startY;
' vx[i] = random (-1, 1);
' vy[i] = random (-1, 1);
' x2[i] = 0;
' y2[i] = 0;
' speed[i] = random(5);
' angle[i] = points + 0.01*speed[i]*frameCount+random(TWO_PI);
' }
' }

' void draw() {

' //fill(255,5);
' //rect(0,0,width,height);
' limit = 600;
' float r = 50;
' float border = 200;
' for (int i  = 0; i < points; i++) {
' x[i] += vx[i];
' y[i] += vy[i];
' angle[i] = points + 0.01*speed[i]*frameCount;
' if (x[i] < border || x[i] > width-border || y[i] < border || y[i] > height-border) {
' x[i] = startX;
' y[i] = startY;
' vx[i] = random(-1, 1);
' vy[i] = random(-1, 1);
' x[i] += vx[i];
' y[i] += vy[i];
' }
' //point(x[i], y[i]);

' x2[i] = x[i] + r * cos(angle[i]);
' y2[i] = y[i] + r * sin(angle[i]);
' //point(x2[i], y2[i]);
' }

' for (int i = 0; i<points; i++) {
' for ( int j = 0; j<points; j++) {
' float distance = dist(x2[i], y2[i], x2[j], y2[j]);
' if (distance < limit) {
' stroke(map(distance,0,200,0,255),map(distance,0,100,255,0),255,map(distance,0,100,100,0));
' line(x2[i], y2[i], x2[j], y2[j]);
' }
      
' }
' }
' }

' void keyPressed() {
' if (key == 's') {
' saveFrame("a.jpg");
' }
' }
