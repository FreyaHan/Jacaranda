// The Nature of Code
// <http://www.shiffman.net/teaching/nature>
// based on Box2DProcessing example

class Petal {

  Body body;
  float r;
  PGraphics projection;
  float n;

  Petal(float x, float y, float r_) {
    r = r_;
    makeBody(x, y, r);
    projection = createGraphics(700, 450, P3D);
    n+=1;
  }

  // remove the particle from the box2d world
  void killBody() {
    box2d.destroyBody(body);
  }

  boolean done(PGraphics projection) {
    Vec2 pos = box2d.getBodyPixelCoord(body);
    if (pos.y > projection.height+r*2 ||pos.x > projection.width+r*2) {
      killBody();
      return true;
    }
    return false;
  }

  void display( PGraphics projection) { 
    Vec2 pos = box2d.getBodyPixelCoord(body);
    float a = body.getAngle();
    projection.beginDraw();
    projection.pushMatrix();
    projection.translate(pos.x, pos.y);
    projection.rotate(-a);
    projection.fill(colour);
    projection.noStroke();
    projection.ellipse(0, 0, r*2, r*2);
    projection.popMatrix();
    projection.endDraw();
  }

  // add wind force
  void applyForce(Vec2 force) {
    Vec2 pos = body.getWorldCenter();
    body.applyForce(force, pos);
  }

  void makeBody(float x, float y, float r) {
    // Define a body
    BodyDef bd = new BodyDef();
    bd.position = box2d.coordPixelsToWorld(x, y);
    bd.type = BodyType.DYNAMIC;
    body = box2d.world.createBody(bd);

    CircleShape cs = new CircleShape();
    cs.m_radius = box2d.scalarPixelsToWorld(r);

    FixtureDef fd = new FixtureDef();
    fd.shape = cs;
    // Parameters that affect physics
    fd.density = 0.0000000001;
    fd.friction = 0.001;
    fd.restitution = 0.000000000001;

    // Attach fixture to body
    body.createFixture(fd);

    body.setLinearVelocity(new Vec2(noise(n)*1f, noise(n)*1.5f));
    body.setAngularVelocity(noise(n)*100);
  }
}
