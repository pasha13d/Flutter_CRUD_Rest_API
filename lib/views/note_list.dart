import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:live_data/models/api_response.dart';
import 'package:live_data/models/notes_for_listing.dart';
import 'package:live_data/services/notes_service.dart';
import 'package:live_data/views/note_delete.dart';
import 'note_modify.dart';

class NoteList extends StatefulWidget {
  // const NoteList({Key? key}) : super(key: key);
  @override
  State<NoteList> createState() => _NoteListState();
}

class _NoteListState extends State<NoteList> {
  NotesService get service => GetIt.I<NotesService>();
  late APIResponse<List<NotesForListing>> _apiResponse;
  bool _isLoading = false;
  // List<NotesForListing> notes = [];

  String formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  @override
  void initState() {
    // notes = service.getNotesList();
    _fetchNotes();
    super.initState();
  }

  _fetchNotes() async {
    setState(() {
      _isLoading = true;
    });

    _apiResponse = await service.getNotesList();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('List of notes'),),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (_) => NoteModify()))
              .then((_) {
            _fetchNotes();
          });
        },
        child: Icon(Icons.add),
      ),
      body: Builder(
        builder: (_){
          if(_isLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if(_apiResponse.error) {
            return Center(
              child: Text('Error occured')
            );
          }
          return ListView.separated(
            separatorBuilder: (_, __) => Divider(height: 1, color: Colors.black45,),
            itemBuilder: (_, index) {
              return Dismissible(
                key: ValueKey(
                    _apiResponse.data![index].noteId
                ),
                direction: DismissDirection.startToEnd,
                onDismissed: (direction) {

                },
                confirmDismiss: (direction) async {
                  final result = await showDialog(
                      context: context,
                      builder: (_)=> NoteDelete()
                  );
                  //Call delete service
                  if(result) {
                    final deleteResult = await service.deleteNote(_apiResponse.data![index].noteId);
                    var message;
                    if(deleteResult != null && deleteResult.data == true) {
                      message = 'Note deleted successfully';
                    }else {
                      message = deleteResult.errorMessage ?? 'Error occured';
                    }
                    //dialogBox
                    showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text('Done'),
                          content: Text(message),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('OK'),
                            )
                          ],
                        ));
                    return deleteResult.data ?? false;
                  }
                  print(result);
                  return result;
                },
                background: Container(
                  color: Colors.red,
                  padding: EdgeInsets.only(left: 16.0),
                  child: Align(
                    child: Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                    alignment: Alignment.centerLeft,
                  ),
                ),
                child: ListTile(
                  title: Text(
                    _apiResponse.data![index].noteTitle,
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                  subtitle: Text(
                    'Last edited on ${_apiResponse.data![index].lastedEditDateTime ?? _apiResponse.data![index].lastedEditDateTime
                    }',
                  ),
                  onTap: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (_) => NoteModify(noteId: _apiResponse.data![index].noteId)))
                    .then((data) => _fetchNotes());
                  },
                ),
              );
            },
            itemCount: _apiResponse.data!.length,
          );
        },
      ),
    );
  }
}
