import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class Note extends ChangeNotifier {
  final String noteId = const Uuid().v4();
  String title;
  String text;
  DateTime updatedAt;

  Note(this.title, this.text, this.updatedAt);

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(json['title'], json['text'],
        DateTime.parse(json['updatedAt']));
  }

  void editNote(String title, String text) {
    this.title = title;
    this.text = text;
    updatedAt = DateTime.now();
    notifyListeners();
  }
}
