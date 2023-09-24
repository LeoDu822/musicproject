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
    _uploadFileChord();
    for (var i in fullchords.entries) {
      for (int x = 0; x < i.value.length; x++) {
        chordbuttons.add(ElevatedButton(onPressed: () {
          //print("Hello");
        }, child: Text(i.value[x])));
      }
    }

  }


  int chordselect = 0;




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


  Future<void> fetchFile2() async {
    await http.get(Uri.parse('$url/finalizeChord')).then((r) async{
      print(r.statusCode);

      if (r.statusCode == 200) {
        // Save audio locally
        print("success");
        Directory tempDir = await getTemporaryDirectory();
        print(tempDir);
        File localAudioFile = File('${tempDir.path}/audio.wav');

        await localAudioFile.writeAsBytes(await r.bodyBytes);

        setState(() {
          audioFile = localAudioFile.path;
          print(audioFile);
       //   _getAudioDuration1(audioFile);
          print(player.source);
//upload file, do chords, if it doesnt play fully reload sever and app
          //repeat

//same file reload sever, then it should play,
          player.setSourceDeviceFile(audioFile);
          player.resume();
        
          int miliseconds = 0;
           await _getAudioDuration1(audioFile).then((value) {
            miliseconds = value?.inMilliseconds;
          });

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => dawpage(audioFile, true, miliseconds)),
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


  Future<void> _uploadFileChord() async {
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

    await request.send().then((r) async {
      print(r.statusCode);
      Map <String, dynamic> tmpfullchords = {};
      if (r.statusCode == 200) {
        r.stream.bytesToString().then((value) {
          print(jsonDecode(value));
          fullchords = jsonDecode(value);

        }
        );

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

        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => dawpage(title: "dawpage")),
        //
        // );
      }
    });
  }

  void refreshChordButtons() {
    print(_counter);
    if (fullchords.entries.length > 0) {
      if (fullchords.entries.elementAt(1) != null) {
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


  Future<Map<String, dynamic>> fetchHW() async {
    print(_selectedFile!.path);
    Map<String, dynamic> snapshot = {};
    print("going here");
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

    await request.send().then((r) async {
      print(r.statusCode);
      Map <String, dynamic> tmpfullchords = {};
      if (r.statusCode == 200) {
        print("im sucessfull");
        request.files.clear();
        return r.stream.bytesToString();
        print("passing this lol");
      }
    });
    print("not Retuning anything");
    // Replace 'collectionName' with your actual collection name
    return snapshot;
  }

  //FutureBuilder
  /*
  FutureBuilder<Map<String, dynamic>>(
                  future: fetchHW(),
                  // Call your fetchData function here
                  builder: (context, snapshot) {

                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {

                      List<Widget> asd = [];
                      asd.add(Center(
                          child:
                          CircularProgressIndicator()));

                      return Row(mainAxisAlignment: MainAxisAlignment.center, children: asd);// Display a loading indicator while waiting for data
                    } else if (snapshot.hasError) {
                      List<Widget> asd = [];
                      asd.add(Center(
                          child: Text(
                              'Error fetching data')));

                      return Row(mainAxisAlignment: MainAxisAlignment.center, children: asd);// Display an error message if data fetching fails
                    } else if (!snapshot.hasData) {
                      List<Widget> asd = [];
                      asd.add(Center(
                          child: Text(
                              'No data available')));

                      return Row(mainAxisAlignment: MainAxisAlignment.center, children: asd);// Display a message if no data is available
                    } else {
                      List<Widget> asd = [];
                      print(snapshot.data);
                      List<dynamic> i = snapshot.data!.entries.elementAt(_counter).value;
                      for (int x = 0; x < i.length; x++) {
                        chordbuttons.add(ElevatedButton(onPressed: () {
                          //print("Hello");
                        }, child: Text(i.elementAt(x))));
                      }

                      asd=chordbuttons;

                      return Row(mainAxisAlignment: MainAxisAlignment.center, children: asd);
                    }})
   */



  @override
  Widget build(BuildContext context) {
    refreshChordButtons();
    print(fullchords);
    print(chordbuttons);
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
        body: SingleChildScrollView(
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
                // Padding(
                //   padding: const EdgeInsets.all(20.0),
                //   child: Row(
                //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //       children: [
                //         ElevatedButton(
                //             onPressed: _incrementCounter, child: Text("chord")),
                //         ElevatedButton(
                //             onPressed: _incrementCounter, child: Text("chord")),
                //         ElevatedButton(
                //             onPressed: _incrementCounter, child: Text("chord")),
                //
                //         ElevatedButton(
                //             onPressed: _incrementCounter, child: Text("chord")),
                //
                //       ]
                //
                //   ),
                //
                //
                // ),
                // Padding(
                //   padding: const EdgeInsets.all(20.0),
                //   child: Row(
                //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //       children: [
                //         ElevatedButton(
                //             onPressed: _incrementCounter, child: Text("chord")),
                //         ElevatedButton(
                //             onPressed: _incrementCounter, child: Text("chord")),
                //         ElevatedButton(
                //             onPressed: _incrementCounter, child: Text("chord")),
                //
                //         ElevatedButton(
                //             onPressed: _incrementCounter, child: Text("chord")),
                //
                //       ]
                //
                //   ),
                //
                //
                // ),
                // Padding(
                //   padding: const EdgeInsets.all(20.0),
                //   child: Row(
                //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //       children: [
                //         ElevatedButton(
                //             onPressed: _incrementCounter, child: Text("chord")),
                //         ElevatedButton(
                //             onPressed: _incrementCounter, child: Text("chord")),
                //         ElevatedButton(
                //             onPressed: _incrementCounter, child: Text("chord")),
                //
                //         ElevatedButton(
                //             onPressed: _incrementCounter, child: Text("chord")),
                //
                //       ]
                //
                //   ),
                //
                //
                // )
              ]
          ),
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
