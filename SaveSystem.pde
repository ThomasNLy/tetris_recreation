JSONObject saveData;
String saveDataFile = "data/saveData.json";
void InitSaveSystem() {
  saveData = new JSONObject();
}


void saveData(int score) {
  JSONObject data = new JSONObject();
  data.setInt("highscore", score);

  saveJSONObject(data, saveDataFile);
}

JSONObject loadData() {
  JSONObject data;
  try {
    data = loadJSONObject(saveDataFile);
  }
  catch(Exception e) {
    data = new JSONObject();
    data.setInt("highscore", 0);
  }
  return data;
}
