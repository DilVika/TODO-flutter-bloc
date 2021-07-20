import 'dart:convert';
import 'dart:io';

import 'package:simple_note/data/dataproviders/dataprovider.dart';
import 'package:simple_note/data/models/note_list_model.dart';

import 'package:http/http.dart' as http;
import 'package:simple_note/data/models/note_model.dart';

class HttpClientImpl implements IDataProvider {
  final _baseUrl = 'https://60f59fd918254c00176dff97.mockapi.io/api/v1/notes';
  // final _apiKey = '884e1251d026311aa93e48d7057cfcce';
  final header = {"Content-Type": "application/json"};

  @override
  Future<NoteList> fetchNotes(int page, int limit, bool isDesc) async {
    // var url = Uri.parse('$_baseUrl?p=$page&l=$limit');
    var url = Uri.parse('$_baseUrl?sortBy=createdAt&order=desc');

    final res = await http.get(url);
    if (res.statusCode == 200) {
      final jsonData = jsonDecode(res.body);
      return NoteList.fromJson(jsonData);
    } else {
      throw HttpException(res.body);
    }
  }

  @override
  Future<Note> addNote(Note note) async {
    var url = Uri.parse('$_baseUrl');
    print('note: ' + note.title + " " + note.content);
    final jsonData = jsonEncode(note.toJson());
    final res = await http.post(url, body: jsonData, headers: header);
    if (res.statusCode == 200 || res.statusCode == 201) {
      return Note.fromJson(jsonDecode(res.body));
    } else {
      throw HttpException(res.body);
    }
  }

  @override
  Future<Note> editNote(Note note) async {
    final id = note.id;
    var url = Uri.parse('$_baseUrl/$id');
    final jsonData = jsonEncode(note.toJson());
    final res = await http.put(url, body: jsonData, headers: header);
    if (res.statusCode == 200 || res.statusCode == 201) {
      return Note.fromJson(jsonDecode(res.body));
    } else {
      throw HttpException(res.body);
    }
  }

  @override
  Future<Note> removeNote(String id) async {
    var url = Uri.parse('$_baseUrl/$id');

    final res = await http.delete(url, headers: header);
    if (res.statusCode == 200) {
      return Note.fromJson(jsonDecode(res.body));
    } else {
      throw HttpException(res.body);
    }
  }

  @override
  Future<NoteList> sort(bool isDes) async {
    var url;
    if (isDes) {
      url = Uri.parse('$_baseUrl?sortBy=createdAt&order=desc');
    } else {
      url = Uri.parse('$_baseUrl?sortBy=createdAt&order=asc');
    }
    final res = await http.get(url, headers: header);
    if (res.statusCode == 200) {
      final jsonData = jsonDecode(res.body);
      return NoteList.fromJson(jsonData);
    } else {
      throw HttpException(res.body);
    }
  }
}
