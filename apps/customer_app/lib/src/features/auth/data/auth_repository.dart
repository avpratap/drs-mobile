import 'package:drs_api/drs_api.dart';
import 'package:drs_api/drs_api_session.dart';
import 'package:drs_core/drs_core.dart';

/// Phone-OTP auth against `/api/v1/auth/*` (`request_otp`, `verify_otp`,
/// `get_me`, `logout`). Tokens go to [TokenStore] only.
class AuthRepository {
  AuthRepository({required this._api, required this._tokens});

  final AuthApi _api;
  final TokenStore _tokens;

  /// Sends an OTP to [e164Phone]. Returns the backend's `dev_otp` when it
  /// provides one (non-prod only), else null.
  Future<String?> requestOtp(String e164Phone) async {
    try {
      final res = await _api.requestOtp(
        oTPRequest: OTPRequest(phone: e164Phone),
      );
      return res.data?.devOtp;
    } on Object catch (e) {
      throw DrsApiError.from(e);
    }
  }

  /// Exchanges the OTP for a JWT pair, persists it, and loads the account.
  Future<Account> verifyOtp(String e164Phone, String otp) async {
    try {
      final res = await _api.verifyOtp(
        oTPVerify: OTPVerify(phone: e164Phone, otp: otp),
      );
      final pair = res.data!;
      await _tokens.write(
        SessionTokens(
          accessToken: pair.accessToken,
          refreshToken: pair.refreshToken,
        ),
      );
      return await currentAccount();
    } on Object catch (e) {
      throw DrsApiError.from(e);
    }
  }

  Future<bool> hasSession() async => await _tokens.read() != null;

  Future<Account> currentAccount() async {
    try {
      final me = (await _api.getMe()).data!;
      return Account(
        userId: me.id,
        phone: me.phone,
        role: AccountRole.parse(me.role),
        fullName: me.fullName,
      );
    } on Object catch (e) {
      throw DrsApiError.from(e);
    }
  }

  /// Revokes the refresh-token family server-side (best effort) and wipes
  /// local tokens.
  Future<void> signOut() async {
    final tokens = await _tokens.read();
    if (tokens != null) {
      try {
        await _api.logout(
          refreshRequest: RefreshRequest(refreshToken: tokens.refreshToken),
        );
      } on Object {
        // Offline sign-out still clears the device; the server-side family
        // expires on its own.
      }
    }
    await _tokens.clear();
  }
}
