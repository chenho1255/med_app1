import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'file:///D:/Collage%20work/year4/Final%20year%20project/flutter_app/med_app1/lib/notification/button/custom_buttom.dart';
import 'button/notification_data.dart';
import 'notification_data.dart';

class createtest2 extends StatefulWidget{

  @override
  _CreateNotifcationPageState createState()=> _CreateNotifcationPageState();
}

class _CreateNotifcationPageState extends State<createtest2>{

  TimeOfDay selectedTime = TimeOfDay.now();

  bool _value = true;

  void _onChanged(bool value){
    setState(() {
      _value = value;
    });
  }
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Color(0xffffffff)),
        backgroundColor: Color(0xff0080ff),
        title: Text('test Set Time'),
        elevation: 0,
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
                  key: _formKey,
                  itemBuilder: (BuildContext context, int index){

                    return new Card(

                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          new Text(""),
                          new Text("Medictation Name "+mydata[index]['Medictation_Name']),
                          new Text("Dosage "+mydata[index]['Dosage']),
                          new Text("Time "+mydata[index]['Hour']+":"+mydata[index]["Minute"]),
                          new Text(""),
                          new Text("Instructions"),
                          new Text(mydata[index]['Instructions']),
                          new IconButton(
                              icon: Icon(Icons.access_alarm),
                              onPressed: (){
                                createNotification(mydata,index);
                              }

                          ),



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

  Future<void> selectTime() async{
    final time = await showTimePicker(
      context: context,

      initialTime: selectedTime,
    );

    setState(() {
      selectedTime = time;
    });
  }

  void createNotification(mydata, int index){
    final title =mydata[index]['Medictation_Name'].toString();
    final description = mydata[index]['Instructions'].toString()
        + "\n"
        +"Time: "+ mydata[index]['Hour']+":"+ mydata[index]["Minute"];

    final time = Time(int.parse(mydata[index]['Hour']), int.parse(mydata[index]["Minute"]));

    final notificationData = NotifcationData(title, description, time);

    Navigator.of(context).pop(notificationData);
  }
}
