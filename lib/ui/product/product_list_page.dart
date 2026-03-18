import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../widgets/product_card.dart';
import 'product_manager.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<ProductManager>().fetchAll());
  }

  void _onSearch(String value) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    _debounce = Timer(const Duration(milliseconds: 400), () {
      context.read<ProductManager>().setSearch(value);
    });
  }

  void _showSortDialog() {
    showModalBottomSheet(
      context: context,
      builder: (_) => Consumer<ProductManager>(
        builder: (context, mgr, _) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Price Low → High'),
              onTap: () {
                mgr.setSort(SortType.priceAsc);
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Price High → Low'),
              onTap: () {
                mgr.setSort(SortType.priceDesc);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
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
    );
  }

  Widget _buildFilterBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          ElevatedButton(onPressed: _showSortDialog, child: const Text("Sort")),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: () => context.read<ProductManager>().clearFilter(),
            child: const Text("Clear"),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChips() {
    return Consumer<ProductManager>(
      builder: (_, mgr, __) {
        return SizedBox(
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              ChoiceChip(
                label: const Text("All"),
                selected: mgr.selectedCategoryId.isEmpty,
                onSelected: (_) => mgr.selectCategory(''),
              ),
              ...mgr.categories.map(
                (c) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ChoiceChip(
                    label: Text(c.name),
                    selected: mgr.selectedCategoryId == c.id,
                    onSelected: (_) => mgr.selectCategory(c.id),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProductGrid() {
    return Consumer<ProductManager>(
      builder: (_, mgr, __) {
        if (mgr.products.isEmpty) {
          return const Center(child: Text("No results"));
        }

        return GridView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: mgr.products.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 0.7,
          ),
          itemBuilder: (_, i) {
            final p = mgr.products[i];
            return ProductCard(
              product: p,
              onTap: () => context.push('/home/product/${p.id}', extra: p),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Products")),
      body: Column(
        children: [
          _buildSearchBar(), // ✅ không rebuild
          _buildFilterBar(), // ✅ không rebuild
          _buildCategoryChips(), // ✅ rebuild riêng
          const SizedBox(height: 10),

          Expanded(
            child: _buildProductGrid(), // ✅ rebuild riêng
          ),
        ],
      ),
    );
  }
}
