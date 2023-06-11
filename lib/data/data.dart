class Data {
  static final Data _instance = Data._();
  Data._();
  factory Data() {
    return _instance;
  }

  List<Map> qrList = [
    {
      "id": 1,
      "description": "Parrilla de Don Pepe",
      "qr":
          "https://www.youtube.com/watch?v=34Na4j8AVgA&list=RDJtH68PJIQLE&index=2"
    },
    {
      "id": 1,
      "description": "Menú de la esquina",
      "qr":
          "https://www.youtube.com/watch?v=34Na4j8AVgA&list=RDJtH68PJIQLE&index=2"
    },
    {
      "id": 1,
      "description": "Alfa, carnes y parrillas",
      "qr":
          "https://www.youtube.com/watch?v=34Na4j8AVgA&list=RDJtH68PJIQLE&index=2"
    },
  ];
}
