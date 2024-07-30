import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo/controllers/favorute_course_controller.dart';
import 'package:todo/models/course.dart';
import 'package:http/http.dart' as http;
import 'package:todo/models/lesson.dart';
import 'package:todo/models/quizes.dart';

class CourseController {
  List<Course> _list = [];
  List<Course> get list => [..._list];

  Future<List<Course>> getCourse() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String userId = sharedPreferences.getString("localId")!;
    List<Course> courses = [];

    final uri = Uri.parse("https://todo-2a867-default-rtdb.firebaseio.com/courses.json");

    final response = await http.get(uri);
    final data = jsonDecode(response.body);

    final favorutes = await FavoriteCourseController.getFavoriteByUserId(userId);
    List<String> curseIds = [];

    if (favorutes != null) {
      final userids = favorutes.values.toList();
      userids.forEach((value) {
        curseIds.add(value['courseId']);
      });
    }

    for (var entry in data.entries) {
      String key = entry.key;
      var value = entry.value;
      bool isLike = curseIds.contains(key);
      List<Lesson> lessons = await getLessonByCourseId(key);

      Course course = Course(
        id: key,
        title: value['title'],
        description: value['description'],
        lessons: lessons,
        imageUrl: value['imageUrl'],
        isLike: isLike,
      );

      courses.add(course);
    }

    _list = courses;
    return courses;
  }

  Future<void> deleteCourse(String id) async {
    final uri = Uri.parse("https://todo-2a867-default-rtdb.firebaseio.com/courses/$id.json");
    final response = await http.delete(uri);

    if (response.statusCode == 200) {
      _list.removeWhere((course) => course.id == id);
    } else {
      throw Exception("Failed to delete course");
    }
  }

  Future<void> updateCourse(Course course) async {
    final uri = Uri.parse("https://todo-2a867-default-rtdb.firebaseio.com/courses/${course.id}.json");
    final response = await http.put(
      uri,
      body: jsonEncode({
        'title': course.title,
        'description': course.description,
        'imageUrl': course.imageUrl,
      }),
    );

    if (response.statusCode == 200) {
      int index = _list.indexWhere((c) => c.id == course.id);
      if (index != -1) {
        _list[index] = course;
      } else {
        _list.add(course);
      }
    } else {
      throw Exception("Failed to update course");
    }
  }

  Future<void> addCourse(Course course) async {
    final uri = Uri.parse("https://todo-2a867-default-rtdb.firebaseio.com/courses.json");
    final response = await http.post(
      uri,
      body: jsonEncode({
        'title': course.title,
        'description': course.description,
        'imageUrl': course.imageUrl,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      course.id = responseData['name'];
      _list.add(course);
    } else {
      throw Exception("Failed to add course");
    }
  }

  Future<List<Lesson>> getLessonByCourseId(String courseId) async {
    List<Lesson> lessons = [];
    final uri = Uri.parse("https://todo-2a867-default-rtdb.firebaseio.com/lessons.json");
    final response = await http.get(uri);
    Map<String, dynamic> datas = jsonDecode(response.body);

    for (var entry in datas.entries) {
      String key = entry.key;
      var value = entry.value;

      if (value['courseId'] == courseId) {
        List<Quiz> quizzes = [];
        if (value['quizes'] != null) {
          for (var quiz in value['quizes']) {
            quizzes.add(
              Quiz(
                id: quiz['id'],
                question: quiz['question'],
                options: List<String>.from(quiz['options']),
                correctOptionIndex: quiz['correctOptionIndex'],
              ),
            );
          }
        }

        Lesson lesson = Lesson(
          id: key,
          courseId: value['courseId'],
          description: value['description'],
          quizes: quizzes,
          title: value['title'],
          videoUrl: value['videoUrl'],
        );

        lessons.add(lesson);
      }
    }

    return lessons;
  }
}
