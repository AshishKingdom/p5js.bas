# p5js.bas

A port of the p5.js library, written in and adapted for QB64.
***
## Say what?

Lauren McCarthy has created p5.js, a native JavaScript alternative to Processing.js that has the official support of the Processing Foundation. See more about it at https://p5js.org/

This is a rewrite of all that's possible so that the same paradigms and techniques can be accomplished in QB64. QB64 is a modern extended BASIC programming language that retains QB4.5/Qbasic compatibility and compiles native binaries for Windows, Linux and macOS. See more about it at www.qb64.com.
***
## Is this for the web?

Definitely not. QB64 is a compiled language, so the goal is to make drawing/animation as simple as it is on the web but for Windows/Linux/macOS programs.
***
## Is this backed by the Processing Foundation?

We're not related to the [Processing Foundation](https://processing.org), mantainer of [p5.js](https://p5js.org). We're fans. This is an open source adaptation of existing open source work.
***
## How many functions does it support?

Currently, p5js.bas has support for the following:

* [arc()](https://p5js.org/reference/#/p5/arc) 
* [angleMode()](https://p5js.org/reference/#/p5/angleMode)
* [background()](https://p5js.org/reference/#/p5/background)
* [beginShape()](https://p5js.org/reference/#/p5/beginShape)
* [bezier()](https://p5js.org/reference/#/p5/bezier)
* [brightness()](https://p5js.org/reference/#/p5/brightness)
* [color()](https://p5js.org/reference/#/p5/color)
* [colorMode()](https://p5js.org/reference/#/p5/colorMode)
* [constrain()](https://p5js.org/reference/#/p5/constrain)
* [createCanvas()](https://p5js.org/reference/#/p5/createCanvas)
* [createImage()](https://p5js.org/reference/#/p5/createImage)
* [createVector()](https://p5js.org/reference/#/p5/createVector)
* [cursor()](https://p5js.org/reference/#/p5/cursor)
* [curve()](https://p5js.org/reference/#/p5/curve)
* [day()](https://p5js.org/reference/#/p5/day)
* [dist()](https://p5js.org/reference/#/p5/dist)
* [doLoop()](https://p5js.org/reference/#/p5/loop)
* [endShape()](https://p5js.org/reference/#/p5/endShape)
* [fill()](https://p5js.org/reference/#/p5/fill)
* [frameCount()](https://p5js.org/reference/#/p5/frameCount)
* [height()](https://p5js.org/reference/#/p5/height)
* [hue()](https://p5js.org/reference/#/p5/hue)
* [hour()](https://p5js.org/reference/#/p5/hour)
* [join()](https://p5js.org/reference/#/p5/join)
* [lerp()](https://p5js.org/reference/#/p5/lep)
* [lerpColor()](https://p5js.org/reference/#/p5/lerpColor)
* [lightness()](https://p5js.org/reference/#/p5/lightness)
* [loadSound()](https://p5js.org/reference/#/p5/loadSound)
* [mag()](https://p5js.org/reference/#/p5/mag)
* [map()](https://p5js.org/reference/#/p5/map)
* [max()](https://p5js.org/reference/#/p5/max)
* [min()](https://p5js.org/reference/#/p5/min)
* [minute()](https://p5js.org/reference/#/p5/minute)
* [month()](https://p5js.org/reference/#/p5/month)
* [noFill()](https://p5js.org/reference/#/p5/noFill)
* [noise()](https://p5js.org/reference/#/p5/noise)
* [noLoop()](https://p5js.org/reference/#/p5/noLoop)
* [noStroke()](https://p5js.org/reference/#/p5/noStroke)
* [p5cos()](https://p5js.org/reference/#/p5/cos)
* [p5ellipse()](https://p5js.org/reference/#/p5/ellipse)
* [p5line()](https://p5js.org/reference/#/p5/line)
* [p5play()](https://p5js.org/reference/#/p5/play)
* [p5point()](https://p5js.org/reference/#/p5/point)
* [p5PrintString()](https://p5js.org/reference/#/p5/text)
* [p5quad()](https://p5js.org/reference/#/p5/quad)
* [p5random()](https://p5js.org/reference/#/p5/random)
* [p5rect()](https://p5js.org/reference/#/p5/rect)
* [p5sin()](https://p5js.org/reference/#/p5/sin)
* [p5triangle()](https://p5js.org/reference/#/p5/triangle)
* [pop()](https://p5js.org/reference/#/p5/pop)
* [pow()](https://p5js.org/reference/#/p5/pow)
* [push()](https://p5js.org/reference/#/p5/push)
* [rectMode()](https://p5js.org/reference/#/p5/rectMode)
* [saturation](https://p5js.org/reference/#/p5/saturation)
* [seconds()](https://p5js.org/reference/#/p5/seconds)
* [sq()](https://p5js.org/reference/#/p5/sq)
* [stroke()](https://p5js.org/reference/#/p5/stroke)
* [text()](https://p5js.org/reference/#/p5/text)
* [textAlign()](https://p5js.org/reference/#/p5/textAlign)
* [textFont()](https://p5js.org/reference/#/p5/textFont)
* [textHeight()](https://p5js.org/reference/#/p5/textHeight)
* [textSize()](https://p5js.org/reference/#/p5/textSize)
* [textWidth()](https://p5js.org/reference/#/p5/textWidth)
* [title()](https://p5js.org/reference/#/p5/title)
* [translate()](https://p5js.org/reference/#/p5/translate)
* [vector.add()](https://p5js.org/reference/#/p5.Vector)
* [vector.addB()](https://p5js.org/reference/#/p5.Vector)
* [vector.div()](https://p5js.org/reference/#/p5.Vector)
* [vector.fromAngle()](https://p5js.org/reference/#/p5.Vector)
* [vector.limit()](https://p5js.org/reference/#/p5.Vector)
* [vector.mag()](https://p5js.org/reference/#/p5.Vector)
* [vector.magSq()](https://p5js.org/reference/#/p5.Vector)
* [vector.mult()](https://p5js.org/reference/#/p5.Vector)
* [vector.normalize()](https://p5js.org/reference/#/p5.Vector)
* [vector.random2d()](https://p5js.org/reference/#/p5.Vector)
* [vector.setMag()](https://p5js.org/reference/#/p5.Vector)
* [vector.sub()](https://p5js.org/reference/#/p5.Vector)
* [vector.subB()](https://p5js.org/reference/#/p5.Vector)
* [vertex()](https://p5js.org/reference/#/p5/vertex)
* [width()](https://p5js.org/reference/#/p5/width)
* [year()](https://p5js.org/reference/#/p5/year)
