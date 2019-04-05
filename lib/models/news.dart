class News {
  final String id;
  final String title;
  final String author;
  final String date;
  final String description;
  final String imageUrl;
  final String schoolId;
  final bool isSportsNews;

  const News({this.id, this.title, this.author, this.description, 
              this.date, this.imageUrl, this.schoolId, this.isSportsNews});

  News.fromMap(Map<String, dynamic> data, String id) : this(
    id: id,
    title: data['title'],
    author: data['author'],
    date: data['date'],
    description: data['description'],
    imageUrl: data['imageUrl'],
    schoolId: data['schoolID'],
    isSportsNews: data['isSportsNews']
  );
}