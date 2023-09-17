import 'package:brew_crew/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/brew.dart';

class DatabaseService
{
  final String uid;
  DatabaseService({required this.uid});

  // Collection Reference
  final CollectionReference brewCollection = FirebaseFirestore.instance.collection('brews');

  Future updateUserData(String sugars, String name, int strength) async {
    return await brewCollection.doc(uid).set({
      'sugars' : sugars,
      'name' : name,
      'strength' : strength
    });
  }

  // Brew List from snapshot
  List<Brew>? _brewListFromSnapshot(QuerySnapshot snapshot)
  {
    return snapshot.docs.map((doc) {
      return Brew(
          name: doc.get('name'),
          sugars: doc.get('sugars'),
          strength: doc.get('strength')
      );
    }).toList();
  }

  // Get brews stream
  Stream<List<Brew>?> get brews {
    return brewCollection.snapshots().map(_brewListFromSnapshot);
  }

  // userData from snapshot
  UserData _userDataFromSnapshot(DocumentSnapshot snapshot) {
    return UserData(uid: uid, name: snapshot.get('name'), sugars: snapshot.get('sugars'), strength: snapshot.get('strength'));
  }

  // Get user doc stream
  Stream<UserData> get userData {
    return brewCollection.doc(uid).snapshots().
    map(_userDataFromSnapshot);
  }
}