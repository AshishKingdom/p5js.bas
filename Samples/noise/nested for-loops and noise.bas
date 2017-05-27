DIM SHARED zPos AS SINGLE

'coded in Qb64 By Ashish
'from
'original code is below
'$include:'../../p5js.bas'

FUNCTION p5setup ()
    title "Nested for-loops and noise"
    createCanvas 350, 350
    frameRate = 120
END FUNCTION

FUNCTION p5draw ()
    noStroke
    fillBA 0, 10
    p5rect 0, 0, height, width
    strokeBA 255, 100

    FOR y = 0 TO height STEP 20
        FOR x = 0 TO width
            p5point x, y + map(noise(x / 150, y / 150, zPos), 0, 1, -100, 100)
        NEXT
    NEXT
    zPos = zPos + .02
END FUNCTION



'float z = 0; // create variable for noise z

'void setup() {
'    size(500, 500);
'}

'void draw() {
'    noStroke();
'    fill(0, 10);
'    rect(0,0,height,width);
'    stroke(255, 100);

'    // float y = 0; creates decimal variable y and assigns value 0 to it
'    // loop repeats as long as y < height; is true
'    // y = y + 20 increments y in the end of each iteration.
'    for (float y = 0; y < height; y = y + 20) {
'        // float x = 0; creates decimal variable x and assigns value 0 to it
'        // loop repeats as long as x < width; is true
'        // x = x + 1 increments the x in the end of each iteration.
'        for (float x = 0; x < width; x = x + 1) {
'            point(x, y + map(noise(x/150, y/150, z), 0, 1, -100, 100));
'        }
'    }
'    // when y is 500 the program will move forward. In this case increment z
'    z = z + 0.02;
'}

