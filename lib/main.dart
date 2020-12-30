import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart' as Firebase; //ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_storage/firebase_storage.dart' //ignore: import_of_legacy_library_into_null_safe
    as Firestorage; //ignore: import_of_legacy_library_into_null_safe
import 'package:cloud_firestore/cloud_firestore.dart' as Firestore; //ignore: import_of_legacy_library_into_null_safe

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
            body: FutureBuilder(
                future: Firebase.Firebase.initializeApp(),
                builder: (context, snapshot) => Column(children: [
                      Expanded(child: Container()),
                      TextButton(
                          child: Text("upload"),
                          onPressed: () async {
                            Firestore.CollectionReference files =
                                Firestore.FirebaseFirestore.instance.collection('files');
                            final file = await files.add({'something': 'new'});
                            File data = File('./garbage.wav');
                            await Firestorage.FirebaseStorage.instance.ref(file.id).putFile(data);
                          })
                    ]))));
  }
}
