import 'package:json_annotation/json_annotation.dart';

part 'todo_model.g.dart';

@JsonSerializable()
class Todo {
  String id;
  String title;
  String description;
  DateTime date;
  bool isComplate;

  Todo({required this.id, required this.title, required this.description, required this.date, required this.isComplate});

  factory Todo.fromJson(String key, Map<String, dynamic> json) {
    return _$TodoFromJson(key, json);
  }

  Map<String, dynamic> toJson() {
    return _$TodoToJson(this);
  }
}
