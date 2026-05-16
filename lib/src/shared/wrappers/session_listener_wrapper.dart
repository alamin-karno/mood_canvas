import 'package:mood_canvas/src/imports/core_imports.dart';
import 'package:mood_canvas/src/imports/packages_imports.dart';

import 'package:mood_canvas/src/features/auth/presentation/bloc/session_bloc.dart';

class SessionListenerWrapper extends StatelessWidget {
  const SessionListenerWrapper({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SessionBloc, SessionState>(
      listenWhen: (prev, next) => prev.status != next.status,
      listener: (context, state) {
        if (state.status != SessionStatus.unknown) {
          FlutterNativeSplash.remove();
        }
      },
      child: child,
    );
  }
}
