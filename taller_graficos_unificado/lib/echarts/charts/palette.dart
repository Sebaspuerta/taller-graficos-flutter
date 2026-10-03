// Paletas en hex (Dart puro).

const Map<String, String> statusColors = {
  'Alive': '#4CAF50',
  'Dead': '#F44336',
  'unknown': '#9E9E9E',
};

const Map<String, String> genderColors = {
  'Male': '#2196F3',
  'Female': '#E91E63',
  'Genderless': '#9C27B0',
  'unknown': '#FF9800',
};

const List<String> rainbow = [
  '#F44336', // rojo
  '#FF9800', // naranja
  '#FFEB3B', // amarillo
  '#4CAF50', // verde
  '#00BCD4', // cian
  '#2196F3', // azul
  '#673AB7', // índigo
  '#9C27B0', // violeta
];

const List<String> general = [
  '#5470C6',
  '#91CC75',
  '#FAC858',
  '#EE6666',
  '#73C0DE',
  '#3BA272',
  '#FC8452',
  '#9A60B4',
  '#EA7CCC',
  '#97BF0D',
];

String statusColor(String status) => statusColors[status] ?? '#9E9E9E';
String genderColor(String gender) => genderColors[gender] ?? '#FF9800';
String rainbowAt(int i) => rainbow[i % rainbow.length];
String generalAt(int i) => general[i % general.length];
