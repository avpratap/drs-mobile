//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'detail_out.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class DetailOut {
  /// Returns a new [DetailOut] instance.
  DetailOut({

    required  this.detail,
  });

  @JsonKey(
    
    name: r'detail',
    required: true,
    includeIfNull: false,
  )


  final String detail;





    @override
    bool operator ==(Object other) => identical(this, other) || other is DetailOut &&
      other.detail == detail;

    @override
    int get hashCode =>
        detail.hashCode;

  factory DetailOut.fromJson(Map<String, dynamic> json) => _$DetailOutFromJson(json);

  Map<String, dynamic> toJson() => _$DetailOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

