import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uas_ambw/models/note.dart';
import 'package:uas_ambw/notes.dart';
import 'package:uuid/uuid.dart';

class NoteDetail extends StatefulWidget {
  final Note note;
  NoteDetail({super.key, required this.note});

  @override
  State<NoteDetail> createState() => _NoteDetailState();
}

class _NoteDetailState extends State<NoteDetail> {
  late TextEditingController titleController = TextEditingController();
  late TextEditingController contentController = TextEditingController();
  bool isPinned = false;

  @override
  void initState() {
    isPinned = widget.note.isPinned;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final notes = Provider.of<Notes>(context);

    titleController.text = widget.note.title;
    contentController.text = widget.note.content;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          backgroundColor: Colors.black,
          leading: Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: GestureDetector(
              onTap: () {
                // only save note when there is a title and content
                if (contentController.text != "" &&
                    titleController.text != "") {
                  var id =
                      widget.note.id != "" ? widget.note.id : const Uuid().v4();

                  notes.insertOrUpdate(
                    Note(
                      id: id,
                      title: titleController.text,
                      content: contentController.text,
                      isPinned: isPinned,
                      createdAt: widget.note.createdAt ?? DateTime.now(),
                      updatedAt: DateTime.now(),
                    ),
                  );
                }

                Navigator.pop(context);
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    CupertinoIcons.back,
                    color: Colors.amber,
                  ),
                  Text(
                    "Notes",
                    style: TextStyle(color: Colors.amber, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          leadingWidth: 100,
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 12, right: 12),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        isPinned = !isPinned;
                      });
                    },
                    icon: Icon(
                      isPinned == true
                          ? CupertinoIcons.pin_fill
                          : CupertinoIcons.pin,
                      color: Colors.amber,
                      size: 20,
                    ),
                  ),
                ),
              ],
            )
          ]),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(children: [
          if (widget.note.updatedAt != null)
            Center(
              child: Text(
                "Last updated ${DateFormat.yMd().format(widget.note.updatedAt ?? DateTime.now())} at ${widget.note.updatedAt?.hour}:${widget.note.updatedAt?.minute}",
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
            ),
          if (widget.note.updatedAt != null) const SizedBox(height: 20),
          TextField(
            controller: titleController,
            autofocus: true,
            cursorColor: Colors.amber,
            maxLines: null,
            autocorrect: false,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              hintText: "Title",
              hintStyle: TextStyle(color: Colors.grey.shade600),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(10),
            ),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            onChanged: (value) => widget.note.title = value,
          ),
          TextField(
            controller: contentController,
            autofocus: false,
            cursorColor: Colors.amber,
            maxLines: null,
            autocorrect: false,
            decoration: InputDecoration(
              hintText: "Content",
              hintStyle: TextStyle(color: Colors.grey.shade600),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 10,
                vertical: 10,
              ),
            ),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
            onChanged: (value) => widget.note.content = value,
          ),
        ]),
      ),
    );
  }
}
