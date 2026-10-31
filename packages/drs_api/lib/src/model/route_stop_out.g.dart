// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'route_stop_out.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RouteStopOut _$RouteStopOutFromJson(Map<String, dynamic> json) =>
    $checkedCreate('RouteStopOut', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['sequence', 'order']);
      final val = RouteStopOut(
        sequence: $checkedConvert('sequence', (v) => (v as num).toInt()),
        order: $checkedConvert(
          'order',
          (v) => DeliveryOrderOut.fromJson(v as Map<String, dynamic>),
        ),
      );
      return val;
    });

Map<String, dynamic> _$RouteStopOutToJson(RouteStopOut instance) =>
    <String, dynamic>{
      'sequence': instance.sequence,
      'order': instance.order.toJson(),
    };
