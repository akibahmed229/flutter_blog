import 'dart:io';

import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/blog/domain/entities/blog_entities.dart';
import 'package:blog_app/features/blog/domain/usecases/get_all_blogs.dart';
import 'package:blog_app/features/blog/domain/usecases/upload_blog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'blog_state.dart';
part 'blog_event.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlog _uploadBlog;
  final GetAllBlogs _getAllBlogs;

  BlogBloc({required UploadBlog uploadBlog, required GetAllBlogs getAllBlogs})
    : _uploadBlog = uploadBlog,
      _getAllBlogs = getAllBlogs,
      super(BlogInitial()) {
    on<BlogEvent>((event, emit) => emit(BlogLoading()));
    on<UploadBlogEvent>(_onUploadBlog);
    on<GetAllBlogsEvent>(_onGetAllBlogs);
  }

  void _onUploadBlog(UploadBlogEvent event, Emitter<BlogState> emit) async {
    final res = await _uploadBlog(
      UploadBlogParams(
        image: event.image,
        title: event.title,
        content: event.content,
        posterId: event.posterId,
        topics: event.topics,
      ),
    );

    res.fold(
      (failure) => emit(BlogFailure(message: failure.message)),
      (blog) => emit(BlogUploadSuccess()),
    );
  }

  void _onGetAllBlogs(GetAllBlogsEvent event, Emitter<BlogState> emit) async {
    final res = await _getAllBlogs(NoParams());

    res.fold(
      (failure) => emit(BlogFailure(message: failure.message)),
      (blogs) => emit(BlogGetAllSuccess(blogs)),
    );
  }
}
