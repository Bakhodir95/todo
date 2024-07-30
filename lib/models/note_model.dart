import 'package:json_annotation/json_annotation.dart';

part 'note_model.g.dart';

@JsonSerializable()
class Note {
  String id;
  String title;
  String content;
  DateTime createdDate;
  Note({required this.id, required this.title, required this.content, required this.createdDate});

 factory Note.fromJson(String key, Map<String, dynamic> json) {
    return _$NoteFromJson(key, json);
  }

  Map<String, dynamic> toJson() {
    return _$NoteToJson(this);
  }
}
