//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'rating_out.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class RatingOut {
  /// Returns a new [RatingOut] instance.
  RatingOut({

    required  this.id,

    required  this.productId,

    required  this.stars,

    required  this.status,

    required  this.verifiedPurchase,

    required  this.helpfulCount,

     this.userId,

     this.mine = false,

     this.comment,

     this.adminReply,
  });

  @JsonKey(
    
    name: r'id',
    required: true,
    includeIfNull: false,
  )


  final int id;



  @JsonKey(
    
    name: r'product_id',
    required: true,
    includeIfNull: false,
  )


  final int productId;



  @JsonKey(
    
    name: r'stars',
    required: true,
    includeIfNull: false,
  )


  final int stars;



      /// approved | pending | rejected
  @JsonKey(
    
    name: r'status',
    required: true,
    includeIfNull: false,
  )


  final String status;



  @JsonKey(
    
    name: r'verified_purchase',
    required: true,
    includeIfNull: false,
  )


  final bool verifiedPurchase;



  @JsonKey(
    
    name: r'helpful_count',
    required: true,
    includeIfNull: false,
  )


  final int helpfulCount;



      /// Only for the author (PII)
  @JsonKey(
    
    name: r'user_id',
    required: false,
    includeIfNull: false,
  )


  final int? userId;



  @JsonKey(
    defaultValue: false,
    name: r'mine',
    required: false,
    includeIfNull: false,
  )


  final bool? mine;



  @JsonKey(
    
    name: r'comment',
    required: false,
    includeIfNull: false,
  )


  final String? comment;



  @JsonKey(
    
    name: r'admin_reply',
    required: false,
    includeIfNull: false,
  )


  final String? adminReply;





    @override
    bool operator ==(Object other) => identical(this, other) || other is RatingOut &&
      other.id == id &&
      other.productId == productId &&
      other.stars == stars &&
      other.status == status &&
      other.verifiedPurchase == verifiedPurchase &&
      other.helpfulCount == helpfulCount &&
      other.userId == userId &&
      other.mine == mine &&
      other.comment == comment &&
      other.adminReply == adminReply;

    @override
    int get hashCode =>
        id.hashCode +
        productId.hashCode +
        stars.hashCode +
        status.hashCode +
        verifiedPurchase.hashCode +
        helpfulCount.hashCode +
        userId.hashCode +
        mine.hashCode +
        comment.hashCode +
        adminReply.hashCode;

  factory RatingOut.fromJson(Map<String, dynamic> json) => _$RatingOutFromJson(json);

  Map<String, dynamic> toJson() => _$RatingOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

