import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

abstract class FirestoreModel {
  String? id;
  String collection;

  DocumentReference<Map<String, dynamic>>? doc;

  Future<void> fromMap(Map<String, dynamic> data);
  Map<String, dynamic> toMap();

  FirestoreModel({required this.id, required this.collection}) {
    setId(id);
  }

  void setId(String? id) {
    this.id = id;
    // loadData(); // Commented this out to handle async issues with loading feed
  }

  void updateDoc() {
    if (id == null) return;
    FirebaseFirestore db = FirebaseFirestore.instance;
    doc = db.collection(collection).doc(id);
  }

  loadData() async {
    if (id == null) return;
    FirebaseFirestore db = FirebaseFirestore.instance;
    doc = db.collection(collection).doc(id);
    // print("GOT DOC $doc FOR $collection $id");
    DocumentSnapshot<Map<String, dynamic>>? event = await doc?.get();
    Map<String, dynamic> data = event!.data()!;
    await fromMap(data);
    // await doc?.get().then((event) {
    //   Map<String, dynamic> data = event.data()!;
    //   // print("GOT DATA $data");
    //   fromMap(data);
    // });
  }

  create() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    id ??= const Uuid().v4();
    doc = db.collection(collection).doc(id);
    await doc?.get().then((event) {
      if (!event.exists) {
        doc?.set(toMap());
      }
    });
  }
}
