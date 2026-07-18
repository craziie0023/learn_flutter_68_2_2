// Step 2 : Install Loading app screen
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:connectivity_plus/connectivity_plus.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:learn_flutter_68_2_2/services/firestore.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  @override
  //อะไรที่อยากจะให้ทำงานตอนเริ่มต้น ให่ใส่อันนี้
  void initState() {
    super.initState();

    checkInternetConnection();
  }

  void checkInternetConnection() async {
    final List<ConnectivityResult> connectivityResult = await (Connectivity()
        .checkConnectivity());

    // This condition is for demo purposes only to explain every connection type.
    // Use conditions which work for your requirements.
    if (connectivityResult.contains(ConnectivityResult.mobile)) {
      // Mobile network available.
      showToast(context, "Mobile network available.");
    } else if (connectivityResult.contains(ConnectivityResult.wifi)) {
      // Wi-fi is available.
      showToast(context, "Wi-fi is available.");
      // Note for Android:
      // When both mobile and Wi-Fi are turned on system will return Wi-Fi only as active network type
    } else if (connectivityResult.contains(ConnectivityResult.ethernet)) {
      // Ethernet connection available.
      showToast(context, "Ethernet connection available.");
    } else if (connectivityResult.contains(ConnectivityResult.vpn)) {
      // Vpn connection active.
      // Note for iOS and macOS:
      showToast(context, "Vpn connection active.");
      // There is no separate network interface type for [vpn].
      // It returns [other] on any device (also simulator)
    } else if (connectivityResult.contains(ConnectivityResult.bluetooth)) {
      // Bluetooth connection available.
      showToast(context, "Bluetooth connection available.");
    } else if (connectivityResult.contains(ConnectivityResult.satellite)) {
      // Carrier-provided satellite network available
      showToast(context, "Satellite network available.");
    } else if (connectivityResult.contains(ConnectivityResult.other)) {
      // Connected to a network which is not in the above mentioned networks.
      showToast(
        context,
        "Connected to a network which is not in the above mentioned networks.",
      );
    } else if (connectivityResult.contains(ConnectivityResult.none)) {
      // No available network types
      showToast(context, "No available network types.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepPurple, Colors.cyanAccent],
          begin: FractionalOffset(0, 0),
          end: FractionalOffset(0.5, 0.6),
          tileMode: TileMode.mirror,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Center(child: Image.asset("./android/assets/image/spin.png")),
          const SizedBox(height: 20),
          const SpinKitSpinningLines(color: Colors.pinkAccent),
        ],
      ),
    );
  }
}

// class SecondScreen extends StatelessWidget {
//   const SecondScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Second Screen")),
//       body: Center(
//         child: Text(
//           "This is a second screen.",
//           style: TextStyle(
//             fontSize: 24,
//             color: Colors.amberAccent,
//             fontWeight: FontWeight.w500,
//             fontFamily: "Alike",
//           ),
//         ),
//       ),
//     );
//   }
// }

//Step 4: Showtoast message
void _timer(BuildContext context) {
  // เมื่อครบ 3 วิให้ไปหน้า SecondScreen
  Timer(
    Duration(seconds: 3),
    () => Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SecondScreen()),
    ),
  );
}

//Step 4: Show toast message
void showToast(BuildContext context, String message) {
  Fluttertoast.showToast(
    msg: message,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.lightGreenAccent,
    textColor: Colors.black,
    fontSize: 24,
  );
}

void showdialog(BuildContext context, String title, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(message),
        actions: <Widget>[
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text(
              'Close',
              style: TextStyle(
                color: Color.fromARGB(255, 0, 112, 150),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      );
    },
  );
}

class SecondScreen extends StatefulWidget {
  const SecondScreen({super.key});

  @override
  State<SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  final FirestoreService firestoreService = FirestoreService();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  void openPersonBox(String? personID) async {
    if (personID != null) {
      final person = await firestoreService.getPersonById(personID);
      nameController.text = person?['personName'] ?? '';
      emailController.text = person?['personEmail'] ?? '';
      ageController.text = person?['personAge']?.toString() ?? '';
    } else {
      nameController.clear();
      emailController.clear();
      ageController.clear();
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: ageController,
              decoration: const InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = nameController.text;
              final email = emailController.text;
              final age = int.tryParse(ageController.text) ?? 0;

              if (personID != null) {
                firestoreService.updatePerson(personID, name, email, age);
              } else {
                firestoreService.addPerson(name, email, age);
              }

              nameController.clear();
              emailController.clear();
              ageController.clear();

              Navigator.of(context).pop();
            },
            child: Text(personID != null ? 'Update' : 'Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Persons List"),
        automaticallyImplyLeading: false,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => openPersonBox(null),
        child: Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getPersons(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final personsList = snapshot.data!.docs;
            return ListView.builder(
              itemCount: personsList.length,
              itemBuilder: (context, index) {
                DocumentSnapshot personDoc = personsList[index];
                String personID = personDoc.id;

                Map<String, dynamic> personData =
                    personDoc.data() as Map<String, dynamic>;

                String nameText = personData['personName'] ?? '';
                String emailText = personData['personEmail'] ?? '';
                int ageText = personData['personAge'] ?? 0;

                return ListTile(
                  title: Text(nameText),
                  subtitle: Text('Email: $emailText, Age: $ageText'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () => openPersonBox(personID),
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          firestoreService.deletePerson(personID);
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return Center(child: Text("No persons found."));
          }
        },
      ),
    );
  }
}
