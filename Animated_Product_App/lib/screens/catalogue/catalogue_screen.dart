import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../data/products_data.dart';
import '../../models/product_model.dart';
import '../../theme/app_theme.dart';
import '../../widgets/animated_product_card.dart';

class CatalogueScreen extends StatefulWidget {
  const CatalogueScreen({super.key});

  @override
  State<CatalogueScreen> createState() => _CatalogueScreenState();
}

class _CatalogueScreenState extends State<CatalogueScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _staggerController;
  late final List<Animation<double>> _cardFades;
  late final List<Animation<Offset>> _cardSlides;

  String _selectedCategory = 'All';
  String _searchQuery = '';
  final _searchCtrl = TextEditingController();

  List<Product> get _filteredProducts {
    return sampleProducts.where((p) {
      final matchCat =
          _selectedCategory == 'All' || p.category == _selectedCategory;
      final matchSearch = _searchQuery.isEmpty ||
          p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.brand.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchCat && matchSearch;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _staggerController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 200 + sampleProducts.length * 100),
    );

    _buildCardAnimations();
    _staggerController.forward();
  }

  void _buildCardAnimations() {
    final count = sampleProducts.length;
    _cardFades = List.generate(count, (i) {
      final start = i * 0.08;
      final end = (start + 0.35).clamp(0.0, 1.0);
      return Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: _staggerController,
          curve: Interval(start, end, curve: Curves.easeOut),
        ),
      );
    });

    _cardSlides = List.generate(count, (i) {
      final start = i * 0.08;
      final end = (start + 0.4).clamp(0.0, 1.0);
      return Tween<Offset>(
        begin: const Offset(0, 0.4),
        end: Offset.zero,
      ).animate(
        CurvedAnimation(
          parent: _staggerController,
          curve: Interval(start, end, curve: Curves.easeOutCubic),
        ),
      );
    });
  }

  @override
  void dispose() {
    _staggerController.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredProducts;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ── Animated SliverAppBar ──────────────────────────────────────
          SliverAppBar(
            pinned: true,
            expandedHeight: 140,
            backgroundColor: AppColors.background,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: AppColors.backgroundGradient,
                ),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 60, 24, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Discover',
                            style: GoogleFonts.poppins(
                              color: AppColors.textPrimary,
                              fontSize: 30,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(
                              gradient: AppColors.primaryGradient,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.accent.withValues(alpha: 0.4),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.shopping_cart_outlined,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── Search bar ────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: TextField(
                controller: _searchCtrl,
                onChanged: (v) => setState(() => _searchQuery = v),
                style: GoogleFonts.poppins(
                  color: AppColors.textPrimary,
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  hintText: 'Search products, brands...',
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: AppColors.textHint,
                  ),
                  suffixIcon: _searchQuery.isNotEmpty
                      ? GestureDetector(
                          onTap: () {
                            _searchCtrl.clear();
                            setState(() => _searchQuery = '');
                          },
                          child: const Icon(
                            Icons.close,
                            color: AppColors.textHint,
                          ),
                        )
                      : null,
                ),
              ),
            ),
          ),

          // ── Category chips ─────────────────────────────────────────────
          SliverToBoxAdapter(
            child: SizedBox(
              height: 50,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: productCategories.length,
                itemBuilder: (context, i) {
                  final cat = productCategories[i];
                  final isSelected = cat == _selectedCategory;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedCategory = cat),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOutCubic,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          gradient: isSelected
                              ? AppColors.primaryGradient
                              : null,
                          color: isSelected ? null : AppColors.surface,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: isSelected
                                ? Colors.transparent
                                : AppColors.divider,
                          ),
                          boxShadow: isSelected
                              ? [
                                  BoxShadow(
                                    color: AppColors.accent.withValues(alpha: 0.35),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ]
                              : null,
                        ),
                        child: Text(
                          cat,
                          style: GoogleFonts.poppins(
                            color: isSelected
                                ? Colors.white
                                : AppColors.textSecondary,
                            fontSize: 13,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 8)),

          // ── Results count ──────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 8, 18, 4),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: Text(
                  key: ValueKey(filtered.length),
                  '${filtered.length} product${filtered.length != 1 ? 's' : ''} found',
                  style: GoogleFonts.poppins(
                    color: AppColors.textHint,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),

          // ── Product grid ───────────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final product = filtered[index];
                  final originalIndex = sampleProducts.indexOf(product);
                  final fade = originalIndex >= 0 && originalIndex < _cardFades.length
                      ? _cardFades[originalIndex]
                      : const AlwaysStoppedAnimation(1.0);
                  final slide = originalIndex >= 0 && originalIndex < _cardSlides.length
                      ? _cardSlides[originalIndex]
                      : const AlwaysStoppedAnimation(Offset.zero);

                  return FadeTransition(
                    opacity: fade,
                    child: SlideTransition(
                      position: slide,
                      child: AnimatedProductCard(
                        product: product,
                        onFavoriteToggle: () => setState(() {}),
                      ),
                    ),
                  );
                },
                childCount: filtered.length,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.72,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
              ),
            ),
          ),

          // ── Empty state ────────────────────────────────────────────────
          if (filtered.isEmpty)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(60),
                child: Column(
                  children: [
                    const Text('🔍', style: TextStyle(fontSize: 64)),
                    const SizedBox(height: 16),
                    Text(
                      'No products found',
                      style: GoogleFonts.poppins(
                        color: AppColors.textSecondary,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Try a different category or search term.',
                      style: GoogleFonts.poppins(
                        color: AppColors.textHint,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),

          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }
}
