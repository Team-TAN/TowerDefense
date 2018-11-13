class Particle{
 
  boolean good = false;
  boolean perfect = false;
  boolean miss = false;
  int x;
  int y;
  int radius = 0;
  int alpha = 255;
  
  Particle(int bol, int X, int Y){
   if(bol ==1) good = true;
   if( bol == 2) perfect = true;
   if (bol == 0) miss = true;
   x= X;
   y = Y;
   
  }
  
  void draw(){
    pushStyle();
    if(good) fill(200,20,255,alpha);
    else if (perfect) fill(200,255,20,alpha);
    else if (miss) fill(255,255,255, alpha);
    ellipse(x, y, radius, radius);
    radius++;
    alpha -=5;
    popStyle();
    
  }
}
