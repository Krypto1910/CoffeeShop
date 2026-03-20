import 'package:flutter/material.dart';
import '../../models/payment_method.dart';
import '../../services/pb_client.dart';

class PaymentMethodManager extends ChangeNotifier {
  List<PaymentMethodModel> _methods = [];
  bool _isLoading = false;

  List<PaymentMethodModel> get methods => _methods;
  bool get isLoading => _isLoading;

  /// FILTER
  List<PaymentMethodModel> get cards =>
      _methods.where((e) => e.type == 'card').toList();

  List<PaymentMethodModel> get ewallets =>
      _methods.where((e) => e.type == 'ewallet').toList();

  /// FETCH
  Future<void> fetch(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final pb = await PbClient.instance;

      final records = await pb
          .collection('PaymentMethod')
          .getFullList(filter: 'userId = "$userId"');

      _methods = records
          .map((e) => PaymentMethodModel.fromJson(e.toJson()))
          .toList();
    } catch (e) {
      debugPrint("FETCH PAYMENT ERROR: $e");
    }

    _isLoading = false;
    notifyListeners();
  }

  /// ADD
  Future<void> add({
    required String userId,
    required String type,
    required String provider,
    required String number,
    required String name,
    String? expiry, // ✅ FIX lỗi
  }) async {
    try {
      final pb = await PbClient.instance;

      await pb
          .collection('PaymentMethod')
          .create(
            body: {
              'userId': userId,
              'type': type,
              'provider': provider,
              'accountNumber': number,
              'accountName': name,
              'expiryDate': expiry ?? "",
              'isDefault': false,
            },
          );

      await fetch(userId); // 🔥 auto reload UI
    } catch (e) {
      debugPrint("ADD PAYMENT ERROR: $e");
    }
  }
}
