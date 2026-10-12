import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Animated favorite button with scale bounce and color transition.
/// Uses AnimationController + Tween with Curves.elasticOut.
class FavoriteButton extends StatefulWidget {
  final bool isFavorite;
  final ValueChanged<bool> onToggle;
  final double size;

  const FavoriteButton({
    super.key,
    required this.isFavorite,
    required this.onToggle,
    this.size = 28,
  });

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    // Scale: 1.0 → 1.5 → 1.0 with elastic overshoot
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.5)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 40,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.5, end: 1.0)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 60,
      ),
    ]).animate(_controller);

    // Slight rotation wiggle
    _rotationAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: -0.3)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: -0.3, end: 0.0)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 70,
      ),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    _controller.forward(from: 0.0);
    widget.onToggle(!widget.isFavorite);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.rotate(
            angle: _rotationAnimation.value,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                width: widget.size + 18,
                height: widget.size + 18,
                decoration: BoxDecoration(
                  color: widget.isFavorite
                      ? AppColors.favorite.withValues(alpha: 0.15)
                      : AppColors.surface,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: widget.isFavorite
                        ? AppColors.favorite.withValues(alpha: 0.4)
                        : AppColors.divider,
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  widget.isFavorite ? Icons.favorite : Icons.favorite_border,
                  color: widget.isFavorite
                      ? AppColors.favorite
                      : AppColors.textHint,
                  size: widget.size,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
