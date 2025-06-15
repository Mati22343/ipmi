class Cuadrado2 {
  float xPos;         // Posición X del centro del cuadrado
  float yPos;         // Posición Y del centro del cuadrado
  float size;         // Tamaño (lado) del cuadrado
  float lineSpacing;  // Espaciado entre las líneas
  float lineThickness; // Grosor de las líneas
  
    Cuadrado2(float x, float y, float s, float spacing, float thickness) {
    xPos = x;
    yPos = y;
    size = s;
    lineSpacing = spacing;
    lineThickness = thickness;
  }

void display(color lineColor, color fillColor) { 
    fill(fillColor);      
    noStroke();     
    rectMode(CENTER); 
    rect(xPos, yPos, size, size);     
    stroke(lineColor);
    strokeWeight(lineThickness); 
    strokeCap(PROJECT);    
    pushMatrix(); 
    translate(xPos, yPos); 
    
    float yLineStart = -size / 2 + (lineThickness / 2);
    float yLineEnd = size / 2 - (lineThickness / 2);

    float xRangeStart = -size / 2 + (lineThickness / 2);
    float xRangeEnd = size / 2 - (lineThickness / 2);

    for (float x = xRangeStart; x <= xRangeEnd; x += lineSpacing) {
      line(x, yLineStart, x, yLineEnd); 
    }

    popMatrix(); 
  }
}
