import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:todo/controllers/todo_controllers.dart';
import 'package:todo/models/todo_model.dart';

// ignore: must_be_immutable
class TodoEdit extends StatefulWidget {
  final Todo todo;
  final Function() setMainState;
  TodoControllers todoControllers;

  TodoEdit({super.key, required this.todo, required this.setMainState, required this.todoControllers});

  @override
  State<TodoEdit> createState() => _TodoEditState();
}

class _TodoEditState extends State<TodoEdit> {
  String? titleError;
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
    });

    if (titleError == null) {
      widget.todo.title = titleController.text;
      widget.todo.description = descriptionController.text;
      await widget.todoControllers.editTodo(widget.todo);
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
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Description (if any)",
          ),
        ),
        const Gap(16),
        TextButton(
            onPressed: () async {
              DateTime? date = await showDatePicker(context: context, firstDate: DateTime(2000), lastDate: DateTime(2050));
              if (date != null) {
                widget.todo.date = date;
                setState(() {});
              }
            },
            child: Text(
              "${widget.todo.date.year}-${widget.todo.date.month.toString().length == 1 ? "0${widget.todo.date.month.toString()}" : widget.todo.date.month}-${widget.todo.date.day}",
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
