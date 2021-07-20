import 'package:simple_note/ultis/time_ultis.dart';
import 'package:uuid/uuid.dart';

class Note {
  String id;
  String title;
  String content;
  DateTime date;

  Note(
      {required this.id,
      required this.title,
      required this.content,
      required this.date});

  factory Note.create(String title, String content) {
    final date = DateTime.now();
    return Note(id: "", title: title, content: content, date: date);
  }

  factory Note.edit(String id, String title, String content) {
    final date = DateTime.now();
    return Note(id: id, title: title, content: content, date: date);
  }

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
        id: json['id'],
        title: json['title'],
        content: json['content'],
        date: readTimeStamp(json['createdAt']));
  }

  Map<String, dynamic> toJson() => {
        'title': this.title,
        'content': this.content,
        'createdAt': int.parse(writeTimeStamp(this.date))
      };
}
