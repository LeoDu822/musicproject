import 'package:flutter/material.dart';
import 'package:musicproject/signup.dart';
import 'package:musicproject/utility.dart';
//import 'package:flutter_class/Accounts/changePasswords.dart';
//import 'package:flutter_class/Accounts/signup.dart';
//import 'package:flutter_class/welcome.dart';
import 'authentication.dart';
import '../main.dart';
import 'dawscreen.dart';
class Login extends StatefulWidget{

  Login();

  @override
  State<Login> createState() => _LoginState();




}

class _LoginState extends State<Login> {
  late final Characters character;
  _LoginState();
  String email = "";
  String password = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: SingleChildScrollView(
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
              SizedBox(
                height: 50,
                width: 500,
                child: ElevatedButton(
                  onPressed: (){
                    AuthenticationHelper()
                        .signIn(email: email!, password: password!)
                        .then((result) {
                          if (result == null) {
                            Navigator.pushReplacement(context,
                                MaterialPageRoute(builder: (context) => dawpage(sessionUtility(), 'My Home Page', false, 0)));
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
                  child: Text("Log in",
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

            ],
        ),
          ),
        ),
      ),
    );
  }
}
