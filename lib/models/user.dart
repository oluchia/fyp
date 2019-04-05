class User {
  final String id;
  final String name;
  final String email;
  final String token;
  final Note note;

  const User({this.id, this.name, this.email,
              this.note, this.token}) : assert(id != null);

  User.fromMap(Map<String, dynamic> data) : this(
    name: data['name'],
    email: data['email'],
    note: _getNote(data['note']),
  );

  Map<String, dynamic> toMap() => {
    'name' : name,
    'email' : email,
    'note' : note != null ? note.toMap() : null,
    'token' : token,
  };

  static Note _getNote(Map<dynamic, dynamic> data) {
    if(data == null) {
      return null;
    }

    Note temp = new Note(dateAdded: data["dateAdded"], description: data["description"], type: data["type"]);
    return temp;
  }

}

enum Type {ABSENCE, CALL, EMAIL}

class Note {
  final String dateAdded;
  final String description;
  final String type;

  const Note({this.dateAdded, this.description, this.type});

  Map<String, dynamic> toMap() => {
    'dateAdded' : dateAdded,
    'description' : description,
    'type' : type
  };
}