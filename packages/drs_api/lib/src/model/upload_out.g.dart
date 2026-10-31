// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_out.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UploadOut _$UploadOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('UploadOut', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['url', 'preview_url']);
      final val = UploadOut(
        url: $checkedConvert('url', (v) => v as String),
        previewUrl: $checkedConvert('preview_url', (v) => v as String),
      );
      return val;
    }, fieldKeyMap: const {'previewUrl': 'preview_url'});

Map<String, dynamic> _$UploadOutToJson(UploadOut instance) => <String, dynamic>{
  'url': instance.url,
  'preview_url': instance.previewUrl,
};
