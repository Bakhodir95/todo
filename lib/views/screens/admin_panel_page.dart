import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:todo/controllers/course_controller.dart';
import 'package:todo/models/course.dart';
import 'package:todo/views/screens/course_lessons_page.dart';

class AdminPanelPage extends StatefulWidget {
  final Function() mainSetState;
  const AdminPanelPage({super.key, required this.mainSetState});

  @override
  State<AdminPanelPage> createState() => _AdminPanelPageState();
}

class _AdminPanelPageState extends State<AdminPanelPage> {
  CourseController courseController = CourseController();

  void _showCourseDialog({Course? course}) {
    final isEditing = course != null;
    final titleController = TextEditingController(text: isEditing ? course.title : '');
    final descriptionController = TextEditingController(text: isEditing ? course.description : '');
    final imageUrlController = TextEditingController(text: isEditing ? course.imageUrl : '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEditing ? 'Edit Course' : 'Add Course'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Title'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              TextField(
                controller: imageUrlController,
                decoration: const InputDecoration(labelText: 'Image URL'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final title = titleController.text;
              final description = descriptionController.text;
              final imageUrl = imageUrlController.text;

              if (isEditing) {
                final updatedCourse = Course(
                  id: course.id,
                  title: title,
                  description: description,
                  imageUrl: imageUrl,
                  lessons: course.lessons,
                );
                await courseController.updateCourse(updatedCourse);
              } else {
                final newCourse = Course(
                  id: '',
                  title: title,
                  description: description,
                  imageUrl: imageUrl,
                  lessons: [],
                );
                await courseController.addCourse(newCourse);
              }
              widget.mainSetState();
              setState(() {});
              // ignore: use_build_context_synchronously
              Navigator.pop(context);
            },
            child: Text(isEditing ? 'Update' : 'Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin-Panel"),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: courseController.getCourse(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: Image.asset("assets/gifs/loading.gif"));
          }
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          if (!snapshot.hasData || snapshot.data == null) {
            return const Center(
              child: Text("Malumot yo'q"),
            );
          }
          List<Course> courses = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: courses.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  Card(
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CourseLessonsPage(
                              course: courses[index],
                              mainSetState: () {
                                setState(() {});
                              },
                            ),
                          ),
                        );
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            alignment: Alignment.center,
                            clipBehavior: Clip.hardEdge,
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
                            child: FadeInImage(
                              height: 170,
                              width: double.infinity,
                              placeholder: const AssetImage('assets/gifs/loading2.gif'),
                              image: NetworkImage(
                                courses[index].imageUrl,
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                          const Gap(10),
                          Row(
                            children: [
                              Text(
                                courses[index].title,
                                style: const TextStyle(fontSize: 25),
                              ),
                              const Spacer(),
                              IconButton(
                                onPressed: () {
                                  _showCourseDialog(course: courses[index]);
                                },
                                icon: const Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                ),
                              ),
                              IconButton(
                                onPressed: () async {
                                  final isDelete = await showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: const Text("Delete"),
                                      content: const Text("Haqiqatdan ham shu courseni o'chrib yubormoqchimisiz"),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context, false);
                                          },
                                          child: const Text("Yo'q"),
                                        ),
                                        FilledButton(
                                          onPressed: () {
                                            Navigator.pop(context, true);
                                          },
                                          child: const Text("Ha"),
                                        ),
                                      ],
                                    ),
                                  );
                                  if (isDelete) {
                                    await courseController.deleteCourse(courses[index].id);
                                    setState(() {});
                                  }
                                },
                                icon: const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Gap(20),
                ],
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCourseDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
