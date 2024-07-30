import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:todo/controllers/todo_controllers.dart';
import 'package:todo/models/todo_model.dart';

// ignore: must_be_immutable
class AddTodo extends StatefulWidget {
  final Function() setMainState;
  TodoControllers todoControllers;

  AddTodo({super.key, required this.setMainState, required this.todoControllers});

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  late String todoTitle;
  late String todoDiscription;
  DateTime? todoDate;

  String? titleError;
  String? discriptionError;
  late TextEditingController titleController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    descriptionController = TextEditingController();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void saveTodo() async {
    setState(() {
      titleError = titleController.text.isEmpty ? 'Title cannot be empty' : null;
      discriptionError = descriptionController.text.isEmpty ? 'Description cannot be empty' : null;
    });

    if (titleError == null || discriptionError == null || todoDate != null) {
      print(todoDate);
      todoTitle = titleController.text;
      todoDiscription = descriptionController.text;
      await widget.todoControllers.addTodo(Todo(id: UniqueKey().toString(), title: todoTitle, description: todoDiscription, date: todoDate!, isComplate: false));

      widget.setMainState();
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextFormField(
          controller: titleController,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            hintText: "Title",
            errorText: titleError,
          ),
        ),
        const Gap(8),
        TextFormField(
          controller: descriptionController,
          decoration: InputDecoration(
            errorText: discriptionError,
            border: OutlineInputBorder(),
            hintText: "Description (if any)",
          ),
        ),
        const Gap(16),
        TextButton(
            onPressed: () async {
              todoDate = await showDatePicker(context: context, firstDate: DateTime(2000), lastDate: DateTime(2050));

              setState(() {});
            },
            child: Text(
              todoDate != null ? "${todoDate!.year}-${todoDate!.month.toString().length == 1 ? "0${todoDate!.month.toString()}" : todoDate!.month}-${todoDate!.day}" : "Kun kriting",
            )),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            const Gap(8),
            FilledButton(
              onPressed: saveTodo,
              child: const Text("Save"),
            ),
          ],
        ),
      ],
    );
  }
}
