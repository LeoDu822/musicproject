import 'package:flutter/material.dart';
import 'package:musicproject/savedsession.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:musicproject/timer.dart';
import 'chord.dart';


class dawpage extends StatefulWidget {
  const dawpage({super.key, required this.title});

  final String title;

  @override
  State<dawpage> createState() => dawPageState();
}


class dawPageState extends State<dawpage> {

  int _counter = 0;
  List<Widget> track1 = [];
  List<Widget> track2 = [];
  void initState()  {
    super.initState();
    print("Im playing");
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
    print("Hello");
    final player = AudioPlayer();
    player.play(AssetSource('intro.wav'));
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
      MaterialPageRoute(builder: (context) => chordpage(title: "daw screen")),

    );
  }

  void addDragable()
  {
    setState(() {
      track1.add(
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: 28.5,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(onPressed: (){

                      }, icon: Icon(Icons.arrow_upward))
                    ]
                  ),
                ),
                Container(
                  height: 28.4,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                      IconButton(onPressed: (){print("something");}, icon: Icon(Icons.arrow_left)),
                        IconButton(onPressed: (){print("something");}, icon: Icon(Icons.arrow_right))

                        ]
                  ),
                ),
                Container(
                  height: 28.4,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(onPressed: (){print("something");}, icon: Icon(Icons.arrow_downward))
                      ]
                  ),
                )
              ]
            ),
            decoration: BoxDecoration(
              border: Border.all(width: 5),
              borderRadius: BorderRadius.circular(12),
              color: Color.fromRGBO(247, 241, 253, 0.4),
            ),

            height:95.3,
            width: 200,
          )
      );
    });

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
                onPressed: playsound,
                icon: Image.asset("assets/play.png"),
                iconSize: 20,
              ),

              IconButton(
                icon: Image.asset("assets/stop.png"),
                iconSize: 30,
                onPressed: ()
                {
                  stoppage();
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

                            ButtonTheme(
                              minWidth: 50,
                              height: 50,
                              child: ElevatedButton(
                                onPressed: (){

                                  nextpage();
                                },
                                child: Text("Chords"),

                              ),
                            ),

                            ElevatedButton(
                              onPressed: _incrementCounter,
                              child: Text("Play"),
                            ),
                            ElevatedButton(
                              onPressed: addDragable,
                              child: Text("Add to track"),
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
                      height: 95.3,
                      width: 180,

                    ),
                    Container(

                        height: 95.3,
                        width: 180,
                        decoration: BoxDecoration(border: Border(

                    top: BorderSide(width: 5, color: Colors.blue),

            ),

        color: Colors.red
    ),
                    ),
                    Container(

                      height: 95.3,
                      width: 180,
                      decoration: BoxDecoration(border: Border(

                          top: BorderSide(width: 5, color: Colors.blue),

                      ),

                          color: Colors.amber
                      ),
                    ),
                  ]
                ),

              decoration: BoxDecoration(border: Border.all(
                  width: 5, color: Colors.blue
              ),
                  borderRadius: BorderRadius.circular(2)

              ),

              height: 500,
              width: 180,
            ),
          ),
          Container(
            decoration: BoxDecoration(border: Border.all(
                width: 5, color: Colors.blue
            ),
                borderRadius: BorderRadius.circular(2)

            ),
            child: Column(
              children: [
                Container(

                    height: 25,
                    width: 734,
    decoration: BoxDecoration(border: Border(
      bottom: BorderSide(width: 5, color: Colors.blue)
    ),

        color: Colors.pink
    ),

                ),
                Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      //children: track1
                    ),
                    color: Colors.black,
                    height: 95.3,
                    width: 734

                ),
                Container(

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                        children: track1

                    ),

                    height: 95.3,
                    width: 734,
    decoration: BoxDecoration(border: Border(
        top: BorderSide(width: 5, color: Colors.blue),

    ),

    color: Colors.red
    ),
                ),
                Container(

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,


                  ),

                  height: 95.3,
                  width: 734,
                  decoration: BoxDecoration(border: Border(
                    top: BorderSide(width: 5, color: Colors.blue),

                  ),

                      color: Colors.amber
                  ),
                )
              ]
            ),

              height: 500,
              width: 734,
          ),
        ]
      )
       // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
