import 'package:flutter/material.dart';
import 'package:musicproject/savedsession.dart';

import 'chord.dart';


class dawpage extends StatefulWidget {
  const dawpage({super.key, required this.title});

  final String title;

  @override
  State<dawpage> createState() => dawPageState();
}


class dawPageState extends State<dawpage> {
  int _counter = 0;
  void nextPage(){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => sessionpage(title: "Saved Sessions")),
    );
  }
  void nextpage(){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => chordpage(title: "daw screen")),

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

      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        //backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        child: AppBar(
            title: Row(
               children: [

               ]

            ),
            actions: <Widget>[
              IconButton(
                onPressed: _incrementCounter,
                icon: Image.asset("assets/play.png"),
                iconSize: 20,
              ),

              IconButton(
                icon: Image.asset("assets/stop.png"),
                iconSize: 30,
                onPressed: ()
                {

                },
              ),
              TextButton(
                  onPressed: (){

                    nextPage();
                  },
                  child: Text("Saved Sessions")
              ),
              SizedBox(
                width: 250,
              )
            ]

          ),
        ),
      drawer: Drawer(
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
                            onPressed: _incrementCounter,
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
                              color: Color.fromRGBO(247, 241, 253, 0.4),
                            ),
                            margin: EdgeInsets.fromLTRB(0, 13, 0, 10),
                            height:100,
                            width: 200,
                          )
                        ]
                    ),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          ElevatedButton(
                            onPressed: (){

                              nextpage();
                            },
                            child: Text("Chords"),

                          ),

                          ElevatedButton(
                            onPressed: _incrementCounter,
                            child: Text("Play"),
                          )
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
                        color: Color.fromRGBO(247, 241, 253, 0.4),
                      ),
                      margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
                      height:100,
                      width: 250,
                    )
                  ]
                ),
              ),

          ],
        )
      ),
      body: Row(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 25, 0, 0),
            child: Container(
              child: Column(
                  children: [
                    Container(
                      color: Colors.black,
                      height: 100,
                      width: 180
                    ),
                    Container(
                        color: Colors.red,
                        height: 100,
                        width: 180
                    )
                  ]
                ),

              decoration: BoxDecoration(
                color: Colors.amber,
                border: Border(
                  right: BorderSide(color: Color(0xFF7F7F7F),
                  width: 13),
                )
              ),

              height: 500,
              width: 180,
            ),
          ),
          Container(
            child: Column(
              children: [
                Container(
                    color: Colors.pink,
                    height: 25,
                    width: 734
                ),
                Container(
                    color: Colors.black,
                    height: 100,
                    width: 734
                ),
                Container(
                    color: Colors.red,
                    height: 100,
                    width: 734
                )
              ]
            ),
              color: Colors.blue,
              height: 500,
              width: 734,
          ),
        ]
      )
       // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
