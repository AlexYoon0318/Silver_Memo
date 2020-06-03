import 'package:flutter/material.dart';
import 'package:silver_memo/db_manager.dart';

class DetailPostPage extends StatefulWidget {
  final DbManager _manager;
  final Note note;

  DetailPostPage(this._manager, {this.note});

  @override
  DetailPostPageState createState(){
    return new DetailPostPageState(_manager, note);
  }
}

class DetailPostPageState extends State<DetailPostPage> {
  final DbManager _manager;
  final Note note;
  final _formKey = new GlobalKey<FormState>();

  String _title;
  String _password;
  String _names;
  String _description;

  DetailPostPageState(this._manager, this.note);


  _submit() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();
      note == null ?
      _manager.insertNote(new Note(title: _title, description: _description, names: _names, password: _password))
          .then((id) => Navigator.pop(context))
          : _manager.updateNote(new Note(title: _title, description: _description, id: note.id, names: note.names, password: note.password))
          .then((id) => Navigator.pop(context));
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("새글쓰기"),
      ),
      body: SingleChildScrollView(
        child: new Container(
            margin: new EdgeInsets.all(16.0),
            child: new Form(
                key: _formKey,
                child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      new Container(
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(color: Colors.blueAccent, width: 2.0)
                          )
                        ),
                        child: new TextFormField(
                          decoration: new InputDecoration(
                            labelText: "사용처",
                            border: InputBorder.none,
                          ),
                          style: TextStyle(fontSize: 25.0),
                          key: new Key("title"),
                          initialValue: note?.title,
                          validator: (val) => val.isNotEmpty ? null : "사이트를 적어주세요.",
                          onSaved: (val) => _title = val,
                        ),

                      ),
                      new Container(
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(color: Colors.blueAccent, width: 2.0)
                            )
                        ),
                        child: new TextFormField(
                          decoration: new InputDecoration(
                            labelText: "아이디",
                            border: InputBorder.none,
                          ),
                          style: TextStyle(fontSize: 25.0),
                          key: new Key("NAME"),
                          initialValue: note?.names,
                          //validator: (val) => val.isNotEmpty ? null : "아이디를 적어주세요.",
                          onSaved: (val) => _names = val,
                        ),
                      ),
                      new Container(
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(color: Colors.blueAccent, width: 2.0)
                            )
                        ),
                        child: new TextFormField(
                          decoration: new InputDecoration(
                            labelText: "비밀번호",
                            border: InputBorder.none,
                          ),
                          style: TextStyle(fontSize: 25.0),
                          key: new Key("PASSWORD"),
                          initialValue: note?.password,
                          validator: (val) => val.isNotEmpty ? null : "비밀번호를 적어주세요.",
                          onSaved: (val) => _password = val,
                        ),
                      ),
                      new Container(
                          child: new Divider(
                            color: Colors.black,)),
                      new TextFormField(
                        decoration: new InputDecoration(
                          labelText: "설명",

                        ),
                        key: new Key("description"),
                        style: TextStyle(fontSize: 20.0),
                        initialValue: note?.description,
                        //validator: (val) => val.isNotEmpty ? null : "Description must not be empty",
                        onSaved: (val) => _description = val,
                        keyboardType: TextInputType.multiline,
                        maxLines: 5,
                      )
                    ]))
        ),
      ),
      floatingActionButton: new FloatingActionButton(
          onPressed: () => _submit(),
          child: new Icon(Icons.check)),
    );
  }
}