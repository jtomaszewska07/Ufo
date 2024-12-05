JSONObject geoData;
JSONArray features;
PShape shp1, shp2; //zmienne dla spodka amerykanskiego i europejskiego
PImage txtr1, txtr2; //zmienna dla tekstury z flagi USA i Europy
PImage inwazja_tlo;
float spin;
Table tabela;
int currentLine = 0; // zmienna przechowująca indeks aktualnie rysowanego wiersza
boolean pokazuj_ekran_start = true;
boolean pokazuj_inwazje = false;  // zmienna śledząca wyświetlanie inwazji

//LASERY
//laser amerykanski:
float x = 130;  // Początkowa pozycja X
float y = 525;  // Początkowa pozycja Y
float speedX = 3;  // Prędkość w osi X
float speedY = -8; // Prędkość w osi Y (np. lekkie opadanie)
//laser europejski:
float x2 = 600;
float y2 = 525;
float speedX2 = -4;



void setup() {
  size(800,700,P3D);
  frameRate(2);
  //fullScreen();
  geoData = loadJSONObject("countries.geojson"); // ładowanie naszego pliku 
  features = geoData.getJSONArray("features"); //  Lista JSON zawierająca wiersze oznaczające Kraje i ich własności 
  tabela = loadTable("ufo_sighting_data_update_v2.csv", "header");
  
  //drawMap(); //jednak to będzie w draw, aby zamalowywać poprzedni spodek i poprzedni laser
  
  
  shp1 = loadShape("model_spodka/UFO.obj");
  shp2 = loadShape("model_spodka/UFO.obj");
  txtr1 = loadImage("data/USA_flaga.jpg");
  txtr2 = loadImage("data/Europa_flaga.png");
  inwazja_tlo = loadImage("data/inwazja_ufo.jpg");
  inwazja_tlo.resize(width, height);  // zdjecie z inwazją dopasuje się do wymiarów ekranu
  
  shp1.scale(2);
  shp2.scale(2);
  shp1.setTexture(txtr1); //dodajemy teksturę
  shp2.setTexture(txtr2); //dodajemy teksturę
  
}



void draw(){
  if (pokazuj_ekran_start) {   //w zmiennych globalnych pokazuj_ekran_start jest ustawione na true
    beginScreen();
  } else {
      background(1,7,59); //kolor oceanów
      drawMap();
      
      //LASERY
       // Rysowanie pocisku
      stroke(62,237,89,150); // Kolor zielony
      strokeWeight(8); // Grubość pocisku
      line(x, y, x - 10, y); // Pocisk jako krótka linia
      line(x2, y2, x2-10, y2); //pocisk europejski
      
      // Ruch pocisku
      x += speedX;
      y += speedY;
      x2 +=speedX2;
      y2 += speedY;
     
      
      // Efekt znikania pocisku (wyjście poza ekran)
      if (x > width || y > height || y < 0) {
        resetBullet(); // Restart pocisku
      }
      
      
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
      
      
      //spodek amerykanski
      pushMatrix();
      translate(width/6, height/4*3, 0);
      lights();
      rotateY(PI/180 + spin);
      
      ambientLight(102, 102, 102);  //dodajemy różne efekty światlne, żeby spodek był jaśniejszy
      lightSpecular(204, 204, 204);
      directionalLight(102, 102, 102, 0, 0, -1);
      specular(255, 255, 255);
        
      fill(209,63,63);  
      shape(shp1);
      popMatrix();
      
      //spodek europejski
      pushMatrix();
      translate(width/4*3, height/4*3, 0);
      lights();
      rotateY(PI/180 + spin);
      
      ambientLight(102, 102, 102); //dodajemy różne efekty światlne, żeby spodek był jaśniejszy
      lightSpecular(204, 204, 204);
      directionalLight(102, 102, 102, 0, 0, -1);
      specular(255, 255, 255);
     
      fill(209,63,63);  
      shape(shp2);
      
      popMatrix();
      
      spin += 0.04; //okresla predkosc obracania sie spodka 
      
      
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


// Funkcja resetująca pocisk do startowej pozycji
void resetBullet() {
  x = 100; // Powrót na startową pozycję X
  x2= 600;
  y = random(height); // Losowa pozycja Y (opcjonalne)
  y2 = random(height);
  speedY = random(-3, 3); // Losowy kąt lotu
}



void beginScreen() {
  //background(0,0,0);
  image(inwazja_tlo, 0, 0);  //wyswietli zdjecie zaczynając od pozycji (0,0)
  
  textAlign(CENTER, CENTER);
  fill(255,33,33);
  textSize(30);
  text("Naciśnij ENTER, by zacząć inwazję!", width/2, height/2);
}


void keyPressed() {
  if (pokazuj_ekran_start) {
    pokazuj_ekran_start = false;  // Zamknij ekran startowy na klawisz
  } 
  else if (!pokazuj_inwazje) {  //jeśli inwazja się pokazuje (bo w zmiennych globalnych pokazuj_inwazje było równe false)
        if (key == ENTER) {
          pokazuj_inwazje = true;
        }   
  }
}
