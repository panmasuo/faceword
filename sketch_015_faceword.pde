String[] linesFromFile;
String oneLongString;
Table table;

PrintWriter testplik;


void loadStringsIntoString() {
  int         num = 219;
  String fileName = num + ".html";
  String fileLoc  = "E:\\Pawel\\Dokumenty\\facebook-zarembamasuo\\messages";
  if (loadStrings(fileLoc + "\\" + fileName) == null) {
    println("Can't find file " + num + "...");
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
    int subEnd   = oneLongString.indexOf("</p>") + 4;

    if (subBegin == -1) {
      println("Finishing file");
      break;
    }

    String helpString = oneLongString.substring(subBegin, subEnd);
    // wykrywanie obrazków
    if ((helpString.indexOf("<p><p>") != -1)) {
      println("Problem w >" + table.getRowCount() + "< linii");
      oneLongString = oneLongString.substring(subEnd + 4);
      continue;
    }

    TableRow newRow = table.addRow();
    newRow.setInt("id", table.getRowCount());
    //println(table.getRowCount() + ":   " + helpString);

    int helpBegin = helpString.indexOf("<span class=\"user\">") + 19;
    int helpEnd   = helpString.indexOf("</span>");
    newRow.setString("user", helpString.substring(helpBegin, helpEnd));
    println(table.getRowCount() + ":   " + table.getString(table.getRowCount()-1, "user"));

    helpBegin = helpString.indexOf("<span class=\"meta\">") + 19;
    helpEnd   = helpString.indexOf(" o ");
    newRow.setString("date", helpString.substring(helpBegin, helpEnd));

    helpBegin = helpString.indexOf(" o ") + 3;
    helpEnd   = helpString.indexOf(" U");
    newRow.setString("time", helpString.substring(helpBegin, helpEnd));

    helpBegin = helpString.indexOf("<p>") + 3;
    helpEnd   = helpString.indexOf("</p>");
    newRow.setString("message", helpString.substring(helpBegin, helpEnd));

    oneLongString = oneLongString.substring(subEnd);
  }
}

void setup() {
  loadStringsIntoString();
  makeTable();
  seperateMessages();

  //debug
  saveTable(table, "E:\\workspace_processing\\sketch_015_data\\test.csv");
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
}
