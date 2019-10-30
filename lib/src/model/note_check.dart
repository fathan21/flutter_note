
class NoteCheck {
    int id;
    String content = '';
    int isChecked = 0;
    int noteId;
    int order;
    String createdAt;
    String updatedAt;
    String deletedAt;

    NoteCheck({
        this.id,
        this.isChecked,
        this.content,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.noteId,
        this.order,
    });

    // Create a Note from JSON data
    factory NoteCheck.fromJson(Map<String, dynamic> json) => new NoteCheck(
        id: json["id"],
        isChecked: json["is_checked"],
        content: json["content"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        deletedAt: json["deleted_at"],
        noteId: json["note_id"],
        order: json["order"],
    );

    // Convert our Note to JSON to make it easier when we store it in the database
    Map<String, dynamic> toJson() => {
        "id": id,
        "content": content,
        "created_at": createdAt,
        "is_checked": isChecked,
        "note_id": noteId,
        'order': order
    };
}