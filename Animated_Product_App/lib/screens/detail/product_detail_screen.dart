import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/product_model.dart';
import '../../theme/app_theme.dart';
import '../../widgets/favorite_button.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _contentController;

  // Content slide-up animations (staggered from bottom)
  late final Animation<Offset> _infoSlide;
  late final Animation<double> _infoFade;
  late final Animation<Offset> _priceSlide;
  late final Animation<double> _priceFade;
  late final Animation<Offset> _tagsSlide;
  late final Animation<double> _tagsFade;
  late final Animation<Offset> _descSlide;
  late final Animation<double> _descFade;
  late final Animation<Offset> _buttonSlide;
  late final Animation<double> _buttonFade;

  bool _addedToCart = false;
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    _contentController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _infoSlide = _makeSlide(0.0, 0.35);
    _infoFade = _makeFade(0.0, 0.3);

    _priceSlide = _makeSlide(0.15, 0.5);
    _priceFade = _makeFade(0.15, 0.45);

    _tagsSlide = _makeSlide(0.30, 0.65);
    _tagsFade = _makeFade(0.30, 0.6);

    _descSlide = _makeSlide(0.45, 0.80);
    _descFade = _makeFade(0.45, 0.75);

    _buttonSlide = _makeSlide(0.60, 1.0);
    _buttonFade = _makeFade(0.60, 0.95);

    // Defer until Hero animation completes
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) _contentController.forward();
    });
  }

  Animation<Offset> _makeSlide(double start, double end) {
    return Tween<Offset>(
      begin: const Offset(0, 0.25),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _contentController,
        curve: Interval(start, end, curve: Curves.easeOutCubic),
      ),
    );
  }

  Animation<double> _makeFade(double start, double end) {
    return Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _contentController,
        curve: Interval(start, end, curve: Curves.easeOut),
      ),
    );
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  void _handleAddToCart() {
    setState(() => _addedToCart = true);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _addedToCart = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ── Hero image section ─────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            backgroundColor: AppColors.background,
            leading: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.surface.withValues(alpha: 0.9),
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.divider),
                ),
                child: const Icon(
                  Icons.arrow_back_rounded,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: FavoriteButton(
                  isFavorite: product.isFavorite,
                  size: 22,
                  onToggle: (val) {
                    setState(() => product.isFavorite = val);
                  },
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  // Background gradient
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.accent.withValues(alpha: 0.2),
                          AppColors.background,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                  ),
                  // Hero emoji
                  Center(
                    child: Hero(
                      tag: 'product_${product.id}',
                      child: Material(
                        color: Colors.transparent,
                        child: Text(
                          product.emoji,
                          style: const TextStyle(fontSize: 140),
                        ),
                      ),
                    ),
                  ),
                  // Discount badge
                  if (product.hasDiscount)
                    Positioned(
                      top: 80,
                      right: 20,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.accent.withValues(alpha: 0.4),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          '-${product.discountPercent.toInt()}% OFF',
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),

          // ── Scrollable content ─────────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Brand + Name + Rating ──────────────────────────────
                  FadeTransition(
                    opacity: _infoFade,
                    child: SlideTransition(
                      position: _infoSlide,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.brand.toUpperCase(),
                            style: GoogleFonts.poppins(
                              color: AppColors.accent,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            product.name,
                            style: GoogleFonts.poppins(
                              color: AppColors.textPrimary,
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              ...List.generate(5, (i) {
                                return Icon(
                                  i < product.rating.floor()
                                      ? Icons.star_rounded
                                      : (i < product.rating
                                          ? Icons.star_half_rounded
                                          : Icons.star_outline_rounded),
                                  color: AppColors.starColor,
                                  size: 18,
                                );
                              }),
                              const SizedBox(width: 8),
                              Text(
                                '${product.rating} (${product.reviewCount} reviews)',
                                style: GoogleFonts.poppins(
                                  color: AppColors.textSecondary,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ── Price section ──────────────────────────────────────
                  FadeTransition(
                    opacity: _priceFade,
                    child: SlideTransition(
                      position: _priceSlide,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: AppColors.cardGradient,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: AppColors.divider),
                        ),
                        child: Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Current Price',
                                  style: GoogleFonts.poppins(
                                    color: AppColors.textHint,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 400),
                                  transitionBuilder: (child, animation) {
                                    return ScaleTransition(
                                      scale: animation,
                                      child: child,
                                    );
                                  },
                                  child: Text(
                                    key: ValueKey(product.price),
                                    '\$${product.price.toStringAsFixed(2)}',
                                    style: GoogleFonts.poppins(
                                      color: AppColors.textPrimary,
                                      fontSize: 30,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                if (product.hasDiscount)
                                  Text(
                                    '\$${product.originalPrice.toStringAsFixed(2)}',
                                    style: GoogleFonts.poppins(
                                      color: AppColors.textHint,
                                      fontSize: 14,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                              ],
                            ),
                            const Spacer(),
                            // Quantity selector
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.divider),
                              ),
                              child: Row(
                                children: [
                                  _QtyButton(
                                    icon: Icons.remove,
                                    onTap: () {
                                      if (_quantity > 1) {
                                        setState(() => _quantity--);
                                      }
                                    },
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: AnimatedSwitcher(
                                      duration:
                                          const Duration(milliseconds: 250),
                                      transitionBuilder: (child, animation) {
                                        return ScaleTransition(
                                          scale: animation,
                                          child: child,
                                        );
                                      },
                                      child: Text(
                                        key: ValueKey(_quantity),
                                        '$_quantity',
                                        style: GoogleFonts.poppins(
                                          color: AppColors.textPrimary,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                  _QtyButton(
                                    icon: Icons.add,
                                    onTap: () => setState(() => _quantity++),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ── Tags ───────────────────────────────────────────────
                  FadeTransition(
                    opacity: _tagsFade,
                    child: SlideTransition(
                      position: _tagsSlide,
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: product.tags.map((tag) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 7),
                            decoration: BoxDecoration(
                              color: AppColors.accent.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: AppColors.accent.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Text(
                              tag,
                              style: GoogleFonts.poppins(
                                color: AppColors.accentLight,
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ── Description ────────────────────────────────────────
                  FadeTransition(
                    opacity: _descFade,
                    child: SlideTransition(
                      position: _descSlide,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'About this product',
                            style: GoogleFonts.poppins(
                              color: AppColors.textPrimary,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            product.description,
                            style: GoogleFonts.poppins(
                              color: AppColors.textSecondary,
                              fontSize: 14,
                              height: 1.7,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ── Add to Cart button ─────────────────────────────────
                  FadeTransition(
                    opacity: _buttonFade,
                    child: SlideTransition(
                      position: _buttonSlide,
                      child: _AddToCartButton(
                        added: _addedToCart,
                        onPressed: _handleAddToCart,
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Helper Widgets ─────────────────────────────────────────────────────────

class _QtyButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _QtyButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Icon(icon, color: AppColors.textSecondary, size: 18),
      ),
    );
  }
}

/// "Add to Cart" button that transforms to a success state on tap.
class _AddToCartButton extends StatelessWidget {
  final bool added;
  final VoidCallback onPressed;

  const _AddToCartButton({required this.added, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: added ? null : onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOutCubic,
        height: 58,
        decoration: BoxDecoration(
          gradient: added
              ? const LinearGradient(
                  colors: [Color(0xFF4CAF7D), Color(0xFF2E7D52)],
                )
              : AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: (added ? AppColors.success : AppColors.accent)
                  .withValues(alpha: 0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: added
                ? Row(
                    key: const ValueKey('added'),
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.check_circle_outline_rounded,
                          color: Colors.white, size: 22),
                      const SizedBox(width: 10),
                      Text(
                        'Added to Cart!',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  )
                : Row(
                    key: const ValueKey('add'),
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.shopping_cart_outlined,
                          color: Colors.white, size: 22),
                      const SizedBox(width: 10),
                      Text(
                        'Add to Cart',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
