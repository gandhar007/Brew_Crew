import 'package:brew_crew/models/user.dart';
import 'package:brew_crew/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService
{
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Create user object based on MyUser?
  MyUser? _userFromFirebase(User user)
  {
    return user != null ? MyUser(uid: user.uid) : null;
  }

  // Auth change user stream
  Stream<MyUser?> get user
  {
    return _auth.authStateChanges()
        .map((User? user) => _userFromFirebase(user!));
  }

  // Sign in anonymously
  Future signInAnon() async
  {
    try{
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _userFromFirebase(user!);
    }
    catch(e)
    {
      return Null;
    }
  }

  // Sign in with email and password
  Future signInEmailPassword (String email, String password) async
  {
    try
    {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return _userFromFirebase(user!);
    }
    catch(e)
    {
      print(e.toString());
      return null;
    }
  }

  // Register with email and password
  Future registerEmailPassword (String email, String password) async
  {
    try
    {
      UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = result.user;

      // Create a new document
      await DatabaseService(uid: user!.uid).updateUserData('0', 'new crew member', 100);

      return _userFromFirebase(user);
    }
    catch(e)
    {
      print(e.toString());
      return null;
    }

  }

  // Sign out
  Future signOut() async
  {
    try
    {
      return _auth.signOut();
    }
    catch(e)
    {
      return null;
    }
  }
}