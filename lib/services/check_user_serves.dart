import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CheckUserServes {
  static const String _baseUrl = "https://identitytoolkit.googleapis.com/v1/accounts";
  static const String _apiKey = "AIzaSyB1lxLNMlOZ7x05tU2TrdUyiFNZ_Elpp0Q";

  Future<Map<String, dynamic>> register(String email, String password, String qure) async {
    final url = Uri.parse("$_baseUrl:$qure?key=$_apiKey");

    try {
      final response = await http.post(
        url,
        body: jsonEncode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );

      if (response.statusCode != 200) {
        return {'error': 'Request failed with status: ${response.statusCode}'};
      }

      final data = jsonDecode(response.body) as Map<String, dynamic>;

      if (data['error'] != null) {
        return data['error'] as Map<String, dynamic>;
      }

      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      await sharedPreferences.setString("token", data["idToken"]);
      await sharedPreferences.setString("localId", data["localId"]);
      await sharedPreferences.setString(
          "tokenTime",
          DateTime.now()
              .add(
                Duration(
                  seconds: int.parse(data['expiresIn']),
                ),
              )
              .toString());

      return data;
    } catch (error) {
      return {'error': '$error'};
    }
  }
}
