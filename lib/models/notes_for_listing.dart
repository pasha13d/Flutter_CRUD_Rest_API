import 'package:json_annotation/json_annotation.dart';
import 'package:build_runner/build_runner.dart';
// import 'lib.g.dart';
//
// part 'note_for_linting.g.dart';

// @JsonSerializable()
class NotesForListing {
  String noteId;
  String noteTitle;
  DateTime createDateTime;
  DateTime? lastedEditDateTime;

  NotesForListing({
    required this.noteId,
    required this.noteTitle,
    required this.createDateTime,
    this.lastedEditDateTime});

  factory NotesForListing.fromJson(Map<String, dynamic> item) {
    return NotesForListing(
      noteId: item['noteID'],
      noteTitle: item['noteTitle'],
      createDateTime: DateTime.parse(item['createDateTime']),
      lastedEditDateTime: item['latestEditDateTime'] != null ? DateTime.parse(item['latestEditDateTime']) : null,
    );
  }
}