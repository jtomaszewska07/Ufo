// JSON EXPLANATION
// Wiktoria
//coś piszę

JSONObject geoData;
JSONArray features;

void setup() {
  size(600,500);
  //fullScreen();
  geoData = loadJSONObject("countries.geojson"); // ładowanie naszego pliku 
  features = geoData.getJSONArray("features"); //  Lista JSON zawierająca wiersze oznaczające Kraje i ich własności 

  background(0,8,88);
  drawMap();
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
    if (countyProp.getString("ADMIN").equals("United States of America")){
        fill(255,0,0);
    } else if (countyProp.getString("ADMIN").equals("Albania") ||
               countyProp.getString("ADMIN").equals("Andorra") ||
               countyProp.getString("ADMIN").equals("Armenia") ||
               countyProp.getString("ADMIN").equals("Austria") ||
               countyProp.getString("ADMIN").equals("Azerbaijan") ||
               countyProp.getString("ADMIN").equals("Belarus") ||
               countyProp.getString("ADMIN").equals("Belgium") ||
               countyProp.getString("ADMIN").equals("Bosnia and Herzegovina") ||
               countyProp.getString("ADMIN").equals("Bulgaria") ||
               countyProp.getString("ADMIN").equals("Croatia") ||
               countyProp.getString("ADMIN").equals("Cyprus") ||
               countyProp.getString("ADMIN").equals("Czech Republic") ||
               countyProp.getString("ADMIN").equals("Denmark") ||
               countyProp.getString("ADMIN").equals("Estonia") ||
               countyProp.getString("ADMIN").equals("Finland") ||
               countyProp.getString("ADMIN").equals("France") ||
               countyProp.getString("ADMIN").equals("Georgia") ||
               countyProp.getString("ADMIN").equals("Germany") ||
               countyProp.getString("ADMIN").equals("Greece") ||
               countyProp.getString("ADMIN").equals("Hungary") ||
               countyProp.getString("ADMIN").equals("Iceland") ||
               countyProp.getString("ADMIN").equals("Ireland") ||
               countyProp.getString("ADMIN").equals("Italy") ||
               countyProp.getString("ADMIN").equals("Kosovo") ||
               countyProp.getString("ADMIN").equals("Latvia") ||
               countyProp.getString("ADMIN").equals("Liechtenstein") ||
               countyProp.getString("ADMIN").equals("Lithuania") ||
               countyProp.getString("ADMIN").equals("Luxemburg") ||
               countyProp.getString("ADMIN").equals("Malta") ||
               countyProp.getString("ADMIN").equals("Moldova") ||
               countyProp.getString("ADMIN").equals("Monaco") ||
               countyProp.getString("ADMIN").equals("Montenegro") ||
               countyProp.getString("ADMIN").equals("Netherlands") ||
               countyProp.getString("ADMIN").equals("North Macrdonia") ||
               countyProp.getString("ADMIN").equals("Norway") ||
               countyProp.getString("ADMIN").equals("Poland") ||
               countyProp.getString("ADMIN").equals("Portugal") ||
               countyProp.getString("ADMIN").equals("Romania") ||
               countyProp.getString("ADMIN").equals("Russia") ||
               countyProp.getString("ADMIN").equals("San Marino") ||
               countyProp.getString("ADMIN").equals("Serbia") ||
               countyProp.getString("ADMIN").equals("Slovakia") ||
               countyProp.getString("ADMIN").equals("Slovenia") ||
               countyProp.getString("ADMIN").equals("Spain") ||
               countyProp.getString("ADMIN").equals("Sweden") ||
               countyProp.getString("ADMIN").equals("Switzerland") ||   
               countyProp.getString("ADMIN").equals("Turkey") ||
               countyProp.getString("ADMIN").equals("Ukraine") ||
               countyProp.getString("ADMIN").equals("United Kingdom") ||
               countyProp.getString("ADMIN").equals("Vatican")) {
                 fill(255,255,255); //europejskie kraje na biało
               }
    else{
      fill(0,0,0);
      stroke(0);
      strokeWeight(0.3);
      
    }
    
    println(country.getJSONObject("properties")); // W tym wypadku nazwa kraju przechowywawna jest w polu "ADMIN" - NIE ZAWSZE TAK MUSI BYĆ 
  

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
    float lat = coord.getFloat(1); // Lattitude  - szerokość geograficzna
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

void mousePressed() {
  exit();  //NIE DZIAŁA!!!!
}
