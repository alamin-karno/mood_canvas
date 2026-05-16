import 'package:mood_canvas/src/imports/core_imports.dart';
import 'package:mood_canvas/src/imports/packages_imports.dart';

import '../../../auth/presentation/bloc/session_bloc.dart';
import '../../../mood/presentation/widgets/mood_face_avatar.dart';
import '../../../mood/domain/entities/mood_type.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final session = context.watch<SessionBloc>().state;
    final user = session.user;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppTopBar(
        title: 'home.home_title'.tr(),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => context
                .read<SessionBloc>()
                .add(const SessionLogoutRequested()),
          ),
        ],
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 600;
            final padding = EdgeInsets.all(AppSpacing.xl.w);

            return Padding(
              padding: padding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    user?.name ?? user?.email ?? 'home.welcome_home'.tr(),
                    style: textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: AppSpacing.sm.h),
                  Text(
                    'home.home_subtitle'.tr(),
                    style: textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: AppSpacing.xxl.h),
                  Expanded(
                    child: Center(
                      child: MoodFaceAvatar(
                        moodType: MoodType.happy,
                        size: isWide ? 120 : 96,
                        intensity: 4,
                      ),
                    ),
                  ),
                  AppButton(
                    label: 'mood.log_mood'.tr(),
                    onPressed: () => context.push(AppRoutes.moodLog),
                    isFullWidth: true,
                  ),
                  SizedBox(height: AppSpacing.md.h),
                  AppButton(
                    label: 'mood.view_history'.tr(),
                    variant: ButtonVariant.outline,
                    onPressed: () => context.push(AppRoutes.moodHistory),
                    isFullWidth: true,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
