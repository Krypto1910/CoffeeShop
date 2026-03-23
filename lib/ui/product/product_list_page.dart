import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../widgets/product_card.dart';
import 'product_manager.dart';

class ProductListPage extends StatefulWidget {
  final String? categoryId;

  const ProductListPage({super.key, this.categoryId});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final manager = context.read<ProductManager>();
      manager.fetchAll();

      if (widget.categoryId != null) {
        manager.selectCategory(widget.categoryId!);
      }
    });
  }

  @override
  void dispose() {
    FocusManager.instance.primaryFocus?.unfocus();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearch(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      context.read<ProductManager>().setSearch(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: TextField(
                onChanged: _onSearch,
                decoration: InputDecoration(
                  hintText: "Search...",
                  prefixIcon: const Icon(Icons.search),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Consumer<ProductManager>(
                builder: (_, mgr, __) {
                  final products = mgr.products;

                  if (products.isEmpty) {
                    return const Center(child: Text("No results"));
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: products.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 12,
                          crossAxisSpacing: 12,
                          childAspectRatio: 0.7,
                        ),
                    itemBuilder: (_, i) {
                      final p = products[i];
                      return ProductCard(
                        product: p,
                        onTap: () =>
                            context.push('/home/product/${p.id}', extra: p),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
