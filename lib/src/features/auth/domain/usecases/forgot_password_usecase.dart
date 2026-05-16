import 'package:mood_canvas/src/utils/typedefs.dart';

import '../repositories/auth_repository.dart';

class ForgotPasswordUseCase {
  const ForgotPasswordUseCase(this._repository);

  final AuthRepository _repository;

  FutureEither<void> call({required String email}) {
    return _repository.forgotPassword(email: email);
  }
}
