import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import "package:dio/dio.dart";
import 'package:intl/intl.dart';
import 'Home.dart';
import 'Information.dart';

class PostPage extends StatefulWidget {
  String auteur;
  String email;
  int id;

  PostPage({this.email,this.auteur,this.id});

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {

  File _image;

  String titre="";
  String description="";
  String categorie="";

  DialogBox _dialogBox=new DialogBox();
  final endPoint="http://192.168.1.109/mysql_connect/addPost.php";

  final formkey=GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    var widthScreen=MediaQuery.of(context).size.width;
    var heightScreen=MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text("Ajouter un poste"),
        centerTitle: true,
      ),
      body: ListView(
          children: <Widget>[
            SizedBox(height: 10,),
            Center(
              child: Container(
                margin: EdgeInsets.all(10.0),
                child: Form(
                  key:formkey ,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      //Image.file(imageSample,height: 300,width: 450,),
                      SizedBox(height: 10,),
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: "Titre du Poste",
                          icon: Icon(Icons.title)
                        ),
                        validator: (value){
                          return value.isEmpty?'Ce champs est requis':null;
                        },
                        onSaved: (value){
                          titre=value;
                        },
                      ),
                      SizedBox(height: 6,),


                      TextFormField(
                        decoration: InputDecoration(
                            labelText: "Catégorie du Poste",
                            icon: Icon(Icons.category)
                        ),
                        validator: (value){
                          return value.isEmpty?'Ce champs est requis':null;
                        },
                        onSaved: (value){
                          categorie=value;
                        },
                      ),
                      SizedBox(height: 6,),


                      TextFormField(
                        decoration: InputDecoration(
                            labelText: "description du Poste",
                            icon: Icon(Icons.description),
                        ),
                        validator: (value){
                          return value.isEmpty?'Ce champs est requis':null;
                        },
                        maxLines: 5,
                        onSaved: (value){
                          description=value;
                        },
                      ),


                      SizedBox(height: 10,),

                      Center(
                        child: _image==null?Text(""):Container(
                          width: widthScreen*0.4,
                          height: heightScreen*0.35,
                          child: Image.file(_image),
                        ),
                      ),

                      RaisedButton(
                        onPressed: ValidateAndSubmit,
                        color: Colors.teal,
                        textColor: Colors.white,
                        child: Text("Ajoutez un post",style:TextStyle(fontSize: 16),),
                      )

                    ],
                  ),
                ),
              ),
            )
          ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: getImage,
        child: Icon(Icons.add_a_photo),
        tooltip: "Ajouter une image",
      ),
    );
  }



  bool Validate() {
    var form=formkey.currentState;
    if(form.validate()){
      form.save();
      return true;
    }else{
      return false;
    }
  }

  void ValidateAndSubmit() async{
    if(Validate()){



        //Upload d'image



      if(_image==null) return;
        String base64Image = base64Encode(_image.readAsBytesSync());
        String fileName = _image.path.split("/").last;

        // ajout du temps de creation du post


        var dbTime=DateTime.now();
        var dateFormat=new DateFormat("MMM d, yyyy");
        var timeFormat= new DateFormat('EEEE,hh:mm aaa');

        String datepost=dateFormat.format(dbTime);
        String timepost=timeFormat.format(dbTime);

        http.post(endPoint, body: {
          "image": base64Image,
          "name": fileName,
          "titre":titre,
          "description":description,
          "categorie":categorie,
          "auteur":widget.auteur,
          "datePost":datepost,
          "timePost":timepost
        }).then((res) {
          print(res.statusCode);
        }).catchError((err) {
          print(err);
        });



        _dialogBox.information(context, widget.auteur, "Félicitation pour votre Publication");


          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context){
            return HomePage(
              email: widget.email,
              name: widget.auteur,
            );
          }));


    }
  }

  Future getImage() async{
    var tempImage= await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
        _image=tempImage;
    });
  }
}
