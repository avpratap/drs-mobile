import 'package:meta/meta.dart';

import '../utils/pii.dart';

/// A saved delivery address. PII — [toString] is redacted.
@immutable
class Address {
  const Address({
    required this.id,
    required this.line1,
    required this.city,
    required this.state,
    required this.pincode,
    this.label,
    this.contactName,
    this.contactPhone,
    this.line2,
    this.landmark,
    this.isDefault = false,
  });

  final int id;
  final String? label;
  final String? contactName;
  final String? contactPhone;
  final String line1;
  final String? line2;
  final String? landmark;
  final String city;
  final String state;
  final String pincode;
  final bool isDefault;

  String get title => (label?.trim().isNotEmpty ?? false) ? label! : 'Address';

  /// Single line used for the order's delivery address.
  String get oneLine => [
    line1,
    line2,
    if (landmark?.trim().isNotEmpty ?? false) 'Near $landmark',
    city,
    '$state $pincode',
  ].whereType<String>().where((s) => s.trim().isNotEmpty).join(', ');

  String? get maskedPhone =>
      contactPhone == null ? null : Pii.maskPhone(contactPhone!);

  @override
  String toString() => 'Address(id: $id, <redacted>)';
}

/// GST state names accepted by the backend (canonical spellings), for the
/// address form's state picker.
abstract final class IndianStates {
  static const all = [
    'Andaman and Nicobar Islands',
    'Andhra Pradesh',
    'Arunachal Pradesh',
    'Assam',
    'Bihar',
    'Chandigarh',
    'Chhattisgarh',
    'Dadra and Nagar Haveli and Daman and Diu',
    'Delhi',
    'Goa',
    'Gujarat',
    'Haryana',
    'Himachal Pradesh',
    'Jammu and Kashmir',
    'Jharkhand',
    'Karnataka',
    'Kerala',
    'Ladakh',
    'Lakshadweep',
    'Madhya Pradesh',
    'Maharashtra',
    'Manipur',
    'Meghalaya',
    'Mizoram',
    'Nagaland',
    'Odisha',
    'Puducherry',
    'Punjab',
    'Rajasthan',
    'Sikkim',
    'Tamil Nadu',
    'Telangana',
    'Tripura',
    'Uttar Pradesh',
    'Uttarakhand',
    'West Bengal',
  ];

  static final _pin = RegExp(r'^[1-9][0-9]{5}$');

  /// Mirrors the backend's PINCODE_RE.
  static bool isValidPincode(String s) => _pin.hasMatch(s.trim());
}
