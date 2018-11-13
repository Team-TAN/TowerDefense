class Note{
  
  int x;
  int y;
  Note(int X){
    x=X;
    y = 0;
  }
  
  
  void draw(){
    ellipse(x,y,10,10);
    y+=2;
  }
}
