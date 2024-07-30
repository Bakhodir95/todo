import 'package:flutter/material.dart';
import 'package:todo/controllers/todo_controllers.dart';
import 'package:todo/models/todo_model.dart';
import 'package:todo/views/widgets/todo_actions/add_todo.dart';
import 'package:todo/views/widgets/todo_actions/todo_delete.dart';
import 'package:todo/views/widgets/todo_actions/todo_edit.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  TodoControllers todoControllers = TodoControllers();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<List<Todo>>(
        future: todoControllers.getTodos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text("Malumot olishda xato"),
            );
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text("Malumot yo'q"),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final todo = snapshot.data![index];
              return Card(
                child: ListTile(
                  leading: Checkbox(
                    value: todo.isComplate,
                    onChanged: (value) async {
                      todo.isComplate = !todo.isComplate;
                      await todoControllers.editIsComplete(todo);
                      setState(() {});
                    },
                  ),
                  title: Text(
                    todo.title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        todo.description,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                      ),
                      Text(
                        "${todo.date.year}-${todo.date.month.toString().length == 1 ? "0${todo.date.month.toString()}" : todo.date.month}-${todo.date.day}",
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    content: TodoEdit(
                                      todo: todo,
                                      setMainState: () {
                                        setState(() {});
                                      },
                                      todoControllers: todoControllers,
                                    ),
                                  ));
                        },
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.blue,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                    content: TodoDelete(
                                      todoControllers: todoControllers,
                                      todo: todo,
                                      setMainState: () {
                                        setState(() {});
                                      },
                                    ),
                                  ));
                        },
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              content: AddTodo(
                setMainState: () {
                  setState(() {});
                },
                todoControllers: todoControllers,
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
