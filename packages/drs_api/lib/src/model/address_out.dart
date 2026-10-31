//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'address_out.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AddressOut {
  /// Returns a new [AddressOut] instance.
  AddressOut({

    required  this.id,

    required  this.accountId,

    required  this.line1,

    required  this.city,

    required  this.state,

    required  this.pincode,

    required  this.country,

    required  this.isDefault,

    required  this.status,

     this.label,

     this.contactName,

     this.contactPhone,

     this.line2,

     this.landmark,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final int id;



  @JsonKey(
    
    name: r'account_id',
    required: true,
    includeIfNull: false,
  )


  final int accountId;



  @JsonKey(
    
    name: r'line1',
    required: true,
    includeIfNull: false,
  )


  final String line1;



  @JsonKey(
    
    name: r'city',
    required: true,
    includeIfNull: false,
  )


  final String city;



  @JsonKey(
    
    name: r'state',
    required: true,
    includeIfNull: false,
  )


  final String state;



  @JsonKey(
    
    name: r'pincode',
    required: true,
    includeIfNull: false,
  )


  final String pincode;



  @JsonKey(
    
    name: r'country',
    required: true,
    includeIfNull: false,
  )


  final String country;



  @JsonKey(
    
    name: r'is_default',
    required: true,
    includeIfNull: false,
  )


  final bool isDefault;



  @JsonKey(
    
    name: r'status',
    required: true,
    includeIfNull: false,
  )


  final String status;



  @JsonKey(
    
    name: r'label',
    required: false,
    includeIfNull: false,
  )


  final String? label;



  @JsonKey(
    
    name: r'contact_name',
    required: false,
    includeIfNull: false,
  )


  final String? contactName;



  @JsonKey(
    
    name: r'contact_phone',
    required: false,
    includeIfNull: false,
  )


  final String? contactPhone;



  @JsonKey(
    
    name: r'line2',
    required: false,
    includeIfNull: false,
  )


  final String? line2;



  @JsonKey(
    
    name: r'landmark',
    required: false,
    includeIfNull: false,
  )


  final String? landmark;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AddressOut &&
      other.id == id &&
      other.accountId == accountId &&
      other.line1 == line1 &&
      other.city == city &&
      other.state == state &&
      other.pincode == pincode &&
      other.country == country &&
      other.isDefault == isDefault &&
      other.status == status &&
      other.label == label &&
      other.contactName == contactName &&
      other.contactPhone == contactPhone &&
      other.line2 == line2 &&
      other.landmark == landmark;

    @override
    int get hashCode =>
        id.hashCode +
        accountId.hashCode +
        line1.hashCode +
        city.hashCode +
        state.hashCode +
        pincode.hashCode +
        country.hashCode +
        isDefault.hashCode +
        status.hashCode +
        label.hashCode +
        contactName.hashCode +
        contactPhone.hashCode +
        line2.hashCode +
        landmark.hashCode;

  factory AddressOut.fromJson(Map<String, dynamic> json) => _$AddressOutFromJson(json);

  Map<String, dynamic> toJson() => _$AddressOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

