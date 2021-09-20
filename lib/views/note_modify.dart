import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:live_data/models/note.dart';
import 'package:live_data/models/note_insert.dart';
import 'package:live_data/services/notes_service.dart';

class NoteModify extends StatefulWidget {
  // const NoteModify({Key? key}) : super(key: key);
  final String? noteId;
  NoteModify({this.noteId});

  @override
  State<NoteModify> createState() => _NoteModifyState();
}

class _NoteModifyState extends State<NoteModify> {
  bool get isEditing => widget.noteId != null;
  NotesService get noteService => GetIt.I<NotesService>();
  late String errorMessage;
  late Note note;
  TextEditingController _titleController = TextEditingController();
  TextEditingController _contentController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();


    if(isEditing){
      setState(() {
        _isLoading = true;
      });

      noteService.getNote(widget.noteId!)
          .then((response) {
        setState(() {
          _isLoading = false;
        });
        if(response.error) {
          errorMessage = response.errorMessage ?? 'An error occured';
        }
        note = response.data!;
        _titleController.text = note.noteTitle;
        _contentController.text = note.noteContent;
      });
    }
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEditing ? 'Edit Note' : 'Create note'),),
      body: Padding(
        padding: EdgeInsets.all(12.0),
        child: _isLoading ? Center(child: CircularProgressIndicator()) : Column(
          children: <Widget>[
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
              hintText: 'Note Title'
            ),
            ),
            Container(height: 8.0,),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(
                hintText: 'Note Content'
            ),
            ),
            Container(height: 16.0,),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                  onPressed: () async {
                    if(isEditing) {
                      //update note in api
                      //display loading
                      setState(() {
                        _isLoading = true;
                      });
                      //create note in api
                      //create model class
                      final note = NoteManipulation(
                          noteTitle: _titleController.text,
                          noteContent: _contentController.text
                      );
                      final result = await noteService.updateNote(widget.noteId!, note);
                      //after request is done then remove loading
                      setState(() {
                        _isLoading = false;
                      });
                      final title = 'Done';
                      final text = result.error ? (result.errorMessage ?? 'Error occured') : 'Note updated';

                      showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text(title),
                            content: Text(text),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('OK'),
                              )
                            ],
                          )
                      ).then((data) {
                        if(result.data!) {
                          Navigator.of(context).pop();
                        }
                      });
                    }else {
                      //display loading
                      setState(() {
                        _isLoading = true;
                      });
                      //create note in api
                      //create model class
                      final note = NoteManipulation(
                        noteTitle: _titleController.text,
                        noteContent: _contentController.text
                      );
                      final result = await noteService.createNote(note);
                      //after request is done then remove loading
                      setState(() {
                        _isLoading = false;
                      });
                      final title = 'Done';
                      final text = result.error ? (result.errorMessage ?? 'Error occured') : 'Note created';

                      showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text(title),
                            content: Text(text),
                            actions: <Widget>[
                              TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('OK'),
                              )
                            ],
                          )
                      ).then((data) {
                        if(result.data!) {
                          Navigator.of(context).pop();
                        }
                      });
                    }
                  },
                  child: Text('Submit'),
                style: TextButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                    )
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
