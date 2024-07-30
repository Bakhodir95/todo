import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:todo/controllers/note_controller.dart';
import 'package:todo/models/note_model.dart';

// ignore: must_be_immutable
class AddNote extends StatefulWidget {
  final Function() setMainState;
  NoteController noteController;

  AddNote({super.key, required this.setMainState, required this.noteController});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  late String noteTitle;
  late String noteContent;
  DateTime? noteDate;

  String? titleError;
  String? contentError;
  late TextEditingController titleController;
  late TextEditingController contentController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController();
    contentController = TextEditingController();
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  void saveTodo() async {
    setState(() {
      titleError = titleController.text.isEmpty ? 'Title cannot be empty' : null;
      contentError = contentController.text.isEmpty ? 'Description cannot be empty' : null;
    });
    print(titleController.text);
    if (titleError == null || contentError == null || noteDate != null) {
      print(titleController.text);

      noteTitle = titleController.text;
      noteContent = contentController.text;
      await widget.noteController.addNote(Note(id: UniqueKey().toString(), title: noteTitle, content: noteContent, createdDate: noteDate!));
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
          controller: contentController,
          decoration: InputDecoration(
            errorText: contentError,
            border: const OutlineInputBorder(),
            hintText: "Description (if any)",
          ),
        ),
        const Gap(16),
        TextButton(
            onPressed: () async {
              noteDate = await showDatePicker(context: context, firstDate: DateTime(2000), lastDate: DateTime(2050));

              setState(() {});
            },
            child: Text(
              noteDate != null ? "${noteDate!.year}-${noteDate!.month.toString().length == 1 ? "0${noteDate!.month.toString()}" : noteDate!.month}-${noteDate!.day}" : "Kun kriting",
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
