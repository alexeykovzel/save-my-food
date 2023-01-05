import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:save_my_food/theme.dart';

import 'features/home.dart';
import 'features/food_inventory/saved_products.dart';
import 'features/settings/settings.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SavedProducts()),
        ChangeNotifierProvider(create: (_) => Settings()),
      ],
      child: MaterialApp(
        restorationScopeId: 'app',

        // Define application color theme
        theme: buildTheme(),

        // Configure application navigation
        routes: {
          HomePage.route: (_) => const HomePage(),
        },
      ),
    );
  }
}
