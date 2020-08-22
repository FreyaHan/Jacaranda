// offline interaction
//I want to apply growing effect for "offline tree", 
//that's why I create "blossomJacaranda"
//if I set condition in the "jacaranda", there will be no growing effect
float prog2;
float growthLevel2;
float len2;
float maxLevel2 = 10;
float size2 = 140;
float branchProb2 = 0.9;
float flowerProb2 = 0.9;
float angle2 = (PI/2)/4;
float rotRand2 = random( 0.5, 1);
int randSeed2 =993;

void branch2(float level2, int seed, PGraphics p ) {

  if (prog2 < level2)
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
  growthLevel2 = (prog2 - level2 > 1) || (prog2 >= maxLevel2 + 1) ? 1 : (prog2 - level2);

  p.strokeWeight(20 * pow((maxLevel2 - level2 + 1)*1.2 / maxLevel2, 2));
  float rand2 = random(-1, 1);
  float rand = random(0, 1);
  //println(rand2);
  len2 = growthLevel2 * size2 * (1 + rand2)/level2;
  p.stroke(64, 51, 54);
  p.line(0, 0, 0, len2);
  p.translate(0, len2); 
  //println(len);
  boolean drawBranch21 = rand < branchProb2;
  boolean drawBranch22 = rand < branchProb2;
  boolean drawFlower2 = rand < flowerProb2;


  if (level2 < maxLevel2) {
    float treeWind = noise(n/1000000)-0.5;
    float r1 = angle * (1 + (rand2+treeWind) * rotRand);
    float r2 = -angle * (1- (rand2+treeWind) * rotRand);
    n++;

    if (drawBranch21) {
      p.push();
      p.rotate(r1);
      branch2(level2 + 1, seed1, p);
      p.pop();
    }
    if (drawBranch22) {
      p.push();
      p.rotate(r2);
      branch2(level2 + 1, seed2, p);
      p.pop();
    }
  }


  // draw flowers 
  if ((level2 >= maxLevel2 || (!drawBranch21 && !drawBranch22)) && drawFlower2) {

    float flowerSize = (size2 / 100) * (len2) * 0.3;
    p.noStroke();
    p.fill(134 + 15 * rand2, 144 + 30 * rand2, 203 + 50 * rand2);
    float fs= flowerSize * ( 0.8 + 0.5 * rand2);
    float jitterX = random(-30, 30);
    float jitterY = random(-30, 30);
    p.ellipse(0, 0, fs, fs);

    p.fill(154, 118, 216, 90);
    p.ellipse(0+ jitterX, 0+ jitterY, fs*5, fs*5);

    float jitterX1 = random(-50, 50);
    float jitterY1 = random(-50, 50);

    p.fill(114, 130, 216, 70);
    p.ellipse(0+ jitterX1, 0+ jitterY1, fs*3, fs*3);
  }
}
