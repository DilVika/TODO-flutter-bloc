part of 'notes_bloc.dart';

@immutable
abstract class NotesState {}

class NotesInitial extends NotesState {}

class NotesFetching extends NotesState {}

class NoteFetched extends NotesState {
  final NoteList? list;

  NoteFetched({this.list});
}

class NoteError extends NotesState {
  final String error;

  NoteError({required this.error});
}
