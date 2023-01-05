import 'package:flutter/cupertino.dart';

class Settings with ChangeNotifier {
  bool deleteExpired = true;
  bool notifyUser = false;
  int notifyAfterDays = 4;
  int notifyAtHour = 3;
}
