import 'package:flutter/foundation.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// PocketBase singleton — dùng chung toàn app.
/// Đảm bảo auth token được chia sẻ giữa tất cả các manager.
class PbClient {
  PbClient._();

  static PocketBase? _instance;

  static String get baseUrl {
    if (kIsWeb) return 'http://45.63.68.43:8090';
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://45.63.68.43:8090';
    }
    return 'http://45.63.68.43:8090';
  }

  static Future<PocketBase> get instance async {
    if (_instance != null) return _instance!;

    final prefs = await SharedPreferences.getInstance();
    final store = AsyncAuthStore(
      save: (data) async => prefs.setString('pb_auth', data),
      initial: prefs.getString('pb_auth'),
    );

    _instance = PocketBase(baseUrl, authStore: store);
    return _instance!;
  }

  /// Đồng bộ — chỉ dùng sau khi instance đã được khởi tạo
  static PocketBase get instanceSync {
    assert(_instance != null,
        'PbClient chưa được khởi tạo. Gọi await PbClient.instance trước.');
    return _instance!;
  }
}