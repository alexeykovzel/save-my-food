class Product {
  late final int id;
  DateTime expiresBy;
  String name;
  int quantity;

  static int idCounter = 0;

  Product(this.name, {required this.expiresBy, this.quantity = 1}) {
    id = idCounter++;
  }

  int get daysLeft {
    return expiresBy.difference(DateTime.now()).inDays;
  }

  String? get image {
    String entry = name.toLowerCase();
    for (Category category in Category.values) {
      if (category.contains(entry)) {
        return category.image;
      }
    }
    return null;
  }
}

enum Category {
  fruits,
  vegetables,
  meat,
  fish,
  snacks,
  bread,
  beverages,
  cereal,
  soup,
}

extension CategoryDetails on Category {
  bool contains(String product) {
    return RegExp(_pattern).hasMatch(product);
  }

  String get _pattern {
    switch (this) {
      case Category.fruits:
        return 'fruit|banana|grape|orange|strawberry|avocado|peach|pear';
      case Category.vegetables:
        return 'vegetable|potato|tomato|onion|carrot|lettuce|broccoli|pepper|celery|garlic|cucumber';
      case Category.meat:
        return 'meat|beef|pork|poultry|chicken';
      case Category.fish:
        return 'fish|crab|clam|tuna|salmon|tilapia|shrimp';
      case Category.snacks:
        return 'snack|nutella|chips|popcorn|peanut|candy';
      case Category.bread:
        return 'bread';
      case Category.beverages:
        return 'beverage|water';
      case Category.cereal:
        return 'cereal|oat|rice|wheat|granola';
      case Category.soup:
        return 'soup';
    }
  }

  String get image {
    switch (this) {
      case Category.fruits:
        return 'https://www.freepnglogos.com/uploads/banana-png/banana-vector-graphic-bananas-yellow-tropical-fruits-18.png';
      case Category.vegetables:
        return 'https://www.freepnglogos.com/uploads/eggplant-png/pack-slim-eggplant-emoji-build-head-0.png';
      case Category.meat:
        return 'https://www.freepnglogos.com/uploads/bone-png/bone-cartoon-meat-launching-soon-tropes-15.png';
      case Category.fish:
        return 'https://www.freepnglogos.com/uploads/dolphin-png/dolphin-icon-download-icons-18.png';
      case Category.snacks:
        return 'https://www.freepnglogos.com/uploads/candy-cane/image-giant-candy-cane-club-penguin-wiki-the-20.PNG';
      case Category.bread:
        return 'https://www.freepnglogos.com/uploads/bread-png/bread-slice-bakery-image-pixabay-33.png';
      case Category.beverages:
        return 'https://www.freepnglogos.com/uploads/water-bottle-png/download-water-bottle-png-transparent-image-and-clipart-28.png';
      case Category.cereal:
        return 'https://www.freepnglogos.com/uploads/rice-png/chinese-rice-and-chopsticks-best-web-clipart-18.png';
      case Category.soup:
        return 'https://www.freepnglogos.com/uploads/noodles-png/noodles-icon-noodles-icons-softiconsm-14.png';
    }
  }
}
