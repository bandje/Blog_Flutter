import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mysql_crud/Post.dart';
import 'package:mysql_crud/profil.dart';
import 'package:http/http.dart' as http;
import "package:mysql_crud/details.dart";

class HomePage extends StatefulWidget {
  String email;
  String name;
  String password;
  String image;
  String id;

  HomePage({this.email,this.id,this.name,this.image,this.password});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String ip="http://192.168.1.109/mysql_connect/";

  Future<List> PostData() async{
    final reponse= await http.get("http://192.168.1.109/mysql_connect/getposts.php");
    return json.decode(reponse.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Accueil'),
        centerTitle: true,
        backgroundColor: Colors.teal,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.person,size: 30,color: Colors.white,),
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
                return ProfilPage(
                 name: widget.name,
                 email: widget.email,
                 password: widget.password,
                 image: widget.image,
                 id: widget.id,
                );
              }));
            }
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(widget.name),
              accountEmail: Text(widget.email),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/elephant.jpg",),
                  fit: BoxFit.cover,
                )
              ),
            ),

            ListTile(
              title: Text("Profil",style: TextStyle(color: Colors.teal)),
              trailing: Icon(Icons.person),
              onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
                    return ProfilPage(
                      id: widget.id,
                      name: widget.name,
                      email: widget.email,
                      password: widget.password,
                      image:widget.image
                    );
                  }));
              },
            ),
            Divider(),

            ListTile(
              title: Text("Liste des Bloggeurs",style: TextStyle(color: Colors.teal)),
              trailing: Icon(Icons.list),
            ),
            Divider(),
            ListTile(
              title: Text("Ajouter un Post",style: TextStyle(color: Colors.teal)),
              trailing: Icon(Icons.add),
              onTap: AddPost,
            ),

            Divider(),

            ListTile(
              title: Text("Deconnexion",style: TextStyle(color: Colors.teal),),
              trailing: Icon(Icons.remove_circle_outline),
            ),
          ],
        ),
      ),

      body: FutureBuilder<List>(
        future: PostData(),
        builder: (context,snapshot){
          if(snapshot.hasError) print(snapshot);
          return snapshot.hasData? new ItemList(
            list:snapshot.data
          ):Center(
            child: CircularProgressIndicator(),
          );
        },
      ),


      floatingActionButton: FloatingActionButton(
        onPressed: AddPost,
        child: Icon(Icons.message),
        backgroundColor: Colors.teal,
        tooltip: "Ajouter un Poste",

      ),
    );
  }

  void AddPost() {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
      return PostPage(
        auteur: widget.name,
        email: widget.email,
      );
    }));
  }
}


class ItemList extends StatelessWidget {

  final List list;

  ItemList({this.list});
  String ip="http://192.168.1.109/mysql_connect/";

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: list==null?0:list.length,
      itemBuilder: (context,i){
        return Container(
          padding: EdgeInsets.all(10),
          child: GestureDetector(
            onTap:(){
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context){
                  return DetailsPage(
                    image: list[i]["image"],
                    titre: list[i]["titre"],
                    description: list[i]["description"],
                    categories: list[i]["categorie"],
                  );
                }));
            },
            child:Card(
              elevation: 10,
              margin: EdgeInsets.symmetric(vertical: 2,horizontal: 4),
              child: Container(
                margin: EdgeInsets.all(6),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        SizedBox(height: 5,),
                        list[i]["datePost"]==null?Text("probleme"): Text(
                          list[i]["datePost"],
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16
                          ),
                        ),

                        list[i]["timePost"]==null? Text("probleme"):Text(
                          list[i]["timePost"],
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15,),

                    Image.network("$ip/${list[i]["image"]}",fit: BoxFit.cover,),

                    SizedBox(height: 15,),
                    Text(
                      list[i]["description"],
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 16
                      ),
                    ),
                    SizedBox(height: 5,),

                  ],
                ),

            ),
          )
        ));
      },
    );
  }
}

