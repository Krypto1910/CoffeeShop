import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '/models/address.dart';

class AddressManager extends ChangeNotifier {
  PocketBase? _pb;

  List<Address> _addresses = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Address> get addresses => List.unmodifiable(_addresses);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Address mặc định (isDefault = true)
  Address? get defaultAddress {
    try {
      return _addresses.firstWhere((a) => a.isDefault);
    } catch (_) {
      return _addresses.isNotEmpty ? _addresses.first : null;
    }
  }

  // ─── BASE URL ─────────────────────────────────────────────────────
  String get _baseUrl {
    if (kIsWeb) return 'http://127.0.0.1:8090';
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:8090';
    }
    return 'http://127.0.0.1:8090';
  }

  // ─── INIT PocketBase ──────────────────────────────────────────────
  Future<PocketBase> _getPb() async {
    if (_pb != null) return _pb!;
    final prefs = await SharedPreferences.getInstance();
    final store = AsyncAuthStore(
      save: (data) async => prefs.setString('pb_auth', data),
      initial: prefs.getString('pb_auth'),
    );
    _pb = PocketBase(_baseUrl, authStore: store);
    return _pb!;
  }

  // ─── FETCH tất cả address của user hiện tại ──────────────────────
  Future<void> fetchAddresses(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final pb = await _getPb();
      final records = await pb.collection('Address').getFullList(
        filter: 'userID = "$userId"',
        sort: '-isDefault,created', // default lên đầu
      );
      _addresses = records
          .map((r) => Address.fromJson(r.toJson()))
          .toList();
    } on ClientException catch (e) {
      _errorMessage = e.response['message']?.toString() ?? 'Lỗi tải địa chỉ';
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ─── THÊM địa chỉ mới ─────────────────────────────────────────────
  Future<bool> addAddress({
    required String userId,
    required String title,
    required String detail,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final pb = await _getPb();

      // Nếu chưa có địa chỉ nào → tự động set isDefault = true
      final isFirst = _addresses.isEmpty;

      final record = await pb.collection('Address').create(body: {
        'userID': userId,
        'title': title,
        'detail': detail,
        'isDefault': isFirst,
      });

      _addresses.add(Address.fromJson(record.toJson()));
      return true;
    } on ClientException catch (e) {
      _errorMessage = e.response['message']?.toString() ?? 'Lỗi thêm địa chỉ';
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ─── CẬP NHẬT địa chỉ ────────────────────────────────────────────
  Future<bool> updateAddress({
    required String addressId,
    required String title,
    required String detail,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final pb = await _getPb();
      final record = await pb.collection('Address').update(
        addressId,
        body: {'title': title, 'detail': detail},
      );

      final index = _addresses.indexWhere((a) => a.id == addressId);
      if (index != -1) {
        _addresses[index] = Address.fromJson(record.toJson());
      }
      return true;
    } on ClientException catch (e) {
      _errorMessage = e.response['message']?.toString() ?? 'Lỗi cập nhật';
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ─── XÓA địa chỉ ─────────────────────────────────────────────────
  Future<bool> deleteAddress(String addressId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final pb = await _getPb();
      await pb.collection('Address').delete(addressId);

      final wasDefault =
          _addresses.firstWhere((a) => a.id == addressId).isDefault;
      _addresses.removeWhere((a) => a.id == addressId);

      // Nếu xóa địa chỉ default → set địa chỉ đầu tiên còn lại làm default
      if (wasDefault && _addresses.isNotEmpty) {
        await setDefault(_addresses.first.id);
      }
      return true;
    } on ClientException catch (e) {
      _errorMessage = e.response['message']?.toString() ?? 'Lỗi xóa địa chỉ';
      return false;
    } catch (e) {
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ─── SET DEFAULT ──────────────────────────────────────────────────
  Future<bool> setDefault(String addressId) async {
    try {
      final pb = await _getPb();

      // Bỏ default tất cả trước
      for (final addr in _addresses.where((a) => a.isDefault)) {
        await pb.collection('Address').update(
          addr.id,
          body: {'isDefault': false},
        );
      }

      // Set default cho địa chỉ được chọn
      await pb.collection('Address').update(
        addressId,
        body: {'isDefault': true},
      );

      // Cập nhật local state
      _addresses = _addresses.map((a) {
        return a.copyWith(isDefault: a.id == addressId);
      }).toList();

      notifyListeners();
      return true;
    } catch (_) {
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}