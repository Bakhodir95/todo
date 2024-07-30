import 'package:flutter/material.dart';
import 'package:todo/controllers/note_controller.dart';
import 'package:todo/models/note_model.dart';
import 'package:todo/views/widgets/note_actions/add_note.dart';
import 'package:todo/views/widgets/note_actions/note_delete.dart';
import 'package:todo/views/widgets/note_actions/note_edit.dart';

class NotePage extends StatefulWidget {
  const NotePage({super.key});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  NoteController noteController = NoteController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder<List<Note>>(
        future: noteController.getNotes(),
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
              final note = snapshot.data![index];
              return Card(
                child: ListTile(
                  title: Text(
                    note.title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        note.content,
                        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                      ),
                      Text(
                        "${note.createdDate.year}-${note.createdDate.month.toString().padLeft(2, '0')}-${note.createdDate.day.toString().padLeft(2, '0')}",
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
                              content: NoteEdit(
                                note: note,
                                setMainState: () {
                                  setState(() {});
                                },
                                noteControllers: noteController,
                              ),
                            ),
                          );
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
                              content: NoteDelete(
                                noteController: noteController,
                                note: note,
                                setMainState: () {
                                  setState(() {});
                                },
                              ),
                            ),
                          );
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
              content: AddNote(
                setMainState: () {
                  setState(() {});
                },
                noteController: noteController,
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
