import 'package:flutter/material.dart';
import 'package:todo/models/course.dart';
import 'package:todo/models/lesson.dart';
import 'package:todo/models/quizes.dart';

class SearchViewDelegate extends SearchDelegate<Course> {
  final List<Course> data;
  SearchViewDelegate(this.data);
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = "";
          },
          icon: const Icon(
            Icons.clear,
          ))
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () {
        close(
            context,
            Course(
                id: "",
                title: "",
                description: "",
                lessons: [
                  Lesson(
                    courseId: "",
                    description: "",
                    id: "",
                    quizes: [
                      Quiz(
                        correctOptionIndex: 1,
                        id: "",
                        options: [""],
                        question: "",
                      ),
                    ],
                    title: "",
                    videoUrl: "",
                  ),
                ],
                imageUrl: ""));
      },
      icon: const Icon(
        Icons.arrow_back,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionList = query.isEmpty
        ? data
        : data.where((element) {
            return element.title.contains(query) || element.description.contains(query);
          }).toList();
    return ListView.builder(
        itemCount: suggestionList.length,
        itemBuilder: (context, index) {
          return ListTile(
            onTap: () {
              close(context, suggestionList[index]);
            },
            title: Text(
              suggestionList[index].title,
            ),
          );
        });
  }
}
