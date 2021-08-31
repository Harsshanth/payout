import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:taskkeeper/models/note.dart';
import 'package:taskkeeper/screens/home.dart';
import 'package:taskkeeper/utils/database_helper.dart';

class UploadForm extends StatefulWidget {
  final String appBarTitle;
  final Note note;
  UploadForm(this.note, this.appBarTitle);
  @override
  State<StatefulWidget> createState() =>
      UploadFormState(this.note, this.appBarTitle);
}

class UploadFormState extends State<UploadForm> {
  String? _date;
  DatabaseHelper helper = DatabaseHelper();
  late String appBarTitle;
  Note note;
  UploadFormState(this.note, this.appBarTitle);

  TextEditingController amountController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void initState() {
    amountController.text = note.amount;
    descriptionController.text = note.description;
    _date = note.date;

    super.initState();
  }

  Widget _buildAmount() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: "Amount Spend",
          labelStyle: TextStyle(color: Colors.purple),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.purple)),
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.purple))),
      keyboardType: TextInputType.number,
      controller: amountController,
      validator: (var value) {
        if (value!.isEmpty) {
          return 'Enter the Amount';
        }

        return null;
      },
      onChanged: (value) {
        updateAmount();
      },
    );
  }

  Widget _buildDescription() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Description',
          labelStyle: TextStyle(color: Colors.purple),
          focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.purple)),
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.purple))),
      controller: descriptionController,
      validator: (var value) {
        if (value!.isEmpty) {
          return 'Required';
        }

        return null;
      },
      onChanged: (value) {
        updateDescription();
      },
    );
  }

  Widget _buildDate() {
    final date = _date;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          final newDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1900),
            lastDate: DateTime.now(),
          );
          if (newDate == null) return;
          setState(() {
            _date = newDate.toString().substring(0, 10);
            updateDate();
          });
        },
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              color: Colors.transparent,
              border: Border.all(
                width: 1,
                color: Colors.purple,
              )),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
          margin: EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Date: ' + (date != null ? date : 'Not selected'),
            style: TextStyle(
              color: Colors.purple,
              backgroundColor: Colors.transparent,
              fontSize: 16.0,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
        backgroundColor: Colors.purpleAccent,
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 10),
                _buildAmount(),
                SizedBox(height: 30),
                _buildDate(),
                SizedBox(height: 10),

                _buildDescription(),

                SizedBox(height: 10),

                SizedBox(height: 50),
                // ignore: deprecated_member_use
                RaisedButton(
                  child: Text(
                    'Upload',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  onPressed: () {
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }

                    _save();
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30))),
                  color: Colors.purple,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void updateAmount() {
    note.amount = amountController.text;
  }

  void updateDescription() {
    note.description = descriptionController.text;
  }

  void updateDate() {
    note.date = _date!;
  }

  void _save() async {
    int result;
    if (note.id != null) {
      result = await helper.updateNote(note);
    } else {
      result = await helper.insertNote(note);
    }

    Navigator.pop(context, true);

    if (result != 0) {
      _showAlertDialog('Status', 'Successfully');
    } else {
      _showAlertDialog('Status', 'Problem in saving');
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }
}
