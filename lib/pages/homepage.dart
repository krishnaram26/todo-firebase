import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo/services/firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirestoreService firestoreService = FirestoreService();
  final TextEditingController textEditingController = TextEditingController();

  void openNoteBox({String? docID}) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: Colors.black,
              title: Text(
                'Add',
                style: TextStyle(color: Colors.white),
              ),
              content: TextField(
                controller: textEditingController,
                style: TextStyle(color: Colors.white),
              ),
              actions: [
                ElevatedButton(
                    onPressed: () {
                      if (docID == null) {
                        firestoreService.addNote(textEditingController.text);
                      } else {
                        firestoreService.updateNote(
                            docID, textEditingController.text);
                      }
                      textEditingController.clear();

                      Navigator.pop(context);
                    },
                    child: Text("Add", style: TextStyle(color: Colors.black)))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Toodoo',
          style: TextStyle(color: Colors.white), // Text color
        ),
        backgroundColor: Colors.black, // Background color
        elevation: 0, // No shadow
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.white), // Icon color
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: openNoteBox,
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getNotesStream(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List notesList = snapshot.data!.docs;

            return ListView.builder(
                itemCount: notesList.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot document = notesList[index];
                  String docID = document.id;
                  Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;
                  String noteText = data['note'];
                  return Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(12.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 3,
                            blurRadius: 7,
                            offset: Offset(0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                      child: ListTile(
                          // Set the background color of the ListTile
                          title: Text(noteText,
                              style: TextStyle(color: Colors.white)),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: () => openNoteBox(docID: docID),
                                icon:
                                    const Icon(Icons.edit, color: Colors.white),
                              ),
                              IconButton(
                                onPressed: () =>
                                    firestoreService.deleteNote(docID),
                                icon: const Icon(Icons.delete,
                                    color: Colors.white),
                              ),
                            ],
                          )),
                    ),
                  );
                });
          } else {
            return const Text("No notes...");
          }
        },
      ),
    );
  }
}
