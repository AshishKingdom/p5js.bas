_DEFINE A-Z AS _FLOAT
CONST NUM = 24

'$include:'../../p5js.bas'

FUNCTION p5setup
    createCanvas 640, 640
    title "loop of circles"
    noStroke
    frameRate = 60
END FUNCTION

FUNCTION p5draw
    backgroundA 0, 0, 30, 20
    translate _WIDTH / 2, _HEIGHT / 2

    FOR i = 1 TO NUM
        angle = i * TWO_PI / NUM
        v = pow(ABS(p5sin(angle / 2 + frameCount * .03)), 4)
        r = map(v, 0, 1, 10, 20)
        fillC lerpColor(color(255, 0, 191), color(191, 255, 0), v)
        p5ellipse (150 + r) * p5cos(angle), (150 + r) * p5sin(angle), r, r
    NEXT
END FUNCTION

'Original:
'https://www.openprocessing.org/sketch/396401
'/**
'* loop of circles
'*
'* @author aa_debdeb
'* @date 2016/12/23
'*/

'int NUM = 24;

'void setup(){
'  size(640, 640);
'  noStroke();
'}

'void draw(){
'  background(0, 0, 30);
'  translate(width / 2, height / 2);
'  for(int i = 0; i < NUM; i++){
'    float angle = i * TWO_PI / NUM;
'    float v = pow(abs(sin(angle / 2 + frameCount * 0.03)), 4);
'    float r = map(v, 0, 1, 10, 20);
'    fill(lerpColor(color(255, 0, 191), color(191, 255, 0), v));
'    ellipse((150 + r) * cos(angle), (150 + r) * sin(angle), r * 2, r * 2);
'  }
'}

