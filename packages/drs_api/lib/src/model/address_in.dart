//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'address_in.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AddressIn {
  /// Returns a new [AddressIn] instance.
  AddressIn({

    required  this.line1,

    required  this.city,

    required  this.state,

    required  this.pincode,

     this.label,

     this.contactName,

     this.contactPhone,

     this.line2,

     this.landmark,

     this.country = 'IN',

     this.isDefault = false,
  });

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



  @JsonKey(
    defaultValue: 'IN',
    name: r'country',
    required: false,
    includeIfNull: false,
  )


  final String? country;



  @JsonKey(
    defaultValue: false,
    name: r'is_default',
    required: false,
    includeIfNull: false,
  )


  final bool? isDefault;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AddressIn &&
      other.line1 == line1 &&
      other.city == city &&
      other.state == state &&
      other.pincode == pincode &&
      other.label == label &&
      other.contactName == contactName &&
      other.contactPhone == contactPhone &&
      other.line2 == line2 &&
      other.landmark == landmark &&
      other.country == country &&
      other.isDefault == isDefault;

    @override
    int get hashCode =>
        line1.hashCode +
        city.hashCode +
        state.hashCode +
        pincode.hashCode +
        label.hashCode +
        contactName.hashCode +
        contactPhone.hashCode +
        line2.hashCode +
        landmark.hashCode +
        country.hashCode +
        isDefault.hashCode;

  factory AddressIn.fromJson(Map<String, dynamic> json) => _$AddressInFromJson(json);

  Map<String, dynamic> toJson() => _$AddressInToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

