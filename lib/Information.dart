import 'package:flutter/material.dart';

class DialogBox{
  information(BuildContext context,String title,String description){
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context){
        return AlertDialog(
          title: Text(title),
          contentPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 10),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                  Text(description)
              ],
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OKAY'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      }
    );
  }
}