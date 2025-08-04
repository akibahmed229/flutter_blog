part of 'blog_bloc.dart';

@immutable
sealed class BlogEvent {
  const BlogEvent();
}

final class UploadBlogEvent extends BlogEvent {
  final File image;
  final String title;
  final String content;
  final String posterId;
  final List<String> topics;

  const UploadBlogEvent({
    required this.image,
    required this.title,
    required this.content,
    required this.posterId,
    required this.topics,
  });
}

final class GetAllBlogsEvent extends BlogEvent {
  const GetAllBlogsEvent();
}
