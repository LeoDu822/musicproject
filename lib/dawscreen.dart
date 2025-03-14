import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:musicproject/savedsession.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:musicproject/timer.dart';
import 'package:musicproject/widgets.dart';
import 'chord.dart';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;

class dawpage extends StatefulWidget {
  const dawpage({super.key, required this.title});

  final String title;

  @override
  State<dawpage> createState() => dawPageState();
}

class dawPageState extends State<dawpage> {
  int _counter = 0;
  FileType _pickingType = FileType.custom;
  List<PlatformFile>? _paths;
  String? _fileName;
  String userurl = 'https://leoproject.jackwagner7.repl.co/';
  List<dynamic> _path3D = [];
  List<Widget> track1 = [];
  List<Widget> track2 = [];
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  bool _isLoading = false;

  void initState() {
    super.initState();
    print("Im playing");
  }

  void stoppage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TimerWidget()),
    );
  }

  void _uploadFiletoServer() async {
    var url = userurl + '/fileupload';
    Map<String, String> headers = {
      "Connection": "Keep-Alive",
      "Keep-Alive": "timeout=10, max=1000"
    };

    String? path = _paths![0].path!.substring(1);
    http.MultipartRequest request =
    http.MultipartRequest('POST', Uri.parse('$url'));
    request.headers.addAll(headers);
    request.files.add(
      await http.MultipartFile.fromPath(
        'song',
        path,
        //contentType: MediaType('audio', 'midi'),
      ),
    );

    request.send().then((r) async {
      print(r.statusCode);
      // print(json.decode(await r.stream.transform(utf8.decoder).join()));
      if (r.statusCode == 200) {
        var result = json.decode(await r.stream
            .transform(utf8.decoder)
            .join()); //result is going to be a list,
        print(result);
        _path3D = result;

      } else {
        print("Failed to get the response correctly!");

        // The next line disables the wakelock again.

      }
    });
    String link = _path3D[0].toString();


    // _dbHelper.insertTask(_newTask);
  }


  void _logException(String message) {
    print(message);
    _scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
    _scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }
  void _resetState() {
    if (!mounted) {
      return;
    }
    setState(() {
      _fileName = null;
      _paths = null;
      _isLoading = false;
    });
  }
  void pickFiles() async {

    _resetState();
    try {
      _paths = (await FilePicker.platform.pickFiles(
        type: _pickingType,
        onFileLoading: (FilePickerStatus status) => print(status),
        allowedExtensions: ['.mid'],
      ))
          ?.files;
     // _uploadFiletoServer();
    } catch (e) {
      _logException(e.toString());
    }
  }


  void playsound() {
    print("Hello");
    final player = AudioPlayer();
    player.play(AssetSource('intro.wav'));
  }

  void nextPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => sessionpage(title: "Saved Sessions")),
    );
  }

  void nextpage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => chordpage(title: "daw screen")),
    );
  }

  void addDragable() {
    setState(() {
      track2.add(dawObject(1));
    });
  }

  void _incrementCounter() {
    print("Hello World");
    setState(() {
      track1.add(dawObject(1));
    });
  }

  void _removeWidget(int index) {
    setState(() {
      if (index >= 0 && index < track1.length) {
        track1.removeAt(index);
      }
    });
  }

  void _removeWidget2(int index) {
    setState(() {
      if (index >= 0 && index < track2.length) {
        track2.removeAt(index);
      }
    });
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(50),
          //backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          child: AppBar(title: Row(children: []), actions: <Widget>[
            IconButton(
              onPressed: playsound,
              icon: Icon(Icons.discord),
              iconSize: 20,
            ),
            IconButton(
              icon: Image.asset("assets/stop.png"),
              iconSize: 30,
              onPressed: () {
                stoppage();
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              iconSize: 30,
              onPressed: () {
                if (track1.isNotEmpty) {
                  _removeWidget(track1.length - 1); // Remove the last widget
                }
              },
            ),
            IconButton(
              icon: Icon(Icons.delete_outline),
              iconSize: 30,
              onPressed: () {
                if (track2.isNotEmpty) {
                  _removeWidget2(track2.length - 1); // Remove the last widget
                }
              },
            ),

            TextButton(
                onPressed: () {
                  nextPage();
                },
                child: Text("Saved Sessions")),
            SizedBox(
              width: 250,
            )
          ]),
        ),
        drawer: Container(
          width: 350,
          child: Drawer(
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
                              onPressed: _incrementCounter,
                              child: Text("Saved melodies"),
                            ),
                            ElevatedButton(
                              onPressed: pickFiles,
                              child: Text("Upload"),
                            )
                          ]),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(width: 5),
                                borderRadius: BorderRadius.circular(12),
                                color: Color.fromRGBO(247, 241, 253, 0.4),
                              ),
                              margin: EdgeInsets.fromLTRB(0, 13, 0, 10),
                              height: 100,
                              width: 200,
                            )
                          ]),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ButtonTheme(
                              minWidth: 50,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: () {
                                  nextpage();
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
                          ]),
                    ],
                  ),
                ),
                color: Colors.amber,
              ),
              Container(
                color: Colors.blue,
                height: 143.3,
                width: 400,
                child: Column(children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 5),
                      borderRadius: BorderRadius.circular(12),
                      color: Color.fromRGBO(247, 241, 253, 0.4),
                    ),
                    margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    height: 100,
                    width: 250,
                  )
                ]),
              ),
            ],
          )),
        ),
        body: Row(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
            child: Container(
              child: Column(children: [
                Container(
                  color: Colors.black,
                  height: 95.3,
                  width: 180,
                ),
                Container(
                  height: 95.3,
                  width: 180,
                  decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(width: 5, color: Colors.blue),
                      ),
                      color: Colors.red),
                ),
                Container(
                  height: 95.3,
                  width: 180,
                  decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(width: 5, color: Colors.blue),
                      ),
                      color: Colors.amber),
                ),
              ]),
              decoration: BoxDecoration(
                  border: Border.all(width: 5, color: Colors.blue),
                  borderRadius: BorderRadius.circular(2)),
              height: 500,
              width: 180,
            ),
          ),
          Container(
            decoration: BoxDecoration(
                border: Border.all(width: 5, color: Colors.blue),
                borderRadius: BorderRadius.circular(2)),
            child: Column(children: [
              Container(
                height: 25,
                width: 734,
                decoration: BoxDecoration(
                    border: Border(
                        bottom: BorderSide(width: 5, color: Colors.blue)),
                    color: Colors.pink),
              ),
              Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: track1
                  ),
                  color: Colors.black,
                  height: 95.3,
                  width: 734),
              Container(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: track2),
                height: 95.3,
                width: 734,
                decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(width: 5, color: Colors.blue),
                    ),
                    color: Colors.red),
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                ),
                height: 95.3,
                width: 734,
                decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(width: 5, color: Colors.blue),
                    ),
                    color: Colors.amber),
              )
            ]),
            height: 500,
            width: 734,
          ),
        ]),
      floatingActionButton: FloatingActionButton(onPressed: pickFiles),
        // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}
