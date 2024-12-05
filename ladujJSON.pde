/*
---- Projekt zaliczeniowy z Processingu w ramach kursu "Projektowanie systemów interaktywnych w środowiskach Processing i Arduino"  ----

Opis projektu: Projekt przedstawia wizualizację zestawu danych "ufo_sighting", który zawiera informacje dot. wszystkich udokumentowanych obserwacji UFO.
               Celem projektu jest wizualizacja, w jakich obszarach świata pojawia się UFO, ze szczególnym uwzględnieniem rywalizacji między
               USA a Europą. Projekt przedstawia również, jak rozkładała się liczba obserwacji na przestrzeni lat (od 1985 roku).

Skład grupy: Martyna Grzegorczyk, Julia Tomaszewska, Wiktoria Rabińska

Wkład osób:
  - Martyna Grzegorczyk: 1. Pojawianie się punktów na mapie, które odpowiadają współrzędnym geograficznym, gdzie zaobserwowano UFO zgodnie z bazą danych.
                         2. Dodanie obracających się obiektów 3D, oklejonych teksturą.
                         3. Dodanie ruchomych laserów wychodzących z obiektów 3D. 
                         4. Dodanie ekranu startowego, który znika na klawisz ENTER.
                         5. Stworzenie klas.
  - Julia Tomaszewska:
  
  - Wiktoria Rabińska:
*/
// ---------------------------------------------------------------------------------------------------------------------------------






// zmienne globalne:
JSONObject geoData;
JSONArray features;
PShape shp1, shp2; //zmienne dla spodka amerykanskiego i europejskiego
PImage txtr1, txtr2; //zmienna dla tekstury z flagi USA i Europy
PImage inwazja_tlo;
Table tabela;
int currentLine = 0; // zmienna przechowująca indeks aktualnie rysowanego wiersza
boolean pokazuj_ekran_start = true;   // flaga kontrolująca wyświetlanie ekranu startowego

Spodek spodekUSA;  //obiekt klasy Spodek
Spodek spodekEuropa;

Laser laserUSA;  //obiekty klasy Laser
Laser laserEurope;

EkranStartowy ekranStartowy;  //obiekt klasy EkranStartowy



void setup() {
  size(800,700,P3D);
  frameRate(2);
  //fullScreen();
  geoData = loadJSONObject("countries.geojson"); // ładowanie naszego pliku 
  features = geoData.getJSONArray("features"); //  lista JSON zawierająca wiersze oznaczające Kraje i ich własności 
  tabela = loadTable("ufo_sighting_data_update_v2.csv", "header");
  
  //drawMap(); //jednak to będzie w draw, aby zamalowywać poprzedni spodek i poprzedni laser
  
  
  shp1 = loadShape("model_spodka/UFO.obj");
  shp2 = loadShape("model_spodka/UFO.obj");
  txtr1 = loadImage("data/USA_flaga.jpg");
  txtr2 = loadImage("data/Europa_flaga.png");
  inwazja_tlo = loadImage("data/inwazja_ufo.jpg");
  
  // inicjalizacja spodków
  spodekUSA = new Spodek(shp1, txtr1, width / 6, height / 4 * 3, 0);
  spodekEuropa = new Spodek(shp2, txtr2, width / 4 * 3, height / 4 * 3, 0);
  
  // inicjalizacja laserów
  laserUSA = new Laser(130, 525, 3, -8, color(62, 237, 89, 150)); // laser ze spodka USA
  laserEurope = new Laser(600, 525, -4, -8, color(62, 237, 89, 150)); // laser ze spodka Europy
  
  ekranStartowy = new EkranStartowy(inwazja_tlo, "Naciśnij ENTER, by zacząć inwazję!");  //inicjalizacja obiektu - dopiero tutaj podajemy treść tekstu
  
  
}



void draw(){
  if (pokazuj_ekran_start) {   //w zmiennych globalnych pokazuj_ekran_start jest ustawione na true
     ekranStartowy.wyswietl_ekran_start(); // wyświetli ekran startowy
  } else {
      background(1,7,59); //kolor oceanów
      drawMap();
 
      //if (currentLine < tabela.getRowCount()) {
          for (int i = 0; i < tabela.getRowCount(); i++) { //ASPEKT CZASOWY TO BĘDZIE CurrentLine - dodaj taką zmienną, tak jak w pracy domowej
              String kol1 = tabela.getString(i, 0); // kolumna z datą
              String kol2 = tabela.getString(i, 3); //kolumna z nazwami krajów
              float latitude = tabela.getFloat(i, 9); //latitude - szerokosc geo.
              float longitude = tabela.getFloat(i, 10); //longitude - długosc geo.
              
              float mappedX = map(longitude, -180,180, 0,width);
              float mappedY = map(latitude, -90,90, height, 0);
              
              fill(248,252,191, 4); //czwarty parametr daje coś w rodzaju przezroczystości
              noStroke();
              ellipse(mappedX, mappedY, 10, 10); //punkty pojawiające się w miejscach sightingów (wg współrzędnych geograficznych)
    
              
              //delay(500); //powinno powodować zatrzymanie programu na pół sekundy, ale jak delay jest w tej pętli for, to program WCALE SIĘ NIE URUCHAMIA; ale konceptualnie
                            //to by było super - "zatrzymuj się po każdym wierszu tabeli" 
              
              //currentLine++;
          
          }
      
      // rysowanie spodków
      spodekUSA.rysuj();
      spodekEuropa.rysuj();
      
      // wyświetlanie laserów
      laserUSA.rysuj_laser();
      laserEurope.rysuj_laser();
      
      // poruszanie się laserów
      laserUSA.ruch_lasera();
      laserEurope.ruch_lasera();
      
      // sprawdzenie, czy lasery opuściły ekran, a jeśli tak, to nastąpi ich reset
      if (laserUSA.isOffScreen()) {
        laserUSA.resetuj_laser(130, random(height), 3, random(-3, 3));  // 130 - oznacza powrót na startową pozycję X
                                                                        // random(height) - oznacza losową pozycję Y
                                                                        // 3 - oznacza prędkość po osi X
                                                                        // random(-3,3) - oznacza losową prędkość po osi Y
      }
    
      if (laserEurope.isOffScreen()) {
        laserEurope.resetuj_laser(600, random(height), -4, random(-3, 3));   // wytłumaczenie analogiczne do powyższego
      }
      
      //delay(2000); //raczej to nic nie daje
      }
}

void drawMap() {
    // Iterowanie Po wszystkich KRAJACH 
  for (int i = 0; i < features.size(); i++) { 
    JSONObject country = features.getJSONObject(i);
    JSONObject geometry = country.getJSONObject("geometry"); //Geometria Kraju - czyli jego kształt 
    String type = geometry.getString("type"); // Typ Geometrii: Może być Poligon, MulitPoligon - czyli kształt 2D lub ich zbiór  - najczęściej kraje to będą MultiPolygony, jeśli jednak mają proste kształty, Polygon wystarczy 
    JSONArray coordinates = geometry.getJSONArray("coordinates"); // Każda geometria ma swoje koordynaty, czyli gdzie na mapie leżą poszczególne elementy (Polygony) - tu mamy Listę List - listę koordynatów odpowiadających danemu krajowi

    JSONObject countyProp= country.getJSONObject("properties"); // Jeśli chcemy zyskać Nazwę kraju - Wiele dodatkowych informacji będzie przechowywanych w Obiekcie JSON: Properties 
    
    
    // możemy następnie wykorzystać nazwę do nadania koloru lub wydzielenia
    fill(0,0,0);    //kolor państw
    stroke(77,2,2);     //kolor konturu państw
    strokeWeight(0.5);     //grubość konturów państw

    
    if (type.equals("Polygon")) {
      drawPolygon(coordinates); // Funkcja rysująca nam koordynaty każdego kraju 
    } else if (type.equals("MultiPolygon")) {
      drawMultiPolygon(coordinates);
    }
  }
}

void drawPolygon(JSONArray coordinates) {
  beginShape(); // tworzymy kształt naszego kraju 
  JSONArray coordArray = coordinates.getJSONArray(0); //dla liczby Wierzchołków Kraju 
  for (int j = 0; j < coordArray.size(); j++) {
    JSONArray coord = coordArray.getJSONArray(j); // koordynaty Długości i szerokości geogreaficznej wierzchołka Polygonu danego kraju 
    float lon = coord.getFloat(0); // Longitutde - długość geograficzna 
    float lat = coord.getFloat(1); // Latitude  - szerokość geograficzna
    // Convert latitude and longitude to screen coordinates
    float x = map(lon, -180, 180, 0, width); // mapujemy nasze współrzędne Geograficzne 
    float y = map(lat, 90, -90, 0, height);  
    vertex(x, y);
  }
  endShape(CLOSE);
}

void drawMultiPolygon(JSONArray coordinates) {
  for (int i = 0; i < coordinates.size(); i++) { // jeśli mamy MultiPolygn, czyli wiele ksztaltów - rysujemy każdy z nich 
    drawPolygon(coordinates.getJSONArray(i));
  }
}


void keyPressed() {
  if (pokazuj_ekran_start && key == ENTER) {
    pokazuj_ekran_start = false; // wyłączy ekran startowy po naciśnięciu ENTER
  }
}
