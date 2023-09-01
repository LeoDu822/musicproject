import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:musicproject/savedsession.dart';


import 'package:flutter/rendering.dart';

import 'dart:async';
import 'package:http/http.dart' as http;

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
  int _counter = 0;
  File? _selectedFile;
  Map <String, dynamic> fullchords = {};
  List <Widget> chordbuttons = [];
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
  void nextPage(){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => dawpage(title: "Saved Sessions")),
    );
  }
  void _incrementCounter() {
    setState(() {
      SelectChord();
      _counter+=1;
    });
  }


  int chordselect = 0;


  Future<void> SelectChord() async {
    print("hello trying to select a chord");
    var url = 'https://leodubackendmusicproject.jackwagner7.repl.co'; // AWS/ec2 host
    print(url);
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
    var url = 'https://leodubackendmusicproject.jackwagner7.repl.co'; // AWS/ec2 host
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


  void refreshChordButtons() {
    for (var i in fullchords.entries) {
      for (int x = 0; x < i.value.length; x++) {
        chordbuttons.add(ElevatedButton(onPressed: () {

          chordselect = x;
          print(chordselect);
        }, child: Text(i.value[x])));
      }
    }
  }


  Future<Map<String, dynamic>> fetchHW() async {
    print(_selectedFile!.path);
    Map<String, dynamic> snapshot = {};
    print("going here");
    var url = 'https://leodubackendmusicproject.thechosenonech1.repl.co'; // AWS/ec2 host
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
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        onPressed: _incrementCounter, child: Text("chord")),
                    ElevatedButton(
                        onPressed: _incrementCounter, child: Text("chord")),
                    ElevatedButton(
                        onPressed: _incrementCounter, child: Text("chord")),

                    ElevatedButton(
                        onPressed: _incrementCounter, child: Text("chord")),

                  ]

              ),


            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        onPressed: _incrementCounter, child: Text("chord")),
                    ElevatedButton(
                        onPressed: _incrementCounter, child: Text("chord")),
                    ElevatedButton(
                        onPressed: _incrementCounter, child: Text("chord")),

                    ElevatedButton(
                        onPressed: _incrementCounter, child: Text("chord")),

                  ]

              ),


            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        onPressed: _incrementCounter, child: Text("chord")),
                    ElevatedButton(
                        onPressed: _incrementCounter, child: Text("chord")),
                    ElevatedButton(
                        onPressed: _incrementCounter, child: Text("chord")),

                    ElevatedButton(
                        onPressed: _incrementCounter, child: Text("chord")),

                  ]

              ),


            )
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
