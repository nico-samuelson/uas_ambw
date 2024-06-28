import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uas_ambw/notes.dart';
import 'package:uas_ambw/widgets/single_note.dart';

class NoteList extends StatelessWidget {
  const NoteList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Notes>(
      builder: (context, notes, child) {
        return notes.notes.isEmpty
            ? const Center(
                child: Padding(
                  padding: EdgeInsets.only(top: 16.0),
                  child: Text(
                    'No notes',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 20,
                    ),
                  ),
                ),
              )
            : Column(
                children: notes.notes
                    .map(
                      (note) => SingleNote(note: note),
                    )
                    .toList(),
              );
      },
    );
  }
}
