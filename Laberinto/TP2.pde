//Laberinto 

//Bugs:
/*
- Hay chance de que la velocidad de los enemigos sea muy cercana a 0
y se muevan lentisimo.
*/

//Notas:
/*
- Use https://print-graph-paper.com/virtual-graph-paper para dibujar el laberinto.
- Hice investigacion y use codigo de este chabon para la deteccion
lineas/circulos:
  http://www.jeffreythompson.org/collision-detection/line-circle.php
*/

//Resumen/Guia:
/*
- La puntuación se basa en qué tan rápido puedes llegar al final, es decir, 
cuanto más baja, mejor..
- Hay fantasmitas que te reinician si te tocan.
- En el modo pesadilla, el número de fantasmas se duplica y su velocidad también 
se duplica, sin embargo, tu temporizador solo cuenta la mitad de rápido y tu velocidad 
también se duplica, lo que hace posible lograr tiempos aún más rápidos que en el modo normal.
- Los ojos de los zaramay
- Hay un portal metido anda a saber donde, una ayudita por si sos malisimo.
- El modo pesadilla solo se desactiva cuando presionas R para reiniciar el juego.
*/

//Controles:
/*
- Movimiento: W,A,S,D o las flechitas
- Reset: R
- Pesadilla: U
*/

//****************************************************************************************
//Variables:

//player
float px, py; //x and y
float pSize = 15;
float fovSize = 200; //tamanio del fov
float flicker = 255; //esto controla la opacidad del fov 255 = 100% 0 = 0%
boolean flickerN = true;
  //movimiento
boolean aDown = false;
boolean sDown = false;
boolean dDown = false;
boolean wDown = false;

//enemigos o fantasmas o zaramay
int arrayS = 10; //numero de enemigos 
float[] eX = new float[arrayS];
float[] eY = new float[arrayS];
float[] speedX = new float[arrayS]; 
float[] speedY = new float[arrayS]; 

//deteccion de linea
int lArraySize = 119; //determina el tamanio del array
//coordenadas de la linea
float[] lx1 = new float[lArraySize];
float[] lx2 = new float[lArraySize];
float[] ly1 = new float[lArraySize];
float[] ly2 = new float[lArraySize];

//color del background pa vo sabe
color mazeCol = color(0,0,0);

//modo pesadilla
boolean nightMare = false;
int nm = 2;
float nmBonus = 0;

//puntos
float score = 0;
float highScore = 0;

//reset
boolean reset = false;


//****************************************************************************************
void setup() {
  size(800, 800);
  //setear donde spawnear
  px = 25; 
  py = 25;
  //array de los fantasmaticos
  for(int n = 0; n < arrayS; n += 1){
    eX[n] = random(100,700);
    eY[n] = random(100,700);
    speedX[n] = random(-1.5,1.5);
    speedY[n] = random(-1.5,1.5);
  }
  
}
//****************************************************************************************
void draw() {
  background(mazeCol);
  //fov
  fov(px, py, fovSize);
  flickerOn();
  //laberinto
  maze();
  //declarando líneas basadas en los valores de maze()
  for (int n = 0; n < lArraySize; ++n) {
    strokeWeight(6);
    stroke(mazeCol);
    line(lx1[n], ly1[n], lx2[n], ly2[n]);
  }
  //exit
  exitGate();
  //portal
  portal();
  //player
  player(px, py);
  //controles
  controls();
  //enemigos
  enemy(arrayS);
  //detección de impactos y reinicio
  hit();
  //reinicia el reinicio, parece joda pero no
  reset = false;
  //muestra las instrucciones
  instructions();
  //puntos
  score();
  //fatality
  win();
  //modo quesadilla xd
  nightMare(nightMare);
}
//****************************************************************************************

void controls(){
  //controles
  //checkea si el modo pesadilla está activado, y si es así, duplica la velocidad
  if(aDown && nightMare){
    px = px -2;
  }else if(aDown){
    px = px -1;
  }
  if(dDown && nightMare){
    px = px +2;
  }else if(dDown){
    px = px +1;
  }
  if(wDown && nightMare){
    py = py -2;
  }else if(wDown){
    py = py -1;
  }
  if(sDown && nightMare){
    py = py +2;
  }else if(sDown){
    py = py +1;
  }
}

void exitGate(){ //visualizacion de la salida
  if(px > width-150 && py > height-100){
    strokeWeight(6);
    stroke(255);
    fill(255);
    line(width-100,height,width,height); //tapuer
    //pa trackear el player
    if(px > width-100 && py > height-75){ 
      noStroke();
      fill(255,100);
      beginShape();
      vertex(width-100,height);
      vertex(width,height);
      vertex(px,py);
      endShape(CLOSE);
    }
  }
}

void portal(){ //de 325,375 a 525,725
  //portal unidireccional
  strokeWeight(4);
  ellipseMode(CENTER);
  if(px > 200 && px < 350 && py > 350 && py < 400){ //hace que el portal sea visible solo cuando estés cerca.
    //el coso de luz 
    noStroke();
    fill(255,100);
    beginShape();
    vertex(325,375-10);
    vertex(325,375+10);
    vertex(px,py);
    endShape();
    //portal laranja (entry)
    stroke(255,94,19); 
    fill(0);
    ellipse(325,375,20,35);
    if(px > 325-5 && px < 325+5 && py > 375-17 && py < 375+17){ //el teleport
      px = 525;
      py = 725;
    }
  }
  if(px > 500 && px < 550 && py > 650 && py < 750){
    //coso de luz
    noStroke();
    fill(255,100);
    beginShape();
    vertex(525-17,725);
    vertex(525+17,725);
    vertex(px,py);
    endShape();
    //portal azul (salida)
    stroke(57,138,215); 
    fill(0);
    ellipse(525,725,35,20);
  }
}

void fov(float x, float y, float size) {
  noStroke();
  fill(150,flicker);
  circle(x, y, size);
}

void flickerOn(){
  float n = -5;
  if(flicker >= 255){
    flickerN = true;
  }
  if(flicker <= 0){
    flickerN = false;
  }
  if(!flickerN){
    flicker -= n;
  }else if(flickerN){
    flicker += n;
  } 
}

void player(float x, float y) {
  strokeWeight(3);
  stroke(0);
  fill(252, 194, 104);
  circle(x, y, pSize);
}

void enemy(int n){
  fovSize = 200;
  for(n = 0; n < arrayS-(arrayS-nm); n += 1){
    eX[n] = eX[n] - speedX[n];
    eY[n] = eY[n] - speedY[n];
    if(eX[n] < px+pSize*6 && eY[n] < py+pSize*6 && eX[n] > px-pSize*6 && eY[n] > py-pSize*6){
      fovSize = 100; //el fov se achica cuando tenes enemigos cerca
    }
    //enemigos
    strokeWeight(2);
    stroke(mazeCol);
    fill(mazeCol);
    //forma de diamante o rombo
    beginShape();
    vertex(eX[n],eY[n]-pSize*2);
    vertex(eX[n]+pSize*2,eY[n]);
    vertex(eX[n],eY[n]+pSize*2);
    vertex(eX[n]-pSize*2,eY[n]);
    endShape(CLOSE);
    //los ojitos 
    noStroke();
    if(mazeCol != color(0)){
     fill(255, 255, 255);
    }else{
     fill(255,0,0);
    }
    circle(eX[n]-5,eY[n],5);
    circle(eX[n]+5,eY[n],5);
    if(eX[n] >= 800-pSize*2){
      speedX[n] = speedX[n] *-1;
    }
    if(eX[n] <= 0+pSize*2){
      speedX[n] = speedX[n] *-1;
    }
    if(eY[n] >= 800-pSize*2){
      speedY[n] = speedY[n] *-1;
    }
    if(eY[n] <= 0+pSize*2){
      speedY[n] = speedY[n] *-1;
    }
    if(eX[n] < px+pSize*2 && eY[n] < py+pSize*2 && eX[n] > px-pSize*2 && eY[n] > py-pSize*2){
      reset = true;
    }
  }
}

void hit() {
  for (int n = 0; n < lArraySize; ++n) {
    boolean hit = lineCircle(lx1[n], ly1[n], lx2[n], ly2[n], px, py, pSize/2);
    if (hit || reset) {
      px = 25; 
      py = 25;
      score = 0;
      //resetea enemigoss
      if(!nightMare){
        for(int n2 = 0; n2 < arrayS; n2 += 1){
          speedX[n2] = random(-1.5,1.5);
          speedY[n2] = random(-1.5,1.5);
        }
      }else{
        for(int n3 = 0; n3 < arrayS; n3 += 1){
          speedX[n3] = random(-3,3);
          speedY[n3] = random(-3,3);
        }
      }
    }
  }
}

void score(){
  //verifica si ya existe un puntaje alto (i.e. is bigger than 0)
  //si no existe, highScore se establece en el valor de score
  //si existe, highScore se establece solo en el valor de score si es menor
  if(highScore < score && highScore == 0 && win()){
    highScore = score;
  }else if(highScore > score && score > 0 && win()){
    highScore = score;
  }
  textAlign(CENTER,BOTTOM);
  textSize(25);
  fill(252, 194, 104);
  text("Record: "+(int)highScore/60,650,30);
  text("Tiempo: "+(int)score/60,150,30);
  score = score +(1-nmBonus);
}

boolean win(){
  if(py >= height){
    reset = true;
    return true;
  }
  return false;
}

void instructions(){
  if(px < 150 && py < 50){
    textAlign(CENTER,BOTTOM);
    textSize(60);
    fill(252, 194, 104);
    text("Encontra la salida!",width/2,height/2);
    textSize(30);
    text("Te moves con las flechitas o con WASD",width/2,height/2+50);
    strokeWeight(5);
    stroke(252, 194, 104);
    line(765,725,765,775);
    line(765,775,750,760);
    line(765,775,780,760);
  }
}

void nightMare(boolean nmOn){
  if(nmOn){
    nm = arrayS;
    mazeCol = color(155,0,0);
    nmBonus = 0.5; //reduce la velocidad del contador en un 50%, haciendo posible obtener tiempos tan bajos como 25 segundos
  }else{
    nm = arrayS/2;
    mazeCol = color(0);
    nmBonus = 0;
  }
}

boolean lineCircle(float x1, float y1, float x2, float y2, float px, float py, float pSize) {
  //detecta si alguno está adentro del círculo
  boolean inside1 = pointCircle(x1, y1, px, py, pSize);
  boolean inside2 = pointCircle(x2, y2, px, py, pSize);
  if (inside1 || inside2) {
    return true;
  }

  // la longitud de la línea
  float distX = x1 - x2;
  float distY = y1 - y2;
  float len = sqrt( (distX*distX) + (distY*distY) );

  // con el dot sacas producto de la linea y el circula
  float dot = (((px-x1)*(x2-x1)) + ((py-y1)*(y2-y1))) / pow(len, 2);

  // encuentra el punto más cercano en la línea
  float closestX = x1 + (dot * (x2-x1));
  float closestY = y1 + (dot * (y2-y1));

  // el dot esta en el segmento de la linea? checkealo 
  // Si es así, sigue, pero si no, devuelve falso.
  boolean onSegment = linePoint(x1, y1, x2, y2, closestX, closestY);
  if (!onSegment) return false;

  // el puntito en la linea
  fill(0,0,0,0); //invisible, pero se puede cambiar a algo como fill(0,255,0,255); para depurar colisiones
  noStroke();
  ellipse(closestX, closestY, 5, 5);

  // obtener la distancia al punto más cercano
  distX = closestX - px;
  distY = closestY - py;
  float distance = sqrt( (distX*distX) + (distY*distY) );

  if (distance <= pSize) {
    return true;
  }
  return false;
}

boolean pointCircle(float pointx, float pointy, float px, float py, float pSize) {
  // obtener la distancia entre el punto y el centro del círculo
  // usando el teorema de pitagoras
  float distX = pointx - px;
  float distY = pointy - py;
  float distance = sqrt((distX*distX) + (distY*distY));

  // si la distancia es menor que el radio del círculo
  // el radio en el que el punto está adentro del círculo
  if (distance <= pSize) {
    return true;
  }
  return false;
}

boolean linePoint(float x1, float y1, float x2, float y2, float pointx, float pointy) {
  // distancia desde el punto hasta los dos extremos de la línea
  float d1 = dist(pointx,pointy, x1,y1);
  float d2 = dist(pointx,pointy, x2,y2);

  // la longitud de la línea
  float lineLen = dist(x1,y1, x2,y2);

  // los floats son re precisos, pongo un poco de margen de error
  // una zona chiquita de armotiguamiento que da la coalision
  float buffer = 0.1;    // higher # = less accurate

  // si las dos distancias son iguales a la longitud de la línea más el margen de error
  // entonces el punto está en la línea
  // usamos el amortiguador para dar un rango,
  // en lugar de un número específico
  if (d1+d2 >= lineLen-buffer && d1+d2 <= lineLen+buffer) {
    return true;
  }
  return false;
}

//controles
void keyReleased() //cuando dejas de apretar la teclita
{
  if (key == 'A' || key == 'a' || keyCode == LEFT){
    aDown = false;
  }
  else if(key == 'D' || key == 'd' || keyCode == RIGHT){
    dDown = false;
  }
  else if(key == 'W' || key == 'w' || keyCode == UP){
    wDown = false;
  }
  else if(key == 'S' || key == 's' || keyCode == DOWN){
    sDown = false;
  }
}

void keyPressed() //cuando apretas la teclona
{
  if (key == 'A' || key == 'a' || keyCode == LEFT){
    aDown = true;
  }
  else if(key == 'D' || key == 'd' || keyCode == RIGHT){
    dDown = true;
  }
  else if(key == 'W' || key == 'w' || keyCode == UP){
    wDown = true;
  }
  else if(key == 'S' || key == 's' || keyCode == DOWN){
    sDown = true;
  }
  if(key == 'r' || key == 'R'){
    nightMare = false; //saque el reset de pesadilla para evitar tner
                       //que iniciarlo constantemente
    reset = true;
  }
  if(key == 'u' || key == 'U'){
    nightMare = true;
    px = 25; 
    py = 25;
    score = 0;
    for(int n2 = 0; n2 < arrayS; n2 += 1){
        speedX[n2] = random(-3,3);
        speedY[n2] = random(-3,3);
    }
  }
}

void maze() { //coordenadas para el laberinto 
  int n = 0;
  int mC = 50; //contador (para facilitar la escritura), básicamente el tamaño por "bloque"
  
  if(n < lArraySize){ //para no caerme del mapa x si me cuelgo con los arrays
    n = 0;
  }
  
  //la perimetral xd
  lx1[n] = 0; ly1[n] = 0; lx2[n] = width; ly2[n] = 0; //ceiling
  n = n +1; //se incrementa de a uno, así no tengo que escribir constantemente [n] individualmente, 
            //alta paja sino
  lx1[n] = 0; ly1[n] = 0; lx2[n] = 0; ly2[n] = height; //pared izq
  n = n +1;
  lx1[n] = 0; ly1[n] = height; lx2[n] = width-mC*2; ly2[n] = height; //floor
  n = n +1;
  lx1[n] = width; ly1[n] = 0; lx2[n] = width; ly2[n] = height; //pared der
  n = n +1;
  
  //el laberinto en cuestion (siguiendo el orden del primer eje y para dar alguna estructura)
    //y empieza en 0
  lx1[n] = mC*3; ly1[n] = mC*0; lx2[n] = mC*3; ly2[n] = mC*2;
  n = n +1;
  lx1[n] = mC*5; ly1[n] = mC*0; lx2[n] = mC*5; ly2[n] = mC*4;
  n = n +1;
  lx1[n] = mC*9; ly1[n] = mC*0; lx2[n] = mC*9; ly2[n] = mC*2;
  n = n +1;
  lx1[n] = mC*10; ly1[n] = mC*0; lx2[n] = mC*10; ly2[n] = mC*1;
  n = n +1;
  lx1[n] = mC*14; ly1[n] = mC*0; lx2[n] = mC*14; ly2[n] = mC*2;
  n = n +1;
    //y empieza en 1
  lx1[n] = mC*0; ly1[n] = mC*1; lx2[n] = mC*2; ly2[n] = mC*1;
  n = n +1;
  lx1[n] = mC*3; ly1[n] = mC*1; lx2[n] = mC*4; ly2[n] = mC*1;
  n = n +1;
  lx1[n] = mC*6; ly1[n] = mC*1; lx2[n] = mC*6; ly2[n] = mC*2;
  n = n +1;
  lx1[n] = mC*6; ly1[n] = mC*1; lx2[n] = mC*8; ly2[n] = mC*1;
  n = n +1;
  lx1[n] = mC*10; ly1[n] = mC*1; lx2[n] = mC*12; ly2[n] = mC*1;
  n = n +1;
  lx1[n] = mC*13; ly1[n] = mC*1; lx2[n] = mC*13; ly2[n] = mC*2;
  n = n +1;
  lx1[n] = mC*15; ly1[n] = mC*1; lx2[n] = mC*15; ly2[n] = mC*3;
  n = n +1;
  lx1[n] = mC*15; ly1[n] = mC*1; lx2[n] = mC*16; ly2[n] = mC*1;
  n = n +1;
    //y empieza en 2
  lx1[n] = mC*1; ly1[n] = mC*2; lx2[n] = mC*1; ly2[n] = mC*3;
  n = n +1;
  lx1[n] = mC*1; ly1[n] = mC*2; lx2[n] = mC*2; ly2[n] = mC*2;
  n = n +1;
  lx1[n] = mC*4; ly1[n] = mC*2; lx2[n] = mC*4; ly2[n] = mC*3;
  n = n +1;
  lx1[n] = mC*6; ly1[n] = mC*2; lx2[n] = mC*7; ly2[n] = mC*2;
  n = n +1;
  lx1[n] = mC*7; ly1[n] = mC*2; lx2[n] = mC*7; ly2[n] = mC*4;
  n = n +1;
  lx1[n] = mC*8; ly1[n] = mC*2; lx2[n] = mC*10; ly2[n] = mC*2;
  n = n +1; 
  lx1[n] = mC*11; ly1[n] = mC*2; lx2[n] = mC*11; ly2[n] = mC*4;
  n = n +1; 
  lx1[n] = mC*11; ly1[n] = mC*2; lx2[n] = mC*13; ly2[n] = mC*2;
  n = n +1; 
  lx1[n] = mC*8; ly1[n] = mC*2; lx2[n] = mC*10; ly2[n] = mC*2;
  n = n +1;
    //y empieza en 3
  lx1[n] = mC*1; ly1[n] = mC*3; lx2[n] = mC*4; ly2[n] = mC*3;
  n = n +1;
  lx1[n] = mC*2; ly1[n] = mC*3; lx2[n] = mC*2; ly2[n] = mC*4;
  n = n +1;
  lx1[n] = mC*3; ly1[n] = mC*3; lx2[n] = mC*3; ly2[n] = mC*4;
  n = n +1;
  lx1[n] = mC*5; ly1[n] = mC*3; lx2[n] = mC*6; ly2[n] = mC*3;
  n = n +1;
  lx1[n] = mC*7; ly1[n] = mC*3; lx2[n] = mC*7; ly2[n] = mC*4;
  n = n +1;
  lx1[n] = mC*9; ly1[n] = mC*3; lx2[n] = mC*9; ly2[n] = mC*4;
  n = n +1;
  lx1[n] = mC*13; ly1[n] = mC*3; lx2[n] = mC*13; ly2[n] = mC*4;
  n = n +1;
  lx1[n] = mC*7; ly1[n] = mC*3; lx2[n] = mC*15; ly2[n] = mC*3;
  n = n +1;
    //y empieza en 4
  lx1[n] = mC*0; ly1[n] = mC*4; lx2[n] = mC*2; ly2[n] = mC*4;
  n = n +1;
  lx1[n] = mC*4; ly1[n] = mC*4; lx2[n] = mC*4; ly2[n] = mC*5;
  n = n +1;
  lx1[n] = mC*4; ly1[n] = mC*4; lx2[n] = mC*5; ly2[n] = mC*4;
  n = n +1;
  lx1[n] = mC*6; ly1[n] = mC*4; lx2[n] = mC*7; ly2[n] = mC*4;
  n = n +1;
  lx1[n] = mC*8; ly1[n] = mC*4; lx2[n] = mC*8; ly2[n] = mC*5;
  n = n +1;
  lx1[n] = mC*10; ly1[n] = mC*4; lx2[n] = mC*10; ly2[n] = mC*6;
  n = n +1;
  lx1[n] = mC*12; ly1[n] = mC*4; lx2[n] = mC*12; ly2[n] = mC*11;
  n = n +1;
  lx1[n] = mC*13; ly1[n] = mC*4; lx2[n] = mC*15; ly2[n] = mC*4;
  n = n +1;
    //y empieza en 5
  lx1[n] = mC*0; ly1[n] = mC*5; lx2[n] = mC*1; ly2[n] = mC*5;
  n = n +1;
  lx1[n] = mC*2; ly1[n] = mC*5; lx2[n] = mC*4; ly2[n] = mC*5;
  n = n +1;
  lx1[n] = mC*5; ly1[n] = mC*5; lx2[n] = mC*5; ly2[n] = mC*6;
  n = n +1;
  lx1[n] = mC*5; ly1[n] = mC*5; lx2[n] = mC*10; ly2[n] = mC*5;
  n = n +1;
  lx1[n] = mC*11; ly1[n] = mC*5; lx2[n] = mC*11; ly2[n] = mC*6;
  n = n +1;
  lx1[n] = mC*11; ly1[n] = mC*5; lx2[n] = mC*15; ly2[n] = mC*5;
  n = n +1;
    //y empieza en 6
  lx1[n] = mC*1; ly1[n] = mC*6; lx2[n] = mC*5; ly2[n] = mC*6;
  n = n +1;
  lx1[n] = mC*4; ly1[n] = mC*6; lx2[n] = mC*4; ly2[n] = mC*8;
  n = n +1;
  lx1[n] = mC*6; ly1[n] = mC*6; lx2[n] = mC*6; ly2[n] = mC*7;
  n = n +1;
  lx1[n] = mC*6; ly1[n] = mC*6; lx2[n] = mC*9; ly2[n] = mC*6;
  n = n +1;
  lx1[n] = mC*12; ly1[n] = mC*6; lx2[n] = mC*16; ly2[n] = mC*6;
  n = n +1;
    //y empieza en 7
  lx1[n] = mC*0; ly1[n] = mC*7; lx2[n] = mC*3; ly2[n] = mC*7;
  n = n +1;
  lx1[n] = mC*1; ly1[n] = mC*7; lx2[n] = mC*1; ly2[n] = mC*9;
  n = n +1;
  lx1[n] = mC*4; ly1[n] = mC*7; lx2[n] = mC*8; ly2[n] = mC*7;
  n = n +1;
  lx1[n] = mC*7; ly1[n] = mC*7; lx2[n] = mC*7; ly2[n] = mC*9;
  n = n +1;
  lx1[n] = mC*8; ly1[n] = mC*7; lx2[n] = mC*8; ly2[n] = mC*9;
  n = n +1;
  lx1[n] = mC*9; ly1[n] = mC*7; lx2[n] = mC*9; ly2[n] = mC*9;
  n = n +1;
  lx1[n] = mC*9; ly1[n] = mC*7; lx2[n] = mC*12; ly2[n] = mC*7;
  n = n +1;
  lx1[n] = mC*13; ly1[n] = mC*7; lx2[n] = mC*16; ly2[n] = mC*7;
  n = n +1;
  lx1[n] = mC*14; ly1[n] = mC*7; lx2[n] = mC*14; ly2[n] = mC*8;
  n = n +1;
  lx1[n] = mC*15; ly1[n] = mC*7; lx2[n] = mC*15; ly2[n] = mC*8;
  n = n +1;
    //y empieza en 8
  lx1[n] = mC*2; ly1[n] = mC*8; lx2[n] = mC*4; ly2[n] = mC*8;
  n = n +1;
  lx1[n] = mC*5; ly1[n] = mC*8; lx2[n] = mC*5; ly2[n] = mC*9;
  n = n +1;
  lx1[n] = mC*5; ly1[n] = mC*8; lx2[n] = mC*7; ly2[n] = mC*8;
  n = n +1;
  lx1[n] = mC*10; ly1[n] = mC*8; lx2[n] = mC*11; ly2[n] = mC*8;
  n = n +1;
  lx1[n] = mC*11; ly1[n] = mC*8; lx2[n] = mC*11; ly2[n] = mC*10;
  n = n +1;
  lx1[n] = mC*12; ly1[n] = mC*8; lx2[n] = mC*13; ly2[n] = mC*8;
  n = n +1;
    //y empieza en 9
  lx1[n] = mC*2; ly1[n] = mC*9; lx2[n] = mC*2; ly2[n] = mC*10;
  n = n +1;
  lx1[n] = mC*2; ly1[n] = mC*9; lx2[n] = mC*5; ly2[n] = mC*9;
  n = n +1;
  lx1[n] = mC*6; ly1[n] = mC*9; lx2[n] = mC*6; ly2[n] = mC*10;
  n = n +1;
  lx1[n] = mC*9; ly1[n] = mC*9; lx2[n] = mC*10; ly2[n] = mC*9;
  n = n +1;
  lx1[n] = mC*13; ly1[n] = mC*9; lx2[n] = mC*15; ly2[n] = mC*9;
  n = n +1;
  lx1[n] = mC*14; ly1[n] = mC*9; lx2[n] = mC*14; ly2[n] = mC*15;
  n = n +1;
    //y empieza en 10
  lx1[n] = mC*0; ly1[n] = mC*10; lx2[n] = mC*3; ly2[n] = mC*10;
  n = n +1;
  lx1[n] = mC*3; ly1[n] = mC*10; lx2[n] = mC*3; ly2[n] = mC*11;
  n = n +1;
  lx1[n] = mC*4; ly1[n] = mC*10; lx2[n] = mC*11; ly2[n] = mC*10;
  n = n +1;
  lx1[n] = mC*9; ly1[n] = mC*10; lx2[n] = mC*9; ly2[n] = mC*11;
  n = n +1;
  lx1[n] = mC*13; ly1[n] = mC*10; lx2[n] = mC*14; ly2[n] = mC*10;
  n = n +1;
  lx1[n] = mC*15; ly1[n] = mC*10; lx2[n] = mC*16; ly2[n] = mC*10;
  n = n +1;
    //y empieza en 11
  lx1[n] = mC*1; ly1[n] = mC*11; lx2[n] = mC*1; ly2[n] = mC*12;
  n = n +1;
  lx1[n] = mC*1; ly1[n] = mC*11; lx2[n] = mC*2; ly2[n] = mC*11;
  n = n +1;
  lx1[n] = mC*2; ly1[n] = mC*11; lx2[n] = mC*2; ly2[n] = mC*12;
  n = n +1;
  lx1[n] = mC*4; ly1[n] = mC*11; lx2[n] = mC*8; ly2[n] = mC*11;
  n = n +1;
  lx1[n] = mC*6; ly1[n] = mC*11; lx2[n] = mC*6; ly2[n] = mC*12;
  n = n +1;
  lx1[n] = mC*7; ly1[n] = mC*11; lx2[n] = mC*7; ly2[n] = mC*13;
  n = n +1;
  lx1[n] = mC*9; ly1[n] = mC*11; lx2[n] = mC*10; ly2[n] = mC*11;
  n = n +1;
  lx1[n] = mC*10; ly1[n] = mC*11; lx2[n] = mC*10; ly2[n] = mC*12;
  n = n +1;
  lx1[n] = mC*11; ly1[n] = mC*11; lx2[n] = mC*11; ly2[n] = mC*12;
  n = n +1;
  lx1[n] = mC*11; ly1[n] = mC*11; lx2[n] = mC*13; ly2[n] = mC*11;
  n = n +1;
  lx1[n] = mC*14; ly1[n] = mC*11; lx2[n] = mC*15; ly2[n] = mC*11;
  n = n +1;
    //y empieza en 12
  lx1[n] = mC*2; ly1[n] = mC*12; lx2[n] = mC*5; ly2[n] = mC*12;
  n = n +1;
  lx1[n] = mC*3; ly1[n] = mC*12; lx2[n] = mC*3; ly2[n] = mC*13;
  n = n +1;
  lx1[n] = mC*5; ly1[n] = mC*12; lx2[n] = mC*5; ly2[n] = mC*13;
  n = n +1;
  lx1[n] = mC*7; ly1[n] = mC*12; lx2[n] = mC*9; ly2[n] = mC*12;
  n = n +1;
  lx1[n] = mC*10; ly1[n] = mC*12; lx2[n] = mC*11; ly2[n] = mC*12;
  n = n +1;
  lx1[n] = mC*12; ly1[n] = mC*12; lx2[n] = mC*12; ly2[n] = mC*13;
  n = n +1;
  lx1[n] = mC*13; ly1[n] = mC*12; lx2[n] = mC*14; ly2[n] = mC*12;
  n = n +1;
  lx1[n] = mC*15; ly1[n] = mC*12; lx2[n] = mC*16; ly2[n] = mC*12;
  n = n +1;
    //y empieza en 13
  lx1[n] = mC*0; ly1[n] = mC*13; lx2[n] = mC*3; ly2[n] = mC*13;
  n = n +1;
  lx1[n] = mC*4; ly1[n] = mC*13; lx2[n] = mC*4; ly2[n] = mC*15;
  n = n +1;
  lx1[n] = mC*5; ly1[n] = mC*13; lx2[n] = mC*7; ly2[n] = mC*13;
  n = n +1;
  lx1[n] = mC*8; ly1[n] = mC*13; lx2[n] = mC*12; ly2[n] = mC*13;
  n = n +1;
  lx1[n] = mC*10; ly1[n] = mC*13; lx2[n] = mC*10; ly2[n] = mC*15;
  n = n +1;
  lx1[n] = mC*13; ly1[n] = mC*13; lx2[n] = mC*13; ly2[n] = mC*14;
  n = n +1;
  lx1[n] = mC*13; ly1[n] = mC*13; lx2[n] = mC*14; ly2[n] = mC*13;
  n = n +1;
  lx1[n] = mC*15; ly1[n] = mC*13; lx2[n] = mC*16; ly2[n] = mC*13;
  n = n +1;
    //y empieza en 14
  lx1[n] = mC*1; ly1[n] = mC*14; lx2[n] = mC*3; ly2[n] = mC*14;
  n = n +1;
  lx1[n] = mC*4; ly1[n] = mC*14; lx2[n] = mC*8; ly2[n] = mC*14;
  n = n +1;
  lx1[n] = mC*9; ly1[n] = mC*14; lx2[n] = mC*9; ly2[n] = mC*15;
  n = n +1;
  lx1[n] = mC*11; ly1[n] = mC*14; lx2[n] = mC*11; ly2[n] = mC*15;
  n = n +1;
  lx1[n] = mC*11; ly1[n] = mC*14; lx2[n] = mC*13; ly2[n] = mC*14;
  n = n +1;
  lx1[n] = mC*14; ly1[n] = mC*14; lx2[n] = mC*15; ly2[n] = mC*14;
  n = n +1;
    //y empieza en 15
  lx1[n] = mC*1; ly1[n] = mC*15; lx2[n] = mC*5; ly2[n] = mC*15;
  n = n +1;
  lx1[n] = mC*2; ly1[n] = mC*15; lx2[n] = mC*2; ly2[n] = mC*16;
  n = n +1;
  lx1[n] = mC*6; ly1[n] = mC*15; lx2[n] = mC*12; ly2[n] = mC*15;
  n = n +1;
  lx1[n] = mC*12; ly1[n] = mC*15; lx2[n] = mC*12; ly2[n] = mC*16;
  n = n +1;
  lx1[n] = mC*13; ly1[n] = mC*15; lx2[n] = mC*13; ly2[n] = mC*16;
  n = n +1;
}

//modo debug por las dudas
/*
void mouseDragged() {
  px = mouseX;
  py = mouseY;
}
*/
