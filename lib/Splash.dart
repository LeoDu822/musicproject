import 'package:flutter/material.dart';

import 'dawscreen.dart';

class splashpage extends StatefulWidget {
  const splashpage({super.key, required this.title});

  final String title;

  @override
  State<splashpage> createState() => splashPageState();
}

class splashPageState extends State<splashpage> {
  int _counter = 0;

  void nextpage(){
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => dawpage(title: "daw screen")),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: nextpage,
        child: Container(

          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/background.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("COMPSMART", style: TextStyle(
                  fontSize: 70, fontFamily: "Tektur", shadows: [
                      Shadow(
                          blurRadius: 10,
                          // bottomLeft
                          offset: Offset(-1.5, -1.5),
                          color: Colors.white),
                      Shadow(
                          blurRadius: 10,
                          // bottomRight
                          offset: Offset(1.5, -1.5),
                          color: Colors.white),
                      Shadow(
                          blurRadius: 10,
                          // topRight
                          offset: Offset(1.5, 1.5),
                          color: Colors.white),
                      Shadow(
                          blurRadius: 10,
                          // topLeft
                          offset: Offset(-1.5, 1.5),
                          color: Colors.white),
                    ])),
                Image.asset("assets/logo-transparent-png.png", height: 245, alignment: Alignment.topCenter),
                Flexible(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Text("Tap anywhere to begin",
                        style: TextStyle(fontSize: 20, color: Colors.white, fontFamily: "Tektur"),
                        textAlign: TextAlign.center),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
