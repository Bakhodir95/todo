import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:todo/controllers/note_controller.dart';
import 'package:todo/models/note_model.dart';

// ignore: must_be_immutable
class NoteDelete extends StatelessWidget {
  NoteController noteController;
  Note note;
  Function() setMainState;
  NoteDelete({super.key, required this.noteController, required this.note, required this.setMainState});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text("Haqiqatdan shu note ni o'chrib yubormoqchimisiz "),
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
                await noteController.deleteNote(note);
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
