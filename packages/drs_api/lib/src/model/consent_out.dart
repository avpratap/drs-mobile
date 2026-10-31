//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'consent_out.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ConsentOut {
  /// Returns a new [ConsentOut] instance.
  ConsentOut({

    required  this.id,

    required  this.purpose,

    required  this.action,

    required  this.source_,

    required  this.createdAt,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final int id;



  @JsonKey(
    
    name: r'purpose',
    required: true,
    includeIfNull: false,
  )


  final String purpose;



  @JsonKey(
    
    name: r'action',
    required: true,
    includeIfNull: false,
  )


  final String action;



  @JsonKey(
    
    name: r'source',
    required: true,
    includeIfNull: false,
  )


  final String source_;



  @JsonKey(
    
    name: r'created_at',
    required: true,
    includeIfNull: false,
  )


  final DateTime createdAt;





    @override
    bool operator ==(Object other) => identical(this, other) || other is ConsentOut &&
      other.id == id &&
      other.purpose == purpose &&
      other.action == action &&
      other.source_ == source_ &&
      other.createdAt == createdAt;

    @override
    int get hashCode =>
        id.hashCode +
        purpose.hashCode +
        action.hashCode +
        source_.hashCode +
        createdAt.hashCode;

  factory ConsentOut.fromJson(Map<String, dynamic> json) => _$ConsentOutFromJson(json);

  Map<String, dynamic> toJson() => _$ConsentOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

