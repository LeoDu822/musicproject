import 'package:flutter/material.dart';

class melodypage extends StatefulWidget {
  const melodypage({super.key, required this.title});

  final String title;

  @override
  State<melodypage> createState() => melodyPageState();
}

class melodyPageState extends State<melodypage> {
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
          shape: Border(
              bottom: BorderSide(
                  color: Color.fromRGBO(74, 67, 77, 1),
                  width: 5
              )
          ),

          backgroundColor: Color.fromRGBO(122, 122, 150, 1),
          toolbarHeight: 40,
        ),
        body: SingleChildScrollView(
          child: Column(

              children: [

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                        children: [
                           Row(
                             children: [
                              Container(
                                  decoration: const BoxDecoration(

                                      border: Border(
                                        bottom: BorderSide(color: Color.fromRGBO(39, 40,41, 0.8), width: 5),
                                      ),
                                      color: Colors.grey
                                  ),
                                width: 913.2,
                                height: 80,

                              )
                             ]
                           ),
                          Row(
                              children: [
                                Container(
                                    decoration: const BoxDecoration(

                                        border: Border(
                                          bottom: BorderSide(color: Color.fromRGBO(39, 40,41, 0.8), width: 5),
                                        ),
                                        color: Colors.grey
                                    ),
                                    width: 913.2,
                                    height: 80,

                                )
                              ]
                          ),
                          Row(
                              children: [
                                Container(
                                  decoration: const BoxDecoration(

                                      border: Border(
                                        bottom: BorderSide(color: Color.fromRGBO(39, 40,41, 0.8), width: 5),
                                      ),
                                      color: Colors.grey
                                  ),
                                    width: 913.2,
                                    height: 80,

                                )
                              ]
                          ),
                          Row(
                              children: [
                                Container(
                                  decoration: const BoxDecoration(

                                      border: Border(
                                        bottom: BorderSide(color: Color.fromRGBO(39, 40,41, 0.8), width: 5),
                                      ),
                                      color: Colors.grey
                                  ),
                                    width: 913.2,
                                    height: 80,

                                )
                              ]
                          ),
                          Row(
                              children: [
                                Container(
                                  decoration: const BoxDecoration(

                                      border: Border(
                                        bottom: BorderSide(color: Color.fromRGBO(39, 40,41, 0.8), width: 5),
                                      ),
                                      color: Colors.grey
                                  ),
                                  width: 913.2,
                                  height: 80,

                                )
                              ]
                          ),
                          Row(
                              children: [
                                Container(
                                  decoration: const BoxDecoration(

                                      border: Border(
                                        bottom: BorderSide(color: Color.fromRGBO(39, 40,41, 0.8), width: 5),
                                      ),
                                      color: Colors.grey
                                  ),
                                  width: 913.2,
                                  height: 80,

                                )
                              ]
                          )

                        ]

                  ),
              )
              ]
          ),
        ),

      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
