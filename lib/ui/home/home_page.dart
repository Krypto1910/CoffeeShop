import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../widgets/hero_section.dart';
import '../../widgets/product_card.dart';
import '../../ui/product/product_manager.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Hàm _showSortDialog đã được chuyển sang HeroSection

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
      body: RefreshIndicator(
        onRefresh: () async => await context.read<ProductManager>().fetchAll(),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Thanh Search ở trên và chức năng lọc đã nằm gọn trong Widget này
              const HeroSection(),

              const SizedBox(height: 20),

              // 🔥 Categories
              Consumer<ProductManager>(
                builder: (context, manager, _) {
                  if (manager.categories.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(16, 16, 16, 12),
                        child: Text(
                          'Categories',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
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
                                ? 'All Menu'
                                : manager.categories[index - 1].name;

                            final isSelected =
                                manager.selectedCategoryId == catId;

                            return GestureDetector(
                              onTap: () {
                                manager.selectCategory(catId);
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                margin: const EdgeInsets.only(right: 10),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? const Color(0xFF6F4E37)
                                      : Colors.white,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Text(
                                  catName,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : const Color(0xFF6F4E37),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),

              const SizedBox(height: 20),

              // 🔥 PRODUCT GRID (ALL + FILTER)
              Consumer<ProductManager>(
                builder: (context, manager, _) {
                  final displayProducts = manager.products;

                  if (manager.isLoading && displayProducts.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (displayProducts.isEmpty) {
                    return const Center(child: Text('No products'));
                  }

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    itemCount: displayProducts.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          childAspectRatio: 0.7,
                        ),
                    itemBuilder: (context, index) {
                      final product = displayProducts[index];

                      return ProductCard(
                        product: product,
                        onTap: () => context.push(
                          '/home/product/${product.id}',
                          extra: product,
                        ),
                      );
                    },
                  );
                },
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
