import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mood_canvas/injection.dart';
import 'package:mood_canvas/src/core/theme/theme_constants.dart';
import 'package:mood_canvas/src/features/mood_tracker/presentation/bloc/mood_tracker_bloc.dart';
import 'package:mood_canvas/src/features/mood_tracker/presentation/bloc/mood_tracker_event.dart';
import 'package:mood_canvas/src/features/mood_tracker/presentation/pages/mood_tracker_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mood Canvas',
      debugShowCheckedModeBanner: false,
      theme: buildLightTheme(primaryColorHex: '#6366F1'),
      darkTheme: buildDarkTheme(primaryColorHex: '#6366F1'),
      home: BlocProvider(
        create: (_) =>
            getIt<MoodTrackerBloc>()..add(const MoodTrackerStarted()),
        child: const MoodTrackerPage(),
      ),
    );
  }
}
