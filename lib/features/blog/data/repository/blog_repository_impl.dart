import 'dart:io';

import 'package:blog_app/core/error/exception.dart';
import 'package:blog_app/core/error/failures.dart';
import 'package:blog_app/core/network/connection_checker.dart';
import 'package:blog_app/features/blog/data/datasouces/blog_local_data_source.dart';
import 'package:blog_app/features/blog/data/datasouces/blog_remote_data_sources.dart';
import 'package:blog_app/features/blog/data/model/blog_model.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:blog_app/features/blog/domain/repositories/blog_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

class BlogRepositoryImpl implements BlogRepository {
  final BlogRemoteDataSources blogRemoteDataSources;
  final BlogLocalDataSource blogLocalDataSource;
  final ConnectionChecker connectionChecker;
  BlogRepositoryImpl(
    this.blogRemoteDataSources,
    this.blogLocalDataSource,
    this.connectionChecker,
  );

  @override
  Future<Either<Failures, Blog>> uploadBlog({
    required File image,
    required String title,
    required String content,
    required String posterId,
    required List<String> topics,
  }) async {
    try {
      BlogModel blogModel = BlogModel(
        id: const Uuid().v1(),
        posterId: posterId,
        title: title,
        content: content,
        imageUrl: " ",
        topics: topics,
        updatedAt: DateTime.now(),
      );
      final imageUrl = await blogRemoteDataSources.uploadBlogImage(
        image: image,
        blog: blogModel,
      );
      blogModel = blogModel.copyWith(
        // now we just have to upload this blogmodel in to the supabase database
        imageUrl: imageUrl,
      );

      final uploadedBlog = await blogRemoteDataSources.uploadBlog(
        blogModel,
      ); // now this will return me the most up-to-dated blog
      return right(uploadedBlog);
    } on ServerException catch (e) {
      return left(Failures(e.message));
    }
  }

  @override
  Future<Either<Failures, List<Blog>>> getAllBlogs() async {
    try {
      final blogs = await blogRemoteDataSources.getAllBlogs();

      return right(
        blogs,
      ); // here we are returning list of BlogModel and this required list of  Blog
    } on ServerException catch (e) {
      return left(Failures(e.message));
    }
  }
}
