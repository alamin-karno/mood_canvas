import 'package:mood_canvas/src/utils/typedefs.dart';

import '../repositories/auth_repository.dart';

class LogoutUseCase {
  const LogoutUseCase(this._repository);

  final AuthRepository _repository;

  FutureEither<void> call() => _repository.logout();
}
