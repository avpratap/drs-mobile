import 'package:drs_api/drs_api.dart';
import 'package:drs_core/drs_core.dart';

import '../../../data/api_guard.dart';
import '../../../data/mappers.dart';

/// Profile, consents and saved addresses (`/api/v1/profile`, `/consents`,
/// `/addresses`). Not cached on device: this is personal data and must be
/// current.
class AccountRepository {
  AccountRepository(this._api);

  final AccountApi _api;

  Future<Profile> profile() =>
      guard(() async => (await _api.getProfile()).data!.toDomain());

  /// Sends only the provided fields (server applies a partial update).
  Future<Profile> updateProfile({
    String? fullName,
    String? displayName,
    String? email,
    bool? notifyPush,
  }) => guard(
    () async => (await _api.updateProfile(
      profileUpdate: ProfileUpdate(
        fullName: fullName,
        displayName: displayName,
        email: email,
        notifyPush: notifyPush,
      ),
    )).data!.toDomain(),
  );

  /// purpose → `granted` | `withdrawn`.
  Future<Map<String, String>> consents() =>
      guard(() async => (await _api.getConsents()).data ?? const {});

  Future<void> setConsent(String purpose, {required bool granted}) => guard(
    () => _api.recordConsent(
      consentIn: ConsentIn(purpose: purpose, action: granted ? 'granted' : 'withdrawn'),
    ),
  );

  Future<List<Address>> addresses() => guard(
    () async => [
      for (final a in (await _api.listAddresses()).data ?? const <AddressOut>[])
        if (a.status != 'deleted') a.toDomain(),
    ],
  );

  Future<Address> createAddress(AddressIn input) =>
      guard(() async => (await _api.createAddress(addressIn: input)).data!.toDomain());

  Future<Address> updateAddress(int id, AddressUpdate patch) => guard(
    () async =>
        (await _api.updateAddress(addressId: id, addressUpdate: patch)).data!.toDomain(),
  );

  Future<void> setDefaultAddress(int id) =>
      guard(() => _api.setDefaultAddress(addressId: id));

  Future<void> deleteAddress(int id) => guard(() => _api.deleteAddress(addressId: id));
}
