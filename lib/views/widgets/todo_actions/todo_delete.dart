import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:todo/controllers/todo_controllers.dart';
import 'package:todo/models/todo_model.dart';

// ignore: must_be_immutable
class TodoDelete extends StatelessWidget {
  TodoControllers todoControllers;
  Todo todo;
  Function() setMainState;
  TodoDelete({super.key, required this.todoControllers, required this.todo, required this.setMainState});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text("Haqiqatdan shu todo ni o'shrib yubormoqchimisiz "),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Yo'q"),
            ),
            const Gap(8),
            FilledButton(
              onPressed: () async {
                await todoControllers.deleteTodo(todo);
                setMainState();
                Navigator.pop(context);
              },
              child: const Text("Ha"),
            ),
          ],
        ),
      ],
    );
  }
}
