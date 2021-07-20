part of 'notes_bloc.dart';

@immutable
abstract class NotesEvent {}

class FetchNote extends NotesEvent {
  final int page;
  final int limit;
  final bool? sortOrder;

  FetchNote({this.page = 1, this.limit = 10, this.sortOrder});
}

class AddNote extends NotesEvent {
  final String title;
  final String content;

  AddNote({required this.title, required this.content});
}

class EditNote extends NotesEvent {
  final String id;
  final String? title;
  final String? content;

  EditNote({this.id = "", this.title, this.content});
}

class RemoveNote extends NotesEvent {
  final String id;

  RemoveNote({this.id = ""});
}
