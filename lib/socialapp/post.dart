class Post {
  final String postid;
  final String userid;
  final String username;
  final likes;
  final String description;
  final DateTime dateReleased;
  final String postURL;
  final String profImage;

  const Post({
    required this.postid,
    required this.userid,
    required this.username,
    required this.likes,
    required this.description,
    required this.dateReleased,
    required this.postURL,
    required this.profImage,
  });
}
