

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:file_picker/file_picker.dart';
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
  const dawpage(this.title, this.fromChords);

  final String title;
  final bool fromChords;

  @override
  State<dawpage> createState() => dawPageState(title, fromChords);
}

enum  MenuItem {
  item1,
  item2,
  item3,
}

class dawPageState extends State<dawpage> {
  String passedInURL = "";
  bool fromChords = false;
  dawPageState(this.passedInURL, this.fromChords);
  var player = AudioPlayer();
  final playerTrack2 = AudioPlayer();
  File? _selectedFile;
  String audioFile = '';
  AudioCache audioCache = AudioCache();
  int _counter = 0;
  ScrollController _controller1 = ScrollController();
  ScrollController _controller2 = ScrollController();
  ScrollController _controller3 = ScrollController();
  List<Widget> track1 = [];
  List<Widget> track2 = [];
  late Map<String, int> audioFilesandDurationMap = {};
  late Map<String, int> track1map = {};
  late Map<String, int> track2map = {};
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
      //  await localAudioFile.writeAsBytes(await r.stream.toBytes());

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

  void _scrollListener() {
    print("hello");
    if (_controller1.position.userScrollDirection == ScrollDirection.forward) {
      _controller2.jumpTo(_controller1.offset);
      _controller3.jumpTo(_controller1.offset);
    }
  }
  void initState()  {
    super.initState();
    _controller1.addListener(_scrollListener);
    print("Im playing");


    player.setSourceUrl("https://cdn.discordapp.com/attachments/1070956419949535272/1137164260208812062/intro.wav");
  }
  void stoppage()
  {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TimerWidget()),

    );
  }
  void playsound()
  {
    if (fromChords == true) {
      player.setSourceDeviceFile(passedInURL);
      player.resume();
    }
    else {
      player.setSourceDeviceFile(currentLocalFile);
      player.resume();
    }

   // _startTimer();
  }

  void stopSound() {
    player.stop();
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
  void track1Set(index, value)
  {
    track1[index] = value;
  }
  Widget track1Get(index, direction)
  {
    if (index + direction > track1.length || index + direction < 0)
      {
        return track1[index];
      }

    return dawObject(10);
  }
  void track2Set(index, value)
  {
    track2[index] = value;
  }
  Widget track2Get(index, direction)
  {
    if (index + direction > track2.length || index + direction < 0)
    {
      return track2[index];
    }

    return dawObject(10);
  }
  void addDragable()
  {
    track2map[currentLocalFile] = audioFilesandDurationMap[currentLocalFile]!;
    print(track2map);

    setState(() {
      track2.add(dawObject(100));
    });

  }
  void _incrementCounter() {
    track1map[currentLocalFile] = audioFilesandDurationMap[currentLocalFile]!;

    print("Hello World");
    print(track1map);
    setState(() {

     track1.add(dawObject(100));
    });
  }
  void _removeWidget(int index) {
    setState(() {
      if (index >= 0 && index < track1.length) {
        track1.removeAt(index);
      }
      track1map.clear();


    });
  }
  void _removeWidget2(int index) {
    setState(() {
      if (index >= 0 && index < track2.length) {
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
    int i = 0;
    int x = 0;
    int previoustime = 0;
    int previoustime2 = 0;


    setState(() {
      if (track1map.values.length > i) {
        audioFile = track1map.keys.elementAt(i);
        player.setSourceDeviceFile(track1map.keys.elementAt(i));
        player.resume();
      }
      if (track2map.values.length > x) {
        audioFile = track2map.keys.elementAt(x);
        playerTrack2.setSourceDeviceFile(track2map.keys.elementAt(i));
        playerTrack2.resume();
      }

    });
    //previoustime = track1map.key.elementAt(i);
    _timer = Timer.periodic(Duration(milliseconds: 1), (Timer timer) {
      // Update the time remaining
      setState(() {
        _currentTime = _timerDuration - timer.tick;
        print(timer.tick);
          if (track1map.values.length > i && timer.tick > previoustime + track1map.values.elementAt(i)) {
            previoustime = track1map.values.elementAt(i)+ previoustime;
            i++;
            print(track1map);
            print(track1map.values.elementAt(i));
            print(track1map.keys.elementAt(i));
            player.dispose();
            player = AudioPlayer();
            player.setSourceDeviceFile(track1map.keys.elementAt(i));
            player.resume();
          }
        if (track2map.values.length > x && timer.tick > previoustime2 + track2map.values.elementAt(i)) {
          previoustime2= track2map.values.elementAt(i)+ previoustime2;
          x++;
          playerTrack2.setSourceDeviceFile(track2map.keys.elementAt(i));
          playerTrack2.resume();
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
    if (_timer != null && _timer!.isActive) {
      _timer!.cancel();
      setState(() {
        _currentTime = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
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
                  onPressed: (){

                    nextPage();
                  },
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
                    value: MenuItem.item1,
                    child: Text('Item 1'),
                  ),
                  PopupMenuItem(
                    value: MenuItem.item2,
                    child: Text('Item 2'),
                  ),
                  PopupMenuItem(
                    value: MenuItem.item3,
                    child: Text('Item 3'),
                  ),
                ],
                onSelected: (value){
                  if (value == MenuItem.item1) {

                  }
                },
              )
            ]

          ),
        ),
      drawer: Container(
        width: 350,
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

                              ElevatedButton(
                                onPressed: nextpagemelody,
                                child: Text("Saved melodies"),
                              ),

                              ElevatedButton(
                                onPressed: (){
                                  _selectFile();
                                },

                                child: Text("Upload"),
                              )
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
                                height:100,
                                width: 200,
                                child: getLocalFileDuration()
                              )
                            ]
                        ),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              ButtonTheme(
                                minWidth: 50,
                                height: 50,
                                child: ElevatedButton(
                                  onPressed: (){

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => chordpage(_selectedFile, "chordspage")),

                                    );
                                  },
                                  child: Text("Chords"),

                                ),
                              ),

                              ElevatedButton(
                                onPressed: _incrementCounter,
                                child: Text("Track 1"),
                              ),
                              ElevatedButton(
                                onPressed: addDragable,
                                child: Text("Track 2"),
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
                  height: 143.3,
                    width: 400,
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(width: 5),
                            borderRadius: BorderRadius.circular(12),
                            color: Color.fromRGBO(39, 40,41, 0.8),
                          ),
                          margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                          height:100,
                          width: 250,
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
      body: SingleChildScrollView(

        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 50, 0, 0),
              child: Container(

                child: Column(
                    children: [
                      Container(
                        color: Colors.blue,
                        height: 95.3,
                        width: 180,
                        child: Row(
                          children: [
                            Container(
                              width: 100,
                              color: Colors.blue
                            ),
                            IconButton(
                              onPressed: () {
                                if (track1.isNotEmpty) {
                                  _removeWidget(track1.length - 1); // Remove the last widget
                                }
                                track1map.clear();
                              },
                              iconSize: 40,
                              icon: Icon(
                                Icons.restore_from_trash_outlined,
                              ),
                            )
                          ]

                        ),

                      ),
                      Container(

                          height: 95.3,
                          width: 180,
                        child: Row(
                            children: [
                              Container(
                                  width: 100,
                                  color: Colors.red
                              ),
                              IconButton(
                                onPressed: () {
                                  if (track2.isNotEmpty) {
                                    _removeWidget2(track2.length - 1); // Remove the last widget
                                  }
                                },
                                iconSize: 40,
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

                        height: 95.3,
                        width: 180,
                        child: Row(
                            children: [
                              Container(
                                  width: 100,
                                  color: Colors.amber
                              ),
                              IconButton(
                                onPressed: _incrementCounter,
                                iconSize: 40,
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
                  bottom: BorderSide(width: 5, color: Color.fromRGBO(39, 40, 41, 0.9)),

                ),


                ),

                height: 500,
                width: 180,
              ),
            ),
            Container(
            decoration: BoxDecoration(border: Border.all(
                width: 5, color: Color.fromRGBO(39, 40, 41, 0.9)
            ),
                borderRadius: BorderRadius.circular(2)

            ),
            width: 380,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Column(

              children: [
                Container(
                  child: Row(


                  ),
                    height: 25,
                    width: 380,
    decoration: BoxDecoration(border: Border(
        bottom: BorderSide(width: 5, color: Color.fromRGBO(39, 40, 41, 0.8))
    ),

          color: Color.fromRGBO(39, 40,41, 0.8)
    ),

                ),
                Container(
                    child: Row(
                      children: track1,


                    ),
                    color: Color.fromRGBO(97, 103, 122, 0.7),
                    height: 95.3,
                    width: 380

                ),
                Container(

                    child: Row(

                      children: track2,

                    ),

                    height: 95.3,
                    width: 380,
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

                  height: 95.3,
                  width: 380,
                  decoration: BoxDecoration(border: Border(
                    top: BorderSide(width: 5, color: Color.fromRGBO(39, 40, 41, 0.8)),

                  ),

                      color: Color.fromRGBO(97, 103, 122, 0.7),
                  ),
                )
              ]
                ),
            ), //tracklist

              height: 500,

              ),
          ]
        ),
      )
       // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
