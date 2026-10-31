//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'fail_in.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class FailIn {
  /// Returns a new [FailIn] instance.
  FailIn({

    required  this.reason,
  });

      /// customer_unavailable | address_wrong | refused | other
  @JsonKey(
    
    name: r'reason',
    required: true,
    includeIfNull: false,
  )


  final String reason;





    @override
    bool operator ==(Object other) => identical(this, other) || other is FailIn &&
      other.reason == reason;

    @override
    int get hashCode =>
        reason.hashCode;

  factory FailIn.fromJson(Map<String, dynamic> json) => _$FailInFromJson(json);

  Map<String, dynamic> toJson() => _$FailInToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

