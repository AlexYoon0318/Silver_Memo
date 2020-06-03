import 'package:flutter/material.dart';
import 'package:silver_memo/db_manager.dart';
import 'package:silver_memo/detail_post_page.dart';

class NotesList extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return new NotesListState();
  }

}

class NotesListState extends State<NotesList> {

  final DbManager manager = new DbManager();
  List<Note> notes;

  @override
  void dispose() {
    super.dispose();
    manager.closeDb();
  }

  @override
  Widget build(BuildContext context) {
    return new FutureBuilder<List<Note>>(
      future: manager.getNotes(),
      builder: (context, snapshot) {
        return new Scaffold(
          appBar: new AppBar(
            title: new Text("  "),
            actions: <Widget>[
              Container(
                height: 60.0 ,
                width: 110.0 ,
                child: FlatButton(
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>new DetailPostPage(manager)));
                    },
                  child: Text('새글쓰기', style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold, fontSize: 20.0), ),

                  ),
              ),
          ]),
          body: buildNotesList(snapshot),
        );
      },
    );
  }

  Widget buildNotesList(AsyncSnapshot<List<Note>> snapshot) {
    switch (snapshot.connectionState) {
      case ConnectionState.none:
      case ConnectionState.waiting:
        return new CircularProgressIndicator();
      default:
        if (snapshot.hasError) {
          return new Text("Unexected error occurs: ${snapshot.error}");
        }
        notes = snapshot.data;
        return Container(
          decoration:BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end:Alignment.bottomLeft,
            colors: [Colors.white, Colors.white]
          ),),
          child: new ListView.builder(
              itemBuilder: (BuildContext context, int index) => _createItem(index),
              itemCount: notes.length),
        );

    }
  }

  Widget _createItem(int index) {
    return new Dismissible(
      key: new UniqueKey(),
      onDismissed: (direction) {
        manager.deleteNote(notes[index].id)
            .then((dynamic) => print("Deleted!"));
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          child: new ListTile(
            title: new Text(notes[index].title, style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.bold, color: Colors.white),),
            subtitle: Padding(
              padding: const EdgeInsets.all(4.0),
              child: new Text(
                  notes[index].description.length > 50
                  ? notes[index].description.substring(0, 50)
                  : notes[index].description,
              style: TextStyle(color:Colors.white)),
            ),

            onTap: () {
              Navigator.of(context)
                  .push(new MaterialPageRoute(builder: (_) => new DetailPostPage(manager, note: notes[index])));
            },
          ),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black45),
            borderRadius: new BorderRadius.all(Radius.circular(20.0)),
            color: Colors.blue
          ),
        ),
      ),
    );
  }
}