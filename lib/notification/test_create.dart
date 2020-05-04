import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'file:///D:/Collage%20work/year4/Final%20year%20project/flutter_app/med_app1/lib/notification/button/custom_buttom.dart';
import 'button/notification_data.dart';
import 'notification_data.dart';

class createtest extends StatefulWidget{
  @override
  _CreateNotifcationPageState createState()=> _CreateNotifcationPageState();
}

class _CreateNotifcationPageState extends State<createtest>{
  var titleName;
  var descrip;
  TimeOfDay selectedTime = TimeOfDay.now();

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
                  itemBuilder: (BuildContext context, int index){
                    this.titleName = mydata[index]['Medictation_Name'];
                    this.descrip= mydata[index]['Dosage'];

                    return new Form(
                      key: _formKey,
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          new Text(""),
                          new Text("Medictation Name "+titleName),
                          Text("Dosage "+descrip),
                          //new Text("time "+mydata[index]['Frequency']),
                          //this.selectedTime = mydata[index]['Frequency'],
                          new Text(""),

                          new FlatButton(onPressed: selectTime,
                            color: Color(0xff0080ff),
                            child: Text(selectedTime.format(context)),
                          ),

                          CustomWideFlatButton(
                            onPressed: createNotification,
                            backgroundColor: Color(0xff0080ff),
                            foregroundColor: Color(0xffffffff),
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

  void createNotification(){
    final title =titleName.toString();
    final description = descrip.toString();
    final time = Time(selectedTime.hour, selectedTime.minute);

    final notificationData = NotifcationData(title, description, time);

    Navigator.of(context).pop(notificationData);
  }
}

class CustomInputField extends StatelessWidget{
  const CustomInputField ({
    Key key,
    @required this.controller,
    @required this.hintText,
    this.autoFocus,
}): super(key: key);

  final TextEditingController controller;
  final String hintText;
  final bool autoFocus;

  @override
  Widget build(BuildContext context){
    return TextFormField(
      controller: controller,
      autofocus: autoFocus,
      keyboardType: TextInputType.text,
      validator: (value){
        if (value.isEmpty){
          return'Field can not be empty';
        }
        return null;
      },
      decoration: InputDecoration(
        labelText: hintText,
        filled: true,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: const BorderRadius.all(
            const Radius.circular(5),
          )
        )
      ),
    );
  }
}
