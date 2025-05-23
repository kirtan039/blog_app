// ignore_for_file: public_member_api_docs, sort_constructors_first

class Blog {
  final String id;
  final String posterId;
  final String title;
  final String content;
  final String imageUrl;
  final List<String> topics;
  final DateTime updatedAt;
  final String?
  posterName; // i put here poster name nullable because at the time creating blogmodel we are not passing the posterName , we only get the name when we doing the join opretion in getAllBlog function .

  Blog({
    required this.id,
    required this.posterId,
    required this.title,
    required this.content,
    required this.imageUrl,
    required this.topics,
    required this.updatedAt,
    this.posterName,
  });
}
