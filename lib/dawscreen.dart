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

class dawpage extends StatefulWidget {
  const dawpage({super.key, required this.title});

  final String title;

  @override
  State<dawpage> createState() => dawPageState();
}

enum  MenuItem {
  item1,
  item2,
  item3,
}

class dawPageState extends State<dawpage> {
  final player = AudioPlayer();
  int _counter = 0;
  ScrollController _controller1 = ScrollController();
  ScrollController _controller2 = ScrollController();
  ScrollController _controller3 = ScrollController();
  List<Widget> track1 = [];
  List<Widget> track2 = [];

  Future<void> _selectFile()
  async {
    FilePickerResult? Result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ["mid"]
    );
    if (Result != null)
      {
        print("File received");
      }
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

    print("Hello");
    player.play(AssetSource('intro.wav'));
    player.resume();
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
    setState(() {
      track2.add(dawObject(100));
    });

  }
  void _incrementCounter() {

    print("Hello World");
    setState(() {

     track1.add(dawObject(100));
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
                  stoppage();
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
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => UploadPage()),

                                );
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
          )
        ),
      ),
      backgroundColor: Color.fromRGBO(122, 122, 150, 1),
      body: Row(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 25, 0, 0),
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
          width: 725,
          child: Column(
          children: [
            Container(
              child: Row(


              ),
                height: 25,
                width: 725,
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
                width: 725

            ),
            Container(

                child: Row(

                  children: track2,

                ),

                height: 95.3,
                width: 725,
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
              width: 725,
              decoration: BoxDecoration(border: Border(
                top: BorderSide(width: 5, color: Color.fromRGBO(39, 40, 41, 0.8)),

              ),

                  color: Color.fromRGBO(97, 103, 122, 0.7),
              ),
            )
          ]
            ), //tracklist

            height: 500,

            ),
        ]
      )
       // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
