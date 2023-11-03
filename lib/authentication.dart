//Code Provided by https://www.bacancytechnology.com/blog/email-authentication-using-firebase-auth-and-flutter
import 'package:firebase_auth/firebase_auth.dart';



class AuthenticationHelper {
  final FirebaseAuth _auth = FirebaseAuth.instance;


  bool hasSignedIn = false;

  get user => _auth.currentUser;
  get uid => user.uid;

  get currentUser => user;




  //creates a new user with email and password
  Future signUp({required String email, required String password}) async {
    //print(uid);
    hasSignedIn = true;

    try {

      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

    } on FirebaseAuthException catch (e) {
      return e.message;
    }

  }

  String getUID() {
    return user.uid;
  }

  //SIGN IN METHOD
  Future signIn({required String email, required String password}) async {
    hasSignedIn = true;

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      // print(uid);
      // print(email);
      // print(password);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  //SIGN OUT METHOD
  Future signOut() async {
    await _auth.signOut();

    print('signout');
  }
}

