import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

//get current user
  User? getCurrentUser() {
    return firebaseAuth.currentUser;
  }

  // email sign in
  Future<UserCredential> signInWithEmailPassword(String email, password) async {
    try {
      UserCredential userCredential =
       await firebaseAuth.signInWithEmailAndPassword(
        email: email, 
        password: password);
    
      return userCredential;
    } on FirebaseAuthException catch(e) {
      throw Exception(e.code);
    }
  }
// email sign up
  Future<UserCredential> signUpWithEmailPassword(String email, password) async {
    try {
      UserCredential userCredential =
       await firebaseAuth.createUserWithEmailAndPassword(
        email: email, 
        password: password);
    
      return userCredential;
    } on FirebaseAuthException catch(e) {
      throw Exception(e.code);
    }
  }

  //sign out
  Future<void> signOut() async {
    return await firebaseAuth.signOut();
  }

  //googleAuth
  signInWithGoogle() async {
    //interactive sign in process
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    //if user cancels the gAuth popup
    if (googleUser == null) return;

    //obtain auth details from req
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    //create a new credential for user
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    //sign in
    return await firebaseAuth.signInWithCredential(credential);
  }

}