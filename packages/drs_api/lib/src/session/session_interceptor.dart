import 'dart:async';

import 'package:dio/dio.dart';

import '../../drs_api.dart';
import 'token_store.dart';

/// Attaches `Authorization: Bearer <access>` to every operation whose OpenAPI
/// security requirement includes `HTTPBearer`, and transparently rotates the
/// token pair once on a 401 (`refresh_token` operation), then retries.
///
/// It is a [QueuedInterceptor], so concurrent 401s trigger a single refresh.
class DrsSessionInterceptor extends QueuedInterceptor {
  DrsSessionInterceptor({
    required this.tokenStore,
    required this.dio,
    required this.refreshApi,
    this.onSessionExpired,
  });

  final TokenStore tokenStore;

  /// The Dio instance requests are retried on.
  final Dio dio;

  /// Must use a Dio *without* this interceptor (avoids refresh recursion).
  final AuthApi refreshApi;

  /// Called after a refresh fails: tokens are already cleared; the app
  /// should route to sign-in.
  final void Function()? onSessionExpired;

  static const _retriedKey = 'drs_session_retried';
  static const _usedTokenKey = 'drs_session_used_token';

  static bool _requiresBearer(RequestOptions o) {
    final secure = o.extra['secure'];
    if (secure is! List) return false;
    return secure.whereType<Map<Object?, Object?>>().any(
      (s) =>
          s['type'] == 'http' &&
          (s['scheme'] as String?)?.toLowerCase() == 'bearer',
    );
  }

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (_requiresBearer(options)) {
      final tokens = await tokenStore.read();
      if (tokens != null) {
        options.headers['Authorization'] = 'Bearer ${tokens.accessToken}';
        options.extra[_usedTokenKey] = tokens.accessToken;
      }
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final req = err.requestOptions;
    final is401 = err.response?.statusCode == 401;
    if (!is401 || !_requiresBearer(req) || req.extra[_retriedKey] == true) {
      return handler.next(err);
    }

    final current = await tokenStore.read();
    if (current == null) return handler.next(err);

    // Another queued request may already have refreshed: just retry.
    var access = current.accessToken;
    if (req.extra[_usedTokenKey] == access) {
      try {
        final res = await refreshApi.refreshToken(
          refreshRequest: RefreshRequest(refreshToken: current.refreshToken),
        );
        final pair = res.data!;
        await tokenStore.write(
          SessionTokens(
            accessToken: pair.accessToken,
            refreshToken: pair.refreshToken,
          ),
        );
        access = pair.accessToken;
      } on DioException catch (e) {
        // Only a genuine auth rejection (the refresh token itself is invalid/revoked)
        // ends the session. A dropped connection or a 5xx during refresh must NOT sign
        // the user out — that would break offline-first; surface the original 401 and
        // let the caller retry later with the still-valid refresh token.
        final status = e.response?.statusCode;
        if (status == 401 || status == 403) {
          await tokenStore.clear();
          onSessionExpired?.call();
        }
        return handler.next(err);
      } on Object {
        // Unexpected non-Dio failure during refresh: don't nuke a possibly-good session.
        return handler.next(err);
      }
    }

    try {
      req.extra[_retriedKey] = true;
      req.extra[_usedTokenKey] = access;
      req.headers['Authorization'] = 'Bearer $access';
      // A multipart body's file streams are single-read; the original was already consumed
      // sending the first (401) attempt, so re-fetching it as-is throws "already read".
      // Clone the FormData (MultipartFile.fromFile is re-readable) so the retry re-streams
      // the POD photo / image upload instead of spuriously failing after a token refresh.
      if (req.data is FormData) {
        req.data = (req.data as FormData).clone();
      }
      final retried = await dio.fetch<Object?>(req);
      return handler.resolve(retried);
    } on DioException catch (e) {
      return handler.next(e);
    }
  }
}
