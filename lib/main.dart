import 'dart:convert';
import 'package:mysql_crud/Home.dart';
import 'Information.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.teal
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}
enum ConnexionState{
  Inscris,nonInscris
}

class _MyHomePageState extends State<MyHomePage> {

  DialogBox _dialogBox=new DialogBox();

  ConnexionState _connexionState=ConnexionState.Inscris;
  final fomrkey=GlobalKey<FormState>();
  String email="";
  String password="";
  String name="";
  String image="profil/first.png";


  void moveToLogin() {
    fomrkey.currentState.reset();
    setState(() {
      _connexionState=ConnexionState.Inscris;
    });
  }

  void moveToRegister() {
    fomrkey.currentState.reset();
    setState(() {
      _connexionState=ConnexionState.nonInscris;
    });
  }

  bool ValidateAndSave(){
    final form=fomrkey.currentState;
    if(form.validate()){
      form.save();
      return true;
    }else {
      return false;
    }
  }

  void ValidateAndSubmit() async{
    if(ValidateAndSave()){
        if(_connexionState==ConnexionState.Inscris){
          final reponse=await http.post("http://192.168.1.109/mysql_connect/login.php",
            body:{
              "username":email,
              "password":password
            }
          );

          var dataUser=json.decode((reponse.body));
          if(dataUser.length==0){
            _dialogBox.information(context, "Erreur", "Une erreur est survenue lors\n "
                "de votre connexion veuillez ressayer\n "
                "s'il vous plait");
          }else{
            print(dataUser[0]["id"]);
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context){
              return HomePage(

                id: dataUser[0]["id"],
                email: dataUser[0]["username"],
                name: dataUser[0]["name"],
                password: dataUser[0]["password"],
                image:dataUser[0]["image_profil"],
              );
            }));
          }
        }
        else{
          final reponse=await http.post("http://192.168.1.109/mysql_connect/addData.php",
              body:{
                "username":email,
                "name":name,
                "password":password,
                "image":image,
              }
          );

          //var dataUser=json.decode((reponse.body));
         // Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context){
           // return HomePage();
          //}));
          _dialogBox.information(context, "Bravo", "Felicitation Vous avez pu vous enregistrer sur "
              "notre platforme, Veuillez vous Connectez s'il vous plait !!!");
        }
    }
  }




  @override
  Widget build(BuildContext context) {
    final screenHeight=MediaQuery.of(context).size.height;
    final screnWidth=MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: ListView(
          children: <Widget>[
            SizedBox(height: 15,),
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10,vertical: 15),
                child: Text(
                  "Batyr Technology",
                  style:TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w800
                  ),
                ),
              ),
            ),
            SizedBox(height: 10,),
            Container(
              height: screenHeight*0.3,
              margin: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/cuba.jpg")
                )
              ),
            ),
            Form(
              key: fomrkey,
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
      ),
    );
  }
  List<Widget> TextFields(){
    if(_connexionState==ConnexionState.nonInscris){
      return[

        TextFormField(
          decoration: InputDecoration(
              labelText: "Nom & Prénom",
              icon: Icon(Icons.person, color: Colors.teal,)
          ),
          validator: (value){
            return value.isEmpty?"Adresse Email obligatoire":null;
          },
          onSaved: (value){
            name=value;
          },
        ),

        SizedBox(height: 10,),

        TextFormField(
          decoration: InputDecoration(
              labelText: "Adresse Email",
              icon: Icon(Icons.email, color: Colors.teal,)
          ),
          validator: (value){
            return value.isEmpty?"Adresse Email obligatoire":null;
          },
          onSaved: (value){
            email=value;
          },
        ),
        SizedBox(height: 10,),

        TextFormField(
          decoration: InputDecoration(
              labelText: "Mot de passe",
              icon: Icon(Icons.vpn_key,color: Colors.teal,)
          ),
          obscureText: true,
          validator: (value){
            return value.isEmpty?"Mot de Passe obligatoire":null;
          },
          onSaved: (value){
            password=value;
          },
        ),
        SizedBox(height: 10,),
      ];
    }else{
      return[

        TextFormField(
          decoration: InputDecoration(
              labelText: "Adresse Email",
              icon: Icon(Icons.email, color: Colors.teal,)
          ),
          validator: (value){
            return value.isEmpty?"Adresse Email obligatoire":null;
          },
          onSaved: (value){
            email=value;
          },
        ),
        SizedBox(height: 10,),

        TextFormField(
          decoration: InputDecoration(
              labelText: "Mot de passe",
              icon: Icon(Icons.vpn_key,color: Colors.teal,)
          ),
          obscureText: true,
          validator: (value){
            return value.isEmpty?"Mot de Passe obligatoire":null;
          },
          onSaved: (value){
            password=value;
          },
        ),
        SizedBox(height: 10,),
      ];
    }

  }

  List<Widget> Bouttons(){
    if(_connexionState==ConnexionState.Inscris)
    {
      return [
        RaisedButton(
          onPressed: ValidateAndSubmit,
          color: Colors.teal,
          hoverColor: Colors.blue,
          textColor: Colors.white,
          child: Text(
              "Connexion",
              style:TextStyle(
                  fontSize: 19,
                  fontWeight: FontWeight.w600
              )
          ),
        ),
        FlatButton(
          onPressed: moveToRegister,
          color: Colors.white,
          textColor: Colors.teal,
          child: Text(
              "Avez-vous un compte? creez en un",
              style:TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600
              )
          ),
        )
      ];
    }
    else
      {
        return [
          RaisedButton(
            onPressed: ValidateAndSubmit,
            color: Colors.teal,
            hoverColor: Colors.blue,
            textColor: Colors.white,
            child: Text(
                "Inscription",
                style:TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w600
                )
            ),
          ),
          FlatButton(
            onPressed: moveToLogin,
            color: Colors.white,
            textColor: Colors.teal,
            child: Text(
                "Avez-vous un compte? Connectez vous",
                style:TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600
                )
            ),
          )
        ];
      }

  }


}
