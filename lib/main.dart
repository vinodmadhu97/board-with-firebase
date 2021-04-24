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

  TextEditingController nameEditingController;
  TextEditingController titleEditingController;
  TextEditingController descriptionEditingController;

  @override
  void initState() {

    super.initState();

    nameEditingController = TextEditingController();
    titleEditingController = TextEditingController();
    descriptionEditingController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Board App"),
        centerTitle: true,

      ),

      floatingActionButton: FloatingActionButton(
         child: Icon(Icons.add_comment),
        onPressed: (){
           _showDialog(context);
        },

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

  _showDialog(BuildContext context) async{
    await showDialog(
        context: context,builder: (context) => AlertDialog(
          contentPadding: EdgeInsets.all(10),
          content: Column(
            children: [
              Text("Please Fill Out the form"),
              Expanded(
                  child: TextField(
                    autofocus: true,
                    autocorrect: true,
                    decoration: InputDecoration(
                      labelText: "Your name"
                      ),
                    controller: nameEditingController,


                    ),
                  ),

              Expanded(
                child: TextField(
                  autofocus: true,
                  autocorrect: true,
                  decoration: InputDecoration(
                      labelText: "Title"
                  ),
                  controller: titleEditingController,


                ),
              ),

              Expanded(
                child: TextField(
                  autofocus: true,
                  autocorrect: true,
                  decoration: InputDecoration(
                      labelText: "Description"
                  ),
                  controller: descriptionEditingController,


                ),
              ),

            ],
          ),
          actions: [
            FlatButton(
                onPressed: (){
                  nameEditingController.clear();
                  titleEditingController.clear();
                  descriptionEditingController.clear();

                  //removing dialog box
                  Navigator.pop(context);
                },
                child: Text("Cancel")
            ),
            FlatButton(
                onPressed: (){
                  nameEditingController.clear();
                  titleEditingController.clear();
                  descriptionEditingController.clear();

                  //removing dialog box
                  Navigator.pop(context);
                },
                child: Text("Save")
            )
          ],
        )
    );
  }
}
