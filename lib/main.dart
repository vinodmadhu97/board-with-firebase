import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      home: BoardAppHome(),
    );
  }
}

class BoardAppHome extends StatefulWidget {
  @override
  _BoardAppHomeState createState() => _BoardAppHomeState();
}

class _BoardAppHomeState extends State<BoardAppHome> {
  //connect to the firesore and retrieve the snapshot of data
  var dbData = FirebaseFirestore.instance.collection("board").snapshots();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Board App"),
        centerTitle: true,

      ),

      body: StreamBuilder(
        stream:  dbData,
        builder: (context,snapshot){

          if(!snapshot.hasData){
            return CircularProgressIndicator();
          }
          if(snapshot.connectionState == ConnectionState.waiting){
            return Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: CircleAvatar(
                    child: Text((index+1).toString()),
                  ),
                  title: Text(snapshot.data.documents[index]['title']),
                  subtitle: Text(snapshot.data.documents[index]['description']),
                );
              },
          );


        },
      ),
    );
  }

  Future getDataFromFireBase() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();

    return StreamBuilder(
      stream:  FirebaseFirestore.instance.collection("board").snapshots(),
      builder: (context,snapshot){

        if(!snapshot.hasData){
          return CircularProgressIndicator();
        }
        if(snapshot.connectionState == ConnectionState.waiting){
          return Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          itemCount: snapshot.data.documents.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: CircleAvatar(
                child: Text((index+1).toString()),
              ),
              title: Text(snapshot.data.documents[index]['title']),
              subtitle: Text(snapshot.data.documents[index]['description']),
            );
          },
        );


      },
    );

  }
}
