import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'linePainter.dart';

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


  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
