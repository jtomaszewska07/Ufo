// Klasa Laser odpowiedzialna za rysowanie i poruszanie się laserów
class Laser {
  float x, y;           // pozycja lasera
  float speedX, speedY; // prędkości w osi X i Y
  color laserColor;     // kolor lasera

  // Konstruktor klasy Laser
  Laser(float init_x, float init_y, float init_speedX, float init_speedY, color c) {
    x = init_x;
    y = init_y;
    speedX = init_speedX;
    speedY = init_speedY;
    laserColor = c;
  }



  // metoda rysująca laser
  void rysuj_laser() {
    stroke(laserColor);
    strokeWeight(8);
    line(x, y, x - 10, y); // rysujemy krótki laser jako linię
  }



  // metoda odpowiedzialna za ruch lasera
  void ruch_lasera() {
    x += speedX;
    y += speedY;
  }



  // sprawdzenie, czy laser opuścił ekran
  boolean isOffScreen() {
    return (x > width || y > height || y < 0);  //zwróci true, jeśli któryś z tych warunków będzie spełniony
  }



  // resetowanie pozycji lasera, gdy opuści ekran
  void resetuj_laser(float init_x, float init_y, float init_speedX, float init_speedY) {
    x = init_x;
    y = init_y;
    speedX = init_speedX;
    speedY = init_speedY;
  }
}
