String[] linesFromFile;
String oneLongString;
Table table;
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
}

void seperateMessages() {
  while (true) {
    int subBegin = oneLongString.indexOf("<div class=\"message\">");

    if (subBegin == -1) {
      println("Finishing file");
      break;
    }
    
    // przesunięcie stringa do pierwszej wiadomości
    oneLongString = oneLongString.substring(subBegin);
    int subEnd   = oneLongString.indexOf("</p>") + 4;
    //println(subBegin);
    //println(subEnd);

    String helpString = oneLongString.substring(0, subEnd);
    //println(helpString);
    // wykrywanie obrazków
    if ((helpString.indexOf("<p><p>") != -1)) {
      oneLongString = oneLongString.substring(subEnd + 4);
      continue;
    }

    TableRow newRow = table.addRow();
    newRow.setInt("id", table.getRowCount());

    int helpBegin = helpString.indexOf("<span class=\"user\">") + 19;
    int helpEnd   = helpString.indexOf("</span>");
    //println("Help: " + helpBegin);
    //println("Help: " + helpEnd);
    newRow.setString("user", helpString.substring(helpBegin, helpEnd));
    //println(helpString);

    helpBegin = helpString.indexOf("<span class=\"meta\">") + 19;
    helpEnd   = helpString.indexOf(" o ");
    newRow.setString("date", helpString.substring(helpBegin, helpEnd));
    //println(helpString.substring(helpBegin, helpEnd));

    helpBegin = helpString.indexOf(" o ") + 3;
    helpEnd   = helpString.indexOf(" UTC");
    newRow.setString("time", helpString.substring(helpBegin, helpEnd));
    //println(helpString.substring(helpBegin, helpEnd));

    helpBegin = helpString.indexOf("<p>") + 3;
    helpEnd   = helpString.indexOf("</p>");
    newRow.setString("message", helpString.substring(helpBegin, helpEnd));
    //println(helpString.substring(helpBegin, helpEnd));

    oneLongString = oneLongString.substring(subEnd);
  }
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
  loadStringsIntoString(iterate);
  seperateMessages();
  iterate++;
}
