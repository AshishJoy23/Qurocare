import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qurocare_test/constants/theme.dart';
import 'package:qurocare_test/models/product_model.dart';

class DetailScreen extends StatelessWidget {
  final Product product;

  const DetailScreen({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(size),
          SliverToBoxAdapter(child: _buildDetailsSection(context,size)),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(size),
    );
  }

  Widget _buildSliverAppBar(var size) {
    return SliverAppBar(
      expandedHeight: size * 0.8,
      pinned: true,
      backgroundColor: AppTheme.primary,
      leading: Padding(
        padding: EdgeInsets.all(size * 0.02),
        child: CircleAvatar(
          backgroundColor: Colors.grey.shade50,
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: size * 0.05,
              color: AppTheme.accent,
            ),
            onPressed: () => Get.back(), // GetX navigation
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          color: Colors.grey.shade50,
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(size * 0.08),
              child: Hero(
                tag: 'product_${product.id}',
                child: CachedNetworkImage(
                  imageUrl: product.image,
                  fit: BoxFit.contain,
                  placeholder: (_, __) => const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                  errorWidget: (_, __, ___) =>  Icon(
                    Icons.image_not_supported_outlined,
                    size: size * 0.15,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailsSection(BuildContext context,var size) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(size * 0.1)),
      ),
      child: Padding(
        padding:  EdgeInsets.all(size * 0.05),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category tag
            Container(
              padding:  EdgeInsets.symmetric(horizontal: size * 0.05, vertical: size * 0.02),
              decoration: BoxDecoration(
                color: AppTheme.accent.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(size * 0.05),
              ),
              child: Text(
                product.category.toUpperCase(),
                style: const TextStyle(
                  color: AppTheme.accent,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1,
                ),
              ),
            ),
             SizedBox(height: size * 0.04),

            // Product title
            Text(
              product.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppTheme.textDark,
                height: 1.3,
              ),
            ),
              SizedBox(height: size * 0.04),

            // Price and rating row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    color: AppTheme.accent,
                  ),
                ),
                _buildRatingBadge(size),
              ],
            ),
             SizedBox(height: size * 0.01),

            Divider(color: Colors.black),
            SizedBox(height: size * 0.01),

            const Text(
              'Description',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppTheme.textDark,
              ),
            ),
             SizedBox(height: size * 0.02),

            Text(
              product.description,
              style: const TextStyle(
                fontSize: 14,
                color: AppTheme.textMuted,
                height: 1.7,
              ),
            ),
             SizedBox(height: size * 0.3),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingBadge(var size) {
    return Container(
      padding:  EdgeInsets.symmetric(horizontal: size * 0.02, vertical: size*0.01),
      decoration: BoxDecoration(
        color: AppTheme.starColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(size*0.04),
      ),
      child: Row(
        children: [
          const Icon(Icons.star_rounded, size: 18, color: AppTheme.starColor),
           SizedBox(width: size * 0.02),
          Text(
            product.rating.toString(),
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: AppTheme.textDark,
            ),
          ),
          Text(
            ' / 5',
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar(var size) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: size*0.02,horizontal: size*0.04),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Wishlist button
          IconButton(
            icon: Icon(
              Icons.favorite_border_rounded,
              size: size*0.08,
              color: AppTheme.accent,
            ),
            onPressed: () => Get.snackbar(
              'Wishlist',
              'Added to wishlist! ❤️',
              snackPosition: SnackPosition.BOTTOM,
              duration: const Duration(seconds: 1),
            ),
          ),
           SizedBox(width: size*0.05),

          // Add to cart button
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => Get.snackbar(
                'Cart',
                'Added to cart! 🛒',
                snackPosition: SnackPosition.BOTTOM,
                duration: const Duration(seconds: 1),
              ),
              icon: Icon(Icons.shopping_cart_rounded, size: size*0.06),
              label: const Text('Add to Cart'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.accent,
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(52),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(size*0.03),
                ),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
