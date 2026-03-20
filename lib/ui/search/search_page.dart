import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../product/product_manager.dart';
import '../../widgets/product_card.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final manager = context.read<ProductManager>();
      _controller.text = manager.searchQuery;
    });
  }

  @override
  void dispose() {
    // Dismiss keyboard immediately
    FocusManager.instance.primaryFocus?.unfocus();
    
    _controller.dispose();
    
    // Use Future.microtask to ensure cleanup happens after navigation completes
    Future.microtask(() {
      context.read<ProductManager>().clearFilter();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6EFE8),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      autofocus: true,
                      onChanged: (value) {
                        context.read<ProductManager>().setSearch(value);
                      },
                      onSubmitted: (_) => FocusScope.of(context).unfocus(),
                      decoration: InputDecoration(
                        hintText: 'Search coffee...',
                        prefixIcon: const Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  InkWell(
                    onTap: () => _showFilterSheet(context),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6F4E37),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: const Icon(Icons.tune, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Consumer<ProductManager>(
                builder: (context, manager, _) {
                  if (manager.isLoading) {
                    return const Center(
                      child: CircularProgressIndicator(color: Color(0xFF6F4E37)),
                    );
                  }

                  if (manager.products.isEmpty) {
                    return const Center(
                      child: Text(
                        'No results',
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: manager.products.length,
                    itemBuilder: (context, index) {
                      final product = manager.products[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: ProductCard(
                          product: product, 
                          onTap: () {
                            FocusScope.of(context).unfocus();
                          }
                        ),
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

  void _showFilterSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const _FilterSheet(),
    );
  }
}

// --- FILTER SHEET CLASS ---
class _FilterSheet extends StatefulWidget {
  const _FilterSheet({super.key});

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  String _selectedCategory = '';
  SortType _sortType = SortType.none;
  double? _minPrice;
  double? _maxPrice;
  final TextEditingController _minController = TextEditingController();
  final TextEditingController _maxController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final manager = context.read<ProductManager>();
    _selectedCategory = manager.selectedCategoryId;
    _sortType = manager.sortType;
    _minPrice = manager.minPrice;
    _maxPrice = manager.maxPrice;
    if (_minPrice != null) _minController.text = _minPrice.toString();
    if (_maxPrice != null) _maxController.text = _maxPrice.toString();
  }

  @override
  void dispose() {
    _minController.dispose();
    _maxController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final manager = context.watch<ProductManager>();

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        top: 24,
        left: 24,
        right: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Filters',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    manager.clearFilter();
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Clear All',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Category', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                ChoiceChip(
                  label: const Text('All'),
                  selected: _selectedCategory.isEmpty,
                  onSelected: (val) {
                    if (val) setState(() => _selectedCategory = '');
                  },
                  selectedColor: const Color(0xFF6F4E37),
                  labelStyle: TextStyle(
                    color: _selectedCategory.isEmpty ? Colors.white : Colors.black,
                  ),
                ),
                ...manager.categories.map(
                  (c) => ChoiceChip(
                    label: Text(c.name),
                    selected: _selectedCategory == c.id,
                    onSelected: (val) {
                      if (val) setState(() => _selectedCategory = c.id);
                    },
                    selectedColor: const Color(0xFF6F4E37),
                    labelStyle: TextStyle(
                      color: _selectedCategory == c.id ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('Price Range', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _minController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(hintText: 'Min', border: OutlineInputBorder()),
                    onChanged: (val) => _minPrice = double.tryParse(val),
                  ),
                ),
                const Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text('-')),
                Expanded(
                  child: TextField(
                    controller: _maxController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(hintText: 'Max', border: OutlineInputBorder()),
                    onChanged: (val) => _maxPrice = double.tryParse(val),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6F4E37),
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  manager.selectCategory(_selectedCategory);
                  manager.setSort(_sortType);
                  manager.setPriceFilter(min: _minPrice, max: _maxPrice);
                  Navigator.pop(context);
                },
                child: const Text('Apply Filters'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}