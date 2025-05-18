import 'dart:io';

import 'package:blog_app/core/error/exception.dart';
import 'package:blog_app/features/blog/data/model/blog_model.dart';
import 'package:blog_app/features/blog/domain/entities/blog.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class BlogRemoteDataSources {
  Future<BlogModel> uploadBlog(
    BlogModel blog,
  ); // we will creat the blog model in repository layer and then passes that model directly over here which we will use to upload the blog

  Future<String> uploadBlogImage({
    required File image,
    required BlogModel blog,
  });
  Future<List<BlogModel>> getAllBlogs();
}

class BlogRemoteDataSourcesImpl extends BlogRemoteDataSources {
  final SupabaseClient supabaseClient;
  BlogRemoteDataSourcesImpl(this.supabaseClient);
  @override
  Future<BlogModel> uploadBlog(BlogModel blog) async {
    try {
      final blogData =
          await supabaseClient.from("blogs").insert(blog.toJson()).select();
      return BlogModel.fromJson(
        blogData.first,
      ); // this line simply convert this blogdata map into a blogmodel.
    } on PostgrestException catch (e) {
      // the PostgrestException occured when we called like subabase db cause thats actually use PostgrestException behind the seen .
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> uploadBlogImage({
    required File image,
    required BlogModel blog,
  }) async {
    try {
      await supabaseClient.storage
          .from("blog_images")
          .update(
            blog.id,
            image,
          ); //blog.id is the floder in which our image gonna stored and if we change that path thwn we have to change the path in getpublicurl too in below. and if we want to stored the multiple image the creat the file inside the folder which is done like this : '${blod.id}/image' here blog.id is floder and image is the file .
      return supabaseClient.storage.from("blogs_images").getPublicUrl(blog.id);
    } on StorageException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<BlogModel>> getAllBlogs() async {
    try {
      final blogs = await supabaseClient
          .from("blogs")
          .select('*, profiles(name)');
      return blogs
          .map(
            (blog) => BlogModel.fromJson(
              blog,
            ).copyWith(posterName: blog["profiles"]["name"]),
          )
          .toList(); // this line will convert every single map into the BlogModel
    } on PostgrestException catch (e) {
      // the PostgrestException occured when we called like subabase db cause thats actually use PostgrestException behind the seen .
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
