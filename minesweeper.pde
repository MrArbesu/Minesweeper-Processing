color backgr;
PImage tile;
//width = 1028
//height = 698
int numMines = 99;
Box[][] boxes = new Box[30][16];
bool isPressed = false;
bool gridCreated = false;
bool gameOver = false;
bool flagMode = false;

void setup() {
   size(screenWidth, screenHeight);
   tile = loadImage("Tile_32.JPG");
   //noStroke();
   textSize(20);
   CreateGrid();
   backgr = color(random(256), random(256), random(256));
   textAlign(CENTER,CENTER);
}

void draw() {
   background(backgr);
   DetectTouch();
   DrawGrid();
}

void CreateGrid(){
   int x = 19;
   int y = 85;
   for(int j = 0; j < 16; j++){
      for(int i = 0; i < 30; i++){
         boxes[i][j] = new Box(x, y);
         x += 33;
      }
      x = 19;
      y += 33;
   }
}

void CreateMinefield(int x, int y){
   for(int a = 0; a < numMines; a++) CreateMine();
   if(SurroundingMines(x,y) != 0){
      for(int i = 0; i < 30; i++){
         for(int j = 0; j < 16; j++){
            boxes[i][j].mine = false;
         }
      }
      CreateMinefield(x,y);
   }
}

void CreateMine(){
   int rndmI = RandomNumber(30);
   int rndmJ = RandomNumber(16);
   if(!boxes[rndmI][rndmJ].mine) boxes[rndmI][rndmJ].mine = true;
   else CreateMine();
}

void DetectTouch(){
   if(mousePressed){
      if(!isPressed){
         isPressed = true;
         int x = int((mouseX - 19) / 33);
         int y = int((mouseY - 85) / 33);
         if(!gameOver){
            if(mouseX >= width/2 -30 && mouseX <= width/2 +30 && mouseY >= 15 && mouseY <= 75) flagMode = !flagMode;
            else if(mouseX >= 19 && mouseX <= 1009 && mouseY >= 85 && mouseY <= 613){
               if(!gridCreated){
                  CreateMinefield(x, y);
                  gridCreated = true;
               }
               if(flagMode){
                  boxes[x][y].flag = !boxes[x][y].flag;
               }
               else RevealBox(x, y);
            }
         }
      }
   }
   else isPressed = false;
}

void RevealBox(int x, int y){
   if(!boxes[x][y].flag){
      if(boxes[x][y].mine) GameOver(x, y);
      else boxes[x][y].revealed = true;
      if(SurroundingMines(x, y) == 0){
         for(int a = x - 1; a <= x + 1; a++){
            if(a >= 0 && a < 30){
               for(int b = y - 1; b <= y + 1; b++){
                  if(b >= 0 && b < 16){
                     if(!boxes[a][b].revealed) RevealBox(a, b);
                  }
               }
            }
         }
      }
   }
}

void DrawGrid(){
   for(int j = 0; j < 16; j++){
      for(int i = 0; i < 30; i++){
         fill(255);
         if(gameOver && boxes[i][j].mine){
            fill(200,0,0);
            rect(boxes[i][j].x, boxes[i][j].y, Box.grosor, Box.grosor);
         }
         else if(boxes[i][j].revealed && gridCreated){
            fill(200);
            rect(boxes[i][j].x, boxes[i][j].y, Box.grosor, Box.grosor);
            int sm = SurroundingMines(i,j);
            if(sm != 0){
               switch(sm){
                  case 1:
                  fill(0,0,255);
                  break;
                  case 2:
                  fill(0,128,0);
                  break;
                  case 3:
                  fill(255,0,0);
                  break;
                  case 4:
                  fill(0,0,128);
                  break;
                  case 5:
                  fill(128,0,0);
                  break;
                  case 6:
                  fill(0,128,128);
                  break;
                  case 7:
                  fill(0);
                  break;
                  case 8:
                  fill(128);
                  break;
               }
               text(SurroundingMines(i,j), boxes[i][j].x + 33/2, boxes[i][j].y + 33/2);
            }
         } else {
            image(tile, boxes[i][j].x, boxes[i][j].y);
            if(boxes[i][j].flag){
               fill(0);
               ellipse(boxes[i][j].x + Box.grosor/2, boxes[i][j].y + Box.grosor/2, 20, 20);
            }
         }
      }
   }
   
   fill(200);
   rect(width/2 -30, 15,60,60);
   if(!flagMode){
      fill(0,0,255);
textSize(38);
      text(1, width/2, 45);
textSize(20);
   } else {
      fill(0);
      ellipse(width/2, 45, 36, 36);
   }
}

void GameOver(int x, int y){
   gameOver = true;
}

int SurroundingMines(int x, int y){
   int mines = 0;
   for(int a = x - 1; a <= x + 1; a++){
      if(a >= 0 && a < 30){
         for(int b = y - 1; b <= y + 1; b++){
            if(b >= 0 && b < 16){
               if(boxes[a][b].mine) mines++;
            }
         }
      }
   }
   return mines;
}

int RandomNumber(int max){
   float number = random(max);
   for(int i = 1; i < max + 1; i++){
      if(number < i) return i - 1;
   }
}

class Box {
   int x = 0;
   int y = 0;
   static int grosor = 33;
   bool mine = false;
   bool revealed = false;
   Box(int _x, int _y) {
      x = _x;
      y = _y;
   }
}
