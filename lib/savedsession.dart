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

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: Text(widget.title),
      ),
      body: Center(
          child: Column(
             children: [

                 Row(
                   children: [
                     Container(
                         decoration: const BoxDecoration(

                             border: Border(
                               top: BorderSide(color: Colors.white, width: 5),
                               left: BorderSide(color: Colors.white, width: 5),
                               right: BorderSide(color: Colors.white, width: 2.5),
                               bottom: BorderSide(color: Colors.white, width: 2.5),
                             ),
                             color: Colors.yellow
                         ),
                       width: 304.4,
                       height: 157.7,

                     ),
                     Container(
                         decoration: const BoxDecoration(

                             border: Border(
                               top: BorderSide(color: Colors.white, width: 5),
                               left: BorderSide(color: Colors.white, width: 2.5),
                               right: BorderSide(color: Colors.white, width: 2.5),
                               bottom: BorderSide(color: Colors.white, width: 2.5),
                             ),
                             color: Colors.green
                         ),
                         width: 304.4,
                         height: 157.7,

                     ),
                     Container(
                         decoration: const BoxDecoration(

                             border: Border(
                               top: BorderSide(color: Colors.white, width: 5),
                               left: BorderSide(color: Colors.white, width: 2.5),
                               right: BorderSide(color: Colors.white, width: 5),
                               bottom: BorderSide(color: Colors.white, width: 2.5),
                             ),
                             color: Colors.blue
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
                           top: BorderSide(color: Colors.white, width: 2.5),
                           left: BorderSide(color: Colors.white, width: 5),
                           right: BorderSide(color: Colors.white, width: 2.5),
                           bottom: BorderSide(color: Colors.white, width: 5),
                         ),
                         color: Colors.black
                     ),
                       width: 304.4,
                       height: 157.7,

                   ),
                   Container(
                       decoration: const BoxDecoration(

                           border: Border(
                             top: BorderSide(color: Colors.white, width: 2.5),
                             left: BorderSide(color: Colors.white, width: 2.5),
                             right: BorderSide(color: Colors.white, width: 2.5),
                             bottom: BorderSide(color: Colors.white, width: 5),
                           ),
                           color: Colors.grey
                       ),
                       width: 304.4,
                       height: 157.7,

                   ),
                   Container(
                       decoration: const BoxDecoration(

                           border: Border(
                             top: BorderSide(color: Colors.white, width: 2.5),
                             left: BorderSide(color: Colors.white, width: 2.5),
                             right: BorderSide(color: Colors.white, width: 5),
                             bottom: BorderSide(color: Colors.white, width: 5),
                           ),
                           color: Colors.red
                       ),
                       width: 304.4,
                       height: 157.7,

                   )
                 ],
               )
          ]
          )




      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
