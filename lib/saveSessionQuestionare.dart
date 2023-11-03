import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:musicproject/utility.dart';
import 'package:path_provider/path_provider.dart';

import 'Authentication.dart';


class SavedSessionForm extends StatelessWidget {
  sessionUtility currentSession = new sessionUtility();
  FirebaseFirestore db = FirebaseFirestore.instance;

  bool mat = false;
  List<bool> _selectedOptions = [false, false, false]; // Modify this based on your questions
  String Title = "";
  String Description = "";
  String Date = "";
  String name = "";
  SavedSessionForm(this.currentSession);
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
              String ogName = name;
              if (Platform.isAndroid) {


                File x = new File(currentSession.currentLocalFile);
                File y = new File("/storage/emulated/0/Download/$name.wav");
                y = await x.copy("/storage/emulated/0/Download/$name.wav");
                currentSession.currentLocalFile = "/storage/emulated/0/Download/$name.wav";
                Map<String, int> newCurrentSession = {};

                int count = 0;
                for (var i in currentSession.audioFilesandDurationMap.entries) {
                  File x = new File(i.key);
                  name = name + count.toString();
                  File y = new File("/storage/emulated/0/Download/$name.wav");
                  y = await x.copy("/storage/emulated/0/Download/$name.wav");
                  newCurrentSession["/storage/emulated/0/Download/$name.wav"] = i.value;
                  count++;

                }
                currentSession.audioFilesandDurationMap = newCurrentSession;
                count++;

                for (int i = 0; i < currentSession.track1.filePaths.length; i++) {
                  File x = new File(currentSession.track1.filePaths[i]);
                  name = name + count.toString();

                  File y = new File("/storage/emulated/0/Download/$name.wav");
                  y = await x.copy("/storage/emulated/0/Download/$name.wav");
                  currentSession.track1.filePaths[i] = "/storage/emulated/0/Download/$name.wav";
                  count++;

                }

                for (int i = 0; i < currentSession.track2.filePaths.length; i++) {
                  File x = new File(currentSession.track2.filePaths[i]);
                  name = name + count.toString();

                  File y = new File("/storage/emulated/0/Download/$name.wav");
                  y = await x.copy("/storage/emulated/0/Download/$name.wav");
                  currentSession.track2.filePaths[i] = "/storage/emulated/0/Download/$name.wav";
                  count++;
                }




              db.collection("users").doc(AuthenticationHelper().uid).collection("sessions").doc(ogName).set(currentSession.toJson());


            }
              else if (Platform.isIOS) {
                Directory? downloads = await getApplicationDocumentsDirectory();
                File x = new File(currentSession.currentLocalFile);
                File y = new File(downloads!.path + "/" + "$name.wav");
                y = await x.copy(downloads!.path + "/" + "$name.wav");
                currentSession.currentLocalFile = downloads!.path + "/" + "$name.wav";


                Map<String, int> newCurrentSession = {};

                int count = 0;
                for (var i in currentSession.audioFilesandDurationMap.entries) {
                  Directory? downloads = await getApplicationDocumentsDirectory();
                  File x = new File(i.key);
                  name = name + count.toString();
                  File y = new File(downloads!.path + "/" + "$name.wav");
                  y = await x.copy(downloads!.path + "/" + "$name.wav");
                  newCurrentSession[downloads!.path + "/" + "$name.wav"] = i.value;
                  count++;

                }
                currentSession.audioFilesandDurationMap = newCurrentSession;
                count++;

                for (int i = 0; i < currentSession.track1.filePaths.length; i++) {
                  Directory? downloads = await getApplicationDocumentsDirectory();
                  File x = new File(currentSession.track1.filePaths[i]);
                  name = name + count.toString();

                  File y = new File(downloads!.path + "/" + "$name.wav");
                  y = await x.copy(downloads!.path + "/" + "$name.wav");
                  currentSession.track1.filePaths[i] = downloads!.path + "/" + "$name.wav";
                  count++;

                }

                for (int i = 0; i < currentSession.track2.filePaths.length; i++) {
                  Directory? downloads = await getApplicationDocumentsDirectory();
                  File x = new File(currentSession.track2.filePaths[i]);
                  name = name + count.toString();

                  File y = new File(downloads!.path + "/" + "$name.wav");
                  y = await x.copy(downloads!.path + "/" + "$name.wav");
                  currentSession.track2.filePaths[i] = downloads!.path + "/" + "$name.wav";
                  count++;
                }

              }


              db.collection("users").doc(AuthenticationHelper().uid).collection("sessions").doc(ogName).set(currentSession.toJson());
            //  db.collection("users").doc(AuthenticationHelper().uid).collection("sessions").add(currentSession.toJson());
            }, child: Text("Save"))
          ],
        ),
      ),
    );
  }
}
