import 'package:board_app_firebase/ui/custom_card.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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

         child: Icon(FontAwesomeIcons.pen),
        onPressed: (){
           _showDialog(context);


        },

      ),

      body: StreamBuilder(
        stream:  dbData,
        builder: (context,snapshot){

          if(!snapshot.hasData){
            return Center(child: CircularProgressIndicator());
          }


          return ListView.builder(
            itemCount: snapshot.data.documents.length,
              itemBuilder: (context, index) {
                return CustomCard(snapshot: snapshot.data, index: index);
              }
          );


        },
      ),
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
                  if(titleEditingController.text.isNotEmpty && nameEditingController.text.isNotEmpty && descriptionEditingController.text.isNotEmpty){
                    FirebaseFirestore.instance.collection("board").add({
                      "name" : nameEditingController.text, "title" : titleEditingController.text,
                      "description" : descriptionEditingController.text, "timeStamp" : new DateTime.now()
                    }).then((value) {
                      print(value.documentID);
                      Navigator.pop(context);
                      nameEditingController.clear();
                      titleEditingController.clear();
                      descriptionEditingController.clear();


                    }).catchError((error) => print(error));
                  }
                },
                child: Text("Save")
            )
          ],
        )
    );
  }


}
