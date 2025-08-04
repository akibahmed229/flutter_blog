import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/blog/domain/entities/blog_entities.dart';
import 'package:blog_app/features/blog/domain/repository/blog_repository.dart';
import 'package:fpdart/fpdart.dart';

class GetAllBlogs implements Usecase<List<BlogEntities>, NoParams> {
  final BlogRepository blogRepository;
  const GetAllBlogs({required this.blogRepository});

  @override
  Future<Either<Failure, List<BlogEntities>>> call(NoParams params) async {
    return await blogRepository.getAllBlogs();
  }
}
