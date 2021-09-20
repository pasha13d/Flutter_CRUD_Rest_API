import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:live_data/models/api_response.dart';
import 'package:live_data/models/note.dart';
import 'package:live_data/models/note_insert.dart';
import 'package:live_data/models/notes_for_listing.dart';
import 'package:http/http.dart' as http;

class NotesService {
  static const  API = 'https://tq-notes-api-jkrgrdggbq-el.a.run.app';
  static const headers = {
    'apiKey': '335160b7-172a-4ba4-a1a5-e175d44b9351',
    'Content-Type': 'application/json'
  };
  Future<APIResponse<List<NotesForListing>>> getNotesList() {
    return http.get(Uri.parse(API+'/notes'), headers: headers)
        .then((data) {
          if(data.statusCode == 200) {
            final jsonData = json.decode(data.body);
            final notes = <NotesForListing>[];
            for(var item in jsonData) {
              NotesForListing.fromJson(item);
              notes.add(NotesForListing.fromJson(item));
            }
            return APIResponse<List<NotesForListing>>(data: notes);
          }
        return APIResponse<List<NotesForListing>>(error: true, errorMessage: 'An erro occured');
    })
        .catchError((_) => APIResponse<List<NotesForListing>>(error: true, errorMessage: 'An error occured'));
  }

  //Get by Id
  Future<APIResponse<Note>> getNote(String noteId) {
    return http.get(Uri.parse(API+'/notes/'+noteId), headers: headers)
        .then((data) {
      if(data.statusCode == 200) {
        final jsonData = json.decode(data.body);
        Note.fromJson(jsonData);
        return APIResponse<Note>(data: Note.fromJson(jsonData));
      }
      return APIResponse<Note>(error: true, errorMessage: 'An erro occured');
    })
        .catchError((_) => APIResponse<Note>(error: true, errorMessage: 'An error occured'));
  }

  //CREATE
  Future<APIResponse<bool>> createNote(NoteManipulation item) {
    return http.post(Uri.parse(API+'/notes'), headers: headers, body: json.encode(item.toJason()))
        .then((data) {
      if(data.statusCode == 201) {
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(error: true, errorMessage: 'An error occured');
    })
        .catchError((_) => APIResponse<bool>(error: true, errorMessage: 'An error occured'));
  }

  //UPDATE
  Future<APIResponse<bool>> updateNote(String noteId, NoteManipulation item) {
    return http.put(Uri.parse(API+'/notes/'+noteId), headers: headers, body: json.encode(item.toJason()))
        .then((data) {
      if(data.statusCode == 204) {
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(error: true, errorMessage: 'An error occured');
    })
        .catchError((_) => APIResponse<bool>(error: true, errorMessage: 'An error occured'));
  }

  //DELETE
  Future<APIResponse<bool>> deleteNote(String noteId) {
    return http.delete(Uri.parse(API+'/notes/'+noteId), headers: headers)
        .then((data) {
      if(data.statusCode == 204) {
        return APIResponse<bool>(data: true);
      }
      return APIResponse<bool>(error: true, errorMessage: 'An error occured');
    })
        .catchError((_) => APIResponse<bool>(error: true, errorMessage: 'An error occured'));
  }
}