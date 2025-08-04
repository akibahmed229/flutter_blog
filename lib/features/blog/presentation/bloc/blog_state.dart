part of 'blog_bloc.dart';

@immutable
sealed class BlogState {
  const BlogState();
}

final class BlogInitial extends BlogState {
  const BlogInitial();
}

final class BlogLoading extends BlogState {
  const BlogLoading();
}

final class BlogFailure extends BlogState {
  final String message;

  const BlogFailure({required this.message});
}

final class BlogUploadSuccess extends BlogState {
  const BlogUploadSuccess();
}

final class BlogGetAllSuccess extends BlogState {
  final List<BlogEntities> blogs;

  const BlogGetAllSuccess(this.blogs);
}
