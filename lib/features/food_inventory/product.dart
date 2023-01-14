class Product {
  late final int id;
  final DateTime expiresBy;
  final String? image;
  final String name;
  final int quantity;

  static int idCounter = 0;

  Product(
    this.name, {
    required this.expiresBy,
    this.quantity = 1,
    this.image,
  }) {
    id = idCounter++;
  }

  int get daysLeft {
    return expiresBy.difference(DateTime.now()).inDays;
  }
}
