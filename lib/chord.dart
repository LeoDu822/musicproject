import 'package:flutter/material.dart';
import 'package:musicproject/savedsession.dart';

import 'dawscreen.dart';

class chordpage extends StatefulWidget {
  const chordpage({super.key, required this.title});

  final String title;

  @override
  State<chordpage> createState() => chordPageState();
}

class chordPageState extends State<chordpage> {
  int _counter = 0;
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

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 40,
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              width: 700,
              height: 100,
              decoration: BoxDecoration(border: Border.all(
                width: 10
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
                  onPressed: _incrementCounter, child: Text("chord"))
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
