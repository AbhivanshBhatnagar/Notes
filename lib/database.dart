import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _collectionReference = _firestore.collection("notes");

class Database {
  static String? UserID;
  static Future<void> addItem(
      {required String Title, required String Description}) async {
    DocumentReference documentReferencer = _collectionReference.doc();
    Map<String, dynamic> data = <String, dynamic>{
      "title": Title,
      "description": Description,
    };
    await documentReferencer
        .set(data)
        .whenComplete(() => Dialog(
              child: Text("Succesfully Added Note"),
            ))
        .catchError((e) => Dialog(
              child: Text("Some Error Occured"),
            ));
  }

  static Stream<QuerySnapshot> readItems() {
    CollectionReference notesItemCollection =
        _collectionReference.doc(UserID).collection("notes");
    return notesItemCollection.snapshots();
  }

  static Future<void> updateItem({
    required String Title,
    required String Description,
    required String docId,
  }) async {
    DocumentReference documentReferencer =
        _collectionReference.doc(docId);

    Map<String, dynamic> data = <String, dynamic>{
      "title": Title,
      "description": Description,
    };

    await documentReferencer
        .update(data)
        .whenComplete(() => print("Note item updated in the database"))
        .catchError((e) => print(e));
  }

  static Future<void> deleteItem({required String docId}) async {
    DocumentReference documentReferencer = _collectionReference.doc(docId);
    await documentReferencer
        .delete()
        .whenComplete(() => Dialog(
              child: Text("Note Deleted Succesfully"),
            ))
        .catchError((e) => print(e));
  }
}
