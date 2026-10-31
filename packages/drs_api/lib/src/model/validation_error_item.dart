//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'validation_error_item.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ValidationErrorItem {
  /// Returns a new [ValidationErrorItem] instance.
  ValidationErrorItem({

    required  this.loc,

    required  this.msg,

    required  this.type,
  });

  @JsonKey(
    
    name: r'loc',
    required: true,
    includeIfNull: false,
  )


  final List<String> loc;



  @JsonKey(
    
    name: r'msg',
    required: true,
    includeIfNull: false,
  )


  final String msg;



  @JsonKey(
    
    name: r'type',
    required: true,
    includeIfNull: false,
  )


  final String type;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ValidationErrorItem &&
      other.loc == loc &&
      other.msg == msg &&
      other.type == type;

    @override
    int get hashCode =>
        loc.hashCode +
        msg.hashCode +
        type.hashCode;

  factory ValidationErrorItem.fromJson(Map<String, dynamic> json) => _$ValidationErrorItemFromJson(json);

  Map<String, dynamic> toJson() => _$ValidationErrorItemToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

