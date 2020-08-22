class Boundary {

  Body body;
  float rectW;
  float rectH;
  PGraphics projection;

  // Constructor pixel
  Boundary(float w, float h, float x, float y) {
    rectW = w;
    rectH = h;
    // Add the box to the box2d world
    makeBody(new Vec2(x, y));
    projection = createGraphics(700, 450, P3D);
  }

  // Drawing the rect
  void display(PGraphics projection) {
    //get screen position of body
    Vec2 pos = box2d.getBodyPixelCoord(body);

    projection.beginDraw();
    projection.translate(pos.x, pos.y);
    projection.fill(0, 0);
    projection.stroke(150, 0);
    projection.rect(0, 0, rectW, rectH);
    projection.endDraw();
  }

  // add the rect to the box2d world
  void makeBody(Vec2 center) {

    BodyDef bd = new BodyDef();
    bd.type = BodyType.STATIC;
    bd.position.set(box2d.coordPixelsToWorld(center));
    body = box2d.createBody(bd);

    PolygonShape polygon = new PolygonShape();
    float box2dW = box2d.scalarPixelsToWorld(rectW/2);
    float box2dH = box2d.scalarPixelsToWorld(rectH/2);
    polygon.setAsBox(box2dW, box2dH);

    body.createFixture(polygon, 0.0001);
  }
}
