import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:simple_note/data/dataproviders/dataprovider.dart';
import 'package:simple_note/data/models/note_list_model.dart';
import 'package:simple_note/data/models/note_model.dart';

part 'notes_event.dart';
part 'notes_state.dart';

class NotesBloc extends Bloc<NotesEvent, NotesState> {
  NotesBloc(IDataProvider dataSrc)
      : this._dataSrc = dataSrc,
        super(NotesInitial());

  IDataProvider _dataSrc;
  NoteList list = NoteList();

  @override
  Stream<NotesState> mapEventToState(
    NotesEvent event,
  ) async* {
    try {
      if (event is FetchNote) {
        yield NotesFetching();
        final res = await _dataSrc.fetchNotes(
            event.page, event.limit, event.sortOrder ?? true);
        this.list.notes.clear();
        this.list.notes.addAll(res.notes);
        this.list.total = this.list.notes.length;
      } else if (event is AddNote) {
        final res =
            await _dataSrc.addNote(Note.create(event.title, event.content));
        this.list.notes.add(res);
        this.list.total = this.list.notes.length;
      } else if (event is EditNote) {
        final res = await _dataSrc.editNote(
            Note.edit(event.id, event.title ?? "", event.content ?? ""));
        this.list.notes.removeWhere((note) => note.id == res.id);
        this.list.notes.add(res);
        this.list.total = this.list.notes.length;
      } else if (event is RemoveNote) {
        final res = await _dataSrc.removeNote(event.id);
        this.list.notes.removeWhere((note) => note.id == res.id);
        this.list.total = this.list.notes.length;
      }
      yield NoteFetched(list: list);
    } catch (err) {
      yield NoteError(error: err.toString());
    }
  }
}
