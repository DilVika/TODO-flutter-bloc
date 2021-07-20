import 'package:simple_note/data/models/note_list_model.dart';
import 'package:simple_note/data/models/note_model.dart';

abstract class IDataProvider {
  Future<NoteList> fetchNotes(int page, int limit, bool isDesc);
  Future<Note> addNote(Note note);
  Future<Note> editNote(Note note);
  Future<Note> removeNote(String id);
  Future<NoteList> sort(bool isDes);
}
