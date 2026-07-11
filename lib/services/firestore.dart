// Step 6: make a firesore services
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final CollectionReference persons = FirebaseFirestore.instance.collection(
    'persons',
  );

  Future<void> addPerson(String personName, String personEmail, int personAge) {
    return persons.add({
      'personName': personName,
      'personEmail': personEmail,
      'personAge': personAge,
      'createdAt': Timestamp.now(),
    });
  }

  Stream<QuerySnapshot> getPersons() {
    return persons.orderBy('createdAt', descending: true).snapshots();
  }

  Future<Map<String, dynamic>?> getPersonById(String personId) async {
    DocumentSnapshot doc = await persons.doc(personId).get();
    if (doc.exists) {
      return doc.data() as Map<String, dynamic>;
    } else {
      return null;
    }
  }

  Future<void> updatePerson(
    String personId,
    String personName,
    String personEmail,
    int personAge,
  ) {
    return persons.doc(personId).update({
      'personName': personName,
      'personEmail': personEmail,
      'personAge': personAge,
    });
  }

  Future<void> deletePerson(String personId) {
    return persons.doc(personId).delete();
  }
}
