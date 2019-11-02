
import 'package:note_f/src/model/note_check.dart';

class Note {
    int id;
    String title = '';
    String content;
    String createdAt;
    String updatedAt;
    String deletedAt;
    int isArchive;
    int color;
    String alarm;
    String type;

    Note({
        this.id,
        this.title,
        this.content,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.isArchive,
        this.alarm,
        this.color,
        this.type
    });

    // Create a Note from JSON data
    factory Note.fromJson(Map<String, dynamic> json) => new Note(
        id: json["id"],
        title: json["title"].toString(),
        content: json["content"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        deletedAt: json["deleted_at"],
        isArchive: json["is_archive"],
        color: json["color"],
        alarm: json["alarm"],
        type: json['type']
    );

    // Convert our Note to JSON to make it easier when we store it in the database
    Map<String, dynamic> toJson() => {
        "id": id,
        "title":title.toString(),
        "content": content,
        "created_at": createdAt,
        "color": color,
        "alarm": alarm,
        'type': type
    };
}


class NoteComp {
  List<NoteCheck> noteCheck;
  Note note;
  
    NoteComp({
        this.noteCheck,
        this.note,
    });
  
    // Create a Note from JSON data
    factory NoteComp.fromJson(note, noteCheck) => new NoteComp(
        note: note,
        noteCheck: noteCheck,
    );

}

