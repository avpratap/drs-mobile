// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'http_validation_error.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HTTPValidationError _$HTTPValidationErrorFromJson(Map<String, dynamic> json) =>
    $checkedCreate('HTTPValidationError', json, ($checkedConvert) {
      final val = HTTPValidationError(
        detail: $checkedConvert(
          'detail',
          (v) => (v as List<dynamic>?)
              ?.map(
                (e) => ValidationErrorItem.fromJson(e as Map<String, dynamic>),
              )
              .toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$HTTPValidationErrorToJson(
  HTTPValidationError instance,
) => <String, dynamic>{
  'detail': ?instance.detail?.map((e) => e.toJson()).toList(),
};
