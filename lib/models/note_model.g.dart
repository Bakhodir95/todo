// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'note_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Note _$NoteFromJson(String key, Map<String, dynamic> json) => Note(
      id: key,
      title: json['title'] as String,
      content: json['content'] as String,
      createdDate: DateTime.parse(json['createdDate'] as String),
    );

Map<String, dynamic> _$NoteToJson(Note instance) => <String, dynamic>{
      'title': instance.title,
      'content': instance.content,
      'createdDate': instance.createdDate.toIso8601String(),
    };
