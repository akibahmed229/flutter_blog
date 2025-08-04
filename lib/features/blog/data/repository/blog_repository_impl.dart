import 'dart:io';

import 'package:blog_app/core/error/execptions.dart';
import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/network/connection_checker.dart';
import 'package:blog_app/features/blog/data/datasources/blog_local_data_soure.dart';
import 'package:blog_app/features/blog/data/datasources/blog_remote_data_source.dart';
import 'package:blog_app/features/blog/data/models/blog_model.dart';
import 'package:blog_app/features/blog/domain/entities/blog_entities.dart';
import 'package:blog_app/features/blog/domain/repository/blog_repository.dart';
import 'package:fpdart/fpdart.dart';
import 'package:uuid/uuid.dart';

class BlogRepositoryImpl implements BlogRepository {
  final BlogRemoteDataSource blogRemoteDataSource;
  final BlogLocalDataSoure blogLocalDataSoure;
  final ConnectionChecker connectionChecker;
  const BlogRepositoryImpl({
    required this.blogRemoteDataSource,
    required this.blogLocalDataSoure,
    required this.connectionChecker,
  });

  @override
  Future<Either<Failure, BlogEntities>> uploadBlog({
    required File image,
    required String title,
    required String content,
    required String posterId,
    required List<String> topics,
  }) async {
    try {
      // check if internet connection is present
      if (!await connectionChecker.isConnected) {
        return left(Failure(message: "No Internet Connection!"));
      }

      BlogModel blogModel = BlogModel(
        id: const Uuid().v8(),
        posterId: posterId,
        title: title,
        content: content,
        imageUrl: "",
        topics: topics,
        updatedAt: DateTime.now(),
      );

      // Upload the image and get the URL
      final imageUrl = await blogRemoteDataSource.uploadImage(
        image: image,
        blog: blogModel,
      );

      // Update the blog model with the image URL
      blogModel = blogModel.copyWith(imageUrl: imageUrl);

      // Upload the blog model to the remote data source
      final uploadedBlog = await blogRemoteDataSource.uploadBlog(blogModel);

      return right(uploadedBlog);
    } on ServerException catch (e) {
      return left(
        Failure(message: 'Failed to create blog model: ${e.message}'),
      );
    }
  }

  @override
  Future<Either<Failure, List<BlogEntities>>> getAllBlogs() async {
    try {
      if (await connectionChecker.isConnected) {
        final blogs = await blogRemoteDataSource.getAllBlogs();

        if (blogs.isNotEmpty) {
          blogLocalDataSoure.uploadLocalBlogs(blogs: blogs);
        }

        return right(blogs);
      } else {
        final cachedBlogs = blogLocalDataSoure.loadBlogs();
        if (cachedBlogs.isNotEmpty) {
          return right(cachedBlogs);
        } else {
          return left(
            Failure(message: "No internet and no cached blogs found."),
          );
        }
      }
    } on ServerException catch (e) {
      return left(Failure(message: "Feiled to fetched blogs ${e.message}"));
    }
  }
}
