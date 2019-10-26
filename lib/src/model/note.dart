
class Note {
    int id;
    String title;
    String content;
    String createdAt;
    String updatedAt;
    String deletedAt;
    int isArchive;
    int color;
    String alarm;

    Note({
        this.id,
        this.title,
        this.content,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.isArchive,
        this.alarm,
        this.color
    });

    // Create a Note from JSON data
    factory Note.fromJson(Map<String, dynamic> json) => new Note(
        id: json["id"],
        title: json["title"],
        content: json["content"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
        deletedAt: json["deleted_at"],
        isArchive: json["is_archive"],
        color: json["color"],
        alarm: json["alarm"]
    );

    // Convert our Note to JSON to make it easier when we store it in the database
    Map<String, dynamic> toJson() => {
        "id": id,
        "title":title,
        "content": content,
        "created_at": createdAt,
        "color": color,
        "alarm": alarm
    };
}