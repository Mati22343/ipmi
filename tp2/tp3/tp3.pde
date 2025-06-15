
PImage imagenReferencia;

float EL = 26;  // espaciado de linea "E.L"
float GLF = 14; // grosor de linea fondo "GLF"
float RA = 135; // rotacion del angulo


Cuadrado2 mCuadrado2;

float cuadradoBlancoSize; // Tamaño del lado del cuadrado blanco
float cuadradoBlancoX;    // Posición X del centro del cuadrado blanco
float cuadradoBlancoY;    // Posición Y del centro del cuadrado blanco

float lineaGrosor = 12;   // Grosor de la línea inclinada

void setup() {

  size(800, 400);

  mCuadrado2 = new Cuadrado2(width * 0.75, height / 2, 288, 24, 12);

  imagenReferencia = loadImage("28.jpg");
  imagenReferencia.resize(400, 400);
  cuadradoBlancoSize = 150; // Un tamaño de 150x150 píxeles
  cuadradoBlancoX = mCuadrado2.xPos; // Centrado horizontalmente con el cuadrado grande
  cuadradoBlancoY = mCuadrado2.yPos; // Centrado verticalmente con el cuadrado grande

}

void draw() {
  if (mousePressed) {
    // Si el mouse está presionado, el fondo será negro
    background(0); 
  } else {
    // Si el mouse NO está presionado, el fondo será blanco (estado normal)
    background(255); 
  }
  
  color lineColor;    // Variable para el color de todas las líneas
  color fillColor;    // Variable para el color de los fondos (cuadrado blanco, y fondo de CebraCuadrado)

  if (mousePressed) {
    lineColor = color(255); // Líneas blancas cuando se presiona
    fillColor = color(0);   // Fondos negros cuando se presiona
  } else {
    lineColor = color(0);   // Líneas negras normalmente
    fillColor = color(255); // Fondos blancos normalmente
  }

  stroke(lineColor); 
  strokeWeight(GLF); 
  strokeCap(PROJECT); 

  pushMatrix(); 
  translate(width / 2, 0); 
  translate( (width/2) / 2, height / 2); 
  rotate(radians(RA)); 
  translate( -(width/2) / 2, -height / 2); 

  float sWidth = width * 2;  
  float sHeight = height * 2;    

  float yLineStart = -200 + (GLF / 2); 
  float yLineEnd = sHeight - (GLF);   

  float effectiveXRange = dist(0, 0, sWidth, sHeight); 
  
  float loopStartX = -effectiveXRange / 2 - GLF; 
  float loopEndX = effectiveXRange / 2 + GLF;   

  for (float x = loopStartX; x <= loopEndX; x += EL) {
    line(x, yLineStart, x, yLineEnd); 
  }
  popMatrix(); 

  mCuadrado2.display(lineColor, fillColor);

  float imgX = (width / 2) / 2 - imagenReferencia.width / 2; 
  float imgY = height / 2 - imagenReferencia.height / 2;
  image(imagenReferencia, imgX, imgY); 

  fill(fillColor);      
  noStroke();     
  rectMode(CENTER); 
  rect(cuadradoBlancoX, cuadradoBlancoY, cuadradoBlancoSize, cuadradoBlancoSize); 

  stroke(lineColor);                  
  strokeWeight(lineaGrosor);  
  strokeCap(PROJECT);         

  float x1_linea = cuadradoBlancoX - cuadradoBlancoSize / 2; 
  float y1_linea = cuadradoBlancoY + cuadradoBlancoSize / 2; 

  float x2_linea = cuadradoBlancoX + cuadradoBlancoSize / 2; 
  float y2_linea = cuadradoBlancoY - cuadradoBlancoSize / 2; 

  line(x1_linea, y1_linea, x2_linea, y2_linea); 

}
