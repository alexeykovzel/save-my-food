class Product {
  static int idCounter = 0;

  late final int id;
  final String name;
  final DateTime expiresBy;
  final int quantity;

  Product(this.name, {required this.expiresBy, this.quantity = 1}) {
    id = idCounter++;
  }

  int get daysLeft {
    return expiresBy.difference(DateTime.now()).inDays;
  }
}
