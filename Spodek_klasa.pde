// Klasa reprezentująca spodek UFO
class Spodek {
  PShape model;  //oznacza, który model wykorzystamy, czyli shp1 czy shp2 ??????
  PImage tekstura;  //określimy, czy chcemy txtr1 czy txtr2
  float x, y, z;  //oznacza położenie spodka na osi X,Y,Z
  float spin;   //posłuży do obrotu spodka wokół własnej osi

  Spodek(PShape model, PImage tekstura, float x, float y, float z) {
    this.model = model;
    this.tekstura = tekstura;
    this.x = x;
    this.y = y;
    this.z = z;
    this.spin = 0;  //narazie równe 0, potem będzie wzrastać

    model.scale(2); // skala (wielkość) modelu
    model.setTexture(tekstura); // przypisanie tekstury
  }
  
  void rysuj() {
    pushMatrix();
    translate(x, y, z);
    lights();
    rotateY(PI/180 + spin);

    ambientLight(102, 102, 102);  // efekty świetlne
    lightSpecular(204, 204, 204);
    directionalLight(102, 102, 102, 0, 0, -1);
    specular(255, 255, 255);

    fill(209, 63, 63); // kolor modelu
    shape(model);

    popMatrix();

    spin += 0.04; // pozwoli na obrót spodka
  }
}
