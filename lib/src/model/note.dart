
class Note {
    int id;
    String title;
    String content;
    String created_at;
    String updated_at;
    String deleted_at;
    int is_archive;

    Note({
        this.id,
        this.title,
        this.content,
        this.created_at,
        this.updated_at,
        this.deleted_at,
        this.is_archive
    });

    // Create a Note from JSON data
    factory Note.fromJson(Map<String, dynamic> json) => new Note(
        id: json["id"],
        title: json["title"],
        content: json["content"],
        created_at: json["created_at"],
        updated_at: json["updated_at"],
        deleted_at: json["deleted_at"],
        is_archive: json["is_archive"],
    );

    // Convert our Note to JSON to make it easier when we store it in the database
    Map<String, dynamic> toJson() => {
        "id": id,
        "title":title,
        "content": content,
        "created_at": created_at
    };
}