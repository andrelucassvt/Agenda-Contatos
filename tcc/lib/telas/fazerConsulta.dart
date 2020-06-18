import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tcc/database/db.dart';

class ContactPage extends StatefulWidget {

  final Contact contact;

  ContactPage({this.contact});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {

  final _nameController = TextEditingController();
  final _idadeController = TextEditingController();
  final _sexoController = TextEditingController();
  final _corController = TextEditingController();
  final _exameController = TextEditingController();
  final _dataController = TextEditingController();

  final _nameFocus = FocusNode();

  bool _userEdited = false;

  Contact _editedContact;

  @override
  void initState() {
    super.initState();

    if(widget.contact == null){
      _editedContact = Contact();
    } else {
      _editedContact = Contact.fromMap(widget.contact.toMap());

      _nameController.text = _editedContact.name;
      _idadeController.text = _editedContact.idade;
      _sexoController.text = _editedContact.sexo;
      _corController.text = _editedContact.cor;
      _exameController.text = _editedContact.exame;
      _dataController.text = _editedContact.data;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text("Nova consulta"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            if(_editedContact.name != null && _editedContact.name.isNotEmpty){
              Navigator.pop(context, _editedContact);
            } else {
              FocusScope.of(context).requestFocus(_nameFocus);
            }
          },
          child: Icon(Icons.save),
          backgroundColor: Colors.red,
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              TextField(
                controller: _nameController,
                focusNode: _nameFocus,
                decoration: InputDecoration(labelText: "Nome do paciente"),
                onChanged: (text){
                  _userEdited = true;
                  setState(() {
                    _editedContact.name = text;
                  });
                },
              ),
              TextField(
                controller: _idadeController,
                decoration: InputDecoration(labelText: "Idade do paciente"),
                onChanged: (text){
                  _userEdited = true;
                  _editedContact.idade = text;
                },
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: _sexoController,
                decoration: InputDecoration(labelText: "Sexo do paciente"),
                onChanged: (text){
                  _userEdited = true;
                  _editedContact.sexo = text;
                },
              ),
              TextField(
                  controller: _corController,
                  decoration: InputDecoration(labelText: "cor do paciente"),
                  onChanged: (text){
                    _userEdited = true;
                    _editedContact.cor = text;
                  },
                ),
              TextField(
                controller: _exameController,
                decoration: InputDecoration(labelText: "Exame"),
                onChanged: (text){
                  _userEdited = true;
                  _editedContact.exame = text;
                },
              ),
              TextField(
                controller: _dataController,
                decoration: InputDecoration(labelText: "Data do exame"),
                onChanged: (text){
                  _userEdited = true;
                  _editedContact.data = text;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _requestPop(){
    if(_userEdited){
      showDialog(context: context,
        builder: (context){
          return AlertDialog(
            title: Text("Descartar Alterações?"),
            content: Text("Se sair as alterações serão perdidas."),
            actions: <Widget>[
              FlatButton(
                child: Text("Cancelar"),
                onPressed: (){
                  Navigator.pop(context);
                },
              ),
              FlatButton(
                child: Text("Sim"),
                onPressed: (){
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        }
      );
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

}