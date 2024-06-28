import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uas_ambw/models/note.dart';
import 'package:uas_ambw/screens/detail.dart';

class AddNoteButton extends StatelessWidget {
  const AddNoteButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(
        CupertinoIcons.square_pencil,
        color: Colors.amber,
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return NoteDetail(
                note: Note(
                  id: "",
                  title: "",
                  content: "",
                  isPinned: false,
                  updatedAt: null,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
