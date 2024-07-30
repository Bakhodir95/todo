import 'dart:convert';
import 'package:todo/models/todo_model.dart';
import 'package:http/http.dart' as http;

class TodoControllers {
  List<Todo> _list = [];
  List<Todo> get list => [..._list];

  Future<List<Todo>> getTodos() async {
    List<Todo> todos = [];
    final data = await http.get(
      Uri.parse('https://todo-2a867-default-rtdb.firebaseio.com/todos.json'),
    );

    if (data.statusCode == 200) {
      Map<String, dynamic>? json = jsonDecode(data.body);

      if (json != null) {
        json.forEach((String key, dynamic value) {
          todos.add(Todo.fromJson(
            key,
            value,
          ));
          print(todos);
        });
      }
    } else {
      throw Exception('Failed to load todos');
    }

    _list = todos;
    return _list;
  }

  Future<void> editIsComplete(Todo todo) async {
    final url = 'https://todo-2a867-default-rtdb.firebaseio.com/todos/${todo.id}.json';
    final response = await http.patch(
      Uri.parse(url),
      body: json.encode({"isComplate": todo.isComplate}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update todo');
    }
  }

  Future<void> editTodo(Todo todo) async {
    final url = 'https://todo-2a867-default-rtdb.firebaseio.com/todos/${todo.id}.json';
    final response = await http.put(
      Uri.parse(url),
      body: json.encode(
        todo.toJson(),
      ),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update todo');
    }
  }

  Future<void> deleteTodo(Todo todo) async {
    final url = 'https://todo-2a867-default-rtdb.firebaseio.com/todos/${todo.id}.json';
    final response = await http.delete(
      Uri.parse(url),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update todo');
    }
  }

  Future<void> addTodo(Todo todo) async {
    const url = 'https://todo-2a867-default-rtdb.firebaseio.com/todos.json';
    final response = await http.post(
      Uri.parse(url),
      body: jsonEncode(
        todo.toJson(),
      ),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update todo');
    }
  }
}
