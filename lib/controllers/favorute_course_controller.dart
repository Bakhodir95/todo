import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:todo/models/course.dart';

class FavoriteCourseController {
  addFavoriteCourse(Course course, String userId) async {
    final url = Uri.parse('https://todo-2a867-default-rtdb.firebaseio.com/favourite.json');
    await http.post(url,
        body: jsonEncode({
          "courseId": course.id,
          "userId": userId,
        }));
  }

  deleteFavorite(Course course, String userId) async {
    final response = await http.get(Uri.parse("https://todo-2a867-default-rtdb.firebaseio.com/favourite.json"));
    final data = jsonDecode(response.body);
    String? deleteItem;

    data.forEach((key, value) {
      if (value["courseId"] == course.id && value["userId"] == userId) {
        deleteItem = key;
      }
    });

    if (deleteItem != null) {
      await http.delete(Uri.parse("https://todo-2a867-default-rtdb.firebaseio.com/favourite/$deleteItem.json"));
    } else {
      print("No matching item found for deletion.");
    }
  }

  static getFavoriteByUserId(String userId) async {
    final url = Uri.parse('https://todo-2a867-default-rtdb.firebaseio.com/favourite.json?orderBy="userId"&equalTo="$userId"');
    final response = await http.get(url);
    final data = jsonDecode(response.body);
    return data;
  }
}
