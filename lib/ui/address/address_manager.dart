import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import '/models/address.dart';
import '../../services/pb_client.dart';

class AddressManager extends ChangeNotifier {
  List<Address> _addresses = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Address> get addresses => List.unmodifiable(_addresses);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Address? get defaultAddress {
    try {
      return _addresses.firstWhere((a) => a.isDefault);
    } catch (_) {
      return _addresses.isNotEmpty ? _addresses.first : null;
    }
  }

  // ─── FETCH ────────────────────────────────────────────────────────
  Future<void> fetchAddresses(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final pb = await PbClient.instance;

      debugPrint('AUTH TOKEN: ${pb.authStore.token}');
      debugPrint('FETCH ADDRESSES for userId: $userId');

      final records = await pb.collection('Address').getFullList(
        filter: 'userID = "$userId"',
        sort: '-isDefault',
      );

      debugPrint('FOUND ${records.length} addresses');

      _addresses = records.map((r) => Address.fromJson(r.toJson())).toList();
    } on ClientException catch (e) {
      debugPrint('FETCH ADDRESS ERROR: ${e.response}');
      _errorMessage = e.response['message']?.toString() ?? 'Lỗi tải địa chỉ';
    } catch (e) {
      debugPrint('FETCH ADDRESS EXCEPTION: $e');
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ─── ADD ──────────────────────────────────────────────────────────
  Future<bool> addAddress({
    required String userId,
    required String title,
    required String detail,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final pb = await PbClient.instance;
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
      debugPrint('ADD ADDRESS ERROR: ${e.response}');
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

  // ─── UPDATE ───────────────────────────────────────────────────────
  Future<bool> updateAddress({
    required String addressId,
    required String title,
    required String detail,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final pb = await PbClient.instance;
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

  // ─── DELETE ───────────────────────────────────────────────────────
  Future<bool> deleteAddress(String addressId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final pb = await PbClient.instance;
      await pb.collection('Address').delete(addressId);

      final wasDefault =
          _addresses.firstWhere((a) => a.id == addressId).isDefault;
      _addresses.removeWhere((a) => a.id == addressId);

      if (wasDefault && _addresses.isNotEmpty) {
        await setDefault(_addresses.first.id);
      }
      return true;
    } on ClientException catch (e) {
      _errorMessage = e.response['message']?.toString() ?? 'Lỗi xóa';
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
      final pb = await PbClient.instance;

      for (final addr in _addresses.where((a) => a.isDefault)) {
        await pb.collection('Address').update(
          addr.id,
          body: {'isDefault': false},
        );
      }

      await pb.collection('Address').update(
        addressId,
        body: {'isDefault': true},
      );

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