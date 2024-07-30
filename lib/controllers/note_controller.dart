import 'package:todo/models/note_model.dart';
import 'package:todo/services/local_database.dart';

class NoteController {
  List<Note> _list = [];
  List<Note> get list => [..._list];
  LocalDatabase localDatabase = LocalDatabase();

  Future<List<Note>> getNotes() async {
    final db = await localDatabase.database;
    List<Note> notes = [];
    List<Map<String, dynamic>> datas = await db.query('notes');

    for (var data in datas) {
      Note notedata = Note(
        id: data['id'].toString(),
        title: data['title'],
        content: data['content'],
        createdDate: DateTime.parse(data['createdDate']),
      );
      notes.add(notedata);
    }
    _list = notes;
    return notes;
  }

  Future<void> editNote(Note note) async {
    await localDatabase.database.then((database) {
      database.update(
          'notes',
          {
            'title': note.title,
            'content': note.content,
            'createdDate': note.createdDate.toString(),
          },
          where: 'id = ? ',
          whereArgs: [note.id]);
    });
  }

  Future<void> deleteNote(Note note) async {
    await localDatabase.database.then((database) {
      database.delete(
        'notes',
        where: 'id = ? ',
        whereArgs: [note.id],
      );
    });
  }

  Future<void> addNote(Note note) async {
    print(note);
    print(note.createdDate);
    await localDatabase.database.then((database) {
      database.insert('notes', {
        'title': note.title,
        'content': note.content,
        'createdDate': note.createdDate.toString(),
      });
    });
  }
}
