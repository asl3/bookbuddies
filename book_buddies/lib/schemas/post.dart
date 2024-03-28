import 'base.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Post extends BaseSchema {
  String messageType;
  DateTime time;
  List<String> likers = [];

  Post(
      {required this.messageType,
      required this.time,
      required this.likers,
      super.doc});

  factory Post.fromMap(
      Map<String, dynamic> data, DocumentReference<Map<String, dynamic>>? doc) {
    String messageType = data["messageType"];
    DateTime time = data["time"].toDate();

    List<String> likers = [];
    for (String liker in data["likers"]) {
      likers.add(liker);
    }

    return Post(messageType: messageType, time: time, likers: likers, doc: doc);
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      "messageType": messageType,
      "time": Timestamp.fromDate(time),
      "likers": likers,
    };
  }
}
