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
  chordPageState(this._selectedFile);
  void nextPage(){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => dawpage(title: "Saved Sessions")),
    );
  }
  void _incrementCounter() {

    print("Hello World");
    setState(() {

      _counter+=2;
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


  @override
  Widget build(BuildContext context) {

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
