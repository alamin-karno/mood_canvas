import 'package:mood_canvas/src/imports/imports.dart';
import 'package:mood_canvas/src/features/mood_tracker/domain/entities/mood_type.dart';
import 'package:mood_canvas/src/features/mood_tracker/presentation/widgets/mood_face_avatar.dart';

import '../models/onboarding_slide.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  late final PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  List<OnboardingSlide> _slides() {
    return [
      OnboardingSlide(
        title: 'onboarding.onboarding_title_1'.tr(),
        subtitle: 'onboarding.onboarding_subtitle_1'.tr(),
        mood: MoodType.happy,
        intensity: 4,
      ),
      OnboardingSlide(
        title: 'onboarding.onboarding_title_2'.tr(),
        subtitle: 'onboarding.onboarding_subtitle_2'.tr(),
        mood: MoodType.calm,
        intensity: 3,
      ),
      OnboardingSlide(
        title: 'onboarding.onboarding_title_3'.tr(),
        subtitle: 'onboarding.onboarding_subtitle_3'.tr(),
        mood: MoodType.excited,
        intensity: 5,
      ),
    ];
  }

  void _onGetStarted() {
    context.go(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return _OnboardingView(
      theme: context.theme,
      colorScheme: context.theme.colorScheme,
      textTheme: context.theme.textTheme,
      pageController: _pageController,
      currentIndex: _currentIndex,
      slides: _slides(),
      onPageChanged: (index) => setState(() => _currentIndex = index),
      onGetStarted: _onGetStarted,
    );
  }
}

class _OnboardingView extends StatelessWidget {
  const _OnboardingView({
    required this.theme,
    required this.colorScheme,
    required this.textTheme,
    required this.pageController,
    required this.currentIndex,
    required this.slides,
    required this.onPageChanged,
    required this.onGetStarted,
  });

  final ThemeData theme;
  final ColorScheme colorScheme;
  final TextTheme textTheme;
  final PageController pageController;
  final int currentIndex;
  final List<OnboardingSlide> slides;
  final ValueChanged<int> onPageChanged;
  final VoidCallback onGetStarted;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: AppSpacing.md.h,
              ),
              child: Text(
                'Mood Canvas',
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: pageController,
                itemCount: slides.length,
                onPageChanged: onPageChanged,
                itemBuilder: (context, index) {
                  final page = slides[index];
                  return LayoutBuilder(
                    builder: (context, constraints) {
                      final maxH = constraints.maxHeight;
                      final faceSize = (maxH * 0.38).clamp(72.0, 140.0);
                      final titleSize = maxH < 320 ? 20.0 : 24.0;

                      return Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.xl.w,
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              flex: 5,
                              child: Center(
                                child: MoodFaceAvatar(
                                  moodType: page.mood,
                                  size: faceSize,
                                  intensity: page.intensity,
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: SingleChildScrollView(
                                physics: const ClampingScrollPhysics(),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      page.title,
                                      textAlign: TextAlign.center,
                                      style: textTheme.headlineMedium?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: colorScheme.onSurface,
                                        height: 1.2,
                                        fontSize: titleSize,
                                      ),
                                    ),
                                    SizedBox(height: AppSpacing.sm.h),
                                    Text(
                                      page.subtitle,
                                      textAlign: TextAlign.center,
                                      style: textTheme.bodyMedium?.copyWith(
                                        color: colorScheme.onSurfaceVariant,
                                        height: 1.4,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.xl.w,
                AppSpacing.sm.h,
                AppSpacing.xl.w,
                AppSpacing.lg.h,
              ),
              child: AppButton(
                label: 'shared.get_started'.tr(),
                onPressed: onGetStarted,
                variant: ButtonVariant.primary,
                isFullWidth: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
