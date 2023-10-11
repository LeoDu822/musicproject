import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:musicproject/savedsession.dart';


import 'package:flutter/rendering.dart';

import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import 'dart:io';
import 'dawscreen.dart';

class chordpage extends StatefulWidget {
  final File? file;
  chordpage(this.file, this.title);

  final String title;

  @override
  State<chordpage> createState() => chordPageState(file);
}

class chordPageState extends State<chordpage> {
  int _counter = 1;
  int finalChordLength = 0;
  File? _selectedFile;
  Map <String, dynamic> fullchords = {};
  List <Widget> chordbuttons = [];
  String url = "https://newalgorithm.thechosenonech1.repl.co";

  chordPageState(this._selectedFile){
  //  alreadygen = false;
  }


  int chordselect = 0;

  bool alreadygen = false;




  Future<void> fetchChord() async {
    await http.get(Uri.parse('$url/selectChords/$chordselect/$_counter'));
  }

  final player = AudioPlayer();
  String audioFile = '';
  AudioCache audioCache = AudioCache();

  Future<Duration?> _getAudioDuration1(String AF) async {
    player.setSourceDeviceFile(AF);

    Duration? audioDuration = await Future.delayed(
      Duration(seconds: 2),
          () => player.getDuration(),
    );
    return audioDuration;
  }

int filenumber = 0;
  Future<void> fetchFile2() async {
    await http.get(Uri.parse('$url/finalizeChord')).then((r) async{
      print(r.statusCode);

      if (r.statusCode == 200) {
        // Save audio locally
        print("success");
        Directory tempDir = await getTemporaryDirectory();
        print(tempDir);
        ///
        File localAudioFile = File(tempDir.path +'/audio$filenumber.wav');
        filenumber++;
        await localAudioFile.writeAsBytes(await r.bodyBytes);

        setState(() async {

          audioFile = localAudioFile.path;
          print(audioFile);
       //   _getAudioDuration1(audioFile);
          print(player.source);
//upload file, do chords, if it doesnt play fully reload sever and app
          //repeat

//same file reload sever, then it should play,
          player.setSourceDeviceFile(audioFile);
          player.resume();
        
          int? miliseconds = 0;
           await _getAudioDuration1(audioFile).then((value) {
             if (value?.inMilliseconds != null) {
              miliseconds = value?.inMilliseconds;
             }
            
          });

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => dawpage(audioFile, true, miliseconds!)),
          );
        });
      }
    });
  }



  Future<void> fetchFile() async {
    http.MultipartRequest request = http.MultipartRequest(
        'GET', Uri.parse('$url/selectChords/finalizeChord')); //post request to URL/analize
    Map<String, String> headers = {
      "Connection": "Keep-Alive",
      "Keep-Alive": "timeout=5, max=1000"
    };

    request.headers.addAll(headers);

    request.send().then((r) async {

    });
  }



  Future<void> SelectChord() async {
    print("hello trying to select a chord");
    Map<String, String> headers = {
      "Connection": "Keep-Alive",
      "Keep-Alive": "timeout=5, max=1000"
    };


    http.MultipartRequest request = http.MultipartRequest(
        'POST', Uri.parse('$url/selectChords/$chordselect/$_counter')); //post request to URL/analize
    request.headers.addAll(headers);
    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        _selectedFile!.path,
      ),
    );

    await request.send().then((r) async {
      print(r.statusCode);
      if (r.statusCode == 200) {
        r.stream.bytesToString().then((value) {
          print(jsonDecode(value));
          fullchords = jsonDecode(value);

        }
        );

      }
    });
  }


  Future<String> _uploadFileChord() async {
    if (alreadygen == true) {
      return "";
    }
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

    return await request.send().then((r) async {
      print(r.statusCode);
      Map <String, dynamic> tmpfullchords = {};
      if (r.statusCode == 200) {
        return await r.stream.bytesToString().then((value) async {
          print("GOING TO RETURN THIS NOW");

          return value;


        }
        );

      }
      else {
        print("RETURNINGNOTHING");
        return "";
      }

    });





  }

  void _incrementCounter() {
    setState(() {
      if (_counter == finalChordLength+1) {
        _counter+=1;
      }
      if (_counter <= finalChordLength) {
        fetchChord();
        _counter+=1;
        chordbuttons.clear();
      }
      if (_counter == finalChordLength+2) {
        fetchFile2();
      }
    });
  }

  void refreshChordButtons() {
    print(_counter);
    if (fullchords.entries.length > 0) {
      if (fullchords.entries.elementAt(0) != null) {
        finalChordLength = fullchords.entries.length;
        if (finalChordLength >= _counter) {
          print(_counter);
          print(fullchords.entries
              .elementAt(0)
              .value);
          List<dynamic> i = fullchords.entries
              .elementAt(_counter - 1)
              .value;
          print(i);
          for (int x = 0; x < i.length; x++) {
            chordbuttons.add(ElevatedButton(onPressed: () {
              chordselect = x;
              print(chordselect);
            }, child: Text(i.elementAt(x))));
          }
          print(fullchords.entries);
        }
      }
    }

    // for (var i in fullchords.entries) {

    // }
  }


  @override
  Widget build(BuildContext context) {
    print(alreadygen);

    return Scaffold(
        appBar: AppBar(
          shape: Border(
              bottom: BorderSide(
                  color: Color.fromRGBO(74, 67, 77, 1),
                  width: 5
              )
          ),

          backgroundColor: Color.fromRGBO(122, 122, 150, 1),
          toolbarHeight: 40,
        ),
        body: FutureBuilder<String>(
          future: _uploadFileChord(),
          // Call your fetchData function here
          builder: (context, snapshot) {
              // print(fullchords);
              // print(chordbuttons);
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child:
                    CircularProgressIndicator());// Display a loading indicator while waiting for data
              }
              else if (snapshot.hasError) {
                return Text("Error in the data, Retry");
              }
              else if (!snapshot.hasData) {
                return Text("No data, Retry");
              }
              print(snapshot.data);
              print(alreadygen);
              if (alreadygen == false) {
                fullchords = jsonDecode(snapshot.data!);
                alreadygen = true;

              }

              refreshChordButtons();
              return SingleChildScrollView(
              child: Column(

                  children: [
                    Container(
                      margin: EdgeInsets.all(5),
                      width: 700,
                      height: 100,
                      decoration: BoxDecoration(border: Border.all(
                          width: 5
                      ),
                          borderRadius: BorderRadius.circular(12)

                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: chordbuttons,
                        )
                    ),
                  ]
              ),
            );

            }
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'Increment',
          child: const Icon(Icons.arrow_forward),

        )
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
