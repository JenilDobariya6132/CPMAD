import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../theme/app_theme.dart';
import '../auth/login_screen.dart';
import '../../widgets/custom_page_route.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Animation controllers for each page
  late final List<AnimationController> _controllers;
  late final List<Animation<double>> _illustrationScales;
  late final List<Animation<double>> _illustrationFades;
  late final List<Animation<Offset>> _titleSlides;
  late final List<Animation<double>> _titleFades;
  late final List<Animation<Offset>> _subtitleSlides;
  late final List<Animation<double>> _subtitleFades;

  static const _pages = [
    _OnboardingData(
      emoji: '🛍️',
      gradient: [Color(0xFF6C63FF), Color(0xFF9D97FF)],
      title: 'Discover Amazing\nProducts',
      subtitle:
          'Explore thousands of premium products curated just for you. Find exactly what you need.',
    ),
    _OnboardingData(
      emoji: '⚡',
      gradient: [Color(0xFF00C9FF), Color(0xFF92FE9D)],
      title: 'Lightning Fast\nDelivery',
      subtitle:
          'Get your orders delivered at record speed. Track in real-time from warehouse to doorstep.',
    ),
    _OnboardingData(
      emoji: '💎',
      gradient: [Color(0xFFFF6B6B), Color(0xFFFFE66D)],
      title: 'Exclusive Premium\nDeals',
      subtitle:
          'Unlock exclusive deals and early access to new arrivals. Save more with every purchase.',
    ),
  ];

  @override
  void initState() {
    super.initState();

    _controllers = List.generate(
      _pages.length,
      (i) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 900),
      ),
    );

    _illustrationScales = _controllers.map((ctrl) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: ctrl,
          curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
        ),
      );
    }).toList();

    _illustrationFades = _controllers.map((ctrl) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: ctrl,
          curve: const Interval(0.0, 0.4, curve: Curves.easeIn),
        ),
      );
    }).toList();

    _titleSlides = _controllers.map((ctrl) {
      return Tween<Offset>(
        begin: const Offset(0, 0.4),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: ctrl,
          curve: const Interval(0.3, 0.75, curve: Curves.easeOutCubic),
        ),
      );
    }).toList();

    _titleFades = _controllers.map((ctrl) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: ctrl,
          curve: const Interval(0.3, 0.65, curve: Curves.easeIn),
        ),
      );
    }).toList();

    _subtitleSlides = _controllers.map((ctrl) {
      return Tween<Offset>(
        begin: const Offset(0, 0.5),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: ctrl,
          curve: const Interval(0.5, 0.9, curve: Curves.easeOutCubic),
        ),
      );
    }).toList();

    _subtitleFades = _controllers.map((ctrl) {
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: ctrl,
          curve: const Interval(0.5, 0.85, curve: Curves.easeIn),
        ),
      );
    }).toList();

    // Kick off first page
    _controllers[0].forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _goToLogin();
    }
  }

  void _goToLogin() {
    Navigator.of(context).pushReplacement(
      CustomPageRoute(page: const LoginScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background
          Container(
            decoration: const BoxDecoration(
              gradient: AppColors.backgroundGradient,
            ),
          ),

          // Pages
          PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            onPageChanged: (index) {
              setState(() => _currentPage = index);
              _controllers[index].forward(from: 0);
            },
            itemBuilder: (context, index) {
              final page = _pages[index];
              return _OnboardingPage(
                data: page,
                illustrationScale: _illustrationScales[index],
                illustrationFade: _illustrationFades[index],
                titleSlide: _titleSlides[index],
                titleFade: _titleFades[index],
                subtitleSlide: _subtitleSlides[index],
                subtitleFade: _subtitleFades[index],
              );
            },
          ),

          // Bottom controls
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.only(
                left: 32,
                right: 32,
                bottom: MediaQuery.of(context).padding.bottom + 40,
                top: 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Dot indicators
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 350),
                        curve: Curves.easeInOut,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: i == _currentPage ? 28 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: i == _currentPage
                              ? AppColors.accent
                              : AppColors.textHint,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Next / Get Started button
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accent.withValues(alpha: 0.4),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: _nextPage,
                        child: Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                _currentPage == _pages.length - 1
                                    ? 'Get Started'
                                    : 'Next',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.arrow_forward_rounded,
                                color: Colors.white,
                                size: 20,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Skip button
                  if (_currentPage < _pages.length - 1)
                    GestureDetector(
                      onTap: _goToLogin,
                      child: Text(
                        'Skip',
                        style: GoogleFonts.poppins(
                          color: AppColors.textHint,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Page Data Model ───────────────────────────────────────────────────────────
class _OnboardingData {
  final String emoji;
  final List<Color> gradient;
  final String title;
  final String subtitle;

  const _OnboardingData({
    required this.emoji,
    required this.gradient,
    required this.title,
    required this.subtitle,
  });
}

// ── Single Onboarding Page ─────────────────────────────────────────────────
class _OnboardingPage extends StatelessWidget {
  final _OnboardingData data;
  final Animation<double> illustrationScale;
  final Animation<double> illustrationFade;
  final Animation<Offset> titleSlide;
  final Animation<double> titleFade;
  final Animation<Offset> subtitleSlide;
  final Animation<double> subtitleFade;

  const _OnboardingPage({
    required this.data,
    required this.illustrationScale,
    required this.illustrationFade,
    required this.titleSlide,
    required this.titleFade,
    required this.subtitleSlide,
    required this.subtitleFade,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        children: [
          const SizedBox(height: 80),

          // Animated illustration container
          FadeTransition(
            opacity: illustrationFade,
            child: ScaleTransition(
              scale: illustrationScale,
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: data.gradient.map((c) => c.withValues(alpha: 0.2)).toList(),
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: data.gradient.first.withValues(alpha: 0.4),
                    width: 2,
                  ),
                ),
                child: Center(
                  child: Text(
                    data.emoji,
                    style: const TextStyle(fontSize: 90),
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 56),

          // Animated title
          SlideTransition(
            position: titleSlide,
            child: FadeTransition(
              opacity: titleFade,
              child: Text(
                data.title,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: AppColors.textPrimary,
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  height: 1.25,
                ),
              ),
            ),
          ),

          const SizedBox(height: 18),

          // Animated subtitle
          SlideTransition(
            position: subtitleSlide,
            child: FadeTransition(
              opacity: subtitleFade,
              child: Text(
                data.subtitle,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  color: AppColors.textSecondary,
                  fontSize: 15,
                  height: 1.6,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
