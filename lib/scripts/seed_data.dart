/// Seed data cho PocketBase v0.36+
/// Chạy: dart run lib/scripts/seed_data.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

const pbUrl = 'http://45.63.68.43:8090';
const adminEmail = 'jackx607@gmail.com';
const adminPassword = 'Dquang1509!';

void main() async {
  print('🔐 Authenticating...');

  final authRes = await http.post(
    Uri.parse('$pbUrl/api/collections/_superusers/auth-with-password'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'identity': adminEmail,
      'password': adminPassword,
    }),
  );

  if (authRes.statusCode != 200) {
    print('❌ Auth failed: ${authRes.body}');
    return;
  }

  final token = jsonDecode(authRes.body)['token'] as String;
  print('✅ Authenticated!');

  final headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  // ── CATEGORIES ────────────────────────────────────────────────────
  print('\n📁 Creating categories...');
  final categoryMap = <String, String>{};

  for (final name in ['Espresso', 'Latte', 'Cappuccino', 'Mocha', 'Cold Brew']) {
    final checkRes = await http.get(
      Uri.parse('$pbUrl/api/collections/Category/records?filter=${Uri.encodeComponent('name="$name"')}'),
      headers: headers,
    );

    if (checkRes.statusCode == 200) {
      final data = jsonDecode(checkRes.body);
      if ((data['totalItems'] ?? 0) > 0) {
        final id = data['items'][0]['id'];
        categoryMap[name] = id;
        print('  ⚠️  $name already exists ($id)');
        continue;
      }
    }

    final res = await http.post(
      Uri.parse('$pbUrl/api/collections/Category/records'),
      headers: headers,
      body: jsonEncode({'name': name}),
    );

    if (res.statusCode == 200 || res.statusCode == 201) {
      final id = jsonDecode(res.body)['id'];
      categoryMap[name] = id;
      print('  ✅ $name ($id)');
    } else {
      print('  ❌ $name: ${res.statusCode} ${res.body}');
    }
  }

  if (categoryMap.isEmpty) {
    print('\n❌ No categories created. Aborting.');
    return;
  }

  // ── PRODUCTS ──────────────────────────────────────────────────────
  print('\n☕ Creating products...');

  final products = [
    _p('Espresso', 'Classic Espresso', 3.5, 50, 'A rich, bold shot of pure espresso made from premium Arabica beans. Intense flavor with a velvety crema on top.'),
    _p('Espresso', 'Double Espresso', 4.5, 50, 'Two shots of our finest espresso for those who need an extra kick. Bold, strong, and deeply satisfying.'),
    _p('Espresso', 'Ristretto', 4.0, 40, 'A shorter, more concentrated espresso shot. Sweeter and less bitter than a standard espresso.'),
    _p('Latte', 'Vanilla Latte', 5.5, 40, 'Smooth espresso blended with steamed milk and a hint of sweet vanilla. A classic comfort drink.'),
    _p('Latte', 'Caramel Latte', 5.9, 40, 'Creamy latte topped with rich caramel drizzle. Sweet, smooth, and irresistible.'),
    _p('Latte', 'Matcha Latte', 6.0, 35, 'Premium Japanese matcha whisked with warm steamed milk. Earthy, creamy, and antioxidant-rich.'),
    _p('Latte', 'Hazelnut Latte', 5.9, 35, 'Espresso with hazelnut syrup and silky steamed milk. Nutty, sweet, and utterly delicious.'),
    _p('Cappuccino', 'Classic Cappuccino', 5.0, 45, 'Equal parts espresso, steamed milk, and silky foam. A timeless Italian classic.'),
    _p('Cappuccino', 'Dry Cappuccino', 5.0, 30, 'Bold espresso with extra foam and minimal milk. Perfect for those who love a stronger coffee taste.'),
    _p('Cappuccino', 'Cinnamon Cappuccino', 5.5, 30, 'Classic cappuccino dusted with warm cinnamon spice. Aromatic and cozy.'),
    _p('Mocha', 'Chocolate Mocha', 6.5, 40, 'Espresso meets rich dark chocolate and velvety steamed milk. A dessert in a cup.'),
    _p('Mocha', 'White Mocha', 6.9, 35, 'Creamy white chocolate sauce blended with espresso and steamed milk. Sweet and indulgent.'),
    _p('Mocha', 'Salted Dark Mocha', 7.0, 25, 'Dark chocolate mocha with a touch of sea salt. Complex, rich, and utterly addictive.'),
    _p('Cold Brew', 'Original Cold Brew', 5.5, 30, 'Steeped for 12 hours in cold water for a smooth, low-acidity coffee. Refreshing and mellow.'),
    _p('Cold Brew', 'Salted Caramel Cold Brew', 6.5, 25, 'Cold brew coffee with a drizzle of salted caramel. The perfect balance of sweet and savory.'),
    _p('Cold Brew', 'Coconut Cold Brew', 6.9, 25, 'Smooth cold brew topped with creamy coconut milk. Tropical, refreshing, and dairy-free.'),
  ];

  int created = 0, failed = 0;

  for (final p in products) {
    final catId = categoryMap[p['category']];
    if (catId == null) {
      print('  ⚠️  Category not found: ${p['category']}');
      failed++;
      continue;
    }

    final res = await http.post(
      Uri.parse('$pbUrl/api/collections/Product/records'),
      headers: headers,
      body: jsonEncode({
        'categoryID': catId,
        'title': p['title'],
        'price': p['price'],
        'stock': p['stock'],
        'description': p['description'],
        'imagePath': '',
      }),
    );

    if (res.statusCode == 200 || res.statusCode == 201) {
      print('  ✅ ${p['title']}');
      created++;
    } else {
      print('  ❌ ${p['title']}: ${res.statusCode} ${res.body}');
      failed++;
    }
  }

  print('\n─────────────────────────────────');
  print('🎉 Done! Created: $created | Failed: $failed');
  print('📌 Upload images in PocketBase Admin → Product → record.');
}

Map<String, dynamic> _p(String cat, String title, double price, int stock, String desc) =>
    {'category': cat, 'title': title, 'price': price, 'stock': stock, 'description': desc};