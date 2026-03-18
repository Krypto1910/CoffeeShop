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
        onRefresh: () async {
          await context.read<ProductManager>().fetchAll();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HeroSection(),

              // ─── CATEGORIES ───────────────────────────────────────────
              Consumer<ProductManager>(
                builder: (context, manager, _) {
                  if (manager.categories.isEmpty)
                    return const SizedBox.shrink();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.fromLTRB(16, 24, 16, 12),
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
                              onTap: () => manager.selectCategory(catId),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                margin: const EdgeInsets.only(right: 10),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18,
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
                                    fontSize: 13,
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

              const SizedBox(height: 24),

              // ─── SPECIAL COFFEE HEADER ────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: InkWell(
                  borderRadius: BorderRadius.circular(8),
                  overlayColor: WidgetStateProperty.all(Colors.transparent),
                  highlightColor: Colors.transparent,
                  onTap: () => context.push('/home/product'),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Special Coffee',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 6),
                        Icon(
                          Icons.chevron_right,
                          size: 22,
                          color: Colors.black54,
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ─── PRODUCT LIST ─────────────────────────────────────────
              Consumer<ProductManager>(
                builder: (context, manager, _) {
                  if (manager.isLoading && manager.products.isEmpty) {
                    return const SizedBox(
                      height: 270,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF6F4E37),
                        ),
                      ),
                    );
                  }

                  if (manager.products.isEmpty) {
                    return const SizedBox(
                      height: 100,
                      child: Center(
                        child: Text(
                          'No products yet',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    );
                  }

                  return SizedBox(
                    height: 270,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      // Hiện tối đa 10 sản phẩm trên home
                      itemCount: manager.products.length.clamp(0, 10),
                      itemBuilder: (context, index) {
                        final product = manager.products[index];
                        return ProductCard(
                          product: product,
                          onTap: () => context.push(
                            '/home/product/${product.id}',
                            extra: product,
                          ),
                        );
                      },
                    ),
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
