import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  //Get the collection of notes
  final CollectionReference notes =
      FirebaseFirestore.instance.collection('notes');
  //Create: Add a new note
  Future<void> addNote(String note) {
    return notes.add({'note': note, 'timestamp': Timestamp.now()});
  }

  //Read: Get the notes from db
  Stream<QuerySnapshot> getNotesStream() {
    final notesStream =
        notes.orderBy('timestamp', descending: true).snapshots();
    return notesStream;
  }

  //Update: Update the notes
  Future<void> updateNote(String docID, String newNote) {
    return notes.doc(docID).update({
      'note': newNote,
      'timeStamp': Timestamp.now(),
    });
  }

  //Delete: Delete the notes
  Future<void> deleteNote(String docID) {
    return notes.doc(docID).delete();
  }
}
