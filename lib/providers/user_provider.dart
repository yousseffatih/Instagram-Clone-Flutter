import 'package:flutter/material.dart';
import 'package:insta_flutter_clone/model/user.dart';
import 'package:insta_flutter_clone/resources/auth_methods.dart';

class UserProvider with ChangeNotifier 
{
  User? _user;
  AuthMethods _authMethods = AuthMethods();
  User get getUser => _user!;

  Future<void> refrecheUser () async 
  {
    User user = await _authMethods.getUsersDetails();
    _user = user;
    notifyListeners();
  }
}