import 'dart:convert';

import 'package:todo/models/lesson.dart';
import 'package:http/http.dart' as http;

class LessonController {
  LessonController();

  List<Lesson> _list = [];

  List<Lesson> get list => [..._list];

  Future<List<Lesson>> getLessons() async {
    List<Lesson> lessons = [];
    final uri = Uri.parse("https://todo-2a867-default-rtdb.firebaseio.com/lessons.json");
    final respons = await http.get(uri);
    Map<String, Map> datas = jsonDecode(respons.body);
    datas.forEach((key, value) {
      final lesson = Lesson(
        id: key,
        courseId: value['curseId'],
        description: value['description'],
        quizes: value['quizes'],
        title: value['title'],
        videoUrl: value['videoUrl'],
      );
      lessons.add(lesson);
    });
    _list = lessons;
    return lessons;
  }

  Future<void> deleteLesson(String id) async {
    final url = Uri.parse("https://todo-2a867-default-rtdb.firebaseio.com/lessons/$id.json");
    await http.delete(url);
  }

  Future<void> addLesson(Lesson lesson) async {
    final url = Uri.parse("https://todo-2a867-default-rtdb.firebaseio.com/lessons.json");

    await http.post(
      url,
      body: jsonEncode(
        {
          "title": lesson.title,
          "courseId": lesson.courseId,
          "description": lesson.description,
          "videoUrl": lesson.videoUrl,
        },
      ),
    );
  }

  Future<void> editLesson(Lesson lesson) async {
    final url = Uri.parse("https://todo-2a867-default-rtdb.firebaseio.com/lessons/${lesson.id}.json");
    await http.put(
      url,
      body: jsonEncode(
        {
          "title": lesson.title,
          "courseId": lesson.courseId,
          "description": lesson.description,
          "videoUrl": lesson.videoUrl,
        },
      ),
    );
  }
}
