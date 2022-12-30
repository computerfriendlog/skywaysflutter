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

  String? passengerName;
  String? mobile_no;
  String? vehicle_type;
  String? payment_type;//card or cash
  String? note;
  String? flight_no;
  String? num_of_people;
  String? fare;
  String? email;
  String? hand_luggage;
  String? luggage;
  String? customer_id;
  String? username;

  Ride(
      {
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
    this.customer_id,
    this.email,this.fare,this.flight_no,this.hand_luggage,this.luggage,this.note,this.num_of_people,this.mobile_no,this.passengerName,
    this.payment_type,this.vehicle_type,this.username
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
      via1: json['via1']as String ?? '',
      via2: json['via2']as String ?? '',
      via3: json['via3']as String ?? '',

      passengerName: json['passengerName'] as String ?? '',
      mobile_no: json['mobile_no'] as String ?? '',
      vehicle_type: json['vehicle_type'] as String ?? '',
      payment_type: json['job_type'] as String ?? '',
      note: json['note'] as String ?? '',
      flight_no: json['flight_no'] as String ?? '',
      num_of_people: json['num_of_people'] as String ?? '',
      fare: json['fare'],
      email: json['email'] as String ?? '',
      hand_luggage: json['hand_luggage'],
      luggage: json['luggage'],
      customer_id: json['customer_id'],
      username: json['username']as String ?? '',

    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['passengerName'] = passengerName;
    data['mobile_no'] = mobile_no;
    data['vehicle_type'] = vehicle_type;
    data['job_type'] = payment_type;
    data['note'] = note;
    data['flight_no'] = flight_no;
    data['num_of_people'] = num_of_people;
    data['fare'] = fare;
    data['email'] = email;
    data['hand_luggage'] = hand_luggage;
    data['luggage'] = luggage;
    data['customer_id'] = customer_id;
    data['username'] = username;

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
