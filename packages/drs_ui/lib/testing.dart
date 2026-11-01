/// Test doubles for apps using the shared notifications service.
library;

import 'dart:async';

import 'package:flutter/rendering.dart';

import 'src/notifications/push_platform.dart';

/// Screen-reader audit of a semantics tree (TalkBack / VoiceOver):
/// returns one line per problem, empty when the screen is fine.
///
/// - every node a user can activate or adjust (tap, long-press,
///   increase/decrease) must have a spoken name — a label or a tooltip;
/// - a name must not be only digits/symbols (e.g. a badge read as "2").
///
/// Pass the root from a test: `t.binding.renderViews.first.owner!
/// .semanticsOwner!.rootSemanticsNode!` with semantics enabled.
List<String> screenReaderProblems(SemanticsNode root) {
  final problems = <String>[];
  void visit(SemanticsNode n) {
    final d = n.getSemanticsData();
    final actionable =
        d.hasAction(SemanticsAction.tap) ||
        d.hasAction(SemanticsAction.longPress) ||
        d.hasAction(SemanticsAction.increase) ||
        d.hasAction(SemanticsAction.decrease);
    final name = '${d.label} ${d.tooltip}'.trim();
    if (actionable && !d.flagsCollection.isHidden) {
      if (name.isEmpty) {
        problems.add('unlabelled control at ${n.rect} (value "${d.value}")');
      } else if (!RegExp(r'[A-Za-z\u0900-\u097F]').hasMatch(name)) {
        problems.add('control named only "$name" at ${n.rect}');
      }
    }
    n.visitChildren((c) {
      visit(c);
      return true;
    });
  }

  visit(root);
  return problems;
}

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
