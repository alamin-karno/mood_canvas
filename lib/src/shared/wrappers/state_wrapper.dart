import '../../imports/imports.dart';
import '../../../injection.dart';
import '../../features/auth/presentation/bloc/session_bloc.dart';

class StateWrapper extends StatelessWidget {
  const StateWrapper({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SessionBloc>.value(
      value: getIt<SessionBloc>(),
      child: child,
    );
  }
}
