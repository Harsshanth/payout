import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:taskkeeper/models/note.dart';
import 'package:taskkeeper/screens/upload_form.dart';
import 'package:taskkeeper/utils/database_helper.dart';

// ignore: must_be_immutable
class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => HomeState();
}

class HomeState extends State<Home> {
  int totAmount = 0;
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Note> noteList = <Note>[];

  @override
  void initState() {
    updateListView();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // if (noteList == null) {
    //   noteList = <Note>[];

    // }
    return Scaffold(
      appBar: AppBar(
        title: Text("Money Spend"),
        backgroundColor: Colors.purpleAccent,
        actions: [
          Center(
              child: Text(
            "$totAmount",
            style: TextStyle(fontSize: 25.0),
          )),
        ],
      ),
      body: getListView(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navigatorToNote(Note('', '', ''), 'Add Note');
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.purple,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  ListView getListView() {
    return ListView.builder(
      itemCount: noteList.length,
      itemBuilder: (BuildContext context, int position) {
        return Card(
          color: Colors.white,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.purple,
              child: Icon(Icons.money_off),
            ),
            title: Text((this.noteList[position].amount)),
            subtitle: Text(this.noteList[position].date),
            trailing: GestureDetector(
              child: Icon(Icons.delete, color: Colors.red),
              onTap: () {
                _delete(context, noteList[position]);
              },
            ),
            onTap: () {
              navigatorToNote(noteList[position], "Edit Note");
            },
          ),
        );
      },
    );
  }

  void _delete(BuildContext context, Note note) async {
    int? result = await databaseHelper.deleteNote(note.id);
    if (result != 0) {
      _showSnackBar(context, 'Deleted');
      updateListView();
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    // ignore: deprecated_member_use
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void navigatorToNote(Note note, String title) async {
    bool result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => UploadForm(note, title)));
    if (result == true) {
      updateListView();
    }
  }

  Future<void> updateListView() async {
    final Database db = await databaseHelper.initializeDatabase();

    List<Note> noteList = await databaseHelper.getNoteList();

    setState(() {
      this.noteList = noteList;
      this.totAmount = noteList
          .map((e) => int.tryParse(e.amount) ?? 0)
          .reduce((value, element) => value + element);
    });
  }
}
