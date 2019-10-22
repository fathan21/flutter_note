import 'package:flutter/src/widgets/editable_text.dart';

class Note {
    int id;
    String title;
    String content;

    Note({
        this.id,
        this.title,
        this.content, TextEditingController contents,
    });

    // Create a Note from JSON data
    factory Note.fromJson(Map<String, dynamic> json) => new Note(
        id: json["id"],
        title: json["title"],
        content: json["content"],
    );

    // Convert our Note to JSON to make it easier when we store it in the database
    Map<String, dynamic> toJson() => {
        "id": id,
        "title":title,
        "content": content,
    };
}