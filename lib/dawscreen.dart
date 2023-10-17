

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:file_picker/file_picker.dart';
import 'package:musicproject/questionare.dart';
import 'package:musicproject/savedsession.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:musicproject/timer.dart';
import 'package:musicproject/upload_screen.dart';
import 'package:musicproject/widgets.dart';
import 'SavedMelodies.dart';
import 'chord.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;


class dawpage extends StatefulWidget {
  const dawpage(this.title, this.fromChords, this.miliseconds);

  final String title;
  final bool fromChords;
  final int miliseconds;

  @override
  State<dawpage> createState() => dawPageState(title, fromChords, this.miliseconds);
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
  dawPageState(this.passedInURL, this.fromChords, this.miliseconds){
    if (this.fromChords == true) {
      currentLocalFile = passedInURL;
      audioFilesandDurationMap[currentLocalFile] = miliseconds;
    }
  }
  var player = AudioPlayer();
  final playerTrack2 = AudioPlayer();
  File? _selectedFile;
  String audioFile = '';
  double deviceLength = 0.0;
  double deviceWidth = 0.0;
  AudioCache audioCache = AudioCache();
  int _counter = 0;
  ScrollController _controller1 = ScrollController();
  ScrollController _controller2 = ScrollController();
  ScrollController _controller3 = ScrollController();
  List<Widget> track1 = [];
  List<Widget> track2 = [];
  late Map<String, int> audioFilesandDurationMap = {};

  //Key: The string to play-Filepath
  //Value: the int is the milisecond duration of the file
  late Map<String, int> track1map = {};
  late Map<String, int> track2map = {};

  //Stores the filepath of whatever file you currently have selected
  String currentLocalFile = "";

  

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
      await _getAudioDuration1(_selectedFile!.path).then((value) {

        // audioFilesandDurationMap[_selectedFile!.path] = value!.inMilliseconds;
        print(value);
      });
      print(audioFilesandDurationMap);

      var url = 'https://newalgorithm.thechosenonech1.repl.co'; // AWS/ec2 host

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
          currentLocalFile = localAudioFile.path;
          audioFilesandDurationMap[localAudioFile.path] = value!.inMilliseconds;
          print(audioFilesandDurationMap);

        });
        setState(() {

          audioFile = localAudioFile.path;

          print(audioFile);
          print(player.source);
          player.setSourceDeviceFile(audioFile);
          player.resume();
        });



        // await _selectedFile?.writeAsBytes(await r.stream.toBytes());
        // audioFile = _selectedFile!.path;
        // await _getAudioDuration1(audioFile).then((value) {
        //   print(value!.inMilliseconds);
        //   audioFilesandDurationMap[_selectedFile!.path] = value!.inMilliseconds;
        // });
        // setState(() {
        //   audioFile = localAudioFile.path;
        //   print(audioFile);
        //   print(player.source);
        //   player.setSourceDeviceFile(audioFile);
        //
        //   player.resume();
        // });
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
        MaterialPageRoute(builder: (context) => chordpage(_selectedFile, "chordspage")));
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
  void stoppage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TimerWidget()),

    );
  }
  void playsound() {
    _startTimer();
    // if (fromChords == true) {
    //   player.setSourceDeviceFile(passedInURL);
    //   player.resume();
    // }
    // else {
    //   print("playing from current file");
    //   setState(() {
    //     player.setSourceDeviceFile(currentLocalFile);
    //     player.resume();
    //   });
    // }

    // _startTimer();
  }
  void stopSound() {
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
      MaterialPageRoute(builder: (context) => chordpage(_selectedFile, "chord Screen")),

    );
  }
  void nextpagemelody(){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => melodypage(title: "Melody screen")),

    );
  }
  void track1Set(index, value){
    track1[index] = value;
  }
  Widget track1Get(index, direction) {
    if (index + direction > track1.length || index + direction < 0)
    {
      return track1[index];
    }

    return dawObject(10);
  }
  void track2Set(index, value) {
    track2[index] = value;
  }
  Widget track2Get(index, direction) {
    if (index + direction > track2.length || index + direction < 0)
    {
      return track2[index];
    }

    return dawObject(10);
  }

  List<AudioPlayer> audioPlayersTrack2 = [];
  List<int> durations2 = [];
  List<String> filePaths2 = [];

  void addtoTrack2Map() {
    track2map[currentLocalFile] = audioFilesandDurationMap[currentLocalFile]!;
    print(track2map);
    AudioPlayer test = new AudioPlayer();

    test.setSourceDeviceFile(currentLocalFile);

    durations2.add(audioFilesandDurationMap[currentLocalFile]!);
    filePaths2.add(currentLocalFile);
    audioPlayersTrack2.add(test);

    setState(() {
      track2.add(dawObject(100));
    });

  }

  List<AudioPlayer> audioPlayers = [];
  List<int> durations = [];
  List<String> filePaths = [];

  void refreshaudioPlayers(){
    for (int i  = 0; i < audioPlayers.length; i++){
      audioPlayers[i].setSourceDeviceFile(filePaths[i]);
    }
    for (int x  = 0; x < audioPlayersTrack2.length; x++){
      audioPlayersTrack2[x].setSourceDeviceFile(filePaths2[x]);
    }
  }

  void addtoTrack1Map() {

    track1map[currentLocalFile] = audioFilesandDurationMap[currentLocalFile]!;
    AudioPlayer test = new AudioPlayer();

    test.setSourceDeviceFile(currentLocalFile);
    print(track1map);
    durations.add(audioFilesandDurationMap[currentLocalFile]!);
    filePaths.add(currentLocalFile);
    audioPlayers.add(test);
    print("Hello World");
    print(track1map);
    setState(() {

      track1.add(dawObject(100));
    });
  }
  void _removeWidget(int index) {
    print(track1map);
    setState(() {

      if (index >= 0 && index < audioPlayers.length) {
        print("REMOVING TRACK 1");
        audioPlayers.removeAt(index);
        durations.removeAt(index);
        track1.removeAt(index);

      }



    });
  }
  void _removeWidget2(int index) {
    setState(() {
      if (index >= 0 && index < audioPlayersTrack2.length) {

        audioPlayersTrack2.removeAt(index);
        durations2.removeAt(index);
        track2.removeAt(index);
      }

    });

  }

  int _timerDuration = 20000000; // Example: 60 seconds

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
    print(track1map);
    print(track2map);

    setState(() {
      //if there is data
      //play data
      if (durations.length > i) {
        previoustime = durations[i];
       // audioFile = track1map.keys.elementAt(i);
       // player.setSourceDeviceFile(track1map.keys.elementAt(i));
      //  player.resume();
        audioPlayers[i].resume();
      }
      if (durations2.length > x) {
        previoustime2 = durations2[x];
        audioPlayersTrack2[x].resume();
      }

    });
    //previoustime = track1map.key.elementAt(i);
    _timer = Timer.periodic(Duration(milliseconds: 1), (Timer timer) {
      // Update the time remaining
      setState(() {
        _currentTime = _timerDuration - timer.tick;
        print(timer.tick);
        //if we have data left and the current time is greater then the previous time
        if (durations.length > i+1 && (timer.tick > previoustime && timer.tick < previoustime+100)) {
          //play the next track

          //first add the pervious track time to the previoustime variable
          previoustime = durations[i]+ previoustime;
          //increment track number
          i++;
          audioPlayers[i].resume();

        }
        if (durations2.length > x+1 && (timer.tick > previoustime2 && timer.tick < previoustime2+100)) {
          previoustime2= durations[x]+ previoustime2;
          x++;

          audioPlayersTrack2[x].resume();
        }

      });

      print(track1map);
      print(track2map);


      // Check if the timer has completed
      if (timer.tick >= _timerDuration) {
        print(_timerDuration);
        timer.cancel(); // Cancel the timer
        _onTimerComplete(); // Execute the timer completion function
      }
    });
  }

  // Function to stop the timer
  void _stopTimer() {
    refreshaudioPlayers();
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
      _onTimerComplete();
      setState(() {
        _currentTime = 0;
      });
    }
    print(track1map);
    print(track2map);
  }

  @override
  Widget build(BuildContext context) {
    deviceWidth = MediaQuery.of(context).size.width;
    deviceLength = MediaQuery.of(context).size.height;
    return Scaffold(

        appBar: PreferredSize(
          preferredSize: Size.fromHeight(56),
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
                  onPressed: ()
                  {
                    stopSound();
                  },
                ),
                IconButton(
                    onPressed: () {
                      print(currentLocalFile);
                      setState(() {
                         showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(

                              content: QuestionnaireForm(
                                  currentLocalFile), // Display the form here
                            );
                          },
                        );
                      });
                      // fileNumber++;
                      // File x = new File(currentLocalFile);
                      // x.copy("/storage/emulated/0/Download/audio10.wav");
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
                        await http.get(Uri.parse('https://newalgorithm.thechosenonech1.repl.co/setChordsKey/$key'));
                      },
                      value: MenuItem.item1,
                      child: Text('C Major'),
                    ),
                    PopupMenuItem(
                      onTap: () async {
                        key = "G";
                        await http.get(Uri.parse('https://newalgorithm.thechosenonech1.repl.co/setChordsKey/$key'));
                      },
                      value: MenuItem.item2,
                      child: Text('G Major'),
                    ),
                    PopupMenuItem(
                      onTap: () async {
                        key = "D";
                        await http.get(Uri.parse('https://newalgorithm.thechosenonech1.repl.co/setChordsKey/$key'));
                      },
                      value: MenuItem.item3,
                      child: Text('D Major'),
                    ),
                    PopupMenuItem(
                      onTap: () async {
                        key = "A";
                        await http.get(Uri.parse('https://newalgorithm.thechosenonech1.repl.co/setChordsKey/$key'));
                      },
                      value: MenuItem.item4,
                      child: Text('A Major'),
                    ),
                    PopupMenuItem(
                      onTap: () async {
                        key = "E";
                        await http.get(Uri.parse('https://newalgorithm.thechosenonech1.repl.co/setChordsKey/$key'));
                      },
                      value: MenuItem.item5,
                      child: Text('E Major'),
                    ),
                    PopupMenuItem(
                      onTap: () async {
                        key = "B";
                        await http.get(Uri.parse('https://newalgorithm.thechosenonech1.repl.co/setChordsKey/$key'));
                      },
                      value: MenuItem.item6,
                      child: Text('B Major'),
                    ),
                    PopupMenuItem(
                      onTap: () async {
                        key = "F#";
                        await http.get(Uri.parse('https://newalgorithm.thechosenonech1.repl.co/setChordsKey/$key'));
                      },
                      value: MenuItem.item7,
                      child: Text('F# Major'),
                    ),
                    PopupMenuItem(
                      onTap: () async {
                        key = "C#";
                        await http.get(Uri.parse('https://newalgorithm.thechosenonech1.repl.co/setChordsKey/$key'));
                      },
                      value: MenuItem.item8,
                      child: Text('C# Major'),
                    ),
                    PopupMenuItem(
                      onTap: () async {
                        key = "a";
                        await http.get(Uri.parse('https://newalgorithm.thechosenonech1.repl.co/setChordsKey/$key'));
                      },
                      value: MenuItem.item8,
                      child: Text('a minor'),
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
                                    onTap: nextpagemelody,
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
                                        child: Text("Saved Melodies", style: TextStyle(
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
                                    if (track1.isNotEmpty) {
                                        print("AM REMOVING FROM TRACK 1 NOW");
                                      _removeWidget(track1.length - 1); // Remove the last widget
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
                                    if (track2.isNotEmpty) {
                                      _removeWidget2(track2.length - 1); // Remove the last widget
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
                              children: track1,


                            ),
                            color: Color.fromRGBO(97, 103, 122, 0.7),
                            height: deviceLength / 4.2,
                            width: deviceWidth/1.38

                        ),
                        Container(

                          child: Row(

                            children: track2,

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
