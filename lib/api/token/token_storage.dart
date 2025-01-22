import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class TokenStorage {
  late SharedPreferences prefs;

  TokenStorage();

  Future<void> save(String token) async {
    prefs = await SharedPreferences.getInstance();
    prefs.setString("token", token);
  }

  Future<String?> read() async {
    prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  Future<void> delete() async {
    prefs = await SharedPreferences.getInstance();
    await prefs.remove("token");
  }
}