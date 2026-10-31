//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'consent_in.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ConsentIn {
  /// Returns a new [ConsentIn] instance.
  ConsentIn({

    required  this.purpose,

    required  this.action,
  });

      /// whatsapp_optin | marketing_sms | marketing_email | marketing_push | marketing_whatsapp | data_processing
  @JsonKey(
    
    name: r'purpose',
    required: true,
    includeIfNull: false,
  )


  final String purpose;



      /// granted | withdrawn
  @JsonKey(
    
    name: r'action',
    required: true,
    includeIfNull: false,
  )


  final String action;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ConsentIn &&
      other.purpose == purpose &&
      other.action == action;

    @override
    int get hashCode =>
        purpose.hashCode +
        action.hashCode;

  factory ConsentIn.fromJson(Map<String, dynamic> json) => _$ConsentInFromJson(json);

  Map<String, dynamic> toJson() => _$ConsentInToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

