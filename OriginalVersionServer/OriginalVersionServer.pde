import shiffman.box2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import deadpixel.keystone.*;
import controlP5.*;

Keystone ks;
CornerPinSurface keystoneSurface;
ControlP5 cp5;
Button pur1, pur2, pur3;

PGraphics ja;
PImage siteImage;
PImage walkingPerson;
float t; // noise force
float j; // noise size
float n;// noise tree wind
float petalSize;
color colour;
Box2DProcessing box2d;

// fixed objects
ArrayList<Arch> arches;
ArrayList<Boundary> boundaries;
// A list for all of our petals
ArrayList<Petal> petals;

void setup() {
  size(1024, 768, P3D);
  //background (255);
  smooth();

  ks = new Keystone(this);
  keystoneSurface = ks.createCornerPinSurface(700, 450, 20);

  // create jacaranda layer
  ja = createGraphics(700, 450, P3D);
  siteImage =  loadImage("data/site3.png");
  walkingPerson =  loadImage("data/walk.png");

  cp5 = new ControlP5(this);
  colour = color(138, 103, 255);
  pur1 = cp5.addButton("pinkPurple")
    .setPosition(0, 680) //moving the button to the specific location on the screen 
    .setSize(200, 19) //setting the size in pixels of the button 
    ;

  pur2 = cp5.addButton("jacarandaPurple")
    .setPosition(0, 700) //moving the button to the specific location on the screen 
    .setSize(200, 19) //setting the size in pixels of the button 
    ;

  pur3 = cp5.addButton("bluePurple")
    .setPosition(0, 720) //moving the button to the specific location on the screen 
    .setSize(200, 19) //setting the size in pixels of the button 
    ;

  // Initialize box2d physics and create the world
  box2d = new Box2DProcessing(this, 20);
  box2d.createWorld();
  // set gravity
  box2d.setGravity(0, -1);

  // Create ArrayLists  
  arches = new ArrayList<Arch>();
  boundaries = new ArrayList<Boundary>();
  petals = new ArrayList<Petal>();

  // Add fixed boundaries
  arches.add(new Arch(215, 410));
  arches.add(new Arch(540, 410));

  boundaries.add(new Boundary (20, 1, 30, 225));
  boundaries.add(new Boundary (30, 1, 140, 225));
  boundaries.add(new Boundary (1, 5, 150, 220));
  boundaries.add(new Boundary (20, 1, 255, 225));
  boundaries.add(new Boundary (20, 1, 370, 225));
  boundaries.add(new Boundary (20, 1, 690, 225));

  boundaries.add(new Boundary (20, 1, 90, 202));
  boundaries.add(new Boundary (20, 1, 191, 202));
  boundaries.add(new Boundary (30, 1, 338, 208));
  boundaries.add(new Boundary (1, 5, 350, 202));
  boundaries.add(new Boundary (20, 1, 435, 208));
  boundaries.add(new Boundary (20, 1, 620, 208));
  boundaries.add(new Boundary (20, 1, 524, 188));

  //left window
  //bottom
  boundaries.add(new Boundary ( 20, 1, 48, 165));
  boundaries.add(new Boundary ( 20, 1, 94, 165));
  boundaries.add(new Boundary ( 50, 1, 138, 165));
  boundaries.add(new Boundary ( 1, 15, 165, 146));
  //top
  boundaries.add(new Boundary ( 1, 15, 55, 55));
  boundaries.add(new Boundary ( 1, 15, 95, 55));
  boundaries.add(new Boundary ( 1, 15, 141, 55));
  boundaries.add(new Boundary ( 15, 1, 60, 65));
  boundaries.add(new Boundary ( 15, 1, 90, 65));
  boundaries.add(new Boundary ( 15, 1, 101, 65));
  boundaries.add(new Boundary ( 15, 1, 131, 65));

  //right window
  //bottom
  boundaries.add(new Boundary ( 20, 1, 350, 165));
  boundaries.add(new Boundary ( 20, 1, 400, 165));
  boundaries.add(new Boundary ( 50, 1, 450, 165));
  boundaries.add(new Boundary ( 50, 1, 510, 165));
  boundaries.add(new Boundary ( 1, 10, 538, 154));
  //top
  boundaries.add(new Boundary ( 20, 1, 350, 35));
  boundaries.add(new Boundary ( 20, 1, 400, 35));
  boundaries.add(new Boundary ( 30, 1, 450, 35));
  boundaries.add(new Boundary ( 44, 1, 504, 35));
  boundaries.add(new Boundary ( 1, 10, 532, 22));

  //line
  boundaries.add(new Boundary ( 60, 1, 140, 250));
  boundaries.add(new Boundary ( 1, 8, 168, 250));
  boundaries.add(new Boundary ( 90, 1, 540, 253));
  boundaries.add(new Boundary ( 1, 8, 573, 250));

  //columns and trunk
  boundaries.add(new Boundary ( 1, 70, 50, 330));
  boundaries.add(new Boundary ( 1, 20, 360, 410));

  //adjust keystone surface position
  int pwidth=700;
  int pheight=450;
  keystoneSurface.moveMeshPointBy(CornerPinSurface.TL, 404, 146);
  keystoneSurface.moveMeshPointBy(CornerPinSurface.TR, 1012-pwidth, 85);
  keystoneSurface.moveMeshPointBy(CornerPinSurface.BL, 416, 597-pheight );
  keystoneSurface.moveMeshPointBy(CornerPinSurface.BR, 1016-pwidth, 584-pheight );
}


void draw() {
  image(siteImage, 0, 0, width, height);
  //println ("mouseX:"+mouseX +"mouseY:" +mouseY);

  // the condition to trigger the offline interaction
  if (mouseY>635 && mouseY<768) {
    show = true;
    push();
    imageMode(CENTER);
    image(walkingPerson, mouseX, mouseY, 150, 150);
    pop();
  } else {
    show = false;
  }

  ja.beginDraw();
  // online user interaction - trigger white trunk jacaranda
  ja.pushMatrix();
  ja.translate(ja.width / 2, ja.height);
  ja.scale(1.4, -1);
  ja.translate(20, 0);
  ja.background(0, 0); // clear PGraphics
  if (petals.size()>60) {
    ja.stroke(0);
    branch(1, randSeed, ja);
    prog+=0.05;
  } 
  if (petals.size()<60) {
    prog=0;
  }
  ja.popMatrix();

  //offline interaction trigger - blossom jacaranda
  ja.push();
  ja.translate(0, -100);
  ja.translate(ja.width / 2, ja.height+100.5);
  ja.scale(1.4, -1);
  ja.translate(20, 0);
  if (show) {
    ja.stroke(0);
    branch2(1, randSeed2, ja);
    prog2+=0.05;
  } 
  if (!show) {
    prog2=0;
  }
  ja.pop();


  // petal section
  box2d.step();

  //draw arches
  for (Arch a : arches) {
    a.display(ja);
  }

  //draw boundary
  for (Boundary b : boundaries) {
    b.display(ja);
  }

  //draw petals 
  if (mousePressed) {
    petalSize= noise(j)*7;
    //println(petalSize);

    if (petalSize>3) {
      petals.add(new Petal(mouseX-340, mouseY-125, petalSize));
    }
  }

  for (Petal p : petals) {
    p.display(ja);
  }

  //remove petals if they're out of PGraphic
  for (int i = petals.size()-1; i >= 0; i--) {
    Petal p = petals.get(i);
    if (p.done(ja)) {
      petals.remove(i);
    }
  }

  //apply noise wind
  for ( Petal p : petals) {
    if (petalSize>3 && petalSize<6) {
      float f = noise (t);
      float f2=0.00000000001;
      Vec2 wind = new Vec2(f*f2, 0);
      p.applyForce(wind);
    } 
    if (petalSize>6 && petalSize<9) {
      float f = noise (t);
      float f2=0.00000000001;
      Vec2 wind = new Vec2(-f*f2, 0);
      p.applyForce(wind);
    }
  }

  ja.endDraw();


  keystoneSurface.render(ja);
  j+=1;
  t+=1;
}

public void pinkPurple() {
  colour = color(154, 118, 216);
}

public void jacarandaPurple() {
  colour = color(138, 103, 255);
}

public void bluePurple() {
  colour = color(114, 130, 216);
}

void keyPressed() {
  if (key == 'c') {
    // enter/leave calibration mode, where surfaces can be warped 
    // and moved
    ks.toggleCalibration();
  }
}
