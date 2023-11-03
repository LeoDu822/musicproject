import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:musicproject/utility.dart';
import 'package:musicproject/widgets.dart';
import 'Authentication.dart';
class sessionpage extends StatefulWidget {
  const sessionpage({super.key, required this.title});

  final String title;

  @override
  State<sessionpage> createState() => sessionPageState();
}

class sessionPageState extends State<sessionpage> {
  int _counter = 0;

  void _incrementCounter() {

    print("Hello World");
    setState(() {

      _counter+=2;
    });
  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchData() async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    return db.collection("users").doc(AuthenticationHelper().uid).collection("sessions").get();

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),
      body: Center(
        child: FutureBuilder<QuerySnapshot<Map<String, dynamic>>>(
            future: fetchData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child:
                    CircularProgressIndicator()); // Display a loading indicator while waiting for data
              } else if (snapshot.hasError) {
                return Center(
                    child: Text(
                        'Error fetching data')); // Display an error message if data fetching fails
              } else if (!snapshot.hasData) {
                return Center(
                    child: Text(
                        'No data available')); // Display a message if no data is available
              } else {
                print(snapshot.data?.docs);
                List<sessionObject> sessions = [];
                for (var i in snapshot.data!.docs) {

                  sessionUtility session = new sessionUtility();
                  session.currentLocalFile = i.data()["currentLocalFile"];

                  Map<String, dynamic> asd = i.data()["audioFilesandDurationsMap"] as Map<String, dynamic>;
                  Map<String, int> newAudioFilesandDurationsMap = {};
                  for (var x in asd.entries) {
                    newAudioFilesandDurationsMap[x.key] = x.value as int;

                   }

                  session.audioFilesandDurationMap = newAudioFilesandDurationsMap;
                  List<dynamic> dsa = i.data()["track1"]["filePaths"] as List<dynamic>;
                  List<String> newFilePaths = [];
                  for (var x in dsa) {

                    newFilePaths.add(x);
                  }

                  session.track1.filePaths = newFilePaths;
                  session.audioFilesandDurationMap = newAudioFilesandDurationsMap;

                  List<dynamic> ads = i.data()["track1"]["durations"] as List<dynamic>;
                  List<int> newDurations = [];
                  for (var x in ads) {
                    int t = x as int;
                    newDurations.add(t);
                  }

                  session.track1.durations = newDurations;
                  int length = i.data()["track1"]["widgets"] as int;
                  for (int x = 0; x < length; x++){
                    session.track1.track1.add(dawObject(100));
                  }
                  for (int x = 0; x < length; x++){
                    AudioPlayer test = new AudioPlayer();
                    test.setSourceDeviceFile(session.track1.filePaths[x]);
                    session.track1.audioPlayers.add(test);
                  }

                  //Track2
                  dsa = i.data()["track2"]["filePaths"] as List<dynamic>;
                  newFilePaths = [];
                  for (var x in dsa) {

                    newFilePaths.add(x);
                  }
                  session.track2.filePaths = newFilePaths;

                  ads = i.data()["track2"]["durations"] as List<dynamic>;
                  newDurations = [];
                  for (var x in ads) {
                    int t = x as int;
                    newDurations.add(t);
                  }

                  session.track2.durations = newDurations;
                  length = i.data()["track2"]["widgets"] as int;
                  for (int x = 0; x < length; x++){
                    session.track2.track1.add(dawObject(100));
                  }
                  for (int x = 0; x < length; x++){
                    AudioPlayer test = new AudioPlayer();
                    test.setSourceDeviceFile(session.track2.filePaths[x]);
                    session.track2.audioPlayers.add(test);
                  }

                  sessions.add(sessionObject(i.id,session));
                }

                return Row(
                  children: sessions,
                );
              }
            }
    ),

          )




// This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
