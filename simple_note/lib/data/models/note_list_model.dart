import 'package:simple_note/data/models/note_model.dart';

class NoteList {
  final List<Note> notes;
  int total;

  NoteList({List<Note>? notes, this.total = 0}) : this.notes = notes ?? [];

  factory NoteList.fromJson(Map<String, dynamic> json) {
    List<Note> notes = [];
    json['items'].forEach((noteJson) {
      notes.add(Note.fromJson(noteJson));
    });

    return NoteList(notes: notes, total: json['total']);
  }
}
