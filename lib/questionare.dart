import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';


class QuestionnaireForm extends StatelessWidget {
  String currentLocalFile = "";
  FirebaseFirestore db = FirebaseFirestore.instance;

  bool mat = false;
  List<bool> _selectedOptions = [false, false, false]; // Modify this based on your questions
  String Title = "";
  String Description = "";
  String Date = "";
  String name = "";
  QuestionnaireForm(this.currentLocalFile);
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           TextField(
             onChanged: (String newEntry){
              name = newEntry;
             },
             decoration: InputDecoration(
               border: OutlineInputBorder(),
               labelText: 'Save File',
             ),
           ),
            SizedBox(
              height: 10,
            ),
            ElevatedButton(onPressed: () async {
              if (Platform.isAndroid) {
                print(currentLocalFile);
                print(name);
                File x = new File(currentLocalFile);
                File y = new File("/storage/emulated/0/Download/$name.wav");

                y = await x.copy("/storage/emulated/0/Download/$name.wav");
              } else if (Platform.isIOS) {
                Directory? downloads = await getDownloadsDirectory();
                File x = new File(currentLocalFile);
                File y = new File(downloads!.path + "$name.wav");

                y = await x.copy(downloads!.path + "$name.wav");

              }
              //double width = MediaQuery.of(context).size.width;
              //double height = MediaQuery.of(context).size.height;

            }, child: Text("Save"))
          ],
        ),
      ),
    );
  }
}
