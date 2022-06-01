class CommentModel {
  CommentModel({
    this.postId,
    this.id,
    this.name,
    this.email,
    this.body,
  });

  factory CommentModel.fromJson({Map<String, dynamic>? json}) {
    return CommentModel(
      postId: json?['postId'] as int,
      id: json?['id'] as int,
      name: json?['name'] as String,
      email: json?['email'] as String,
      body: json?['body'] as String,
    );
  }

  int? postId;
  int? id;
  String? name;
  String? email;
  String? body;
}
