//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'upload_out.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class UploadOut {
  /// Returns a new [UploadOut] instance.
  UploadOut({

    required  this.url,

    required  this.previewUrl,
  });

      /// media:<key> reference
  @JsonKey(
    
    name: r'url',
    required: true,
    includeIfNull: false,
  )


  final String url;



  @JsonKey(
    
    name: r'preview_url',
    required: true,
    includeIfNull: false,
  )


  final String previewUrl;





    @override
    bool operator ==(Object other) => identical(this, other) || other is UploadOut &&
      other.url == url &&
      other.previewUrl == previewUrl;

    @override
    int get hashCode =>
        url.hashCode +
        previewUrl.hashCode;

  factory UploadOut.fromJson(Map<String, dynamic> json) => _$UploadOutFromJson(json);

  Map<String, dynamic> toJson() => _$UploadOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

