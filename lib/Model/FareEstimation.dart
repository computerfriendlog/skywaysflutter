import 'package:flutter/material.dart';

class FareEstimation{
  String? id, type;
  String? seats, description;
  String? luggage, small_luggage;
  String? car_image, price;
  String? orig_price, return_fare, orig_return_fare;

  FareEstimation({
    this.price,
    this.small_luggage,
    this.seats,
    this.type,
    this.description,
    this.car_image,
    this.luggage,
    this.id,
    this.orig_price,
    this.return_fare,
    this.orig_return_fare,
  });

  factory FareEstimation.fromJson(Map<String, dynamic> json) {
    return FareEstimation(
      price: json['price'] as String ?? '',
      small_luggage: json['small_luggage'] as String ?? '',
      seats: json['seats'] as String ?? '',
      type: json['type'] as String ?? '',
      description: json['description'] as String ?? '',
      car_image: json['car_image'] as String ?? '',
      luggage: json['luggage'] as String ?? '',
      id: json['id'] as String ?? '',
      orig_price: json['orig_price'],
      return_fare: json['return_fare'],
      orig_return_fare: json['orig_return_fare'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['price'] = price;
    data['small_luggage'] = small_luggage;
    data['seats'] = seats;
    data['type'] = type;
    data['description'] = description;
    data['car_image'] = car_image;
    data['luggage'] = luggage;
    data['id'] = id;
    data['orig_price'] = orig_price;
    data['return_fare'] = return_fare;
    data['orig_return_fare'] = orig_return_fare;
    return data;
  }
}