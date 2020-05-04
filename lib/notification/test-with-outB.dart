import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:convert';


import 'package:flutter/cupertino.dart';
import 'package:medapp1/notification/testCreate2.dart';
import 'package:medapp1/notification/userInfo.dart';
import 'button/custom_buttom.dart';
import 'notification_data.dart';
import 'notification_plugin.dart';
import 'userInfo.dart';



class showUser3 extends StatefulWidget {

  @override
  showUserState createState() => new showUserState();
}



class showUserState extends State<showUser3>{
  final NotificationPlugin _notificationPlugin = NotificationPlugin();
  Future<List<PendingNotificationRequest>> notificationFuture;
  bool _value = true;

  @override
  void initState() {
    super.initState();

  }

  void _onChanged(bool value){
    setState(() {
      _value = value;
    });
  }

  List data;

  var titleName;
  var descrip;
  TimeOfDay selectedTime = TimeOfDay.now();


  final _formKey = GlobalKey<FormState>();



  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("load test"),
      ),
      body: new Container(
        child: new Center(
          child: new FutureBuilder(

              future: DefaultAssetBundle
                  .of(context)
                  //.loadString("load_json/person.json"),
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
                          new Text("Medication Name "+mydata[index]['Medictation_Name']),
                          new Text("Dosage "+mydata[index]['Dosage']),
                          new Text("Time "+mydata[index]['Hour']+":"+mydata[index]["Minute"]),


                          new IconButton(
                              icon: Icon(Icons.access_alarm),
                              onPressed: navigateToNotificationCreation),


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

  Future<void> navigateToNotificationCreation() async {
    NotifcationData notificationDate = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => createtest2(),
        )
    );

    if (notificationDate != null) {
      final notificationList = await _notificationPlugin.getScheduledNotification();
      int id = 0;
      for (var i = 0; i < 100; i++) {
        bool exists = _notificationPlugin.checkIfIdExists(notificationList, i);
        if (!exists) {
          id = i;
        }
      }

      await _notificationPlugin.showDailyAtTime(
        notificationDate.time,
        id,
        notificationDate.title,
        notificationDate.description,
      );
      setState(() {
        notificationFuture = _notificationPlugin.getScheduledNotification();
      });
    }
  }

}
