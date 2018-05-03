String[] linesFromFile;
String oneLongString;
Table table, myCsv, tableWord, tableCount;
int iterate = 0;

PrintWriter testplik;


void loadStringsIntoString(int num) {
  String fileName = num + ".html";
  String fileLoc  = "E:\\Pawel\\Dokumenty\\facebook-zarembamasuo\\messages";
  if (loadStrings(fileLoc + "\\" + fileName) == null) {
    println("Can't find file " + num + "...");
    saveTable(table, "E:\\workspace_processing\\sketch_015_data\\test2.csv");
    noLoop();
  } else {
    oneLongString = join(loadStrings(fileLoc + "\\" + fileName), "");
    println("Loading file " + num + "...");
  }
}

void makeTable() {
  table = new Table();
  table.addColumn("id");
  table.addColumn("user");
  table.addColumn("date");
  table.addColumn("time");
  table.addColumn("message");

  tableWord = new Table();
  tableWord.addColumn("id");
  tableWord.addColumn("user");
  tableWord.addColumn("date");
  tableWord.addColumn("time");
  tableWord.addColumn("message");

  tableCount = new Table();
  tableCount.addColumn("id");
  tableCount.addColumn("date");
  tableCount.addColumn("number");
}

void seperateMessages(boolean searching) {
  while (true) {
    // początek linii wiadomości
    int subBegin = oneLongString.indexOf("<div class=\"message\">");

    /// jeżeli nie znajdzie początku to kończy przetwarzać plik
    if (subBegin == -1) {
      println("Finishing file");
      break;
    }

    // ucięcie stringa do pierwszej wiadomości
    oneLongString = oneLongString.substring(subBegin);
    int subEnd   = oneLongString.indexOf("</p>") + 4;

    // pomocniczy string od początku stringa do </p>
    String helpString = oneLongString.substring(0, subEnd);

    // wykrywanie innego typu wiadomości (obrazy, pliki, itd) if so, wytnij i continue
    if ((helpString.indexOf("<p><p>") != -1)) {
      oneLongString = oneLongString.substring(subEnd + 4);
      continue;
    }

    // szukanie user w <span class="user">Paweł Zarembski</span>
    int helpBegin = helpString.indexOf("<span class=\"user\">") + 19; // span + 19 znaków
    int helpEnd   = helpString.indexOf("</span>");                    // koniec user
    String user = helpString.substring(helpBegin, helpEnd);           // zapisz string

    // szukanie daty w <span class="meta">27 marca 2018 o 15:01 UTC+02</span>
    helpBegin = helpString.indexOf("<span class=\"meta\">") + 19;
    helpEnd   = helpString.indexOf(" o ");
    String date = helpString.substring(helpBegin, helpEnd);

    // szukanie czasu w <span class="meta">27 marca 2018 o 15:01 UTC+02</span>
    helpBegin = helpString.indexOf(" o ") + 3;
    helpEnd   = helpString.indexOf(" UTC");
    String time = helpString.substring(helpBegin, helpEnd);

    // szukanie wiadomości w <p>o kruci</p>
    helpBegin = helpString.indexOf("<p>") + 3;
    helpEnd   = helpString.indexOf("</p>");
    String message = helpString.substring(helpBegin, helpEnd);

    // zapis do tabeli
    TableRow newRow = table.addRow();
    newRow.setInt(   "id", table.getRowCount());
    newRow.setString("user", user);
    newRow.setString("date", date);
    newRow.setString("time", time);
    newRow.setString("message", message);

    // ucięcie przetworzonej wiadomości
    oneLongString = oneLongString.substring(subEnd);
  }
}

void lookupWord(String user, String word) {
  myCsv = loadTable("E:\\workspace_processing\\sketch_015_data\\test2.csv", "header");
  println("Looking for Word >" + word + "<");
  for (int i = 1; i < myCsv.getRowCount() - 1; i++) {
    TableRow newRow = myCsv.getRow(i);
    String[] imie = match(newRow.getString("user"), user);
    if (imie != null) {
      String[] match = match(newRow.getString("message"), "(K|k)+(R|r)+(U|u)+(C|c)+(i|I)+");
      if (match != null) {
        TableRow newRowWord = tableWord.addRow();
        newRowWord.setInt(   "id", tableWord.getRowCount());
        newRowWord.setString("user", newRow.getString("user"));
        newRowWord.setString("date", newRow.getString("date"));
        newRowWord.setString("time", newRow.getString("time"));
        newRowWord.setString("message", newRow.getString("message"));
      }
    }
  }
  saveTable(tableWord, "E:\\workspace_processing\\sketch_015_data\\test3.csv");
  println("Table tableWord saved");
  noLoop();
}

void countWord() {
  TableRow countRow = tableCount.addRow();
  TableRow wordRow  = tableWord.getRow(0);
  countRow.setInt("id", 1);
  countRow.setString("date", wordRow.getString("date"));
  countRow.setInt("number", 0);
  println(tableCount.getRowCount());

  boolean newDate = false;
  println("Counting started");
  //println("tableWord row Count " + tableWord.getRowCount());  
  for (int i = 0; i < tableWord.getRowCount(); i++) {
    wordRow = tableWord.getRow(i);
    println("tableCount row Count " + tableCount.getRowCount());  
    for (int j = 0; j < tableCount.getRowCount(); j++) {
      countRow = tableCount.getRow(j);
      //println(wordRow.getString("date") + " : " + countRow.getString("date") + " = " + 
      //wordRow.getString("date") == countRow.getString("date"));
      String first = wordRow.getString("date");
      String second = countRow.getString("date");
      String[] match = match(first, second);
      println(first + " : " + second);
      if (match != null) {
        println("Dodano numer");
        countRow.setInt("number", countRow.getInt("number") + 1);
        //println("Numer " + countRow.getInt("number"));
        newDate = false;
        break;
      } else {
        newDate = true;
      }
    }
    if (newDate) {
      println("New Date created " + wordRow.getString("date"));
      countRow = tableCount.addRow();
      countRow.setInt("id", tableCount.getRowCount());
      countRow.setString("date", wordRow.getString("date"));
      countRow.setInt("number", 1);
      println("tableCount row Count " + tableCount.getRowCount());
    }
  }
  saveTable(tableCount, "E:\\workspace_processing\\sketch_015_data\\test4.csv");
}

void setup() {
  makeTable();

  //debug
  //println(linesFromFile[0]);
  //for(int i = 0; i < linesFromFile.length; i++) {
  //  println(linesFromFile[0]);
  //}
  //saveStrings("test.txt", oneLongString);
  //testplik = createWriter("test1.txt");
  //testplik.println(oneLongString);
  //testplik.close();
}

void draw() {
  //loadStringsIntoString(iterate);
  //seperateMessages(true);
  lookupWord("Paweł Zarembski", "kurwa");
  countWord();
  iterate++;
}
