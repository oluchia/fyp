class EventType {
  final String id;
  final String title;
  final DateTime startDate;
  final DateTime endDate;
  final String description;
  final String moreInfo;
  final String schoolID;

  const EventType({this.id, this.title, this.startDate, this.description, 
              this.endDate, this.moreInfo, this.schoolID}) : assert(startDate != null);

  EventType.fromMap(Map<String, dynamic> data, String id) : this(
    id: id,
    title: data['title'],
    startDate: data['startDateTime'],
    endDate: data['endDateTime'],
    description: data['description'],
    moreInfo: data['moreInfo'],
    schoolID: data['schoolID'],
  );
}