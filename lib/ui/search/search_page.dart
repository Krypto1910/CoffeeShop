// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import '../../widgets/product_card.dart';
// import '../../models/product.dart';

// class SearchPage extends StatefulWidget {
//   const SearchPage({super.key});

//   @override
//   State<SearchPage> createState() => _SearchPageState();
// }

// class _SearchPageState extends State<SearchPage> {
//   final TextEditingController _controller = TextEditingController();
//   String _query = '';

//   final List<Product> _allProducts = [
//     Product(
//       id: 1,
//       name: 'Cappuccino',
//       category: 'Cappuccino',
//       price: 90.0,
//       oldPrice: 120.0,
//       imagePath: 'assets/images/coffee1.png',
//     ),
//     Product(
//       id: 2,
//       name: 'Doppio Coffee',
//       category: 'Doppio',
//       price: 70.0,
//       oldPrice: 100.0,
//       imagePath: 'assets/images/coffee2.png',
//     ),
//     Product(
//       id: 3,
//       name: 'Mocha Coffee',
//       category: 'Mocha',
//       price: 85.0,
//       oldPrice: 110.0,
//       imagePath: 'assets/images/coffee1.png',
//     ),
//     Product(
//       id: 4,
//       name: 'Caramel Macchiato',
//       category: 'Caramel',
//       price: 90.0,
//       oldPrice: 100.0,
//       imagePath: 'assets/images/coffee.png',
//     ),
//   ];

//   List<Product> get _filtered => _query.isEmpty
//       ? _allProducts
//       : _allProducts
//           .where(
//               (p) => p.name.toLowerCase().contains(_query.toLowerCase()))
//           .toList();

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF6EFE8),
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         centerTitle: true,
//         title: const Text(
//           'Search Coffee',
//           style: TextStyle(color: Colors.black),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // SEARCH BAR
//             Container(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: TextField(
//                 controller: _controller,
//                 onChanged: (v) => setState(() => _query = v),
//                 decoration: const InputDecoration(
//                   icon: Icon(Icons.search),
//                   hintText: 'Search your coffee...',
//                   border: InputBorder.none,
//                 ),
//               ),
//             ),

//             const SizedBox(height: 20),

//             Text(
//               _query.isEmpty ? 'Popular Coffee' : 'Results',
//               style: const TextStyle(
//                   fontSize: 18, fontWeight: FontWeight.bold),
//             ),

//             const SizedBox(height: 12),

//             // GRID
//             Expanded(
//               child: _filtered.isEmpty
//                   ? const Center(
//                       child: Text(
//                         'No coffee found',
//                         style: TextStyle(color: Colors.grey),
//                       ),
//                     )
//                   : LayoutBuilder(builder: (context, constraints) {
//                       const crossAxisCount = 2;
//                       const spacing = 16.0;

//                       final cardWidth =
//                           (constraints.maxWidth - spacing) / crossAxisCount;
//                       final aspectRatio =
//                           cardWidth / (cardWidth * 260 / 180);

//                       return GridView.builder(
//                         itemCount: _filtered.length,
//                         gridDelegate:
//                             SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: crossAxisCount,
//                           mainAxisSpacing: spacing,
//                           crossAxisSpacing: spacing,
//                           childAspectRatio: aspectRatio,
//                         ),
//                         itemBuilder: (context, index) {
//                           final p = _filtered[index];
//                           return ClipRRect(
//                             borderRadius: BorderRadius.circular(20),
//                             child: FittedBox(
//                               fit: BoxFit.fill,
//                               child: SizedBox(
//                                 width: 180,
//                                 height: 260,
//                                 child: OverflowBox(
//                                   alignment: Alignment.topLeft,
//                                   maxWidth: 196,
//                                   maxHeight: 260,
//                                   child: ProductCard(
//                                     product: p,
//                                     onTap: () =>
//                                         context.push('/product', extra: p),
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           );
//                         },
//                       );
//                     }),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// This file is not used in the app. It was created for testing the search functionality and UI. It can be deleted later.