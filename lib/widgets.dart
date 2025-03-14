import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
//import 'linePainter.dart';

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
      child: Align(
        alignment: Alignment.topLeft,
        child: IconButton(onPressed: () {print("Something");}, icon: Icon(Icons.close),),
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
