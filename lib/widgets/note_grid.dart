import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:uas_ambw/models/note.dart';
import 'package:uas_ambw/notes.dart';
import 'package:uas_ambw/screens/detail.dart';

class NoteGrid extends StatelessWidget {
  const NoteGrid({super.key});

  @override
  Widget build(BuildContext context) {
    Notes notes = Provider.of<Notes>(context);
    final width = MediaQuery.of(context).size.width / 2 - 32;
    final double totalHeight = (width * 1.25) * (notes.notes.length / 2).ceil();

    return SizedBox(
      height: totalHeight,
      child: notes.notes.isNotEmpty
          ? GridView.builder(
              padding: const EdgeInsets.symmetric(vertical: 16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: 1.05),
              physics: const NeverScrollableScrollPhysics(),
              itemCount: notes.notes.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return NoteDetail(
                            note: notes.notes[index],
                          );
                        },
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      Container(
                        height: width * 2 / 3,
                        width: width,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          color: Colors.grey.shade900,
                        ),
                        child: Text(
                          notes.notes[index].content,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 16.0),
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: Text(
                            notes.notes[index].title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Text(
                            DateFormat.yMd().format(
                                notes.notes[index].updatedAt ?? DateTime.now()),
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                          trailing: PopupMenuButton(
                            padding: EdgeInsets.zero,
                            iconSize: 20,
                            elevation: 0,
                            offset: Offset(index.isEven ? -135 : -15, 0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            color: Colors.grey.shade800,
                            position: PopupMenuPosition.over,
                            enableFeedback: false,
                            itemBuilder: (context) {
                              return [
                                PopupMenuItem(
                                  onTap: () {
                                    notes.insertOrUpdate(Note(
                                      id: notes.notes[index].id,
                                      title: notes.notes[index].title,
                                      content: notes.notes[index].content,
                                      isPinned: !notes.notes[index].isPinned,
                                      updatedAt: notes.notes[index].updatedAt,
                                    ));
                                  },
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text("Pin Note"),
                                            const SizedBox(width: 20),
                                            Icon(
                                              notes.notes[index].isPinned
                                                  ? CupertinoIcons.pin_fill
                                                  : CupertinoIcons.pin,
                                              color: Colors.white,
                                              size: 20,
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                PopupMenuItem(
                                  child: const Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          "Delete",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                        SizedBox(width: 20),
                                        Icon(
                                          CupertinoIcons.trash,
                                          color: Colors.red,
                                          size: 20,
                                        ),
                                      ],
                                    ),
                                  ),
                                  onTap: () {
                                    notes.delete(notes.notes[index]);
                                  },
                                ),
                              ];
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            )
          : const Center(
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
            ),
    );
  }
}
