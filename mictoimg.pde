
import processing.sound.*;

import controlP5.*;
ControlP5 cp5;
FFT fft;
AudioIn in;
int bands = 512;
float[] spectrum = new float[bands];
PImage star;
int direction = 1;
int x;
int speed = 5;
Amplitude amp;
float volume=0;
boolean pause=false;
void setup() {
  size(1920, 800);
  x = width/2;
  background(0);

  fft = new FFT(this, bands);
  amp = new Amplitude(this);
  in = new AudioIn(this, 0);
  in.start();
  fft.input(in);
  amp.input(in);
  star = loadImage("star.png");

  cp5 = new ControlP5(this);
  ControlFont controlFont = new ControlFont(createFont("Arial", 12)); //font for percentage button
  int stepCount = 100; 
  cp5.addSlider("colors")
    .setPosition(900, 0)
    .setSize(300, 40)
    .setRange(0, stepCount-1)
    .setValue(int(stepCount/2))
    .setNumberOfTickMarks(stepCount)
    .setCaptionLabel("colors")
    ;

  cp5.getController("colors").getValueLabel().setVisible(false);
  cp5.getController("colors").getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER);
  cp5.getController("colors").getCaptionLabel().setFont(controlFont);

  controlFont = new ControlFont(createFont("Arial", 18)); //font for percentage button

  cp5.addButton("Pause")
    .setValue(100)
    .setPosition(750, 0)
    .setSize(50, 40)
    .setLabel("||")
    ;

  cp5.getController("Pause").getCaptionLabel().setFont(controlFont);

  cp5.addButton("Play")
    .setValue(0)
    .setPosition(800, 0)
    .setSize(50, 40)
    .setLabel(">")
    ;

  cp5.getController("Play").getCaptionLabel().setFont(controlFont);
}      

void draw() { 
  fill(0, 0, 0, 10);
  if (!pause) {

    rect(0, 0, width, height);
  }  
  fft.analyze(spectrum);
  fill(255, 255, 255, 255);
  if (!pause) {
    x += speed*direction;
  }
  volume = amp.analyze();
 pushStyle();
  colorMode(HSB, 100);
  stroke(int(cp5.getController("colors").getValue()), 255, 255);
  fill( int(cp5.getController("colors").getValue()), 255, 255);

  if (volume>.01) {
    for (int i = 0; i < bands; i++) {
      if (spectrum[i]>.010) {
        if (!pause) {
          star(((speed*5)+direction*15)+ x+random(-50, 50), -10+height-spectrum[i]*height*10, random(3, 6), 10, int(random(4, 6)));
        }
      }
    }
  }
popStyle();
  if (x > width-100 || x < 100) {
    direction = -1 * direction ;
  }
}

void star(float x, float y, float radius1, float radius2, int npoints) {
  float angle = TWO_PI / npoints;
  float halfAngle = angle/2.0;
  if (random(5)>4) {
    beginShape();
  } else if (random(5)>4)
  { 
    beginShape(POINTS);
  } else
  {
    beginShape(LINES);
  }
  for (float a = 0; a < TWO_PI; a += angle) {
    float sx = x + cos(a) * radius2;
    float sy = y + sin(a) * radius2;
    vertex(sx, sy);
    sx = x + cos(a+halfAngle) * radius1;
    sy = y + sin(a+halfAngle) * radius1;
    vertex(sx, sy);
  }
  endShape(CLOSE);
}

void colors() {
  pushStyle();
  colorMode(HSB, 100);
  cp5.getController("colors").setColorBackground(color(int(cp5.getController("colors").getValue()), 100, 100));
  cp5.getController("colors").setColorForeground(color(int(cp5.getController("colors").getValue()), 100, 100));
  cp5.getController("colors").setColorActive(color(int(cp5.getController("colors").getValue()), 100, 80));
  popStyle();
}

void Pause() {
  pause = true;
}
void Play() {
  pause = false;
}