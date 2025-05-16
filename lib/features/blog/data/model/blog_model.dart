import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:fpdart/fpdart.dart';

class BlogModel extends Blog {
  BlogModel({
    required super.id,
    required super.posterId,
    required super.title,
    required super.content,
    required super.imageUrl,
    required super.topics,
    required super.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'posterId': posterId,
      'title': title,
      'content': content,
      'imageUrl': imageUrl,
      'topics': topics,
      'updatedAt':
          updatedAt
              .toIso8601String(), //this will return us the string and when its going to supabse it have timestamp propertioes //millisecondsSinceEpoch,<-- this is by default given which required the integer and this will giving us the integer.
    };
  }

  factory BlogModel.fromMap(Map<String, dynamic> map) {
    return BlogModel(
      id: map['id'] as String,
      posterId: map['posterId'] as String,
      title: map['title'] as String,
      content: map['content'] as String,
      imageUrl: map['imageUrl'] as String,
      topics: List<String>.from(map['topics'] as List<String>),
      updatedAt:
          map["updated_at"] == null
              ? DateTime.now()
              : DateTime.parse(
                map["updated_at"],
              ), // we put .parse beacuse this parse will convert the string into the DateTime.and thats exactly we want.
    );
  }
}
