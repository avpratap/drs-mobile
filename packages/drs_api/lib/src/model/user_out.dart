//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'user_out.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class UserOut {
  /// Returns a new [UserOut] instance.
  UserOut({

    required  this.id,

    required  this.phone,

    required  this.role,

    required  this.status,

     this.fullName,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final int id;



  @JsonKey(
    
    name: r'phone',
    required: true,
    includeIfNull: false,
  )


  final String phone;



  @JsonKey(
    
    name: r'role',
    required: true,
    includeIfNull: false,
  )


  final String role;



  @JsonKey(
    
    name: r'status',
    required: true,
    includeIfNull: false,
  )


  final String status;



  @JsonKey(
    
    name: r'full_name',
    required: false,
    includeIfNull: false,
  )


  final String? fullName;





    @override
    bool operator ==(Object other) => identical(this, other) || other is UserOut &&
      other.id == id &&
      other.phone == phone &&
      other.role == role &&
      other.status == status &&
      other.fullName == fullName;

    @override
    int get hashCode =>
        id.hashCode +
        phone.hashCode +
        role.hashCode +
        status.hashCode +
        fullName.hashCode;

  factory UserOut.fromJson(Map<String, dynamic> json) => _$UserOutFromJson(json);

  Map<String, dynamic> toJson() => _$UserOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

