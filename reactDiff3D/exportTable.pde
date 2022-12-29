Table table;

void initTable() {
  table = new Table();

  table.addColumn("posX");
  table.addColumn("posY");
  table.addColumn("posZ");
  table.addColumn("level");
}

void exportTable() {

  for (int x = 0; x < cols; x++) {
    for (int y = 0; y < rows; y++) {
      for (int z = 0; z < zAxis; z++) {
        float sumA = array3D[x][y][z][0];
        float sumB = array3D[x][y][z][1];
        float level = sumA - sumB;

        if (level < isoLevel) {
          TableRow newRow = table.addRow();
          newRow.setInt("posX", x);
          newRow.setInt("posY", y);
          newRow.setInt("posZ", z);
          newRow.setFloat("level", level);
        }
      }
    }
  }

  saveTable(table, "src/new.csv");
}
