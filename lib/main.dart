import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);

  runApp(MyApp());
}

class MyApp extends StatelessWidget { 
  
  
   @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: AuthenticationScreen(),
    );
  }
}

class AuthenticationScreen extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Online Voting System'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          },
          child: Text('Login'),
        ),
      ),
    );
  }
}

class LoginScreen extends StatelessWidget {
  String?votePerson;
  
  final firestoreInstance=FirebaseFirestore.instance;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      
    //  body: Center(
         
     //   child: ElevatedButton(
        //  onPressed: () {
        //    Navigator.push(
        //      context,
        //      MaterialPageRoute(builder: (context) => BallotScreen()),
        //    );
        //  },
        //  child: Text('Login'),
       // ),
     // ),
     body: Column(
      children: [
        TextField(decoration: InputDecoration(hintText: "enter the name"),
        onChanged: (value){
         votePerson=value;
        }  ,),
        ElevatedButton(
          onPressed: ()async {
            await firestoreInstance.collection("votes").doc().set(
                  {
                    "voted person":votePerson,
                  }
                );
          Navigator.push(
           context,
            MaterialPageRoute(builder: (context) => BallotScreen()),
           );
        },
          child: Text('Login'),
        ),
      ],
     ),
    ); 
  }
}                                     

class BallotScreen extends StatefulWidget {
  @override
  _BallotScreenState createState() => _BallotScreenState();
}

class _BallotScreenState extends State<BallotScreen> {
  List<String> candidates = ['Candidate A', 'Candidate B', 'Candidate C'];
  String selectedCandidate = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ballot'),
      ),
      body: ListView.builder(
        itemCount: candidates.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(candidates[index]),
            onTap: () {
              setState(() {
                selectedCandidate = candidates[index];
              });
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (selectedCandidate.isNotEmpty) {
            _submitVote(context);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Please select a candidate.'),
              ),
            );
          }
        },
        child: Icon(Icons.check),
      ),
    );
  }

  void _submitVote(BuildContext context) {
    
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Vote'),
          content: Text('Are you sure you want to vote for $selectedCandidate?'),
          actions: [
            TextButton(
              onPressed: (){
                
                Navigator.pop(context);
                Navigator.pop(context); // Go back to the login screen after voting
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                
                Navigator.pop(context);
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }
}