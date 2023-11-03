import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:musicproject/utility.dart';

import 'dawscreen.dart';


class dawObject extends StatelessWidget {
  late final int time;

  List<dynamic> myJson = [];

  dawObject(this.time);

  void playsound() {
    print("Hello");
    final player = AudioPlayer();
    player.setSource(AssetSource('intro.wav'));
    print(player.getDuration().then((value) => print(value?.inSeconds)));
    player.resume();
  }
  void right()
  {

  }
  void left()
  {

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [

            Container(
              height: 28.4,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(onPressed: (){print("something");}, icon: Icon(Icons.arrow_left)),
                    IconButton(onPressed: (){print("something");}, icon: Icon(Icons.arrow_right))

                  ]
              ),
            ),

          ]
      ),
      decoration: BoxDecoration(
        border: Border.all(width: 4),
        borderRadius: BorderRadius.circular(12),
        color: Color.fromRGBO(247, 241, 253, 0.4),
      ),

      height:95.3,
      width: 200,
    );
  }
}


class sessionObject extends StatelessWidget{
  late sessionUtility session;
  late String title;
  sessionObject(this.title, this.session);
  @override
  Widget build(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;
    double deviceLength = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        print("opening dawpage Now");

        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => dawpage(this.session, this.session.currentLocalFile, true, 100)),
        );

      },
      child: Container(
        decoration: const BoxDecoration(

            border: Border(
              top: BorderSide(color: Colors.white, width: 5),
              left: BorderSide(color: Colors.white, width: 2.5),
              right: BorderSide(color: Colors.white, width: 2.5),
              bottom: BorderSide(color: Colors.white, width: 2.5),
            ),
            color: Colors.green
        ),
        width: deviceWidth / 3,
        height: deviceLength / 3,
        child: Center(
          child: Text(title),
        ),
      ),
    );
  }
}