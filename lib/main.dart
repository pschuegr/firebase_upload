import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart' as Firebase; //ignore: import_of_legacy_library_into_null_safe
import 'package:firebase_storage/firebase_storage.dart' //ignore: import_of_legacy_library_into_null_safe
    as Firestorage; //ignore: import_of_legacy_library_into_null_safe
import 'package:cloud_firestore/cloud_firestore.dart' as Firestore; //ignore: import_of_legacy_library_into_null_safe

void main() {
  runApp(MyApp());
}

void _audioTaskEntrypoint() async {
  await AudioServiceBackground.run(() => PlayerBackground());
}

class PlayerBackground extends BackgroundAudioTask {}

class MyApp extends StatelessWidget {
  final String uploadDir = Directory.current.absolute.path;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Scaffold(
            body: AudioServiceWidget(
                child: FutureBuilder(
                    future: Firebase.Firebase.initializeApp(),
                    builder: (context, snapshot) {
                      // Check for errors
                      if (snapshot.hasError) {
                        print(snapshot.error);
                      }

                      // Once complete, show your application
                      if (snapshot.connectionState == ConnectionState.done) {
                        return FutureBuilder(
                            future: AudioService.start(backgroundTaskEntrypoint: _audioTaskEntrypoint),
                            builder: (context, snapshot) {
                              return Column(children: [
                                Expanded(child: Container()),
                                TextButton(child: Text("upload $uploadDir/garbage.mp3"), onPressed: _onPress)
                              ]);
                            });
                      }

                      return Container();
                    }))));
  }

  _onPress() async {
    try {
      print("button pressed");
      Firestore.CollectionReference files = Firestore.FirebaseFirestore.instance.collection('files');
      print("adding to firestore");
      final file = await files.add({'something': 'new'});
      print('checking for file');
      File data = File('$uploadDir/garbage.mp3');
      assert(data.existsSync());
      print("starting upload for ${file.id}");
      await Firestorage.FirebaseStorage.instance.ref(file.id).putFile(data);
      print("success!");
    } catch (e) {
      print(e);
    }
  }
}
