import 'package:meta/meta.dart';

import '../utils/pii.dart';

/// The signed-in customer's profile. PII — [toString] is redacted.
@immutable
class Profile {
  const Profile({
    required this.userId,
    required this.phone,
    this.email,
    this.emailVerified = false,
    this.fullName,
    this.displayName,
    this.notifyPush = true,
    this.notifySms = true,
    this.notifyWhatsapp = false,
    this.notifyEmail = false,
    this.marketingOptIn = false,
  });

  final int userId;
  final String phone;
  final String? email;
  final bool emailVerified;
  final String? fullName;

  /// What the app calls the user ("Hi, Asha").
  final String? displayName;

  /// Server-side channel switches (apply to every device of the user).
  final bool notifyPush;
  final bool notifySms;
  final bool notifyWhatsapp;
  final bool notifyEmail;

  /// Derived by the backend from the consent ledger (any marketing consent).
  final bool marketingOptIn;

  String get maskedPhone => Pii.maskPhone(phone);

  @override
  String toString() => 'Profile(userId: $userId, <redacted>)';
}

/// Consent-ledger purposes the app records (backend `ConsentIn.purpose`).
abstract final class ConsentPurpose {
  static const marketingPush = 'marketing_push';
}

/// Simple email shape check mirroring the backend pattern.
bool isPlausibleEmail(String s) =>
    RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(s.trim());
