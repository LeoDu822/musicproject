import 'package:flutter/material.dart';

class sessionpage extends StatefulWidget {
  const sessionpage({super.key, required this.title});

  final String title;

  @override
  State<sessionpage> createState() => sessionPageState();
}

class sessionPageState extends State<sessionpage> {
  int _counter = 0;

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

        backgroundColor: Color.fromRGBO(122, 122, 150, 0.7),

        title: Text(widget.title),
      ),
      body: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                 children: [

                     Row(
                       children: [
                         Container(
                             decoration: const BoxDecoration(

                                 border: Border(
                                   top: BorderSide(color: Color.fromRGBO(39, 40,41, 0.8), width: 5),
                                   left: BorderSide(color: Color.fromRGBO(39, 40,41, 0.8), width: 5),
                                   right: BorderSide(color: Color.fromRGBO(39, 40,41, 0.8), width: 2.5),
                                   bottom: BorderSide(color: Color.fromRGBO(39, 40,41, 0.8), width: 2.5),
                                 ),
                                 color: Color.fromRGBO(122, 122, 150, 1)
                             ),
                           width: 304.4,
                           height: 157.7,

                         ),
                         Container(
                             decoration: const BoxDecoration(

                                 border: Border(
                                   top: BorderSide(color: Color.fromRGBO(39, 40,41, 0.8), width: 5),
                                   left: BorderSide(color: Color.fromRGBO(39, 40,41, 0.8), width: 2.5),
                                   right: BorderSide(color: Color.fromRGBO(39, 40,41, 0.8), width: 2.5),
                                   bottom: BorderSide(color: Color.fromRGBO(39, 40,41, 0.8), width: 2.5),
                                 ),
                                 color: Color.fromRGBO(122, 122, 150, 1)
                             ),
                             width: 304.4,
                             height: 157.7,

                         ),
                         Container(
                             decoration: const BoxDecoration(

                                 border: Border(
                                   top: BorderSide(color: Color.fromRGBO(39, 40,41, 0.8), width: 5),
                                   left: BorderSide(color: Color.fromRGBO(39, 40,41, 0.8), width: 2.5),
                                   right: BorderSide(color: Color.fromRGBO(39, 40,41, 0.8), width: 5),
                                   bottom: BorderSide(color: Color.fromRGBO(39, 40,41, 0.8), width: 2.5),
                                 ),
                                 color: Color.fromRGBO(122, 122, 150, 1)
                             ),
                             width: 304.4,
                             height: 157.7,

                         )
                       ],
                     ),
                   Row(
                     children: [
                       Container(
                         decoration: const BoxDecoration(

                             border: Border(
                               top: BorderSide(color: Color.fromRGBO(39, 40,41, 0.8), width: 2.5),
                               left: BorderSide(color: Color.fromRGBO(39, 40,41, 0.8), width: 5),
                               right: BorderSide(color: Color.fromRGBO(39, 40,41, 0.8), width: 2.5),
                               bottom: BorderSide(color: Color.fromRGBO(39, 40,41, 0.8), width: 5),
                             ),
                             color: Color.fromRGBO(122, 122, 150, 1)
                         ),
                           width: 304.4,
                           height: 157.7,

                       ),
                       Container(
                           decoration: const BoxDecoration(

                               border: Border(
                                 top: BorderSide(color: Color.fromRGBO(39, 40,41, 0.8), width: 2.5),
                                 left: BorderSide(color: Color.fromRGBO(39, 40,41, 0.8), width: 2.5),
                                 right: BorderSide(color: Color.fromRGBO(39, 40,41, 0.8), width: 2.5),
                                 bottom: BorderSide(color: Color.fromRGBO(39, 40,41, 0.8), width: 5),
                               ),
                               color: Color.fromRGBO(122, 122, 150, 1)
                           ),
                           width: 304.4,
                           height: 157.7,

                       ),
                       Container(
                           decoration: const BoxDecoration(

                               border: Border(
                                 top: BorderSide(color: Color.fromRGBO(39, 40,41, 0.8), width: 2.5),
                                 left: BorderSide(color: Color.fromRGBO(39, 40,41, 0.8), width: 2.5),
                                 right: BorderSide(color: Color.fromRGBO(39, 40,41, 0.8), width: 5),
                                 bottom: BorderSide(color: Color.fromRGBO(39, 40,41, 0.8), width: 5),
                               ),
                               color: Color.fromRGBO(122, 122, 150, 1)
                           ),
                           width: 304.4,
                           height: 157.7,

                       )
                     ],
                   )
              ]
              ),
            ),
          )




      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
