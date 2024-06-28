import 'package:flutter/cupertino.dart';
import 'package:uas_ambw/hive.dart';
import 'package:uas_ambw/models/note.dart';

class Notes with ChangeNotifier {
  List<Note> notes = noteBoxes.values.toList() as List<Note>;

  Notes() {
    notes = noteBoxes.values.toList() as List<Note>;
    sort();
  }

  void insertOrUpdate(Note note) {
    noteBoxes.put(note.id, note);
    notes = noteBoxes.values.toList() as List<Note>;
    sort();
    notifyListeners();
  }

  void delete(Note note) {
    noteBoxes.delete(note.id);
    notes = noteBoxes.values.toList() as List<Note>;
    sort();
    notifyListeners();
  }

  void sort({String by = 'updatedAt', bool ascending = false}) {
    notes.sort((a, b) {
      if (a.isPinned && !b.isPinned) {
        return -1; // a should come before b
      } else if (!a.isPinned && b.isPinned) {
        return 1; // a should come after b
      } else {
        return b.updatedAt!
            .compareTo(a.updatedAt!); // a and b are equal in terms of isPinned
      }
    });
    notifyListeners();
  }

  void search(String search) {
    if (search != "") {
      notes = noteBoxes.values
          .where((note) =>
              note.title.toLowerCase().contains(search.toLowerCase()) ||
              note.content.toLowerCase().contains(search.toLowerCase()))
          .toList() as List<Note>;
    } else {
      notes = noteBoxes.values.toList() as List<Note>;
    }

    sort();
    notifyListeners();
  }
}
