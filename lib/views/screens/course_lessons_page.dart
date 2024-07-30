import 'package:flutter/material.dart';
import 'package:todo/controllers/lesson_controller.dart';
import 'package:todo/models/course.dart';
import 'package:todo/models/lesson.dart';
import 'package:todo/models/quizes.dart';

class CourseLessonsPage extends StatefulWidget {
  final Course course;
  final Function() mainSetState;

  const CourseLessonsPage({Key? key, required this.course, required this.mainSetState}) : super(key: key);

  @override
  _CourseLessonsPageState createState() => _CourseLessonsPageState();
}

class _CourseLessonsPageState extends State<CourseLessonsPage> {
  final LessonController _lessonController = LessonController();

  void _showAddLessonDialog() async {
    Lesson newLesson = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add New Lesson"),
        content: _buildLessonForm(),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              final quiz = Quiz(id: "id", question: "question", options: ["options"], correctOptionIndex: 1);

              Lesson lesson = Lesson(
                quizes: [quiz],
                id: '', // Generate or leave empty for Firebase to assign
                courseId: widget.course.id,
                title: _lessonTitleController.text,
                description: _lessonDescriptionController.text,
                videoUrl: _lessonVideoUrlController.text,
              );
              Navigator.pop(context, lesson);
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );

    // ignore: unnecessary_null_comparison
    if (newLesson != null) {
      await _lessonController.addLesson(newLesson);
      setState(() {
        widget.mainSetState();
      });
    }
  }

  void _showEditLessonDialog(Lesson lesson) async {
    TextEditingController editLessonTitleController = TextEditingController(text: lesson.title);
    TextEditingController editLessonDescriptionController = TextEditingController(text: lesson.description);
    TextEditingController editLessonVideoUrlController = TextEditingController(text: lesson.videoUrl);

    Lesson updatedLesson = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Edit Lesson"),
        content: _buildLessonForm(
          titleController: editLessonTitleController,
          descriptionController: editLessonDescriptionController,
          videoUrlController: editLessonVideoUrlController,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              final quiz = Quiz(id: "id", question: "question", options: ["options"], correctOptionIndex: 1);
              Lesson editedLesson = Lesson(
                id: lesson.id,
                courseId: lesson.courseId,
                title: editLessonTitleController.text,
                description: editLessonDescriptionController.text,
                videoUrl: editLessonVideoUrlController.text,
                quizes: [quiz],
              );
              Navigator.pop(context, editedLesson);
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );

    // ignore: unnecessary_null_comparison
    if (updatedLesson != null) {
      await _lessonController.editLesson(updatedLesson);
      setState(() {
        widget.mainSetState();
      });
    }
  }

  Widget _buildLessonForm({
    TextEditingController? titleController,
    TextEditingController? descriptionController,
    TextEditingController? videoUrlController,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: titleController ?? _lessonTitleController,
          decoration: const InputDecoration(labelText: "Lesson Title"),
        ),
        TextField(
          controller: descriptionController ?? _lessonDescriptionController,
          decoration: const InputDecoration(labelText: "Lesson Description"),
        ),
        TextField(
          controller: videoUrlController ?? _lessonVideoUrlController,
          decoration: const InputDecoration(labelText: "Video URL"),
        ),
      ],
    );
  }

  final TextEditingController _lessonTitleController = TextEditingController();
  final TextEditingController _lessonDescriptionController = TextEditingController();
  final TextEditingController _lessonVideoUrlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.course.title} Lessons"),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: widget.course.lessons.length,
        itemBuilder: (context, index) {
          final lesson = widget.course.lessons[index];
          return Card(
            child: ListTile(
              onTap: () {},
              title: Text(
                lesson.title,
                style: const TextStyle(fontSize: 25),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () => _showEditLessonDialog(lesson),
                    icon: const Icon(Icons.edit),
                  ),
                  IconButton(
                    onPressed: () async {
                      bool idDelete = await showDialog(
                        barrierDismissible: false,
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text("Delete"),
                          content: const Text(
                            "Are you sure you want to delete this lesson?",
                            style: TextStyle(fontSize: 18),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context, false);
                              },
                              child: const Text("Cancel"),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context, true);
                              },
                              child: const Text("Yes"),
                            ),
                          ],
                        ),
                      );
                      if (idDelete) {
                        await _lessonController.deleteLesson(lesson.id);
                        setState(() {
                          widget.mainSetState();
                        });
                      }
                    },
                    icon: const Icon(Icons.delete),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddLessonDialog,
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    _lessonTitleController.dispose();
    _lessonDescriptionController.dispose();
    _lessonVideoUrlController.dispose();
    super.dispose();
  }
}
