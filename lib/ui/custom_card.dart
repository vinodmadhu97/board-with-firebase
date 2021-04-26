import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
class CustomCard extends StatelessWidget {
  final QuerySnapshot snapshot;
  final int index;



  const CustomCard({Key key, this.snapshot, this.index}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    var timeToDate = DateTime.fromMillisecondsSinceEpoch(snapshot.documents[index]['timeStamp'].seconds * 1000);
    var dateFormatted  =  DateFormat("EEEE, MM d, y").format(timeToDate);

    var nameEditingController = TextEditingController(text: snapshot.documents[index]['name']);
    var titleEditingController = TextEditingController(text: snapshot.documents[index]['title']);
    var descriptionEditingController = TextEditingController(text: snapshot.documents[index]['description']);

    return Card(
        elevation: 5,
        child: Column(
          children: [
            Container(
              height: 100,
              child: ListTile(
                leading: CircleAvatar(

                  child: Text(snapshot.documents[index]['name'].toString()[0]),

                ),
                title: Text(snapshot.documents[index]['title'].toString()),
                subtitle: Text(snapshot.documents[index]['description'].toString()),


              ),

            ),
            Row(
              mainAxisAlignment:MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text("By: ${snapshot.documents[index]['name'].toString()}  $dateFormatted"),
                ),
                Row(
                  children: [

                        IconButton(
                            icon: Icon(FontAwesomeIcons.solidEdit),
                            onPressed: () async {
                              await showDialog(context: context, builder: (context){
                                  return AlertDialog(
                                    content: Column(
                                      children: [
                                        Text("Please fill Out to Upload"),
                                        Expanded(
                                          child: TextField(
                                            autofocus: true,
                                            autocorrect: true,
                                            controller: nameEditingController,
                                            decoration: InputDecoration(
                                              labelText: "Name",
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: TextField(
                                            autofocus: true,
                                            autocorrect: true,
                                            controller: titleEditingController,
                                            decoration: InputDecoration(
                                              labelText: "Title",
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: TextField(
                                            autofocus: true,
                                            autocorrect: true,
                                            controller: descriptionEditingController,
                                            decoration: InputDecoration(
                                              labelText: "Description",
                                            ),
                                          ),
                                        ),

                                      ],
                                    ),

                                    actions: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          FlatButton(
                                              onPressed: (){
                                                Navigator.pop(context);
                                              },
                                              child: Text("Cancel")
                                          ),
                                          FlatButton(
                                              onPressed: (){
                                                if(nameEditingController.text.isNotEmpty && titleEditingController.text.isNotEmpty && descriptionEditingController.text.isNotEmpty){
                                                  Firestore.instance.collection("board").document(snapshot.documents[index].documentID).updateData(
                                                      {
                                                        "name":nameEditingController.text,
                                                        "title": titleEditingController.text,
                                                        "description":descriptionEditingController.text,
                                                        "timeStamp" : DateTime.now()
                                                      }
                                                  ).then((value) => Navigator.pop(context));
                                                }




                                              },
                                              child: Text("Update"))

                                        ],
                                      )
                                    ],

                                  );
                                }
                              );
                            }
                          ),
                        IconButton(
                            icon: Icon(FontAwesomeIcons.solidTrashAlt),
                            onPressed: () async{
                              var collectionReference = FirebaseFirestore.instance.collection("board");
                              await collectionReference.document(snapshot.documents[index].documentID).delete();
                            }
                        ),
                  ],
                )
              ],
            ),

          ],
        ),
      );


  }


}
