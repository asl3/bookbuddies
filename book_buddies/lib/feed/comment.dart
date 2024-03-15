class Comment {
  final String username;
  final String comment;
  final DateTime time;

  const Comment(this.username, this.comment, this.time);

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
        json['username'], json['comment'], DateTime.parse(json['time']));
  }
}
