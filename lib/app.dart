import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:save_my_food/features/profile.dart';
import 'package:save_my_food/theme.dart';

import 'features/home.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Profile()),
      ],
      child: MaterialApp(
        restorationScopeId: 'app',

        // Define application color theme
        theme: buildTheme(),

        // Configure application navigation
        routes: {
          '/': (_) => const HomePage(),
        },
      ),
    );
  }
}
