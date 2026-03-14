import 'dart:async';
import 'dart:developer' show log;

import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:pocketbase/pocketbase.dart';

import '../models/user.dart';
import 'pocketbase_client.dart';

class AuthService {
  void Function(User? user)? onAuthChange;
  StreamSubscription? _authSubscription;

  static const _callbackScheme = 'coffeenow';

  AuthService({this.onAuthChange}) {
    if (onAuthChange != null) {
      _initAuthListener();
    }
  }

  Future<void> _initAuthListener() async {
    final pb = await getPocketbaseInstance();
    _authSubscription = pb.authStore.onChange.listen((event) {
      onAuthChange!(
        event.record == null ? null : User.fromJson(event.record!.toJson()),
      );
    });
  }

  void dispose() {
    _authSubscription?.cancel();
  }

  // ─── SIGNUP ──────────────────────────────────────────────────────
  Future<User> signup(String email, String password, {String? name}) async {
    final pb = await getPocketbaseInstance();
    try {
      await pb.collection('users').create(body: {
        'email': email,
        'password': password,
        'passwordConfirm': password,
        if (name != null && name.isNotEmpty) 'name': name,
      });
      log('SIGNUP created: $email');
      return await login(email, password);
    } catch (error) {
      log('SIGNUP ERROR: $error');
      _handleError(error, prefix: 'SIGNUP');
    }
  }

  // ─── LOGIN ───────────────────────────────────────────────────────
  Future<User> login(String email, String password) async {
    final pb = await getPocketbaseInstance();
    try {
      final auth = await pb
          .collection('users')
          .authWithPassword(email, password);
      log('LOGIN success: ${auth.record.id}');
      return User.fromJson(auth.record.toJson());
    } catch (error) {
      log('LOGIN ERROR: $error');
      _handleError(error, prefix: 'LOGIN');
    }
  }

  // ─── OAUTH2 ──────────────────────────────────────────────────────
  Future<User> loginWithOAuth2(String provider) async {
    final pb = await getPocketbaseInstance();
    try {
      final auth = await pb.collection('users').authWithOAuth2(
        provider,
        (url) async {
          // Mở browser và chờ callback về coffeenow://oauth2
          await FlutterWebAuth2.authenticate(
            url: url.toString(),
            callbackUrlScheme: _callbackScheme,
          );
        },
      );
      log('OAUTH2 [$provider] success: ${auth.record.id}');
      return User.fromJson(auth.record.toJson());
    } catch (error) {
      log('OAUTH2 [$provider] ERROR: $error');
      _handleError(error, prefix: 'OAUTH2');
    }
  }

  // ─── LOGOUT ──────────────────────────────────────────────────────
  Future<void> logout() async {
    final pb = await getPocketbaseInstance();
    pb.authStore.clear();
    log('LOGOUT: session cleared');
  }

  // ─── RESTORE SESSION ─────────────────────────────────────────────
  Future<User?> getUserFromStore() async {
    final pb = await getPocketbaseInstance();
    final record = pb.authStore.record;
    if (record == null || !pb.authStore.isValid) {
      log('SESSION: none or expired');
      return null;
    }
    log('SESSION restored: ${record.id}');
    return User.fromJson(record.toJson());
  }

  // ─── ERROR HELPER ────────────────────────────────────────────────
  Never _handleError(Object error, {required String prefix}) {
    if (error is ClientException) {
      log('$prefix response: ${error.response}');
      final data = error.response['data'];
      final message = error.response['message'];
      if (data != null && data is Map && data.isNotEmpty) {
        final fieldErrors = data.entries
            .map((e) => '${e.key}: ${e.value['message'] ?? e.value}')
            .join('\n');
        throw Exception(fieldErrors);
      } else if (message != null && message.toString().isNotEmpty) {
        throw Exception(message.toString());
      } else {
        throw Exception('Server error ${error.statusCode}: ${error.response}');
      }
    }
    throw Exception('An error occurred: $error');
  }
}