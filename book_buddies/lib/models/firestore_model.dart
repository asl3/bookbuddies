import 'package:cloud_firestore/cloud_firestore.dart';
import '../schemas/base.dart';
import 'package:uuid/uuid.dart';

class FirestoreModel<T extends BaseSchema> {
  String? id;
  String collection;
  late T value;
  Function(Map<String, dynamic>, DocumentReference<Map<String, dynamic>>?)
      creator;

  DocumentReference<Map<String, dynamic>>? doc;

  FirestoreModel(
      {required this.id, required this.collection, required this.creator}) {
    if (id == null) return;
    this.id = id;
    this.collection = collection;
    this.creator = creator;
    loadData();
  }

  void setId(String id) {
    this.id = id;
    loadData();
  }

  loadData() {
    if (id == null) return;
    FirebaseFirestore db = FirebaseFirestore.instance;
    doc = db.collection(collection).doc(id);
    doc?.get().then((event) {
      Map<String, dynamic> data = event.data()!;
      value = creator(data, doc);
    });
  }

  createWithMap(Map<String, dynamic> map) async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    id = const Uuid().v4();
    doc = db.collection(collection).doc(id);
    await doc?.get().then((event) {
      if (!event.exists) {
        doc?.set(map);
      }
    });
    value.doc = doc;
  }

  create() async {
    throw UnimplementedError();
  }
}
