import 'dart:convert';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mysql_crud/Information.dart';

class ProfilPage extends StatefulWidget {

  String id;
  String name;
  String email;
  String password;
  String image;


  ProfilPage({this.name, this.email,this.image,this.id,this.password});

  @override
  _ProfilPageState createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {

  @override

  String ip="http://192.168.1.109/mysql_connect/";
  File image;
  final formkey=GlobalKey<FormState>();
  String password_edit;
  String email_edit;
  String name_edit;
  String email_actu="";
  var datainfo;
  void getImage() async{
    var temImg= await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      image=temImg;
    });
  }

  Future newInfo() async{
    final info= await http.post(ip+"/getUserInfo.php",body: {
      "id":widget.id
    });

    return json.decode((info.body));
  }

  DialogBox _dialog=new DialogBox();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.name,style: TextStyle(fontWeight: FontWeight.w800,fontSize: 20),),
          centerTitle: true,
        ),
      body: ListView(
        children: <Widget>[
          SizedBox(height:45,),
          image==null?Image.network(ip+widget.image,height: 200,width: 200,):Image.file(image,height: 200,width: 200,),
          SizedBox(height: 15,),
          FlatButton(
            onPressed: getImage,
            textColor: Colors.teal,
            child:Text("changez votre photo de profil",style:TextStyle(fontSize: 16),),
          ),

          Form(
            key: formkey,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: TextFields() + Bouttons(),
              ),
            ),
          )


        ],
      ),
    );
  }

 List<Widget> TextFields() {
   return[

     TextFormField(
       decoration: InputDecoration(
           labelText: email_actu==""? widget.name:email_actu,
           icon: Icon(Icons.person, color: Colors.teal,)
       ),
       validator: (value){
         return value.isEmpty?"Adresse Email obligatoire":null;
       },
       onSaved: (value){
         name_edit=value;
       },
     ),

     SizedBox(height: 10,),

     TextFormField(
       decoration: InputDecoration(
           labelText: widget.email,
           icon: Icon(Icons.email, color: Colors.teal,)
       ),
       validator: (value){
         return value.isEmpty?"Adresse Email obligatoire":null;
       },
       onSaved: (value){
         email_edit=value;
       },
     ),
     SizedBox(height: 10,),

     TextFormField(
       decoration: InputDecoration(
           labelText: widget.password,
           icon: Icon(Icons.vpn_key,color: Colors.teal,)
       ),
       obscureText: true,
       validator: (value){
         return value.isEmpty?"Mot de Passe obligatoire":null;
       },
       onSaved: (value){
         password_edit=value;
       },
     ),
     SizedBox(height: 10,),
   ];
 }

 List<Widget> Bouttons(){
   return [
     RaisedButton(
       onPressed: ValidateAndSubmit,
       color: Colors.teal,
       hoverColor: Colors.blue,
       textColor: Colors.white,
       child: Text(
           "Modification du profil",
           style:TextStyle(
               fontSize: 19,
               fontWeight: FontWeight.w600
           )
       ),
     ),
   ];
 }

  bool ValidateAndSave(){
    final form=formkey.currentState;
    if(form.validate()){
      form.save();
      return true;
    }else {
      return false;
    }
  }
  void ValidateAndSubmit() async {
    if(ValidateAndSave()){

      if(image==null) return;
      String base64Image = base64Encode(image.readAsBytesSync());
      String fileName = image.path.split("/").last;
      print(base64Image);

      final reponse=await http.post("http://192.168.1.109/mysql_connect/editProfil.php",
          body:{
            "id":widget.id,
            "image": base64Image,
            "filename": fileName,
            "name_edit":name_edit,
            "email_edit":email_edit,
            "password_edit":password_edit
          }).then((res) {
        print(res.statusCode);
      }).catchError((err) {
        print(err);
      });
      print(widget.id+widget.email);


        _dialog.information(context, "Felicitation", "Modification de profil reussie");
        
        final info= await http.post(ip+"/getUserInfo.php",body: {
          "id":widget.id
        });

          datainfo=json.decode((info.body));
          print(datainfo[0]['username']);
          email_actu=datainfo[0]['username'];


    }
  }
}
