//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'helpful_out.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class HelpfulOut {
  /// Returns a new [HelpfulOut] instance.
  HelpfulOut({

    required  this.ratingId,

    required  this.helpfulCount,

    required  this.voted,
  });

  @JsonKey(
    
    name: r'rating_id',
    required: true,
    includeIfNull: false,
  )


  final int ratingId;



  @JsonKey(
    
    name: r'helpful_count',
    required: true,
    includeIfNull: false,
  )


  final int helpfulCount;



  @JsonKey(
    
    name: r'voted',
    required: true,
    includeIfNull: false,
  )


  final bool voted;





    @override
    bool operator ==(Object other) => identical(this, other) || other is HelpfulOut &&
      other.ratingId == ratingId &&
      other.helpfulCount == helpfulCount &&
      other.voted == voted;

    @override
    int get hashCode =>
        ratingId.hashCode +
        helpfulCount.hashCode +
        voted.hashCode;

  factory HelpfulOut.fromJson(Map<String, dynamic> json) => _$HelpfulOutFromJson(json);

  Map<String, dynamic> toJson() => _$HelpfulOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

