class EventType {
  final String id;
  final String title;
  final DateTime startDate;
  final DateTime endDate;
  final String description;
  final String moreInfo;
  final String schoolId;
  final String location;

  const EventType({this.id, this.title, this.startDate, this.description, 
              this.endDate, this.moreInfo, this.schoolId, this.location}) : assert(startDate != null);

  EventType.fromMap(Map<String, dynamic> data, String id) : this(
    id: id,
    title: data['title'],
    startDate: _check(data['startDateTime']), 
    endDate: _check(data['endDateTime']),
    description: data['description'],
    moreInfo: data['moreInfo'],
    schoolId: data['schoolId'],
    location: data['location'],
  );

  static Object _check(dynamic date) {
    if(date is DateTime) {
      return date;
    } else return date.toDate();
  }
   
}