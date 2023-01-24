import 'package:flutter/material.dart';
import 'package:save_my_food/theme.dart';

class Product {
  late final int id;
  DateTime expiresBy;
  String name;
  int quantity;

  static int idCounter = 0;
  static String defaultImage =
      'https://cdn-icons-png.flaticon.com/512/5184/5184592.png';

  Product(this.name, {required this.expiresBy, this.quantity = 1}) {
    id = idCounter++;
  }

  static Product byDaysAgo(String name, {required int daysAgo, int? quantity}) {
    return Product(name,
        expiresBy: DateTime.now().add(Duration(days: daysAgo + 1)),
        quantity: quantity ?? 1);
  }

  int get daysLeft => expiresBy.difference(DateTime.now()).inDays;

  String get fullName => '$quantityPlus $name';

  String get daysLeftPlus => daysLeft > 99 ? '99+' : daysLeft.toString();

  String get quantityPlus {
    if (quantity == 1) return '';
    if (quantity > 99) return '99+';
    return quantity.toString();
  }

  String get image {
    String entry = name.toLowerCase();
    for (Category category in Category.values) {
      if (category.contains(entry)) {
        return category.image;
      }
    }
    return defaultImage;
  }

  Color get color {
    if (daysLeft <= 4) return HexColor.pink.get();
    if (daysLeft <= 10) return HexColor.yellow.get();
    return HexColor.green.get();
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
  cheese,
  pizza,
  croissant,
  apple,
  cocktail,
  chips,
}

extension CategoryDetails on Category {
  bool contains(String product) {
    return RegExp(_pattern).hasMatch(product);
  }

  String get _pattern {
    switch (this) {
      case Category.apple:
        return 'apple';
      case Category.fruits:
        return 'fruit|banana|grape|orange|strawberry|avocado|peach|pear';
      case Category.vegetables:
        return 'vegetable|potato|tomato|onion|carrot|lettuce|broccoli|pepper|celery|garlic|cucumber';
      case Category.meat:
        return 'meat|beef|pork|poultry|chicken';
      case Category.fish:
        return 'fish|crab|clam|tuna|salmon|tilapia|shrimp|dolphin';
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
      case Category.cheese:
        return 'cheese';
      case Category.pizza:
        return 'pizza';
      case Category.croissant:
        return 'croissant';
      case Category.cocktail:
        return 'cocktail|smoothi';
      case Category.chips:
        return 'chip|lay\'s|lays';
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
      case Category.cheese:
        return 'https://www.freepnglogos.com/uploads/cheese-png/the-watonga-cheese-festival-fun-for-the-whole-family-0.png';
      case Category.pizza:
        return 'https://images.vexels.com/media/users/3/262561/isolated/preview/d4e8a9986c2b7eb249a5f57b6684615a-food-pizza-meal.png';
      case Category.croissant:
        return 'https://www.freepnglogos.com/uploads/croissant-png/png-croissant-hq-image-28.png';
      case Category.apple:
        return 'https://static.vecteezy.com/system/resources/previews/008/506/545/original/apple-fruit-cartoon-png.png';
      case Category.cocktail:
        return 'https://static.wikia.nocookie.net/clubpenguin/images/a/a2/Smoothie.png/revision/latest/scale-to-width-down/170?cb=20120829042649';
      case Category.chips:
        return 'https://www.freepnglogos.com/uploads/potato-chips-png/potato-chips-utz-quality-foods-american-snack-brand-est-28.png';
    }
  }
}
