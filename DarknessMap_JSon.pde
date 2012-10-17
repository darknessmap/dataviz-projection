import org.json.*;

ArrayList darknessLines;
ArrayList values;

String baseURL="http://178.79.145.84:8080/api/darkness";


void setup() {
  size(400, 600, P2D);
  //present mode - set background color to black
  background(0);

  darknessLines = new ArrayList();
  values = new ArrayList();
  //String data[] = loadStrings(filename);
  //darknessVals = new float [data.length-1];

  //getJsonData(); 
  getData(); 
  smooth();

  for (int i = values.size()-1 ; i > 0; i--) {
    float strkd = (Float)(values.get(i));
    darknessLines.add(new DataLine(strkd, i));
    println(i);
  }

  for (int i = darknessLines.size()-1; i > 0; i--) {
    DataLine d = (DataLine) darknessLines.get(i);
    d.render();
  }
}

void draw() {
  //getData();
  /*
  for(int i = 0; i < values.size(); i++) {
   float strkd = (Float)(values.get(i));
   darknessLines.add(new DataLine(strkd, width));
   }
   */
  for (int i = darknessLines.size()-1; i > 0; i--) {
    DataLine d = (DataLine) darknessLines.get(i);
    d.render();
    d.update();  

    //    if (d.x1 <= 0) {
    //      darknessLines.remove(0);
    //    }
    if (darknessLines.size() > width*1.25) {
      darknessLines.remove(0);
    }
    println("DarknessLines Size: " + darknessLines.size());
  }
}

void getJsonData() {
  String request = baseURL + "?query=payload";
  println("Sending query to Darkness Map API");
  String result = join(loadStrings(request), "");
  println( result );

  try {
    JSONObject payload = new JSONObject(result);
    JSONArray responses = payload.getJSONArray("payload");
    println(responses);
    for (int i = 0; i < responses.length(); i++) {
      JSONObject obj = (JSONObject) responses.get(i);
    }
  } 
  catch(JSONException e) {
    println("There was an error parsing the JSON Object.");
  }
}

void getData() {
  String request = baseURL + "?query=payload";
  String result = join(loadStrings(request), "");
  //println(result);

  try {
    JSONArray darknessAPI = new JSONArray(join(loadStrings(request), ""));
    for (int i = 0; i < darknessAPI.length(); i++) {
      JSONObject obj = (JSONObject) darknessAPI.get(i);
      int tempPayload = (int)(obj.getLong("payload"));
      //println(obj.getString("payload"));
      println(tempPayload);
      //values.add(new PVector(tempPayload, 0 , 0));
      values.add(new Float(tempPayload));
    }
    println("Values Size: "+ values.size());
  }
  catch(JSONException e) {
    println("There was an error parsing the JSON Object.");
  }
}


class DataLine {
  float value; //grayscale stroke
  float x1, y1, x2, y2;

  DataLine( float _value, float _x1) {
    value = _value;
    x1 = _x1;
    y1 = 0;
    x2 = _x1;
    y2 = height;
  }

  void render() {
    stroke(value);
    strokeWeight(2);
    line(x1, y1, x1, y2);
  }

  void update() {
    x1--;

    if (x1 < 0) {
      x1 = width;
    }
  }
}

