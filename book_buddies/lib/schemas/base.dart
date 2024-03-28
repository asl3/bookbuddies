import 'package:cloud_firestore/cloud_firestore.dart';

abstract class BaseSchema {
  DocumentReference<Map<String, dynamic>>? doc;

  BaseSchema({this.doc});

  factory BaseSchema.fromMap(
      Map data, DocumentReference<Map<String, dynamic>>? doc) {
    throw UnimplementedError();
  }

  Map<String, dynamic> toMap() {
    throw UnimplementedError();
  }
}
