import 'package:mood_canvas/src/imports/core_imports.dart';
import 'package:mood_canvas/src/imports/packages_imports.dart';

import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (prev, next) => prev.status != next.status,
      listener: (context, state) {
        if (state.status == AuthStatus.failure && state.failure != null) {
          showToast(
            context,
            message: state.failure!.message,
            status: 'error',
          );
        }
        if (state.status == AuthStatus.success) {
          showToast(
            context,
            message: state.message ?? 'auth.reset_link_sent'.tr(),
            status: 'success',
          );
          context.go(AppRoutes.login);
        }
      },
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          final cs = context.theme.colorScheme;
          final tt = context.theme.textTheme;

          Future<void> handleForgotPassword() async {
            if (!(_formKey.currentState?.validate() ?? false)) return;
            context.read<AuthBloc>().add(
                  ForgotPasswordRequested(
                    email: _emailController.text.trim(),
                  ),
                );
          }

          return _ForgotPasswordView(
            formKey: _formKey,
            emailController: _emailController,
            isLoading: state.isLoading,
            onForgotPassword: handleForgotPassword,
            cs: cs,
            tt: tt,
          );
        },
      ),
    );
  }
}

class _ForgotPasswordView extends StatelessWidget {
  const _ForgotPasswordView({
    required this.formKey,
    required this.emailController,
    required this.isLoading,
    required this.onForgotPassword,
    required this.cs,
    required this.tt,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final bool isLoading;
  final VoidCallback onForgotPassword;
  final ColorScheme cs;
  final TextTheme tt;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppTopBar(title: 'auth.forgot_password_title'.tr()),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.lg.w),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'auth.forgot_password_subtitle'.tr(),
                  textAlign: TextAlign.center,
                  style: tt.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
                ),
                SizedBox(height: AppSpacing.xxxl.h),
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      AppTextField(
                        controller: emailController,
                        enabled: !isLoading,
                        keyboardType: TextInputType.emailAddress,
                        label: 'auth.email'.tr(),
                        prefixIcon: const Icon(Icons.email_outlined),
                        validator: (v) {
                          if (AppUtils.isBlank(v)) {
                            return 'auth.email_required'.tr();
                          }
                          if (!AppUtils.isValidEmail(v!)) {
                            return 'auth.email_invalid'.tr();
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: AppSpacing.lg.h),
                      AppButton(
                        label: 'auth.send_reset_link'.tr(),
                        isLoading: isLoading,
                        onPressed: isLoading ? null : onForgotPassword,
                        isFullWidth: true,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: AppSpacing.xl.h),
                TextButton(
                  onPressed: () => context.go(AppRoutes.login),
                  child: Text('auth.back_to_login'.tr()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
