import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../_models/user_model.dart';
import '../_services/api_service.dart';
import '../_utils/constants.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = false;

  User? get user => _user;
  bool get isLoading => _isLoading;

  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> login(String email, String password) async {
    setLoading(true);
    try {
      final response = await ApiService.login(email, password);
      if (response != null) {
        _user = response;
        await _saveUserToPreferences(response);
        notifyListeners();
      }
    } catch (e) {
      // Handle error (show a dialog, etc.)
      print(e);
    } finally {
      setLoading(false);
    }
  }

  Future<void> logout() async {
    _user = null;
    await _clearUserFromPreferences();
    notifyListeners();
  }

  Future<void> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(Constants.userKey)) return;

    final extractedUserData = json.decode(prefs.getString(Constants.userKey)!)
        as Map<String, dynamic>;
    _user = User.fromJson(extractedUserData);

    notifyListeners();
  }

  Future<void> _saveUserToPreferences(User user) async {
    final prefs = await SharedPreferences.getInstance();
    final userData = json.encode(user.toJson());
    prefs.setString(Constants.userKey, userData);
  }

  Future<void> _clearUserFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(Constants.userKey);
  }
}
