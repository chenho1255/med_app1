import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'file:///D:/Collage%20work/year4/Final%20year%20project/flutter_app/med_app1/lib/notification/button/custom_buttom.dart';
import 'notification_data.dart';

class CreateNotificationPage extends StatefulWidget{
  @override
  _CreateNotifcationPageState createState()=> _CreateNotifcationPageState();
}

class _CreateNotifcationPageState extends State<CreateNotificationPage>{
  final _titileController = TextEditingController();
  final _descriptionController = TextEditingController();
  TimeOfDay selectedTime = TimeOfDay.now();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Color(0xffffffff)),
        backgroundColor: Color(0xff0080ff),
        title: Text('Set Time'),
        elevation: 0,
      ),

      body: Column(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child:Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    CustomInputField(
                      controller: _titileController,
                      hintText: "Title",
                      autoFocus: true,
                    ),
                    SizedBox(height: 12),
                    CustomInputField(
                      controller: _descriptionController,
                      hintText: "Description",
                      autoFocus: true,
                    ),
                    SizedBox(height: 12),
                    FlatButton(
                      onPressed: selectTime,
                      color: Color(0xff0080ff),
                      child: Text(selectedTime.format(context)),
                    ),
                  ],
                ),
              )

              //itemCount: mydata== null ? 0 : mydata.length,
            ),
          ),
          CustomWideFlatButton(
            onPressed: createNotification,
            backgroundColor: Color(0xff0080ff),
            foregroundColor: Color(0xffffffff),
          ),

        ],
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
    final title = _titileController.text;
    final description = _descriptionController.text;
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
