import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/models/user.dart';

class UserController {
  User _user = User();
  User get user => _user;

  saveUser(User user) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("userName", user.name!);
    await prefs.setString("userSurname", user.surname!);
    await prefs.setString('userphoneNumber', user.phoneNumber!);
    await prefs.setString("userimageUri", user.imageUri!);
  }

  getUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _user.name = prefs.getString('userName') ?? "";
    _user.surname = prefs.getString('userName') ?? "";
    _user.phoneNumber = prefs.getString("userphoneNumber") ?? "";
    _user.imageUri = prefs.getString("userimageUri") ?? "";
  }
}
