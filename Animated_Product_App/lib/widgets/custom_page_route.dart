import 'package:flutter/material.dart';

/// A custom page route that combines a slide-up and fade transition.
/// Forward: slides in from bottom + fades in.
/// Reverse (pop): slides out to bottom + fades out.
class CustomPageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  CustomPageRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: const Duration(milliseconds: 450),
          reverseTransitionDuration: const Duration(milliseconds: 350),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            // Slide transition — comes up from the bottom
            final slideTween = Tween<Offset>(
              begin: const Offset(0.0, 0.12),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOutCubic,
              ),
            );

            // Fade transition
            final fadeTween = Tween<double>(begin: 0.0, end: 1.0).animate(
              CurvedAnimation(
                parent: animation,
                curve: const Interval(0.0, 0.7, curve: Curves.easeIn),
              ),
            );

            // Outgoing page fades out and scales down slightly
            final outFadeTween =
                Tween<double>(begin: 1.0, end: 0.85).animate(
              CurvedAnimation(
                parent: secondaryAnimation,
                curve: Curves.easeInOut,
              ),
            );

            return FadeTransition(
              opacity: outFadeTween,
              child: SlideTransition(
                position: slideTween,
                child: FadeTransition(
                  opacity: fadeTween,
                  child: child,
                ),
              ),
            );
          },
        );
}
