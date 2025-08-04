import 'dart:io';

import 'package:blog_app/core/error/execptions.dart';
import 'package:blog_app/features/blog/data/models/blog_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

abstract interface class BlogRemoteDataSource {
  Future<BlogModel> uploadBlog(BlogModel blog);

  Future<String> uploadImage({required File image, required BlogModel blog});

  Future<List<BlogModel>> getAllBlogs();
}

class BlogRemoteDataSourceImpl implements BlogRemoteDataSource {
  final SupabaseClient supabaseClient;
  const BlogRemoteDataSourceImpl({required this.supabaseClient});

  @override
  Future<BlogModel> uploadBlog(BlogModel blog) async {
    try {
      final blogData = await supabaseClient
          .from("blogs")
          .insert(blog.toJson())
          .select();

      return BlogModel.fromJson(blogData.first);
    } on PostgrestException catch (e) {
      throw ServerException('Failed to upload blog: ${e.message}');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> uploadImage({
    required File image,
    required BlogModel blog,
  }) async {
    try {
      await supabaseClient.storage.from("blog_images").upload(blog.id, image);

      return supabaseClient.storage.from("blog_images").getPublicUrl(blog.id);
    } on StorageException catch (e) {
      throw ServerException("Failed to upload image: ${e.message}");
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<BlogModel>> getAllBlogs() async {
    try {
      // used Joined operation in supabase to get profile,blogs table
      final blogsData = await supabaseClient
          .from("blogs")
          .select("*, profiles (name)");

      return blogsData
          .map(
            (blog) => BlogModel.fromJson(
              blog,
            ).copyWith(posterName: blog["profiles"]["name"]),
          )
          .toList();
    } on PostgrestException catch (e) {
      throw ServerException('Failed to fetched blogs: ${e.message}');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
