import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Ride {
  String? pick_loc, drop_loc;
  DateTime? pick_date;
  TimeOfDay? pick_time;
  DateTime? retrun_date;
  TimeOfDay? return_time;
  String? distance, duration;
  String? lat_pick, lat_drop;
  String? long_pick, long_drop;
  String? via1, via2, via3;

  Ride({
    this.long_drop,
    this.lat_drop,
    this.distance,
    this.drop_loc,
    this.duration,
    this.long_pick,
    this.lat_pick,
    this.pick_date,
    this.pick_loc,
    this.pick_time,
    this.retrun_date,
    this.return_time,
    this.via1,
    this.via2,
    this.via3,
  });

  factory Ride.fromJson(Map<String, dynamic> json) {
    return Ride(
      long_drop: json['long_drop'] as String ?? '',
      lat_drop: json['lat_drop'] as String ?? '',
      distance: json['distance'] as String ?? '',
      drop_loc: json['drop_loc'] as String ?? '',
      duration: json['duration'] as String ?? '',
      long_pick: json['long_pick'] as String ?? '',
      lat_pick: json['lat_pick'] as String ?? '',
      pick_date: json['pick_date'],
      pick_loc: json['pick_loc'] as String ?? '',
      pick_time: json['pick_time'],
      retrun_date: json['retrun_date'],
      return_time: json['return_time'],
      via1: json['via1'],
      via2: json['via2'],
      via3: json['via3'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['long_drop'] = long_drop;
    data['lat_drop'] = lat_drop;
    data['distance'] = distance;
    data['drop_loc'] = drop_loc;
    data['duration'] = duration;
    data['long_pick'] = long_pick;
    data['lat_pick'] = lat_pick;
    data['pick_date'] = pick_date;
    data['pick_loc'] = pick_loc;
    data['pick_time'] = pick_time;
    data['retrun_date'] = retrun_date;
    data['return_time'] = return_time;
    data['via1'] = via1;
    data['via2'] = via2;
    data['via3'] = via3;
    return data;
  }
}
