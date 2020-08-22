// online interaction 
// reference: https://github.com/someuser-321/TreeGenerator/tree/4d6c6e3f9a8093a8544ee46822c2d3deb11f8d00
float prog;
float growthLevel;
float len;  //branch level
float maxLevel = 10;//tree size
float size = 140;// split probability
float branchProb = 0.9;// floawer probability
float flowerProb = 0.9;// angle
float angle = (PI/2)/4;// split rotation
float rotRand = random( 0.5, 1);
int randSeed =993; //1000 / 993 / 188 /520
boolean show;
float treeWind;
void branch(float level, int seed, PGraphics p ) {

  if (prog < level)
    return;

  //https://www.geeksforgeeks.org/p5-js-randomseed-function/
  //get the same random values time after time
  randomSeed(seed);
  int seed1 = floor(random(1000)); 
  int seed2 = floor(random(1000));


  //http://codingdict.com/questions/8347
  // equals to
  // if (prog >= maxLevel + 1) {
  // growthLevel = 1}
  // else { 
  //   growthLevel=prog - level
  // }
  growthLevel = (prog - level > 1) || (prog >= maxLevel + 1) ? 1 : (prog - level);

  p.strokeWeight(20 * pow((maxLevel - level + 1)*1.2 / maxLevel, 2));
  float rand2 = random(-1, 1);
  float rand = random(0, 1);
  //println(rand2);
  len = growthLevel * size * (1 + rand2)/level;
  p.stroke(255);
  p.line(0, 0, 0, len);
  p.translate(0, len); 
  //println(len);
  boolean drawBranch1 = rand < branchProb;
  boolean drawBranch2 = rand < branchProb;
  boolean drawFlower = rand < flowerProb;

  // if there are offline users, then apply wind animation
  if (mouseY>635 && mouseY<768 && level < maxLevel) {
    float treeWind = noise(n/1000000)-0.5;
    float r1 = angle * (1 + (rand2+treeWind) * rotRand);
    float r2 = -angle * (1- (rand2+treeWind) * rotRand);
    n++;

    if (drawBranch1) {
      p.push();
      p.rotate(r1);
      branch(level + 1, seed1, p);
      p.pop();
    }
    if (drawBranch2) {
      p.push();
      p.rotate(r2);
      branch(level + 1, seed2, p);
      p.pop();
    }
  }

  // if there is no offline user, the tree is static
  if (mouseY<635 && level < maxLevel) {
    float treeWind = 0;
    float r1 = angle * (1 + (rand2+treeWind) * rotRand);
    float r2 = -angle * (1- (rand2+treeWind) * rotRand);
    n=0;

    if (drawBranch1) {
      p.push();
      p.rotate(r1);
      branch(level + 1, seed1, p);
      p.pop();
    }
    if (drawBranch2) {
      p.push();
      p.rotate(r2);
      branch(level + 1, seed2, p);
      p.pop();
    }
  }

  // draw flowers
  if ((level >= maxLevel || (!drawBranch1 && !drawBranch2)) && drawFlower) {
    float flowerSize = (size / 100) * (len) * 0.3;
    p.noStroke();
    p.fill(138, 103, 255);
    float fs= flowerSize * ( 0.8 + 0.5 * rand2);
    p.ellipse(0, 0, fs, fs);
  }
}
