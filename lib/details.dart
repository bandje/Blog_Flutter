import 'dart:convert';
import 'package:flutter/material.dart';

class DetailsPage extends StatefulWidget {
  String image;
  String titre;
  String description;
  String categories;


  DetailsPage({this.image, this.titre, this.description, this.categories});

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {

  String ip="http://192.168.1.109/mysql_connect/";


  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.titre,style: TextStyle(fontSize: 18),),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          SizedBox(height: 20,),
          Column(
            children: <Widget>[
              Card(
                margin: EdgeInsets.symmetric(horizontal: 15),
                elevation: 10,
                child: Image.network(ip+widget.image,fit: BoxFit.cover,),
              ),
              SizedBox(height: 30,),
              Container(
                margin:EdgeInsets.symmetric(horizontal: 15),
                child: Text("DESCRIPTION: "+widget.description,style: TextStyle(fontWeight: FontWeight.w600),),
              ),
              SizedBox(height: 20,)
            ],
          )
        ],
      ),
    );
  }
}
