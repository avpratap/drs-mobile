/// Test doubles for apps using the shared notifications service.
library;

import 'dart:async';

import 'src/notifications/push_platform.dart';

/// Scriptable [PushPlatform]: set [grant], [currentToken], [launchedWith];
/// push taps / refreshes / foreground messages via the controllers.
class FakePushPlatform implements PushPlatform {
  FakePushPlatform({this.grant = PushPermission.granted});

  PushPermission grant;
  PushPermission current = PushPermission.notDetermined;
  String? currentToken = 't' * 160;
  Map<String, Object?>? launchedWith;
  int prompts = 0;
  int deletes = 0;
  final openedCtl = StreamController<Map<String, Object?>>.broadcast();
  final refreshCtl = StreamController<String>.broadcast();
  final fgCtl = StreamController<PushMessage>.broadcast();

  @override
  bool get available => true;
  @override
  String get platformName => 'ios';
  @override
  Future<void> init() async {}
  @override
  Future<PushPermission> permission() async => current;
  @override
  Future<PushPermission> requestPermission() async {
    prompts++;
    return current = grant;
  }

  @override
  Future<String?> token() async => currentToken;
  @override
  Stream<String> get tokenRefresh => refreshCtl.stream;
  @override
  Stream<PushMessage> get foreground => fgCtl.stream;
  @override
  Stream<Map<String, Object?>> get opened => openedCtl.stream;
  @override
  Future<Map<String, Object?>?> initialOpen() async => launchedWith;
  @override
  Future<void> deleteToken() async => deletes++;
}
