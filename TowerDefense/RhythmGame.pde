class RhythmGame {
  
  public AudioPlayer player; 
  private AudioPlayer dummy;
  private BeatDetect beat;
  private BeatListener b1;
  
  
  private ArrayList<Note> notes = new ArrayList<Note>();
  private ArrayList<Particle> particles = new ArrayList<Particle>();
  //PVector pv = new PVector();
  
  private boolean start = false;
  private boolean test = true;
  private boolean pulse;
  
  private float player1StartTime = 1;
  private float player2StartTime = 1;
  
  public int good1 = 0;
  public int perfect1 = 0;
  public int miss1 = 0;
  
  public Player player1;
  public Player player2;
  
  public int good2 = 0;
  public int perfect2 = 0;
  public int miss2 = 0;
  
  private int wait = 0;
  private int wait2 = 0;
  private int wait3 = 0;
  private int wait4= 0;
  
  private int alpha = 200;
  
  private float length;
  
  public RhythmGame(Player player1, Player player2, int songIndex, float length) {
    
    this.player1 = player1;
    this.player2 = player2;
    this.length = length * 1000;
    
    player = minim.loadFile(songs[songIndex]);
    dummy = minim.loadFile(songs[songIndex]);
    
    beat = new BeatDetect(dummy.bufferSize(), dummy.sampleRate());
    beat.setSensitivity(1000);
    b1 = new BeatListener(beat, dummy);
  
    dummy.rewind();
    dummy.play();
    dummy.setGain(-80);
  }
  
  public void draw() {
    background(0);
    //beat.detect(dummy.mix);
    if (dummy.position() >= 3700 && !start) {
      player.rewind();
      player.play();
      start = true;
    } else if (dummy.position() > length - 3900) {
      dummy.pause();
    }
  
    if (beat.isHat() && wait4 == 0) {
      Note n = new Note(250);
      notes.add(n);
      Note n2 = new Note(750);
      notes.add(n2);
      wait4 +=10;
      //print("hat ");
    }
    fill(255, 0, 0);
    rect(475, 0, 50, height);
    //fill(0, 0, 255);
    fill(200, 200, 255, alpha);
    rect(0, 430, 1000, 20);
    rect(0, 470, 1000, 10);
    //fill(0, 255, 0);
    fill(200, 255, 200, alpha);
    rect(0, 450, 1000, 20);
  
    textSize(15);
    textAlign(LEFT);
    text("GOOD: " + good1, 10, 15 );
    text("PERFECT: " + perfect1, 10, 30);
    text("MISS: "+ miss1, 10, 45);
    textAlign(RIGHT);
    text("GOOD: " + good2, 990, 15 );
    text("PERFECT: " + perfect2, 990, 30);     
    text("MISS: "+ miss2, 990, 45);
  
    for (int i = 0; i <= particles.size() - 1; i++) {
      Particle p = particles.get(i);
      p.draw();
      if (p.alpha <= 0) {
        particles.remove(i);
      }
    }
  
    for (int i = 0; i <= notes.size() - 1; i++) {
  
      Note n = notes.get(i);
      n.draw();
      if (n.y > 480) {
        if (n.x > 500) miss2++;
        else miss1++;
        Particle p = new Particle(0, n.x, n.y);
        particles.add(p);
        notes.remove(i);
      }
    }
  
    if (pulse) {
      alpha --;
    } else alpha ++;
    
    if (alpha < 150) pulse = false;
    if(alpha > 200) pulse = true;
  
  
    if (wait >0) wait --;
    if (wait2 >0) wait2 --;
    if (wait3 >0) wait3 --;
    if (wait4 >0) wait4 --;
  }
  
  /*public MiniGameData returnData() {
    MiniGameData data = new MiniGameData();
    data.good1 = good1;
    data.good2 = good2;
    data.perfect1 = perfect1;
    data.perfect2 = perfect2;
    data.miss1 = miss1;
    data.miss2 = miss2;
    return data;
  }*/
  
  public void addPlayer1Creep(boolean isPowered) {
    Creep c = new Creep(isPowered, true);
    //c.targetPos = 
    c.timeToLeave = player1StartTime;
    player1StartTime += .8;
    int rand = floor(random(3, 7));
    c.pos = new PVector(GRID_START_X + tileWidth / 2, GRID_START_Y + ((rand + 0.5) * tileHeight));
    c.start = new PVector(0, rand);
    c.targetPos = new PVector(19, rand);
    player1.creeps.add(c);
  }

  public void addPlayer2Creep(boolean isPowered) {
    Creep c = new Creep(isPowered, false);
     
    c.timeToLeave = player2StartTime;
    player2StartTime += .8;
    int rand = floor(random(3, 7));
    c.pos = new PVector(GRID_START_X + (19.5 * tileWidth), GRID_START_Y + ((rand + 0.5) * tileHeight));
    c.start = new PVector(19, rand);
    c.targetPos = new PVector(0, rand);
    player2.creeps.add(c);
  }
  
  public void onKeyPressed() {
    ////////////////////////////////////////////
    //player 1
    ////////////////////////////////////////////
  
    if ( keyCode == 81) {
      for (int i = 0; i <= notes.size() - 1; i++) {
        Note n = notes.get(i);
        // if ( n.x == 200 && n.y >=400) {
        if (n.x == 250 && n.y >=400) {
          if (n.y >= 430 && n.y < 450 || n.y >= 470 && n.y <= 480) {
            addPlayer1Creep(false);
            good1 ++;
            Particle p = new Particle(1, n.x, n.y);
            particles.add(p);
          } else if (n.y >= 450 && n.y <470) {
            addPlayer1Creep(true);
            perfect1++;
            Particle p = new Particle(2, n.x, n.y);
            particles.add(p);
          } else {
            miss1++;
            Particle p = new Particle(0, n.x, n.y);
            particles.add(p);
          }
  
          notes.remove(i);
          break;
        }
      }
    }
  
    if ( keyCode == 87) {
      for (int i = 0; i <= notes.size() - 1; i++) {
        Note n = notes.get(i);
        if ( n.x == 300 && n.y >=400) {
          if (n.y >= 430 && n.y < 450 || n.y >= 470 && n.y <= 480) {
            good1 ++;
          } else if (n.y >= 450 && n.y <470) {
            perfect1 ++;
          } else miss1 ++;
  
          notes.remove(i);
          break;
        }
      }
    }
  
    if ( keyCode == 69) {
      for (int i = 0; i <= notes.size() - 1; i++) {
        Note n = notes.get(i);
        if ( n.x == 400 && n.y >=400) {
          if (n.y >= 500 && n.y < 450 || n.y >= 470 && n.y <= 480) {
            good1 ++;
          } else if (n.y >= 450 && n.y <470) {
            perfect1 ++;
          } else miss1++;
  
          notes.remove(i);
          break;
        }
      }
    }
  
    /////////////////////////////////////////
    //player2
    /////////////////////////////////////////
  
    if ( keyCode == 36 || key == '7') {
      for (int i = 0; i <= notes.size() - 1; i++) {
        Note n = notes.get(i);
        //if ( n.x == 600 && n.y >=400) {
        if (n.x == 750 && n.y >= 400) {
          if (n.y >= 430 && n.y < 450 || n.y >= 470 && n.y <= 480) {
            addPlayer2Creep(false);
            good2++;
            Particle p = new Particle(1, n.x, n.y);
            particles.add(p);
          } else if (n.y >= 450 && n.y <470) {
            addPlayer2Creep(true);
            perfect2++;
            Particle p = new Particle(2, n.x, n.y);
            particles.add(p);
          } else {
            miss2 ++;
            Particle p = new Particle(0, n.x, n.y);
            particles.add(p);
          }
  
  
          notes.remove(i);
          break;
        }
      }
    }
  
    if ( keyCode == 38) {
      for (int i = 0; i <= notes.size() - 1; i++) {
        Note n = notes.get(i);
        if ( n.x == 700 && n.y >=400) {
          if (n.y >= 430 && n.y < 450 || n.y >= 470 && n.y <= 480) {
            good2 ++;
          } else if (n.y >= 450 && n.y <470) {
            perfect2 ++;
          } else miss2 ++;
  
          notes.remove(i);
          break;
        }
      }
    }
  
    if ( keyCode == 33) {
      for (int i = 0; i <= notes.size() - 1; i++) {
        Note n = notes.get(i);
        if ( n.x == 800 && n.y >=400) {
          if (n.y >= 430 && n.y < 450 || n.y >= 470 && n.y <= 480) {
            good2 ++;
          } else if (n.y >= 450 && n.y <470) {
            perfect2 ++;
          } else miss2++;
  
          notes.remove(i);
          break;
        }
      }
    }
  }
}
