// Klasa odpowiedzialna za wyświetlanie ekranu startowego
class EkranStartowy {
  PImage tlo;    // obraz tła ekranu startowego
  String tekst;  // tekst wyświetlany na ekranie

  // Konstruktor klasy 
  EkranStartowy(PImage tlo, String tekst) {
    this.tlo = tlo;
    this.tekst = tekst;
    tlo.resize(width, height); // dopasowanie zdjęcia tła do wymiarów ekranu
  }

  // metoda rysująca ekran startowy
  void wyswietl_ekran_start() {
    image(tlo, 0, 0); // wyświetli zdjęcie zaczynając od pozycji (0,0)

    // wyświetlanie tekstu
    textAlign(CENTER, CENTER);
    fill(255, 33, 33);  // czerwony kolor tekstu
    textSize(30);
    text(tekst, width / 2, height / 2);   // zmienną "tekst" wypełnimy w głównym programie konkretną treścią
  }
}
