//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'rating_in.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class RatingIn {
  /// Returns a new [RatingIn] instance.
  RatingIn({

    required  this.stars,

     this.comment,
  });

          // minimum: 1
          // maximum: 5
  @JsonKey(
    
    name: r'stars',
    required: true,
    includeIfNull: false,
  )


  final int stars;



  @JsonKey(
    
    name: r'comment',
    required: false,
    includeIfNull: false,
  )


  final String? comment;





    @override
    bool operator ==(Object other) => identical(this, other) || other is RatingIn &&
      other.stars == stars &&
      other.comment == comment;

    @override
    int get hashCode =>
        stars.hashCode +
        comment.hashCode;

  factory RatingIn.fromJson(Map<String, dynamic> json) => _$RatingInFromJson(json);

  Map<String, dynamic> toJson() => _$RatingInToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

