//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'address_update.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AddressUpdate {
  /// Returns a new [AddressUpdate] instance.
  AddressUpdate({

     this.label,

     this.contactName,

     this.contactPhone,

     this.line1,

     this.line2,

     this.landmark,

     this.city,

     this.state,

     this.pincode,

     this.isDefault,
  });

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
    
    name: r'line1',
    required: false,
    includeIfNull: false,
  )


  final String? line1;



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
    
    name: r'city',
    required: false,
    includeIfNull: false,
  )


  final String? city;



  @JsonKey(
    
    name: r'state',
    required: false,
    includeIfNull: false,
  )


  final String? state;



  @JsonKey(
    
    name: r'pincode',
    required: false,
    includeIfNull: false,
  )


  final String? pincode;



  @JsonKey(
    
    name: r'is_default',
    required: false,
    includeIfNull: false,
  )


  final bool? isDefault;





    @override
    bool operator ==(Object other) => identical(this, other) || other is AddressUpdate &&
      other.label == label &&
      other.contactName == contactName &&
      other.contactPhone == contactPhone &&
      other.line1 == line1 &&
      other.line2 == line2 &&
      other.landmark == landmark &&
      other.city == city &&
      other.state == state &&
      other.pincode == pincode &&
      other.isDefault == isDefault;

    @override
    int get hashCode =>
        label.hashCode +
        contactName.hashCode +
        contactPhone.hashCode +
        line1.hashCode +
        line2.hashCode +
        landmark.hashCode +
        city.hashCode +
        state.hashCode +
        pincode.hashCode +
        isDefault.hashCode;

  factory AddressUpdate.fromJson(Map<String, dynamic> json) => _$AddressUpdateFromJson(json);

  Map<String, dynamic> toJson() => _$AddressUpdateToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

