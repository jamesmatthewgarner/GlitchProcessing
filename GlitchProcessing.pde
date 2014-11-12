PImage img, maskImage;

//clunky glitches
boolean blockGlitch     = false;
boolean linesGlitch     = true;
boolean channelShuffle  = false;
boolean foldableMirror  = false; 

//Incorporate some shapes
boolean triangles       = false;
boolean pixellate       = false;
boolean pyramids        = false;
boolean shapes          = false;

//Colors
boolean colorFucked     = true;
boolean tint            = false;

//Pattern creation
boolean melting         = true;
boolean pattern         = true;

float x1 = -1, y1 = -1, x2 = -1, y2 = -1;
boolean second = false;
boolean dontGlitch = false;

void setup() {
  int cWidth = 1280;
  int cHeight = 900;
  size(cWidth, cHeight);

  
  loadImg();
}

void loadImg () {
  img = loadImage("input.bmp");
  img.resize(width, height);
  img.loadPixels();
}

/**
  Load the image, apply the glitch, and then stop the loop so that the image is displayed for the user
  */
void draw() {
 
 if(!dontGlitch) {
   background(img); 
   glitch();
 }
 noLoop();
}

/**
  As soon as a key is pressed we either need to save the image, if the key pressed was space, or loop and apply a new glitch if anything else
  */
void keyPressed() {
  dontGlitch = false;
  if(key == 32) {
    save("output." + hour() + "." + minute() + "." + second() + ".png");
  } else if(key == 100) {
    duplicateMouse();
    dontGlitch = true;
    loop();
  } else {
    loop();
  }
}

/**
  Need a way to get a bounding box for stuff
  */
void mouseClicked() {
  if(second) {
    x2 = mouseX;
    y2 = mouseY;
    second = false;
  } else {
    x1 = mouseX;
    y1 = mouseY;
    x2 = -1;
    y2 = -1;
    second = true;
  }
}

void glitch() {
  if(tint) {
    addTint();
  }
  if (melting) {
    glitch_melt();
  }
  if (blockGlitch) {
    glitch_block();
  }
  if (linesGlitch) {
    glitch_lines();
  }
  if (channelShuffle) {
    glitch_channelShuffle();
  }
  if (triangles) {
    glitch_triangles(int(random(5, 20)));
  }
  if (pixellate) {
    glitch_pixel(int(random(2, 20)));
  }
  if (pyramids) {
    glitch_pyramids(int(random(5, 20)));
  }
  if (colorFucked) {
    glitch_colors(int(random(-360,360)), int(random(-40,40))); 
  }
  if (shapes) {
    glitch_shapes(int(random(2, 5))); 
  }
  if (pattern) {
    glitch_pattern();
  }
  if(foldableMirror) {
    glitch_foldableMirror(); 
  }
}

void glitch_block() {
  int num = int(random(5, 50));
  for(int i = 0; i < num; i++) { 
    int startX = int(random(0, width));
    int startY = int(random(0, height));
    int randWidth = int(random(3, 10));
    int randHeight = int(random(3, 10));
    int placeX = int(random(0, width));
    int placeY = int(random(0, width));
    int placeWidth = int(random(40, 100));
    int placeHeight = int(random(40, 100));
    copy(img, startX, startY, randWidth, randHeight, placeX, placeY, placeWidth, placeHeight);
  }
}

void glitch_lines() {
  int num = int(random(5, 50));
  for(int i = 0; i < num; i++) { 
    int startX = int(random(0, width));
    int startY = int(random(0, height));
    int randWidth = int(random(3, 10));
    int randHeight = int(random(3, 10));
    int placeX = 0;
    int placeY = int(random(0, width));
    int placeWidth = width;
    int placeHeight = 1;
    copy(img, startX, startY, randWidth, randHeight, placeX, placeY, placeWidth, placeHeight);
  }
}

void glitch_channelShuffle() {
  //extract channels
  int num = int(random(1, 6));
  for(int x = 0; x < num; x++) { 
    FloatList channelPixels = new FloatList();
    
    //select channel to shuffle
    int channel = floor(random(0,2.5));
    for(int i = 0; i < (width*height); i++) {
     if(channel == 0) {
       channelPixels.append(red(img.pixels[i]));
     }else if(channel == 1) {
       channelPixels.append(green(img.pixels[i]));
     }else if(channel == 2) {
       channelPixels.append(blue(img.pixels[i])); 
     }
    }
    
    //now have channel pixels in a map. create an image from them
    PImage newImg = createImage(width, height, ARGB);
    newImg.loadPixels();
    for(int i = 0; i < (width*height); i++) {
      if(channel == 0) {
        newImg.pixels[i] = color(channelPixels.get(i), 0,0,100);//green(newImg.pixels[i]), blue(newImg.pixels[i]), 200);
      } else if (channel == 1) {
        newImg.pixels[i] = color(/*red(newImg.pixels[i])*/0, channelPixels.get(i), 0, 100);//blue(newImg.pixels[i]), 200);
      } else if (channel == 2) {
        newImg.pixels[i] = color(/*red(newImg.pixels[i]), green(newImg.pixels[i])*/0,0, channelPixels.get(i), 100);
      }
    }
    int startX = int(random(0, width));
    int startY = int(random(0, height));
    int randWidth = int(random(70, 300));
    int randHeight = int(random(40, 100));
    int randX = int(random(-100, 100));
    int randY = int(random(-100, 100));
    copy(newImg, startX, startY, randWidth, randHeight, startX+randX, startY+randY, randWidth, randHeight);
  }
  
}

void glitch_triangles (int triangleSize) {
  noStroke();
  smooth();
  float s60 = sin(60 * PI / 180);
  
  float height1 = (s60*(triangleSize));
  for(int x = -triangleSize; x < width+(triangleSize*2); x += triangleSize) {
    for(int y = 0; y < height+height1; y += (height1*2)) {
      float x1 = x;
      float y1 = y;
      float x2 = x+triangleSize;
      float y2 = y;
      float x3 = x+(triangleSize/2);
      float y3 = y1+height1;
      float x4 = x3+triangleSize;
      float y4 = y3;
      float x5 = x2;
      float y5 = y1 + (2*height1);
      float x6 = x1;
      float y6 = y1 + (2*height1);
      color c1 = get(int(min(width-1, x1+(triangleSize/2))), int(min(height-1, y1+(height1/2))));
      color c2 = get(int(min(width-1, x2)), int(min(height-1, y2+(height1/2))));
      color c3 = get(int(min(width-1, x3)), int(min(height-1, y3+(height1/2))));
      color c4 = get(int(min(width-1, x4-(triangleSize/2))), int(min(height-1, y4+(height1/2))));
      fill(c1);
      triangle(x1, y1, x2, y2, x3, y3);
      fill(c2);
      triangle(x2, y2, x3, y3, x4, y4);
      fill(c3);
      triangle(x3, y3, x5, y5, x6, y6);
      fill(c4);
      triangle(x3, y3, x4, y4, x5, y5);
    }
  }
}



void glitch_pyramids (int triangleSize) {
  noStroke();
  float s60 = sin(60 * PI / 180);
  float c60 = cos(60 * PI / 180);
  
  for(int x = 0; x < width; x += (triangleSize*2)) {
    for(int y = 0; y < height; y += triangleSize) {
      float x1 = x;
      float y1 = y;
      float x2 = x+triangleSize;
      float y2 = y;
      float x3 = (c60*(x1-x2)) - (s60*(y1-y2)) + x2;
      float y3 = (s60*(x1-x2)) + (c60*(y1-y2)) + y2;
      float x4 = x+(triangleSize*2);
      float y4 = y;
      color c1 = get(x, y);
      color c2 = get(floor(x3), floor(y3));
      fill(c1);
      triangle(x1, y1, x2, y2, x3, y3);
      fill(c2);
      triangle(x3, y3, x2, y2, x4, y4); 
    }
  }
}

void toggle(boolean b) {
  if(b) { b = false; } else { b = true; }
}


void glitch_pixel(int size) {
  noStroke();
  for (int x = 0; x < width; x += size) {
    for (int y = 0; y < height; y += size) {
      fill(get(x, y));
      rect(x, y, size, size);
    }
  }
}

void glitch_colors(int hueShift, int satShift) {
  colorMode(HSB, 360);
  for(int x = 0; x < width; x++) {
    for(int y = 0; y < height; y++) {
      color pixel = color( hue(get(x, y)) + hueShift, saturation(get(x,y)) + satShift, brightness(get(x,y)) );
      set(x, y, pixel);
    }
  }
}

void addTint() {
    tint(
      int(random(0, 255)),
      int(random(0, 255)),
      int(random(0, 255)),
      255
    );
    image(img, 0, 0);
}

void glitch_shapes(int scale) {
  noStroke();
  int shape = int(random(0, 3.9));
  int inc = 0;
  int scale1 = 1;
  if(shape == 1 || shape == 2) { scale1 = 0; }
  if(shape == 2) { inc = 6; }
  for(int x = 0; x < width; x+= 3+inc+scale1) {
    for(int y = 0; y < height; y+= 3+inc+scale1) {
      if(shape == 0) {
        int x1 = int(random(x-4, x+4));
        int y1 = int(random(y-4, y+4));
        int w = int(random(4+scale, 6+scale));
        int h = int(random(4+scale, 6+scale));
        color c = get(x, y);
        fill(c);
        ellipse(x1, y1, w, h);
      } else if (shape == 1) {
        int x1 = int(random(x-3-scale, x+3+scale));
        int y1 = int(random(y-3-scale, y+3+scale));
        int x2 = int(random(x1+3+scale, x1+5+scale));
        int y2 = int(random(y1+3+scale, y1+5+scale));
        int x3 = int(random(x1+3+scale, x1+5+scale));
        int y3 = int(random(y1+3+scale, y1+5+scale));
        int x4 = int(random(x1-3+scale, x1+3+scale));
        int y4 = int(random(y3-3+scale, y3+3+scale));
        color c = get(x, y);
        fill(c, 200);//, 200);
        quad(x1, y1, x2, y2, x3, y3, x4, y4);
      } else if (shape == 2) {
         int w = int(random(9+scale, 12+scale));
         int h = int(random(15+scale, 15+scale));
         color c = get(x,y);
         fill(c);
         arc(x, y, w, h, 0, PI, CHORD);
      } else if (shape == 3) {
       int r = int(random(3+scale, 5+scale));
       int r2 = int(random(r+scale, r+scale+2));
       int numPoints = int(random(5, 10));
       color c = img.get(x, y);
       fill(c);
       star(x, y, r, r2, numPoints);
      }
    }
  } 
}

//Taken from processing website
void star(float x, float y, float radius1, float radius2, int npoints) {
  float angle = TWO_PI / npoints;
  float halfAngle = angle/2.0;
  beginShape();
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

void glitch_melt() {
  int melts = int(random(100, width));
  for(int j = 0; j < melts; j++) {
    int startX = int(random(0, width));
    int startY = int(random(0, height));
    int meltLength = int(random(20, 70));
    int meltWidth = int(random(3, 6));
    color c = get(startX, startY);
    for(int i = 0; i < meltLength; i++) {
      for(int k = 0; k < meltWidth; k++) {
        set(startX+k, startY+i, c); 
      }
    }
  }  
}


void glitch_pattern() {
  
  int num = int(random(5, 20));
  for(int count = 0; count < num; count++) {
    int randX = int(random(0, width));
    int randY = int(random(0, height));
    int randHeight = int(random(1, height-randY));
    int randWidth = int(random(1, width-randX));
    
    int[] shifts = new int[randHeight];
    shifts[0] = 0;
    int mostLeft = 0;
    int mostRight = 0;
    for(int i = 1; i < randHeight; i++) {
      int shift = int(random(-1.5, 1.5));
      shifts[i] = shifts[i-1] + shift;
      if(shifts[i] < mostLeft) { mostLeft = shifts[i]; }
      else if (shifts[i] > mostRight) { mostRight = shifts[i]; } 
    }
    
    int start = int(random(0, width));
    int stop = int(random(start, width));
    
    for(int inY = 0; inY < randHeight; inY++) {
      //find the offset of this block
      int offset = (randX +shifts[inY] ) % randWidth;
      int counter = offset;
      for(int x = start; x < stop; x++) {
         color c = get(randX+(counter), randY+inY);
         set(x, randY+inY, c);
         counter++;
         if (counter > randWidth) { counter = 0; }
      }
    }
    
  }
}

void duplicateMouse() {
 if(!second && x2 != -1) {
    int randX = floor(random(0, width-(abs(x1-x2))));
    int randY = floor(random(0, height-(abs(y1-y2))));
    copy(int(x1), int(y1), abs(int(x1-x2)), abs(int(y1-y2)), randX, randY, abs(int(x1-x2)), abs(int(y1-y2)));
 }
}

void glitch_foldableMirror() {
 
  PGraphics pg = createGraphics(width, height);
  //Flip pg
  pg.pushMatrix();
  pg.scale(-1.0, 1.0);
  pg.background(img);
  pg.loadPixels();
  pg.image(img, -img.width, 0);
  pg.popMatrix();
  //Pick number of folds
  int numFolds = int(random(5, 10));
  //get maximum width for a mirrored section
  int maxWidth = int((width/(numFolds*2)));
  //keep track of our place in the columns - choose an initial column to use.
  int columnIterator = int(random(0, maxWidth));
  int currFold = 0;
  
  while(columnIterator<width) {
   int sectionWidth = int(random(0, maxWidth));
   for(int x = columnIterator; x < columnIterator+sectionWidth; x++) {
    for(int y = 0; y < height; y++) {
     set(x, y, pg.get(x, y));
    }
   }
   columnIterator += sectionWidth;
   //Now we have moved the column iterator to the end of the area, move an additional bit
   columnIterator += int(random(0, maxWidth));
  }
}

void glitch_kaleidoscope() {
 int rotateDegrees = int(random(0, 45));
 //now have the degrees for how large the kaleidoscope section should be
 //need to define slice of image to use for kaleidoscope
  
}
