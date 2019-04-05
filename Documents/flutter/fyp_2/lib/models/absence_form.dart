class AbsenceForm {
  String name;
  String description;

  AbsenceForm({this.name, this.description});

  AbsenceForm.fromJson(Map<String, dynamic> json)
    : name = json['subject'],
      description = json['description'];

  Map<String, dynamic> toJson() => 
  {
    'subject' : name,
    'description' : description,

  };
}