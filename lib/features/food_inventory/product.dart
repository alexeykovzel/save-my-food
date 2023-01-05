class Product {
  final String name;
  final DateTime expiresBy;
  final int quantity;

  Product(
    this.name, {
    required this.expiresBy,
    this.quantity = 1,
  });

  int get daysLeft {
    return expiresBy.difference(DateTime.now()).inDays;
  }
}
