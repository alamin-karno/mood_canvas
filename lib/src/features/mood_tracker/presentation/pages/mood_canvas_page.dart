import 'package:mood_canvas/src/imports/core_imports.dart';
import 'package:mood_canvas/src/imports/packages_imports.dart';

import '../../../auth/presentation/bloc/session_bloc.dart';
import '../../domain/entities/mood_type.dart';
import '../bloc/mood_bloc.dart';
import '../bloc/mood_event.dart';
import '../bloc/mood_state.dart';
import '../widgets/mood_face_avatar.dart';

class MoodCanvasPage extends StatefulWidget {
  const MoodCanvasPage({super.key});

  @override
  State<MoodCanvasPage> createState() => _MoodCanvasPageState();
}

class _MoodCanvasPageState extends State<MoodCanvasPage> {
  final _noteController = TextEditingController();

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userId = context.watch<SessionBloc>().state.user?.id;
    if (userId == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return BlocConsumer<MoodBloc, MoodState>(
      listenWhen: (prev, next) =>
          prev.status != next.status && next.status == MoodStatus.success,
      listener: (context, state) {
        showToast(
          context,
          message: 'mood.logged_success'.tr(),
          status: 'success',
        );
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppTopBar(title: 'mood.log_mood'.tr()),
          body: SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final faceSize = constraints.maxWidth < 600 ? 72.0 : 88.0;
                return SingleChildScrollView(
                  padding: EdgeInsets.all(AppSpacing.lg.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'mood.how_feeling'.tr(),
                        style: context.theme.textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: AppSpacing.lg.h),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: AppSpacing.md.w,
                        runSpacing: AppSpacing.md.h,
                        children: MoodType.values.map((type) {
                          final selected = state.selectedMood == type;
                          return GestureDetector(
                            onTap: () => context
                                .read<MoodBloc>()
                                .add(MoodTypeSelected(type)),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                MoodFaceAvatar(
                                  moodType: type,
                                  size: faceSize,
                                  intensity: state.intensity,
                                  selected: selected,
                                ),
                                SizedBox(height: AppSpacing.xs.h),
                                Text(
                                  type.label,
                                  style: context.theme.textTheme.labelSmall,
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: AppSpacing.xl.h),
                      Text('mood.intensity'.tr()),
                      Slider(
                        value: state.intensity.toDouble(),
                        min: 1,
                        max: 5,
                        divisions: 4,
                        label: state.intensity.toString(),
                        onChanged: state.isLoading
                            ? null
                            : (v) => context.read<MoodBloc>().add(
                                  MoodIntensityChanged(v.round()),
                                ),
                      ),
                      AppTextField(
                        controller: _noteController,
                        enabled: !state.isLoading,
                        label: 'mood.note_optional'.tr(),
                        maxLines: 3,
                        onChanged: (value) => context
                            .read<MoodBloc>()
                            .add(MoodNoteChanged(value)),
                      ),
                      SizedBox(height: AppSpacing.lg.h),
                      AppButton(
                        label: 'mood.save_mood'.tr(),
                        isLoading: state.isLoading,
                        onPressed: state.isLoading
                            ? null
                            : () => context.read<MoodBloc>().add(
                                  MoodLogSubmitted(userId: userId),
                                ),
                        isFullWidth: true,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
