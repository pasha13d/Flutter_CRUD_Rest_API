class NoteManipulation {
  String noteTitle;
  String noteContent;
  NoteManipulation({
    required this.noteTitle,
    required this.noteContent,
  });
  Map<String, dynamic> toJason() {
    return {
    "noteTitle": noteTitle,
    "noteContent": noteContent,
    };
  }
}