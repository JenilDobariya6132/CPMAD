import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/product_model.dart';
import '../theme/app_theme.dart';
import '../screens/detail/product_detail_screen.dart';
import 'custom_page_route.dart';
import 'favorite_button.dart';

/// Product card using AnimatedContainer for elevation/shadow morphing on tap.
/// Contains a Hero widget around the product emoji for seamless detail transition.
class AnimatedProductCard extends StatefulWidget {
  final Product product;
  final VoidCallback onFavoriteToggle;

  const AnimatedProductCard({
    super.key,
    required this.product,
    required this.onFavoriteToggle,
  });

  @override
  State<AnimatedProductCard> createState() => _AnimatedProductCardState();
}

class _AnimatedProductCardState extends State<AnimatedProductCard> {
  bool _isPressed = false;

  void _onTapDown(TapDownDetails _) => setState(() => _isPressed = true);
  void _onTapUp(TapUpDetails _) => setState(() => _isPressed = false);
  void _onTapCancel() => setState(() => _isPressed = false);

  void _navigateToDetail(BuildContext context) {
    setState(() => _isPressed = false);
    Navigator.of(context).push(
      CustomPageRoute(
        page: ProductDetailScreen(product: widget.product),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final discountText = widget.product.hasDiscount
        ? '-${widget.product.discountPercent.toInt()}%'
        : null;

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      onTap: () => _navigateToDetail(context),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        transform: Matrix4.identity()
          ..translate(0.0, _isPressed ? 4.0 : 0.0),
        decoration: BoxDecoration(
          gradient: AppColors.cardGradient,
          borderRadius: BorderRadius.circular(_isPressed ? 20 : 16),
          border: Border.all(
            color: _isPressed
                ? AppColors.accent.withValues(alpha: 0.4)
                : AppColors.divider,
            width: 1.2,
          ),
          boxShadow: _isPressed
              ? [
                  BoxShadow(
                    color: AppColors.accent.withValues(alpha: 0.15),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Image / emoji section ──────────────────────────────────────
            Stack(
              children: [
                Hero(
                  tag: 'product_${widget.product.id}',
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    height: 130,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.accent.withValues(alpha: _isPressed ? 0.25 : 0.15),
                          AppColors.surface,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: Center(
                      child: AnimatedDefaultTextStyle(
                        duration: const Duration(milliseconds: 200),
                        style: TextStyle(
                          fontSize: _isPressed ? 58 : 52,
                        ),
                        child: Text(widget.product.emoji),
                      ),
                    ),
                  ),
                ),
                // Discount badge
                if (discountText != null)
                  Positioned(
                    top: 10,
                    left: 10,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        discountText,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                // Favorite button
                Positioned(
                  top: 8,
                  right: 8,
                  child: FavoriteButton(
                    isFavorite: widget.product.isFavorite,
                    size: 20,
                    onToggle: (val) {
                      widget.product.isFavorite = val;
                      widget.onFavoriteToggle();
                    },
                  ),
                ),
              ],
            ),
            // ── Info section ───────────────────────────────────────────────
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.product.brand,
                      style: GoogleFonts.poppins(
                        color: AppColors.accent,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.product.name,
                      style: GoogleFonts.poppins(
                        color: AppColors.textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    // Rating row
                    Row(
                      children: [
                        const Icon(
                          Icons.star_rounded,
                          color: AppColors.starColor,
                          size: 14,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          widget.product.rating.toString(),
                          style: GoogleFonts.poppins(
                            color: AppColors.textSecondary,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '(${widget.product.reviewCount})',
                          style: GoogleFonts.poppins(
                            color: AppColors.textHint,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    // Price row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '\$${widget.product.price.toStringAsFixed(2)}',
                          style: GoogleFonts.poppins(
                            color: AppColors.textPrimary,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (widget.product.hasDiscount) ...[
                          const SizedBox(width: 6),
                          Text(
                            '\$${widget.product.originalPrice.toStringAsFixed(0)}',
                            style: GoogleFonts.poppins(
                              color: AppColors.textHint,
                              fontSize: 11,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
