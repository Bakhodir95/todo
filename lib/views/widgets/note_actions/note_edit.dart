import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:todo/controllers/note_controller.dart';
import 'package:todo/models/note_model.dart';

// ignore: must_be_immutable
class NoteEdit extends StatefulWidget {
  final Note note;
  final Function() setMainState;
  NoteController noteControllers;

  NoteEdit({super.key, required this.note, required this.setMainState, required this.noteControllers,});

  @override
  State<NoteEdit> createState() => _NoteEditState();
}

class _NoteEditState extends State<NoteEdit> {
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
      widget.note.title = titleController.text;
      widget.note.content = descriptionController.text;
      await widget.noteControllers.editNote(widget.note);
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
            hintText: "Content (if any)",
          ),
        ),
        const Gap(16),
        TextButton(
            onPressed: () async {
              DateTime? date = await showDatePicker(context: context, firstDate: DateTime(2000), lastDate: DateTime(2050));
              if (date != null) {
                widget.note.createdDate = date;
                setState(() {});
              }
            },
            child: Text(
              "${widget.note.createdDate.year}-${widget.note.createdDate.month.toString().length == 1 ? "0${widget.note.createdDate.month.toString()}" : widget.note.createdDate.month}-${widget.note.createdDate.day}",
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
