//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:json_annotation/json_annotation.dart';

part 'tracking_event_out.g.dart';


@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class TrackingEventOut {
  /// Returns a new [TrackingEventOut] instance.
  TrackingEventOut({

    required  this.status,

     this.location,

     this.note,

     this.eventTime,
  });

  @JsonKey(
    
    name: r'status',
    required: true,
    includeIfNull: false,
  )


  final String status;



  @JsonKey(
    
    name: r'location',
    required: false,
    includeIfNull: false,
  )


  final String? location;



  @JsonKey(
    
    name: r'note',
    required: false,
    includeIfNull: false,
  )


  final String? note;



  @JsonKey(
    
    name: r'event_time',
    required: false,
    includeIfNull: false,
  )


  final DateTime? eventTime;





    @override
    bool operator ==(Object other) => identical(this, other) || other is TrackingEventOut &&
      other.status == status &&
      other.location == location &&
      other.note == note &&
      other.eventTime == eventTime;

    @override
    int get hashCode =>
        status.hashCode +
        location.hashCode +
        note.hashCode +
        eventTime.hashCode;

  factory TrackingEventOut.fromJson(Map<String, dynamic> json) => _$TrackingEventOutFromJson(json);

  Map<String, dynamic> toJson() => _$TrackingEventOutToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }

}

