import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tcc/database/db.dart';
import 'package:tcc/telas/fazerConsulta.dart';
import 'package:url_launcher/url_launcher.dart';

enum OrderOptions {orderaz, orderza}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  ContactHelper helper = ContactHelper();

  List<Contact> contacts = List();

  @override
  void initState() {
    super.initState();

    _getAllContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Consultas"),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton.extended(
          onPressed: (){
            _showContactPage();
          },
          label: Text("Marcar consulta"),
          icon: Icon(Icons.add),
          backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
          padding: EdgeInsets.all(10.0),
          itemCount: contacts.length,
          itemBuilder: (context, index) {
            return _contactCard(context, index);
          }
      ),
    );
  }

  Widget _contactCard(BuildContext context, int index){
    return Card(
      elevation: 2.0,
      child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Container(
            height: 200,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
               
                Text("Nome:" +contacts[index].name,
                  style: TextStyle(fontSize: 17.0,),
                ),
                Text("Idade:" +contacts[index].idade,
                  style: TextStyle(fontSize: 17.0,),
                ),
                Text("Sexo:" +contacts[index].sexo,
                  style: TextStyle(fontSize: 17.0,),
                ),
                Text("Cor:" +contacts[index].cor,
                  style: TextStyle(fontSize: 17.0,),
                ),
                Text("Exame:" +contacts[index].exame,
                  style: TextStyle(fontSize: 17.0,),
                ),
                Text("Data:" +contacts[index].data,
                  style: TextStyle(fontSize: 17.0,),
                ),
              ],
            ),
          ),
      ),
    );
  }

  
  void _showContactPage({Contact contact}) async {
    final recContact = await Navigator.push(context,
      MaterialPageRoute(builder: (context) => ContactPage(contact: contact,))
    );
    if(recContact != null){
      if(contact != null){
        await helper.updateContact(recContact);
      } else {
        await helper.saveContact(recContact);
      }
      _getAllContacts();
    }
  }

  void _getAllContacts(){
    helper.getAllContacts().then((list){
      setState(() {
        contacts = list;
      });
    });
  }
}