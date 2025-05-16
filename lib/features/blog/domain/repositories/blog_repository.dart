import 'dart:io';

import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class BlogRepository {
  Future<Either<Failures, Blog>> uploadBlog({
    // using this method we are gonna called 2 method of datasource 1.blogimage method and 2.uploadblog to databse method.
    required File image,
    required String title,
    required String content,
    required String posterId,
    required List<String> topics,
  });
}
