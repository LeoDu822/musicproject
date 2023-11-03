

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:file_picker/file_picker.dart';
import 'package:musicproject/questionare.dart';
import 'package:musicproject/saveSessionQuestionare.dart';
import 'package:musicproject/savedsession.dart';
import 'package:audioplayers/audioplayers.dart';


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:musicproject/dawscreen.dart';
import 'package:musicproject/utility.dart';

import 'authentication.dart';
import 'login.dart';
import '../main.dart';
import 'SavedMelodies.dart';
import 'chord.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import "utility.dart";

class dawpage extends StatefulWidget {
  const dawpage(this.session, this.title, this.fromChords, this.miliseconds);
  final sessionUtility session;
  final String title;
  final bool fromChords;
  final int miliseconds;

  @override
  State<dawpage> createState() => dawPageState(session, title, fromChords, this.miliseconds);
}

enum  MenuItem {
  item1,
  item2,
  item3,
  item4,
  item5,
  item6,
  item7,
  item8,
  item9,
}

class dawPageState extends State<dawpage> {
  String passedInURL = "";
  String key = "G";
  bool fromChords = false;
  int miliseconds = 0;
  FirebaseFirestore db = FirebaseFirestore.instance;

  sessionUtility session = new sessionUtility();
  var player = AudioPlayer();
  final playerTrack2 = AudioPlayer();
  File? _selectedFile;
  String audioFile = '';
  double deviceLength = 0.0;
  double deviceWidth = 0.0;




  dawPageState(this.session, this.passedInURL, this.fromChords, this.miliseconds){
    if (this.fromChords == true) {
      session = this.session;
      session.currentLocalFile = passedInURL;
      session.audioFilesandDurationMap[session.currentLocalFile] = miliseconds;
    }
  }



  //Key: The string to play-Filepath
  //Value: the int is the milisecond duration of the file


  //Stores the filepath of whatever file you currently have selected


  

  void _resetState() {
    if (!mounted) {
      return;
    }
    setState(() {
      _selectedFile = null;
    });
  }

  bool uploaded = false;
  Future<void> _selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['mid'],
    );

    if (result != null) {

      _selectedFile = File(result.files.single.path!);


      var url = 'https://new-algorithm-thechosenonech1.replit.app'; // AWS/ec2 host

      Map<String, String> headers = {
        "Connection": "Keep-Alive",
        "Keep-Alive": "timeout=5, max=1000"
      };





      //CONVERTING TO WAV FILE
      http.MultipartRequest request = http.MultipartRequest(
          'POST', Uri.parse('$url/convertToWav')); //post request to URL/analize
      request.headers.addAll(headers);
      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          _selectedFile!.path,
        ),
      );



      request.send().then((r) async {
        Directory tempDir = await getTemporaryDirectory();
        print(tempDir);


        File localAudioFile = File('${tempDir.path}/audio$fileNumber.wav');
        fileNumber++;
        await localAudioFile.writeAsBytes(await r.stream.toBytes());

        // Save audio locally

        // _selectedFile = File(result.files.single.path!);

        await _getAudioDuration1(localAudioFile.path).then((value) {
          print(value!.inMilliseconds);
          session.currentLocalFile = localAudioFile.path;
          session.audioFilesandDurationMap[localAudioFile.path] = value!.inMilliseconds;

        });
        setState(() {

          audioFile = localAudioFile.path;

          print(audioFile);
          print(player.source);
          player.setSourceDeviceFile(audioFile);
          player.resume();
        });




      });



      setState(() {
        uploaded = true;
        print(uploaded);
      });



    }
  }
void chordScreen(){
    Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => chordpage(session, _selectedFile, "chordspage")));
  }
  int fileNumber = 0;
  Future<void> _uploadFile() async {
    var url = 'https://priceyconcreteemacs.jackwagner7.repl.co'; // AWS/ec2 host
    print(url);
    Map<String, String> headers = {
      "Connection": "Keep-Alive",
      "Keep-Alive": "timeout=5, max=1000"
    };

    http.MultipartRequest request = http.MultipartRequest(
        'POST', Uri.parse('$url/upload')); //post request to URL/analize
    request.headers.addAll(headers);
    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        _selectedFile!.path,
      ),
    );

    request.send().then((r) async {
      print(r.statusCode);

      if (r.statusCode == 200) {
        // Save audio locally
        print("sucess?");
        Directory tempDir = await getTemporaryDirectory();
        print(tempDir);

        File localAudioFile = File('${tempDir.path}/audio$fileNumber.wav');
        fileNumber++;
        await localAudioFile.writeAsBytes(await r.stream.toBytes());
        setState(() {
          audioFile = localAudioFile.path;

          print(audioFile);
          print(player.source);
          player.setSourceDeviceFile(audioFile);
          player.resume();
        });
      }
    });
  }
  Future<void> _uploadFileChord() async {
    var url = 'https://priceyconcreteemacs.jackwagner7.repl.co'; // AWS/ec2 host
    print(url);
    Map<String, String> headers = {
      "Connection": "Keep-Alive",
      "Keep-Alive": "timeout=5, max=1000"
    };

    http.MultipartRequest request = http.MultipartRequest(
        'POST', Uri.parse('$url/getAllChords')); //post request to URL/analize
    request.headers.addAll(headers);
    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        _selectedFile!.path,
      ),
    );

    request.send().then((r) async {
      print(r.statusCode);

      if (r.statusCode == 200) {
        print(r.stream.bytesToString().then((value) {
          print(value);
        }));
      }
    });
  }
  Future<Duration?> _getAudioDuration() async {
    player.setSourceDeviceFile(audioFile);

    Duration? audioDuration = await Future.delayed(
      Duration(seconds: 2),
          () => player.getDuration(),
    );

    return audioDuration;
  }
  Future<Duration?> _getAudioDuration1(String AF) async {
    player.setSourceDeviceFile(AF);

    Duration? audioDuration = await Future.delayed(
      Duration(seconds: 2),
          () => player.getDuration(),
    );
    return audioDuration;
  }
  Widget getLocalFileDuration() {
    return FutureBuilder<Duration?>(
      future: _getAudioDuration(),
      builder: (BuildContext context, AsyncSnapshot<Duration?> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Text('No Connection...');
          case ConnectionState.active:
          case ConnectionState.waiting:
            return Text('Waiting...');
          case ConnectionState.done:
            if (snapshot.hasError) return Text('Error: ${snapshot.error}');
            if (snapshot.data.toString() == "null") {
              return Text("");
            }
            else {
              return Text(  snapshot.data.toString());
            }
        }
      },
    );
  }
  int getTimeString(int milliseconds) {
    if (milliseconds == null) milliseconds = 0;
    String minutes =
        '${(milliseconds / 60000).floor() < 10 ? 0 : ''}${(milliseconds / 60000).floor()}';
    String seconds =
        '${(milliseconds / 1000).floor() % 60 < 10 ? 0 : ''}${(milliseconds / 1000).floor() % 60}';
    print("THIS IS THE MILISENDONS" + milliseconds.toString());
    return milliseconds; // Returns a string with the format mm:ss
  }

  void initState()  {
    super.initState();

    print("Im playing");


    player.setSourceUrl("https://cdn.discordapp.com/attachments/1070956419949535272/1137164260208812062/intro.wav");
  }

  void playsound() {
    _startTimer();
  }
  void stopSound() {
    print("stopping Sound");
    _stopTimer();
  }
  void nextPage(){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => sessionpage(title: "Saved Sessions")),
    );
  }
  void nextpage(){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => chordpage(session, _selectedFile, "chord Screen")),

    );
  }
  void nextpagemelody(){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => melodypage(title: "Melody screen")),

    );
  }





  void addtoTrack2Map() {
    AudioPlayer test = new AudioPlayer();
    test.setSourceDeviceFile(session.currentLocalFile);
    setState(() {
      session.track2.AddTrack1(session.currentLocalFile, session.audioFilesandDurationMap[session.currentLocalFile]!);
    });
    print("THIS IS THE TRACK 1 LENGTH " + session.track1.track1.length.toString());
  }



  void refreshaudioPlayers(){

    for (int i  = 0; i < session.track1.audioPlayers.length; i++){
      session.track1.audioPlayers[i].stop();
      session.track1.audioPlayers[i].setSourceDeviceFile(session.track1.filePaths[i]);
    }
    for (int x  = 0; x < session.track2.audioPlayers.length; x++){
      session.track2.audioPlayers[x].stop();
      session.track2.audioPlayers[x].setSourceDeviceFile(session.track2.filePaths[x]);
    }
  }

  void addtoTrack1Map() {
    AudioPlayer test = new AudioPlayer();
    test.setSourceDeviceFile(session.currentLocalFile);
    setState(() {
      session.track1.AddTrack1(session.currentLocalFile, session.audioFilesandDurationMap[session.currentLocalFile]!);
    });
    print("THIS IS THE TRACK 1 LENGTH " + session.track1.track1.length.toString());
  }

  void _removeWidget(int index) {
    setState(() {

      if (index >= 0 && index < session.track1.audioPlayers.length) {
        print("REMOVING TRACK 1");
        session.track1.audioPlayers.removeAt(index);
        session.track1.durations.removeAt(index);
        session.track1.track1.removeAt(index);
        session.track1.filePaths.removeAt(index);
      }



    });
  }
  void _removeWidget2(int index) {
    setState(() {
      if (index >= 0 && index < session.track2.audioPlayers.length) {

        if (index >= 0 && index < session.track2.audioPlayers.length) {
          print("REMOVING TRACK 1");
          session.track2.audioPlayers.removeAt(index);
          session.track2.durations.removeAt(index);
          session.track2.track1.removeAt(index);
          session.track2.filePaths.removeAt(index);
        }

      }

    });

  }

  int _timerDuration = 20000; // Example: 60 seconds

  // Variable to hold the current time remaining
  int _currentTime = 0;

  // Timer object
  Timer? _timer;

  // Function to be executed when the timer expires
  void _onTimerComplete() {
    // Implement actions to perform when the timer expires
    print("Timer complete!");
  }

  // Function to start the timer
  void _startTimer() {
    // Initialize the timer with the specified duration
    // Save audio locally

    //Which melody you are on
    int i = 0;
    int x = 0;

    //Milliseconds of the tracks you past
    int previoustime = 0;
    int previoustime2 = 0;


    setState(() {
      //if there is data
      //play data
      if (session.track1.durations.length > i) {
        previoustime = session.track1.durations[i];

        session.track1.audioPlayers[i].resume();
      }
      if (session.track2.durations.length > x) {
        previoustime2 = session.track2.durations[x];
        session.track2.audioPlayers[x].resume();
      }

    });
    //previoustime = track1map.key.elementAt(i);
    _timer = Timer.periodic(Duration(milliseconds: 1), (Timer timer) {
      // Update the time remaining
      setState(() {
        _currentTime = _timerDuration - timer.tick;

        //if we have data left and the current time is greater then the previous time
        if (session.track1.durations.length > i+1 && (timer.tick > previoustime && timer.tick < previoustime+100)) {
          //play the next track

          //first add the pervious track time to the previoustime variable
          previoustime = session.track1.durations[i]+ previoustime;
          //increment track number
          i++;
          session.track1.audioPlayers[i].resume();

        }
        if (session.track2.durations.length > x+1 && (timer.tick > previoustime2 && timer.tick < previoustime2+100)) {
          previoustime2= session.track2.durations[x]+ previoustime2;
          x++;

          session.track2.audioPlayers[x].resume();
        }

      });


      // Check if the timer has completed
      if (timer.tick >= _timerDuration) {
        timer.cancel(); // Cancel the timer
        _onTimerComplete(); // Execute the timer completion function
      }
    });
  }

  // Function to stop the timer
  void _stopTimer() {
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
      _onTimerComplete();
      setState(() {
        _currentTime = 0;
      });
    }

    refreshaudioPlayers();
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
      _onTimerComplete();
      setState(() {
        _currentTime = 0;
      });
    }

  }



  @override
  Widget build(BuildContext context) {
    deviceWidth = MediaQuery.of(context).size.width;
    deviceLength = MediaQuery.of(context).size.height;
    return Scaffold(

        appBar: PreferredSize(
          preferredSize: Size.fromHeight(55),
          //backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          child: AppBar(

              backgroundColor: Color.fromRGBO(122, 122, 150, 1),
              actions: <Widget>[
                IconButton(

                  onPressed: playsound,
                  icon: Icon(
                    Icons.play_circle_outline,
                    //color: Colors.green
                  ),
                  iconSize: 40,
                ),

                IconButton(
                  icon: Icon(
                    Icons.stop_circle_outlined,
                  ),
                  iconSize: 40,
                  onPressed: stopSound




                ),
                IconButton(
                    onPressed: () {

                    //  db.collection("users").doc(AuthenticationHelper().uid).collection("sessions").add(session.toJson());
                      setState(() {
                         showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(

                              content: SavedSessionForm(
                                  session), // Display the form here
                            );
                          },
                        );
                      });

                    },
                    // await localAudioFile.writeAsBytes(await r.bodyBytes);                    },
                    icon: Icon(Icons.save_outlined),
                    iconSize: 40
                ),
                Container(
                    width: 190
                ),

                GestureDetector(
                  onTap: nextPage,
                  child: Container(
                      height: 35,
                      width: 60,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Color.fromRGBO(74, 67, 77, 1),
                              width: 3.5


                          ),
                          borderRadius: BorderRadius.circular(3)
                      ),
                      alignment: Alignment.center,
                      child: Text("Saved", style: TextStyle(
                          fontFamily: "Tektur"
                      ),)
                  ),
                ),
                SizedBox(
                  width: 60,
                ),
                PopupMenuButton<MenuItem>(

                  itemBuilder: (context) => [
                    PopupMenuItem(
                      onTap: () async {
                        key = "C";
                        await http.get(Uri.parse('https://new-algorithm-thechosenonech1.replit.app/setChordsKey/$key'));
                      },
                      value: MenuItem.item1,
                      child: Text('C Major'),
                    ),
                    PopupMenuItem(
                      onTap: () async {
                        key = "G";
                        await http.get(Uri.parse('https://new-algorithm-thechosenonech1.replit.app//setChordsKey/$key'));
                      },
                      value: MenuItem.item2,
                      child: Text('G Major'),
                    ),
                    PopupMenuItem(
                      onTap: () async {
                        key = "D";
                        await http.get(Uri.parse('https://new-algorithm-thechosenonech1.replit.app/setChordsKey/$key'));
                      },
                      value: MenuItem.item3,
                      child: Text('D Major'),
                    ),
                    PopupMenuItem(
                      onTap: () async {
                        key = "A";
                        await http.get(Uri.parse('https://new-algorithm-thechosenonech1.replit.app/setChordsKey/$key'));
                      },
                      value: MenuItem.item4,
                      child: Text('A Major'),
                    ),
                    PopupMenuItem(
                      onTap: () async {
                        key = "E";
                        await http.get(Uri.parse('https://new-algorithm-thechosenonech1.replit.app/setChordsKey/$key'));
                      },
                      value: MenuItem.item5,
                      child: Text('E Major'),
                    ),
                    PopupMenuItem(
                      onTap: () async {
                        key = "B";
                        await http.get(Uri.parse('https://new-algorithm-thechosenonech1.replit.app/setChordsKey/$key'));
                      },
                      value: MenuItem.item6,
                      child: Text('B Major'),
                    ),
                    PopupMenuItem(
                      onTap: () async {
                        key = "F2";
                        await http.get(Uri.parse('https://new-algorithm-thechosenonech1.replit.app/setChordsKey/$key'));
                      },
                      value: MenuItem.item7,
                      child: Text('F# Major'),
                    ),
                    PopupMenuItem(
                      onTap: () async {
                        key = "C2";
                        await http.get(Uri.parse('https://new-algorithm-thechosenonech1.replit.app/setChordsKey/$key'));
                      },
                      value: MenuItem.item8,
                      child: Text('C# Major'),
                    ),
                    PopupMenuItem(
                      onTap: () async {
                        key = "a";
                        await http.get(Uri.parse('https://new-algorithm-thechosenonech1.replit.app/setChordsKey/$key'));
                      },
                      value: MenuItem.item8,
                      child: Text('a minor'),
                    ),
                    PopupMenuItem(
                      onTap: () async {
                        key = "e";
                        await http.get(Uri.parse('https://new-algorithm-thechosenonech1.replit.app/setChordsKey/$key'));
                      },
                      value: MenuItem.item8,
                      child: Text('e minor'),
                    ),
                    PopupMenuItem(
                      onTap: () async {
                        key = "b";
                        await http.get(Uri.parse('https://new-algorithm-thechosenonech1.replit.app/setChordsKey/$key'));
                      },
                      value: MenuItem.item8,
                      child: Text('b minor'),
                    ),
                    PopupMenuItem(
                      onTap: () async {
                        key = "f2";
                        await http.get(Uri.parse('https://new-algorithm-thechosenonech1.replit.app/setChordsKey/$key'));
                      },
                      value: MenuItem.item8,
                      child: Text('f# minor'),
                    ),
                    PopupMenuItem(
                      onTap: () async {
                        key = "c2";
                        await http.get(Uri.parse('https://new-algorithm-thechosenonech1.replit.app/setChordsKey/$key'));
                      },
                      value: MenuItem.item8,
                      child: Text('c# minor'),
                    ),
                    PopupMenuItem(
                      onTap: () async {
                        key = "g2";
                        await http.get(Uri.parse('https://new-algorithm-thechosenonech1.replit.app/setChordsKey/$key'));
                      },
                      value: MenuItem.item8,
                      child: Text('g# minor'),
                    ),
                    PopupMenuItem(
                      onTap: () async {
                        key = "d2";
                        print(key);
                        await http.get(Uri.parse('https://new-algorithm-thechosenonech1.replit.app/setChordsKey/$key'));
                      },
                      value: MenuItem.item8,
                      child: Text('d# minor'),
                    ),
                    PopupMenuItem(
                      onTap: () async {
                        key = "a2";
                        await http.get(Uri.parse('https://new-algorithm-thechosenonech1.replit.app/setChordsKey/$key'));
                      },
                      value: MenuItem.item8,
                      child: Text('a# minor'),
                    ),
                  ],

                )
              ]

          ),
        ),
        drawer: Container(
          width: deviceWidth / 2.546,
          child: Drawer(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8, 25, 8, 8),
                        child: Column(
                          children: [
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [


                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(

                                              content: QuestionnaireForm(
                                                  session.currentLocalFile), // Display the form here
                                            );
                                          },
                                        );
                                      });
                                    },
                                    child: Container(
                                        height: 25,
                                        width: deviceWidth/6,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Color.fromRGBO(74, 67, 77, 1),
                                                width: 2


                                            ),
                                            borderRadius: BorderRadius.circular(3)
                                        ),
                                        alignment: Alignment.center,
                                        child: Text("Save Melody", style: TextStyle(
                                            fontFamily: "Tektur", fontSize: deviceWidth/55
                                        ),)
                                    ),
                                  ),


                                  GestureDetector(
                                    onTap: _selectFile,
                                    child: Container(
                                        height: 25,
                                        width: deviceWidth/10,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Color.fromRGBO(74, 67, 77, 1),
                                                width: 2


                                            ),
                                            borderRadius: BorderRadius.circular(3)
                                        ),
                                        alignment: Alignment.center,
                                        child: Text("Upload", style: TextStyle(
                                            fontFamily: "Tektur", fontSize: deviceWidth/55
                                        ),)
                                    ),
                                  ),
                                ]
                            ),
                            Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [

                                  Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(width: 5),
                                        borderRadius: BorderRadius.circular(12),
                                        color: Color.fromRGBO(39, 40,41, 0.8),
                                      ),
                                      margin: EdgeInsets.fromLTRB(0, 13, 0, 10),
                                      height:deviceLength / 3.5,
                                      width: deviceWidth / 4.5,
                                      child: getLocalFileDuration()
                                  )
                                ]
                            ),
                            Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [

                                      GestureDetector(
                                        onTap: chordScreen,
                                        child: Container(
                                            height: 25,
                                            width: deviceWidth/10,
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Color.fromRGBO(74, 67, 77, 1),
                                                    width: 2


                                                ),
                                                borderRadius: BorderRadius.circular(3)
                                            ),
                                            alignment: Alignment.center,
                                            child: Text("Chords", style: TextStyle(
                                                fontFamily: "Tektur", fontSize: deviceWidth/55
                                            ),)
                                        ),
                                      ),

                                  GestureDetector(
                                    onTap: addtoTrack1Map,
                                    child: Container(
                                        height: 25,
                                        width: deviceWidth/10,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Color.fromRGBO(74, 67, 77, 1),
                                                width: 2


                                            ),
                                            borderRadius: BorderRadius.circular(3)
                                        ),
                                        alignment: Alignment.center,
                                        child: Text("Track 1", style: TextStyle(
                                            fontFamily: "Tektur", fontSize: deviceWidth/55
                                        ),)
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: addtoTrack2Map,
                                    child: Container(
                                        height: 25,
                                        width: deviceWidth/10,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Color.fromRGBO(74, 67, 77, 1),
                                                width: 2


                                            ),
                                            borderRadius: BorderRadius.circular(3)
                                        ),
                                        alignment: Alignment.center,
                                        child: Text("Track 2", style: TextStyle(
                                            fontFamily: "Tektur", fontSize: deviceWidth/55
                                        ),)
                                    ),
                                  ),
                                ]
                            ),
                          ],
                        ),
                      ),
                      color: Colors.amber,
                    ),
                    Container(
                      color: Colors.blue,
                      height: deviceLength / 2.30,
                      width: deviceWidth / 2.25,
                      child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(width: 5),
                                borderRadius: BorderRadius.circular(12),
                                color: Color.fromRGBO(39, 40,41, 0.8),
                              ),
                              margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                              height: deviceLength / 4,
                              width: deviceWidth / 3.6,
                            )
                          ]
                      ),
                    ),

                  ],
                ),
              )
          ),
        ),
        backgroundColor: Color.fromRGBO(122, 122, 150, 1),
        body: Row(
            children: [
              //side bar
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                child: Container(

                  child: Column(

                      children: [
                        Container(
                          color: Colors.blue,
                          height: deviceLength / 4.2,
                          width: deviceWidth / 5,
                          child: Row(
                              children: [
                                Container(
                                    width: deviceWidth / 10,
                                    color: Colors.blue
                                ),
                                IconButton(
                                  onPressed: () {
                                    if (session.track1.track1.isNotEmpty) {
                                        print("AM REMOVING FROM TRACK 1 NOW");
                                      _removeWidget(session.track1.track1.length - 1); // Remove the last widget
                                    }

                                  },
                                  iconSize: 28,
                                  icon: Icon(
                                    Icons.restore_from_trash_outlined,
                                  ),
                                )
                              ]

                          ),

                        ),
                        Container(

                          height: deviceLength / 4.2,
                          width: deviceWidth / 5,
                          child: Row(
                              children: [
                                Container(
                                    width: deviceWidth / 10,
                                    color: Colors.red
                                ),
                                IconButton(
                                  onPressed: () {
                                    if (session.track2.track1.isNotEmpty) {
                                      _removeWidget2(session.track2.track1.length - 1); // Remove the last widget
                                    }
                                  },
                                  iconSize: 28,
                                  icon: Icon(
                                    Icons.restore_from_trash_outlined,
                                  ),
                                )
                              ]

                          ),
                          decoration: BoxDecoration(border: Border(

                            top: BorderSide(width: 5, color: Color.fromRGBO(39, 40, 41, 0.9)),

                          ),

                              color: Colors.red
                          ),
                        ),
                        Container(

                          height: deviceLength / 4.2,
                          width: deviceWidth / 5,
                          child: Row(
                              children: [
                                Container(
                                    width: deviceWidth / 10,
                                    color: Colors.amber
                                ),
                                IconButton(
                                  onPressed: () {},
                                  iconSize: 28,
                                  icon: Icon(
                                    Icons.restore_from_trash_outlined,
                                  ),
                                )
                              ]

                          ),
                          decoration: BoxDecoration(border: Border(

                            top: BorderSide(width: 5, color: Color.fromRGBO(39, 40, 41, 0.9)),

                          ),

                              color: Colors.amber
                          ),
                        ),
                      ]
                  ),

                  decoration: BoxDecoration(border: Border(
                    top: BorderSide(width: 5, color: Color.fromRGBO(39, 40, 41, 0.9)),
                    left: BorderSide(width: 5, color: Color.fromRGBO(39, 40, 41, 0.9)),
                    bottom: BorderSide(width:5, color: Color.fromRGBO(39, 40, 41, 0.9)),

                  ),


                  ),

                  height: deviceLength ,
                  width: deviceWidth / 5,
                ),
              ),
              //main tracklist
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Container(
                  decoration: BoxDecoration(border: Border.all(
                      width: 5, color: Color.fromRGBO(39, 40, 41, 0.9)
                  ),
                      borderRadius: BorderRadius.circular(2)

                  ),
                  width: deviceWidth/ 1.38,
                  height: deviceLength,
                  child: Column(

                      children: [

                        Container(
                            child: Row(
                              children: session.track1.track1,


                            ),
                            color: Color.fromRGBO(97, 103, 122, 0.7),
                            height: deviceLength / 4.2,
                            width: deviceWidth/1.38

                        ),
                        Container(

                          child: Row(

                            children: session.track2.track1,

                          ),

                          height: deviceLength / 4.2,
                          width: deviceWidth/1.38,
                          decoration: BoxDecoration(border: Border(
                            top: BorderSide(width: 5, color: Color.fromRGBO(39, 40,41, 0.8)),


                          ),

                            color: Color.fromRGBO(97, 103, 122, 0.7),
                          ),
                        ),
                        Container(

                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,



                          ),

                          height: deviceLength / 4.2,
                          width: deviceWidth/1.38,
                          decoration: BoxDecoration(border: Border(
                            top: BorderSide(width: 5, color: Color.fromRGBO(39, 40, 41, 0.8)),

                          ),

                            color: Color.fromRGBO(97, 103, 122, 0.7),
                          ),
                        )
                      ]
                  ), //tracklist



                ),
              ),
            ]
        )
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}


