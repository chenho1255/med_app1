import 'dart:convert';
import 'dart:io';
import 'package:medapp1/notification/test-with-outB.dart';

import 'showUser2.dart';
import 'package:path_provider/path_provider.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart' hide Key;
import 'package:flutter/services.dart';
import 'dart:async';
import 'notification/userInfo.dart';
import 'notification/notification_page.dart';

import 'notification/show_info.dart';
import 'package:encrypt/encrypt.dart';


void main() => runApp(MaterialApp(
  debugShowCheckedModeBanner: false,
  home: HomePage(),

));

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() {

    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  String result = '';
  String resultER="";
  String dataRead="";
  String qrResult;

  List<user_save> _user = List<user_save>();

  Future _scanQR() async {
    try {
      final qrResult = await BarcodeScanner.scan();

      print ("test qr code scanner ");
      print(qrResult);

      final key = Key.fromUtf8('This is a Key123');
      final iv = IV.fromUtf8('This is an IV456');


      print("test");
      final encrypter = Encrypter(AES(key, mode: AESMode.cfb64 ));

      final text = base64Decode(qrResult).toString();
      final test2 = json.decode(text);
      print("test2");
      print(text.toString());

      print("test3");
      print(test2);

      print('test4');

      //stop running at
      final decrypted = encrypter.decrypt64(test2.toString(), iv: iv);
      print(decrypted);

      print("3");

      print("chack decrypted");
      print(""+decrypted);


      setState(() {
        result = decrypted;
        //writeContent(); //save data from scanner
        resultER = "";
      });
    } on PlatformException catch (ex) {
      if (ex.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          resultER = "Camera permission was denied$ex";
        });
      } else {
        setState(() {
          resultER = "Unknown Error $ex";
        });
      }
    } on FormatException catch (ex) {
      setState(() {
        resultER = "You pressed the back button before scanning anything $ex";
      });
    } catch (ex) {
      setState(() {
        resultER = "Unknown Error $ex";
      });
    }
  }
  Future<List<user_save>> fetxhResult() async{

    var data = List<user_save>();
    var dataJSON = json.decode(result);
    for(var dataJSON in dataJSON){
      data.add(user_save.fromJson(dataJSON));
    }
    return data;

  }
  @override
  Widget build(BuildContext context) {

    fetxhResult().then((value){
      _user.addAll(value);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text("QR Scanner2"),
      ),

      body: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[

            new Text(

              resultER+ "\n" +result,
              // style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),

            //new Text(_user[0].name),

            new RaisedButton(
                child:  Text('save'),
                onPressed: writeContent

            ),


            new RaisedButton(
                child: Text(
                  "read",
                  //style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                onPressed: readcontent

            ),


            new RaisedButton(
                child:  Text(
                    "notification"),
                onPressed: (){
                  Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => showUser2()
                      )
                  );
                }),



            new RaisedButton(
                child:  Text(
                    "Set Notiftication"),
                onPressed: (){
                  Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => showUser3()
                      )
                  );
                }),


          ]

      ),



      floatingActionButton: FloatingActionButton.extended(
          icon: Icon(Icons.camera_alt),
          label: Text("Scan"),
          onPressed: _scanQR
      ),




      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

    );
  }


//====================================================================
  //new read and wirte
  Future<File> writeContent() async {
    if(result ==""){
    }
    else{
      final file = await _localFile;
      print("loook at me file path "+file.toString());
      // Write the file
      return file.writeAsString(result);
    }

  }
  Future<File> get _localFile async {
    final path = await _localPath;
    print("loook at me"+'$path/data.json');
    return File('$path/data.json');

  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    // For your reference print the AppDoc directory
    print("loook at me"+directory.path);
    return directory.path;
  }

  Future<String> readcontent() async {
    try {
      final file = await _localFile;

      String contents = await file.readAsString();
      print(contents);
      dataRead = contents;
      return contents;
    } catch (e) {
      // If there is an error reading, return a default String
      return 'Error';
    }
  }
}