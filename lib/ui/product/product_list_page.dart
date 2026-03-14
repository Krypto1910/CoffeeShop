import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../widgets/product_card.dart';
import '../../ui/product/product_manager.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductManager>().fetchAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6EFE8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('All Products',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Consumer<ProductManager>(
        builder: (context, manager, _) {
          if (manager.isLoading && manager.products.isEmpty) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFF6F4E37)),
            );
          }

          if (manager.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 48),
                  const SizedBox(height: 12),
                  Text(manager.errorMessage!,
                      style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6F4E37)),
                    onPressed: () => manager.fetchAll(),
                    child: const Text('Retry',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // ─── CATEGORY FILTER ────────────────────────────────────
              if (manager.categories.isNotEmpty)
                SizedBox(
                  height: 44,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: manager.categories.length + 1,
                    itemBuilder: (context, index) {
                      final isAll = index == 0;
                      final catId = isAll
                          ? ''
                          : manager.categories[index - 1].id;
                      final catName = isAll
                          ? 'All'
                          : manager.categories[index - 1].name;
                      final isSelected =
                          manager.selectedCategoryId == catId;

                      return GestureDetector(
                        onTap: () => manager.selectCategory(catId),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? const Color(0xFF6F4E37)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            catName,
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xFF6F4E37),
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

              const SizedBox(height: 12),

              // ─── GRID ───────────────────────────────────────────────
              Expanded(
                child: manager.products.isEmpty
                    ? const Center(
                        child: Text('No products found',
                            style: TextStyle(color: Colors.grey)),
                      )
                    : LayoutBuilder(
                        builder: (context, constraints) {
                          const crossAxisCount = 2;
                          const spacing = 16.0;
                          const padding = 16.0;
                          final cardWidth = (constraints.maxWidth -
                                  padding * 2 -
                                  spacing) /
                              crossAxisCount;
                          final aspectRatio =
                              cardWidth / (cardWidth * 260 / 180);

                          return Padding(
                            padding: const EdgeInsets.all(padding),
                            child: GridView.builder(
                              itemCount: manager.products.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: crossAxisCount,
                                mainAxisSpacing: spacing,
                                crossAxisSpacing: spacing,
                                childAspectRatio: aspectRatio,
                              ),
                              itemBuilder: (context, index) {
                                final product = manager.products[index];
                                return ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: FittedBox(
                                    fit: BoxFit.fill,
                                    child: SizedBox(
                                      width: 180,
                                      height: 260,
                                      child: OverflowBox(
                                        alignment: Alignment.topLeft,
                                        maxWidth: 196,
                                        maxHeight: 260,
                                        child: ProductCard(
                                          product: product,
                                          onTap: () => context.push(
                                            '/home/product/${product.id}',
                                            extra: product,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}