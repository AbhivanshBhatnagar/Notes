import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:notes/database.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

final FirebaseFirestore _firestore = FirebaseFirestore.instance;
final CollectionReference _collectionReference = _firestore.collection("notes");
TextEditingController titleController = TextEditingController();
TextEditingController descrptionController = TextEditingController();

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Padding(
                      padding: EdgeInsets.all(15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text("Add new Note"),
                          SizedBox(
                            height: 50,
                          ),
                          TextField(
                              controller: titleController,
                              clipBehavior: Clip.none,
                              decoration: InputDecoration(
                                hintText: "Title",
                              )),
                          SizedBox(
                            height: 50,
                          ),
                          TextField(
                              controller: descrptionController,
                              clipBehavior: Clip.none,
                              decoration: InputDecoration(
                                hintText: "Description",
                              )),
                          SizedBox(
                            height: 50,
                          ),
                          ElevatedButton(
                              onPressed: () async {
                                Database.addItem(
                                    Title: titleController.text,
                                    Description: descrptionController.text);
                              },
                              child: Text("Add Note")),
                          SizedBox(
                            height: 50,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              });
          ;
        },
        child: Icon(Icons.add),
      ),
      body: StreamBuilder(
        stream: _collectionReference.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          if (streamSnapshot.hasData) {
            return ListView.builder(
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: ((context, index) {
                  final DocumentSnapshot documentSnapshot =
                      streamSnapshot.data!.docs[index];

                  return Card(
                    margin: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        ListTile(
                          title: Text(documentSnapshot['title']),
                          subtitle: Text(documentSnapshot['description']),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                                onPressed: () {
                                  showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return SingleChildScrollView(
                                          child: Padding(
                                            padding: EdgeInsets.only(
                                                bottom: MediaQuery.of(context)
                                                    .viewInsets
                                                    .bottom),
                                            child: Padding(
                                              padding: EdgeInsets.all(15),
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Text("Edit Note"),
                                                  SizedBox(
                                                    height: 50,
                                                  ),
                                                  TextField(
                                                      controller:
                                                          titleController,
                                                      clipBehavior: Clip.none,
                                                      decoration:
                                                          InputDecoration(
                                                        hintText: "Title",
                                                      )),
                                                  SizedBox(
                                                    height: 50,
                                                  ),
                                                  TextField(
                                                      controller:
                                                          descrptionController,
                                                      clipBehavior: Clip.none,
                                                      decoration:
                                                          InputDecoration(
                                                        hintText: "Description",
                                                      )),
                                                  SizedBox(
                                                    height: 50,
                                                  ),
                                                  ElevatedButton(
                                                      onPressed: () async {
                                                        Database.updateItem(
                                                            Title:
                                                                titleController
                                                                    .text,
                                                            Description:
                                                                descrptionController
                                                                    .text,
                                                            docId:
                                                                documentSnapshot
                                                                    .id);
                                                      },
                                                      child: Text("Edit Note")),
                                                  SizedBox(
                                                    height: 50,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      });
                                },
                                icon: Icon(
                                  Icons.edit_sharp,
                                  color: Colors.black,
                                )),
                            IconButton(
                                onPressed: () {
                                  Database.deleteItem(
                                      docId: documentSnapshot.id);
                                },
                                icon: Icon(
                                  Icons.delete_outline_sharp,
                                  color: Colors.black,
                                )),
                            SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }));
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
