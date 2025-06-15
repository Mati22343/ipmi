class Cuadrado3 {
  float xPos;          // Posición X del centro del cuadrado
  float yPos;          // Posición Y del centro del cuadrado
  float size;          // Tamaño (lado) del cuadrado
  float lineSpacing;   // Espaciado entre las líneas
  float lineThickness;  // Grosor de las líneas
  float rotationAngle;  // Ángulo de rotación de las líneas

  Cuadrado3(float x, float y, float s, float spacing, float thickness, float angle) {
    xPos = x;
    yPos = y;
    size = s;
    lineSpacing = spacing;
    lineThickness = thickness;
    rotationAngle = angle;
  }

  void display() {
    
    fill(255);
    noStroke();
    rectMode(CENTER);
    rect(xPos, yPos, size, size);

    stroke(0);
    strokeWeight(lineThickness);
    strokeCap(PROJECT);

    pushMatrix();
    translate(xPos, yPos);
    rotate(radians(rotationAngle));

    float effectiveRange = size * sqrt(2); 
    float yLineStart = -size / 2 + (lineThickness / 2);
    float yLineEnd = size / 2 - (lineThickness / 2);
    float xRangeStart = -effectiveRange / 2 - (lineThickness / 2); 
    float xRangeEnd = effectiveRange / 2 + (lineThickness / 2);   
    for (float x = xRangeStart; x <= xRangeEnd; x += lineSpacing) {
      line(x, yLineStart, x, yLineEnd); 
    }

    popMatrix(); // Restaura el sistema de coordenadas
  }
}
