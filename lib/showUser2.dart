import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'dart:io';
import 'notification/userInfo.dart';



class showUser extends StatefulWidget {

  @override
  showUserState createState() => new showUserState();

}

class showUserState extends State<showUser>{
  List data;
  String result;
  String address = 'localPath/data.json';

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("load test"),
      ),
      body: new Container(
        child: new Center(
          child: new FutureBuilder(

              future: DefaultAssetBundle
                  .of(context)
                  .loadString('/data/user/0/com.example.medapp1/app_flutter/data.json'),
              builder: (context, snapshot){
                //decode json

                var mydata= jsonDecode(snapshot.data.toString());
                return new ListView.builder(
                  itemBuilder: (BuildContext context, int index){
                    return new Card(
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          new Text(""),
                          new Text("Name "+mydata[index]['name']),
                          new Text("Medictation_Name "+mydata[index]['Medictation_Name']),
                          new Text("Dosage "+mydata[index]['Dosage']),
                          new Text("time "+mydata[index]['Frequency']),
                          new Text(""),
                        ],
                      ),
                    );
                  },
                  itemCount: mydata== null ? 0 : mydata.length,
                );
              }
          ),
        ),
      ),

    );
  }



}