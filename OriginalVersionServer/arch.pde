// Reference
// Nature of Code: https://natureofcode.com/book/chapter-5-physics-libraries/#chapter05_section4
// tutorials - https://www.youtube.com/watch?v=MsRROjQJxuo&list=PLRqwX-V7Uu6Zy4FyZtCHsZc_K0BrXzxfE
class Arch {

  Body body;
  float w;
  float h;
  float r;
  PGraphics projection;

  Arch(float x, float y) {
    w = 240;
    h = 120;
    r = 130;

    // Add to the box2d world
    makeBody(new Vec2(x, y));
    projection = createGraphics(700, 450, P3D);
  }

  // Drawing the arches
  void display(PGraphics projection) {
    Vec2 pos = box2d.getBodyPixelCoord(body);

    projection.beginDraw();
    projection.rectMode(CENTER);
    projection.pushMatrix();
    projection.translate(pos.x, pos.y);
    projection.fill(0, 0);
    projection.stroke(0, 0);
    projection.ellipse(0, h/9, r*2, r*2);
    projection.popMatrix();
    projection.endDraw();
  }

  // add the circle to the box2d world
  void makeBody(Vec2 center) {

    // Define the body and make it from the shape
    BodyDef bd = new BodyDef();
    bd.type = BodyType.STATIC;
    bd.position.set(box2d.coordPixelsToWorld(center));
    body = box2d.createBody(bd);

    CircleShape circle = new CircleShape();
    circle.m_radius = box2d.scalarPixelsToWorld(r);
    Vec2 offset = new Vec2(0, h/9);
    offset = box2d.vectorPixelsToWorld(offset);

    circle.m_p.set(offset.x, offset.y);

    body.createFixture(circle, 0.0001);
  }
}
