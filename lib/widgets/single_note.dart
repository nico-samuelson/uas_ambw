import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uas_ambw/models/note.dart';
import 'package:uas_ambw/notes.dart';
import 'package:uas_ambw/screens/detail.dart';

class SingleNote extends StatelessWidget {
  final Note note;

  const SingleNote({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    final notes = Provider.of<Notes>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Dismissible(
        direction: DismissDirection.endToStart,
        key: Key(note.id),
        background: Container(
          alignment: Alignment.centerRight,
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(
              CupertinoIcons.trash,
              color: Colors.white,
            ),
          ),
        ),
        onDismissed: (direction) {
          notes.delete(note);
        },
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return NoteDetail(
                    note: note,
                  );
                },
              ),
            );
          },
          child: ListTile(
            tileColor: Colors.grey.shade900,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            title: Text(
              note.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
            subtitle: Text(
              note.content,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
              ),
            ),
            leading: IconButton(
              onPressed: () {
                notes.insertOrUpdate(
                  Note(
                    id: note.id,
                    title: note.title,
                    content: note.content,
                    isPinned: !note.isPinned,
                    updatedAt: note.updatedAt,
                  ),
                );
                notes.sort();
              },
              icon: Icon(
                note.isPinned ? CupertinoIcons.pin_fill : CupertinoIcons.pin,
                color: Colors.amber,
                size: 20,
              ),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  DateFormat.yMd().format(
                    note.updatedAt ?? DateTime.now(),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
