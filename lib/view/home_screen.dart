
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qurocare_test/constants/theme.dart';
import 'package:qurocare_test/controller/product_controller.dart';
import 'package:qurocare_test/view/detail_screen.dart';
import 'package:qurocare_test/view/widgets/error_view.dart';
import 'package:qurocare_test/view/widgets/product_card.dart';
import 'package:qurocare_test/view/widgets/shimmer_grid.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Put (register) the controller — GetX manages its lifecycle automatically
    final controller = Get.put(ProductController());
    var size = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: size*0.1,
              height: size*0.1,
              decoration: BoxDecoration(
                color: AppTheme.accent,
                borderRadius: BorderRadius.circular(size*0.02),
              ),
              child:  Icon(
                Icons.shopping_bag_rounded,
                size: size*0.06,
                color: Colors.white,
              ),
            ),
             SizedBox(width: size*0.03),
            const Text('ShopLite'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search_rounded),
            onPressed: () {
              Get.snackbar(
                'Search',
                'Search coming soon!',
                snackPosition: SnackPosition.BOTTOM,
                duration: const Duration(seconds: 1),
              );
            },
          ),
           SizedBox(width: size*0.03),
        ],
        bottom: PreferredSize(
          preferredSize:  Size.fromHeight(size*0.01),
          child: Container(height: size*0.01, color: Colors.white.withValues(alpha: 0.1)),
        ),
      ),

      // Obx rebuilds only this widget when observables change
      body: Obx(() {
        // Loading state — shimmer effect
        if (controller.isLoading.value) {
          return const ShimmerGrid();
        }

        // Error state
        if (controller.hasError) {
          return ErrorView(
            message: controller.errorMessage.value,
            onRetry: controller.fetchProducts,
          );
        }

        // Loaded state — product grid
        return Column(
          children: [
            _buildHeaderBar(controller.products.length,size),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
                  return GridView.builder(
                    padding: EdgeInsets.all(size*0.02),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: size*0.02,
                      mainAxisSpacing: size*0.02,
                      childAspectRatio: 0.68,
                    ),
                    itemCount: controller.products.length,
                    itemBuilder: (context, index) {
                      final product = controller.products[index];
                      return ProductCard(
                        product: product,
                        onTap: () => Get.to(
                          () => DetailScreen(product: product),
                          transition: Transition.fadeIn,
                          duration: const Duration(milliseconds: 400),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildHeaderBar(int count,var size) {
    return Container(
      padding:  EdgeInsets.symmetric(horizontal: size*0.03, vertical: size*0.02),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$count Products',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppTheme.textMuted,
            ),
          ),
          InkWell(
            onTap: () {
              Get.snackbar(
                'View',
                'Other view coming soon!',
                snackPosition: SnackPosition.BOTTOM,
                duration: const Duration(seconds: 1),
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: size*0.02, vertical: size*0.01),
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: 0.07),
                borderRadius: BorderRadius.circular(size*0.05),
              ),
              child: const Row(
                children: [
                  Icon(Icons.grid_view_rounded, size: 14, color: AppTheme.primary),
                  SizedBox(width: 4),
                  Text(
                    'Grid View',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.primary,
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
