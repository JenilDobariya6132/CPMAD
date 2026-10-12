import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../catalogue/catalogue_screen.dart';
import '../../widgets/custom_page_route.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  // Staggered entrance intervals
  late final Animation<double> _logoFade;
  late final Animation<Offset> _logoSlide;
  late final Animation<double> _subtitleFade;
  late final Animation<double> _emailFade;
  late final Animation<Offset> _emailSlide;
  late final Animation<double> _passwordFade;
  late final Animation<Offset> _passwordSlide;
  late final Animation<double> _forgotFade;
  late final Animation<double> _buttonFade;
  late final Animation<Offset> _buttonSlide;
  late final Animation<double> _dividerFade;
  late final Animation<double> _socialFade;

  // Background gradient animation
  late final AnimationController _bgController;
  late final Animation<Color?> _bgColor1;
  late final Animation<Color?> _bgColor2;

  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    // Staggered entrance controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );

    // Background pulse controller
    _bgController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _bgColor1 = ColorTween(
      begin: const Color(0xFF0A0E21),
      end: const Color(0xFF0E1530),
    ).animate(_bgController);

    _bgColor2 = ColorTween(
      begin: const Color(0xFF14193A),
      end: const Color(0xFF1A1050),
    ).animate(_bgController);

    // ── Sequential staggered entrance animations ──────────────────────────

    // Logo: 0–30%
    _logoFade = _intervalFade(0.0, 0.25);
    _logoSlide = _intervalSlide(0.0, 0.3);

    // Subtitle: 15–40%
    _subtitleFade = _intervalFade(0.15, 0.4);

    // Email field: 30–55%
    _emailFade = _intervalFade(0.28, 0.5);
    _emailSlide = _intervalSlide(0.28, 0.55);

    // Password field: 45–68%
    _passwordFade = _intervalFade(0.42, 0.64);
    _passwordSlide = _intervalSlide(0.42, 0.68);

    // Forgot password: 58–75%
    _forgotFade = _intervalFade(0.56, 0.75);

    // Button: 65–85%
    _buttonFade = _intervalFade(0.62, 0.82);
    _buttonSlide = _intervalSlide(0.62, 0.88);

    // Divider: 75–88%
    _dividerFade = _intervalFade(0.72, 0.88);

    // Social: 82–100%
    _socialFade = _intervalFade(0.80, 1.0);

    _controller.forward();
  }

  Animation<double> _intervalFade(double start, double end) {
    return Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(start, end, curve: Curves.easeOut),
      ),
    );
  }

  Animation<Offset> _intervalSlide(double start, double end) {
    return Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Interval(start, end, curve: Curves.easeOutCubic),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _bgController.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    // Simulate network call
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => _isLoading = false);
    Navigator.of(context).pushReplacement(
      CustomPageRoute(page: const CatalogueScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _bgController,
      builder: (context, child) {
        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  _bgColor1.value ?? AppColors.background,
                  _bgColor2.value ?? const Color(0xFF14193A),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: child,
          ),
        );
      },
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 48),

                // ── Logo / branding ──────────────────────────────────────
                FadeTransition(
                  opacity: _logoFade,
                  child: SlideTransition(
                    position: _logoSlide,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.accent.withValues(alpha: 0.5),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.shopping_bag_rounded,
                            color: Colors.white,
                            size: 32,
                          ),
                        ),
                        const SizedBox(height: 28),
                        Text(
                          'Welcome back 👋',
                          style: GoogleFonts.poppins(
                            color: AppColors.textPrimary,
                            fontSize: 28,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // ── Subtitle ─────────────────────────────────────────────
                FadeTransition(
                  opacity: _subtitleFade,
                  child: Text(
                    'Sign in to explore amazing products',
                    style: GoogleFonts.poppins(
                      color: AppColors.textSecondary,
                      fontSize: 15,
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // ── Email field ───────────────────────────────────────────
                FadeTransition(
                  opacity: _emailFade,
                  child: SlideTransition(
                    position: _emailSlide,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _FieldLabel('Email address'),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _emailCtrl,
                          keyboardType: TextInputType.emailAddress,
                          style: GoogleFonts.poppins(
                            color: AppColors.textPrimary,
                            fontSize: 15,
                          ),
                          decoration: const InputDecoration(
                            hintText: 'you@example.com',
                            prefixIcon: Icon(
                              Icons.email_outlined,
                              color: AppColors.textHint,
                            ),
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'Please enter your email';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // ── Password field ────────────────────────────────────────
                FadeTransition(
                  opacity: _passwordFade,
                  child: SlideTransition(
                    position: _passwordSlide,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _FieldLabel('Password'),
                        const SizedBox(height: 8),
                        TextFormField(
                          controller: _passwordCtrl,
                          obscureText: _obscurePassword,
                          style: GoogleFonts.poppins(
                            color: AppColors.textPrimary,
                            fontSize: 15,
                          ),
                          decoration: InputDecoration(
                            hintText: '••••••••',
                            prefixIcon: const Icon(
                              Icons.lock_outline_rounded,
                              color: AppColors.textHint,
                            ),
                            suffixIcon: GestureDetector(
                              onTap: () => setState(
                                  () => _obscurePassword = !_obscurePassword),
                              child: Icon(
                                _obscurePassword
                                    ? Icons.visibility_off_outlined
                                    : Icons.visibility_outlined,
                                color: AppColors.textHint,
                              ),
                            ),
                          ),
                          validator: (v) {
                            if (v == null || v.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // ── Forgot password ───────────────────────────────────────
                FadeTransition(
                  opacity: _forgotFade,
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Forgot password?',
                      style: GoogleFonts.poppins(
                        color: AppColors.accent,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // ── Sign In button ────────────────────────────────────────
                FadeTransition(
                  opacity: _buttonFade,
                  child: SlideTransition(
                    position: _buttonSlide,
                    child: _AnimatedLoginButton(
                      isLoading: _isLoading,
                      onPressed: _handleLogin,
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                // ── Divider ───────────────────────────────────────────────
                FadeTransition(
                  opacity: _dividerFade,
                  child: Row(
                    children: [
                      const Expanded(
                          child: Divider(color: AppColors.divider, height: 1)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'Or continue with',
                          style: GoogleFonts.poppins(
                            color: AppColors.textHint,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const Expanded(
                          child: Divider(color: AppColors.divider, height: 1)),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // ── Social login buttons ───────────────────────────────────
                FadeTransition(
                  opacity: _socialFade,
                  child: Row(
                    children: [
                      Expanded(
                        child: _SocialButton(label: 'Google', emoji: '🌐'),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _SocialButton(label: 'Apple', emoji: '🍎'),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // ── Sign up prompt ────────────────────────────────────────
                FadeTransition(
                  opacity: _socialFade,
                  child: Center(
                    child: RichText(
                      text: TextSpan(
                        text: "Don't have an account? ",
                        style: GoogleFonts.poppins(
                          color: AppColors.textHint,
                          fontSize: 14,
                        ),
                        children: [
                          TextSpan(
                            text: 'Sign up',
                            style: GoogleFonts.poppins(
                              color: AppColors.accent,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Helper Widgets ─────────────────────────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        color: AppColors.textSecondary,
        fontSize: 13,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

/// Login button that morphs into a circular loader on tap.
class _AnimatedLoginButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onPressed;

  const _AnimatedLoginButton({
    required this.isLoading,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOutCubic,
        height: 56,
        width: isLoading ? 56 : double.infinity,
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(isLoading ? 28 : 14),
          boxShadow: [
            BoxShadow(
              color: AppColors.accent.withValues(alpha: 0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Center(
          child: isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                )
              : Text(
                  'Sign In',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3,
                  ),
                ),
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String label;
  final String emoji;

  const _SocialButton({required this.label, required this.emoji});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.divider),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(emoji, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.poppins(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
