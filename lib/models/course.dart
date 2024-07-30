import 'package:todo/models/lesson.dart';

class Course {
  String id;
  String title;
  String description;
  String imageUrl;
  List<Lesson> lessons;
  bool isLike;
  bool isSave;
  Course({
    required this.id,
    required this.title,
    required this.description,
    required this.lessons,
    required this.imageUrl,
    this.isLike = false,
    this.isSave = false,
  });
}
