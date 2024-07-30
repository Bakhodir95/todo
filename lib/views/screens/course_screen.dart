import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:todo/models/course.dart';
import 'package:todo/views/screens/lesson_page.dart';

// ignore: must_be_immutable
class CourseScreen extends StatelessWidget {
  Course course;
  CourseScreen({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(course.title),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 15,
            right: 15,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                clipBehavior: Clip.hardEdge,
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                ),
                child: FadeInImage(
                  height: double.infinity,
                  width: double.infinity,
                  placeholder: const AssetImage('assets/gifs/loading2.gif'),
                  image: NetworkImage(
                    course.imageUrl,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              const Gap(10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  course.description,
                  style: const TextStyle(
                    fontSize: 18,
                    wordSpacing: 2,
                    letterSpacing: 2,
                  ),
                ),
              ),
              const Text(
                "Lessons",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
              ),
              for (int index = 0; index < course.lessons.length; index++)
                Column(
                  children: [
                    Card(
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LessonPage(
                                lesson: course.lessons[index],
                              ),
                            ),
                          );
                        },
                        title: Text(
                          course.lessons[index].title,
                          style: const TextStyle(fontSize: 20),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios_outlined),
                      ),
                    ),
                    const Gap(20)
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }
}
