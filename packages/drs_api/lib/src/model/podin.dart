//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'podin.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class PODIn {
  /// Returns a new [PODIn] instance.
  PODIn({

     this.recipientName,

     this.photoUrl,

     this.signatureUrl,

     this.lat,

     this.lng,

     this.note,
  });

  @JsonKey(
    
    name: r'recipient_name',
    required: false,
    includeIfNull: false,
  )


  final String? recipientName;



      /// media:… ref from upload_pod_asset, or https URL
  @JsonKey(
    
    name: r'photo_url',
    required: false,
    includeIfNull: false,
  )


  final String? photoUrl;



  @JsonKey(
    
    name: r'signature_url',
    required: false,
    includeIfNull: false,
  )


  final String? signatureUrl;



  @JsonKey(
    
    name: r'lat',
    required: false,
    includeIfNull: false,
  )


  final num? lat;



  @JsonKey(
    
    name: r'lng',
    required: false,
    includeIfNull: false,
  )


  final num? lng;



  @JsonKey(
    
    name: r'note',
    required: false,
    includeIfNull: false,
  )


  final String? note;





    @override
    bool operator ==(Object other) => identical(this, other) || other is PODIn &&
      other.recipientName == recipientName &&
      other.photoUrl == photoUrl &&
      other.signatureUrl == signatureUrl &&
      other.lat == lat &&
      other.lng == lng &&
      other.note == note;

    @override
    int get hashCode =>
        recipientName.hashCode +
        photoUrl.hashCode +
        signatureUrl.hashCode +
        lat.hashCode +
        lng.hashCode +
        note.hashCode;

  factory PODIn.fromJson(Map<String, dynamic> json) => _$PODInFromJson(json);

  Map<String, dynamic> toJson() => _$PODInToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

