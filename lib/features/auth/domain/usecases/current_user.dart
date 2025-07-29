import 'package:blog_app/core/common/entities/user_entities.dart';
import 'package:blog_app/core/error/failure.dart';
import 'package:blog_app/core/usecase/usecase.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:fpdart/fpdart.dart';

/*
   Use case for fetching the current authenticated user.

   This class acts as an intermediary between the UI/business logic
   and the repository layer. It follows Clean Architecture principles,
   encapsulating the logic to get the current user without exposing
   implementation details.

   Implements [Usecase] interface:
    - Input: [NoParams] (no input required)
    - Output: [Either]<[Failure], [UserEntities]> representing success or failure
*/
class CurrentUser implements Usecase<UserEntities, NoParams> {
  // Repository dependency injected via constructor.
  final AuthRepository authRepository;

  const CurrentUser({required this.authRepository});

  /*
     Executes the use case to fetch the current user.
    
     Calls the repository's method to get the current user.
     Returns an Either type with [Failure] on error or [UserEntities] on success.
  */
  @override
  Future<Either<Failure, UserEntities>> call(NoParams params) async {
    return await authRepository.currentUser();
  }
}
