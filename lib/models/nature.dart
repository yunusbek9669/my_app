class Nature {
  final String title;
  final String imageUrl;
  final String cost;
  final String date;
  final String description;

  Nature(this.title, this.imageUrl, this.cost, this.date, this.description);

  factory Nature.fromJson(Map<String, dynamic> json) {
    return Nature(
      json['title'],
      json['imageUrl'],
      json['cost'],
      json['date'],
      json['description'],
    );
  }
}