import 'package:todo/models/quizes.dart';

class Lesson {
  String id;
  String courseId;
  String title;
  String description;
  String videoUrl;
  List<Quiz> quizes;
  Lesson({
    required this.id,
    required this.courseId,
    required this.description,
    required this.quizes,
    required this.title,
    required this.videoUrl,
  });
}
