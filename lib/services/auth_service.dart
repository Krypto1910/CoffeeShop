import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pocketbase/pocketbase.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/user.dart';
import '../services/pb_client.dart';

class AuthProvider extends ChangeNotifier {
  User? _user;
  bool _initialized = false;
  bool _isLoading = false;
  String? _errorMessage;

  User? get user => _user;
  bool get isLoggedIn => _user != null;
  bool get initialized => _initialized;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  AuthProvider() {
    _init();
  }

  Future<void> _init() async {
    final pb = await PbClient.instance;

    pb.authStore.onChange.listen((event) {
      _user = event.record != null ? _mapUser(event.record!) : null;
      notifyListeners();
    });

    if (pb.authStore.isValid && pb.authStore.record != null) {
      _user = _mapUser(pb.authStore.record!);
    }

    _initialized = true;
    notifyListeners();
  }

  // ─── SIGNUP ───────────────────────────────────────────────────────
  Future<bool> signup(String email, String password) async {
    return _run(() async {
      final pb = await PbClient.instance;
      await pb.collection('users').create(body: {
        'email': email,
        'password': password,
        'passwordConfirm': password,
      });
      final auth = await pb
          .collection('users')
          .authWithPassword(email, password);
      return _mapUser(auth.record);
    });
  }

  // ─── LOGIN ────────────────────────────────────────────────────────
  Future<bool> login(String email, String password) async {
    return _run(() async {
      final pb = await PbClient.instance;
      final auth = await pb
          .collection('users')
          .authWithPassword(email, password);
      return _mapUser(auth.record);
    });
  }

  // ─── OAUTH2 ───────────────────────────────────────────────────────
  Future<bool> loginWithOAuth2(String provider) async {
    return _run(() async {
      final pb = await PbClient.instance;
      final auth = await pb.collection('users').authWithOAuth2(
        provider,
        (url) async {
          if (await canLaunchUrl(url)) {
            await launchUrl(url, mode: LaunchMode.externalApplication);
          } else {
            throw Exception('Không thể mở trình duyệt');
          }
        },
      );
      return _mapUser(auth.record);
    });
  }

  // ─── UPDATE PROFILE ───────────────────────────────────────────────
  Future<bool> updateProfile({String? name, String? phone}) async {
    return _run(() async {
      final pb = await PbClient.instance;
      final userId = _user?.id;
      if (userId == null) throw Exception('Chưa đăng nhập');

      final record = await pb.collection('users').update(
        userId,
        body: {
          if (name != null) 'name': name,
          if (phone != null) 'phone': phone,
        },
      );
      return _mapUser(record);
    });
  }

  // ─── UPLOAD AVATAR ────────────────────────────────────────────────
  Future<bool> uploadAvatar(File imageFile) async {
    return _run(() async {
      final pb = await PbClient.instance;
      final userId = _user?.id;
      if (userId == null) throw Exception('Chưa đăng nhập');

      // Dùng http.MultipartFile từ package http
      final multipartFile = http.MultipartFile.fromBytes(
        'avatar',
        await imageFile.readAsBytes(),
        filename: 'avatar_$userId.jpg',
      );

      final record = await pb.collection('users').update(
        userId,
        files: [multipartFile],
      );
      return _mapUser(record);
    });
  }

  // ─── GET AVATAR URL ───────────────────────────────────────────────
  String? getAvatarUrl() {
    final u = _user;
    if (u == null || u.avatar == null || u.avatar!.isEmpty) return null;
    return '${PbClient.baseUrl}/api/files/users/${u.id}/${u.avatar}';
  }

  // ─── LOGOUT ───────────────────────────────────────────────────────
  Future<void> logout() async {
    final pb = await PbClient.instance;
    pb.authStore.clear();
    _user = null;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // ─── MAP USER ─────────────────────────────────────────────────────
  User _mapUser(RecordModel record) {
    return User(
      id: record.id,
      email: record.getStringValue('email'),
      name: record.getStringValue('name').isEmpty
          ? null
          : record.getStringValue('name'),
      phone: record.getStringValue('phone').isEmpty
          ? null
          : record.getStringValue('phone'),
      avatar: record.getStringValue('avatar').isEmpty
          ? null
          : record.getStringValue('avatar'),
    );
  }

  // ─── RUN WRAPPER ──────────────────────────────────────────────────
  Future<bool> _run(Future<User> Function() action) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _user = await action();
      return true;
    } on ClientException catch (e) {
      final data = e.response['data'];
      final message = e.response['message'];
      if (data != null && data is Map && data.isNotEmpty) {
        _errorMessage = data.entries
            .map((e) => '${e.key}: ${e.value['message'] ?? e.value}')
            .join('\n');
      } else if (message != null && message.toString().isNotEmpty) {
        _errorMessage = message.toString();
      } else {
        _errorMessage = 'Lỗi server: ${e.statusCode}';
      }
      return false;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}