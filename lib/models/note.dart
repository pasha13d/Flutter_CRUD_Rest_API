class Note {
  String noteId;
  String noteTitle;
  String noteContent;
  DateTime createDateTime;
  DateTime? lastedEditDateTime;
  Note({
    required this.noteId,
    required this.noteTitle,
    required this.noteContent,
    required this.createDateTime,
    this.lastedEditDateTime});

  factory Note.fromJson(Map<String, dynamic> item) {
    return Note(
      noteId: item['noteID'],
      noteTitle: item['noteTitle'],
      noteContent: item['noteContent'],
      createDateTime: DateTime.parse(item['createDateTime']),
      lastedEditDateTime: item['latestEditDateTime'] != null ? DateTime.parse(item['latestEditDateTime']) : null,
    );
  }
}