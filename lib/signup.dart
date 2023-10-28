import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
//import 'package:flutter/material.dart';
//import 'package:flutter_class/Teachers/teacherQuestionare.dart';
//import 'package:flutter_class/widgets.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:musicproject/dawscreen.dart';
import 'package:musicproject/utility.dart';

import 'authentication.dart';
import 'login.dart';
import '../main.dart';
//import '../welcome.dart';
class Signup extends StatefulWidget {
  @override


  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  @override
  late final Characters character;
  bool thisCharacterTeacher = false;
  String Teachercode = "OOOO";
  String CorrectTeacherCode = "";
  FirebaseFirestore db = FirebaseFirestore();


  _SignupState(){

  }

  void refreshTeacherCode() {

  }

  String email = "";
  String password = "";
  Widget build(BuildContext context) {
    refreshTeacherCode();
    return Scaffold(
      appBar: AppBar(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(50),
              bottomRight: Radius.circular(50),
            )
        ),
        toolbarHeight: 250,
        backgroundColor: Colors.blue[100],
        bottomOpacity: 0,
        elevation: 0,
        title:
        Padding(
            padding: const EdgeInsets.only(top: 0.0,),
            child: Image.asset(
              "assets/logo.PNG",
              width: 160,
            )
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0,),
                child: TextField(
                  obscureText: false,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Email',
                  ),
                  onChanged: (String newEntry) {
                    print("Username was changed to $newEntry");
                    email = newEntry;
                  },
                ),
              ),
              const SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.only(top: 10.0,),
                child: TextField(
                  obscureText: false,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Password',
                  ),
                  onChanged: (String newEntry) {
                    print("Username was changed to $newEntry");
                    password = newEntry;
                  },
                ),
              ),
              const SizedBox(height: 20,),
              Visibility(visible:thisCharacterTeacher,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0,),
                    child: TextField(
                      obscureText: false,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Teacher Code',
                      ),
                      onChanged: (String newEntry) {
                        Teachercode = newEntry;
                      },
                    ),
                  ),
              ),
              const SizedBox(height: 20,),

              SizedBox(
                height: 50,
                width: 500,
                child: ElevatedButton(
                  onPressed: (){
                    AuthenticationHelper()
                        .signUp(email: email!, password: password!)
                        .then((result) {
                      if (result == null) {
                        db.collection("users").doc(AuthenticationHelper().uid);
                      }
                      else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                            result,
                            style: TextStyle(fontSize: 16),
                          ),
                        ));
                      }
                    });
                  },
                  child: Text("Sign up",
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: "Metropolis",
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    elevation: 5.0,
                    backgroundColor: Colors.blue[100],
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 5,),
              Text("-or-",
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                  fontSize: 15,
                  fontFamily: "Merriweather",
                ),
              ),
              const SizedBox(height: 5,),
              SizedBox(
                height: 50,
                width: 500,
                child: ElevatedButton(
                  onPressed: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => dawpage(sessionUtility(), "daw screen", false, 100)));
                  },
                  child: Text("Continue With Google",
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      fontSize: 20,
                      fontFamily: "Metropolis",
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    elevation: 5.0,
                    backgroundColor: Colors.lightBlue[900],
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: Colors.transparent,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10,),
              SizedBox(
                height: 50,
                width: 500,
                child: ElevatedButton(
                  onPressed: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Login(),
                        ));
                  },
                  child: Text("Continue With Microsoft",
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                      fontSize: 20,
                      fontFamily: "Metropolis",
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    elevation: 5.0,
                    backgroundColor: Colors.white,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: Colors.grey,
                        width: 2,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10,),
              SizedBox(
                height: 50,
                width: 500,
                child: ElevatedButton(
                  onPressed: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => Login(),
                        ));
                  },
                  child:
                      Text("Continue With Apple",
                        style: TextStyle(
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          fontSize: 20,
                          fontFamily: "Metropolis",
                        ),
                      ),
                  style: ElevatedButton.styleFrom(
                    elevation: 5.0,
                    backgroundColor: Colors.black,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  teacherQuestion(Characters character, uid, String email, String password) {}
}

mixin instance {
}



class FirebaseFirestore {
  collection(String s) {}
}

