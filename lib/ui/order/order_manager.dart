import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import '../../models/order_item.dart';
import '../../services/pb_client.dart';
import '../cart/cart_manager.dart';

class OrderManager extends ChangeNotifier {
  List<OrderModel> _orders = [];
  bool _isLoading = false;
  String? _errorMessage;
  String? _lastOrderId;

  List<OrderModel> get orders => List.unmodifiable(_orders);
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get lastOrderId => _lastOrderId;

  // ─── PLACE ORDER ──────────────────────────────────────────────────
  Future<bool> placeOrder({
    required String userId,
    required List<CartItem> cartItems,
    required String address,
    required String paymentMethod,
    required double totalAmount,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final pb = await PbClient.instance;

      // 1. Tạo Order
      final orderRecord = await pb.collection('Order').create(body: {
        'userID': userId,
        'status': 'pending',
        'totalAmount': totalAmount,
        'address': address,
        'paymentMethod': paymentMethod,
      });

      final orderId = orderRecord.id;
      _lastOrderId = orderId;
      debugPrint('ORDER created: $orderId');

      // 2. Tạo từng OrderItem
      for (final item in cartItems) {
        await pb.collection('OrderItem').create(body: {
          'orderID': orderId,
          'productID': item.product.id,
          'unitPrice': item.product.price,
          'quantity': item.quantity,
          'options': {'title': item.product.title},
        });
        debugPrint('ORDER ITEM: ${item.product.title} x${item.quantity}');
      }

      return true;
    } on ClientException catch (e) {
      debugPrint('PLACE ORDER ERROR: ${e.response}');
      _errorMessage = e.response['message']?.toString() ?? 'Đặt hàng thất bại';
      return false;
    } catch (e) {
      debugPrint('PLACE ORDER EXCEPTION: $e');
      _errorMessage = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ─── FETCH ORDER HISTORY ──────────────────────────────────────────
  Future<void> fetchOrders(String userId) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final pb = await PbClient.instance;

      debugPrint('FETCH ORDERS for userId: $userId');
      debugPrint('AUTH TOKEN valid: ${pb.authStore.isValid}');

      // PocketBase v0.36: Relation field dùng cú pháp field.id
      final records = await pb.collection('Order').getFullList(
        filter: 'userID.id = "$userId"',
        sort: '-created',
      );

      debugPrint('ORDERS fetched: ${records.length}');

      _orders = records.map((r) => OrderModel.fromJson(r.toJson())).toList();
    } on ClientException catch (e) {
      debugPrint('FETCH ORDERS ERROR: ${e.response}');
      debugPrint('FETCH ORDERS STATUS: ${e.statusCode}');
      _errorMessage = e.response['message']?.toString() ?? 'Lỗi tải đơn hàng';
    } catch (e) {
      debugPrint('FETCH ORDERS EXCEPTION: $e');
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ─── FETCH ORDER ITEMS ────────────────────────────────────────────
  Future<List<OrderItemModel>> fetchOrderItems(String orderId) async {
    try {
      final pb = await PbClient.instance;
      final records = await pb.collection('OrderItem').getFullList(
        filter: 'orderID.id = "$orderId"',
        expand: 'productID',
      );

      return records.map((r) {
        final productJson = r.expand['productID']?.first.toJson();
        return OrderItemModel.fromJson(r.toJson(), productJson: productJson);
      }).toList();
    } on ClientException catch (e) {
      debugPrint('FETCH ORDER ITEMS ERROR: ${e.response}');
      return [];
    } catch (e) {
      debugPrint('FETCH ORDER ITEMS EXCEPTION: $e');
      return [];
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}