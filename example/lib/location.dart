import 'package:flutter/foundation.dart';

@immutable
class Location {
  const Location({
    required this.locTime,
    required this.locationType,
    required this.latitude,
    required this.longitude,
    required this.accuracy,
    required this.altitude,
    required this.bearing,
    required this.speed,
    this.country,
    this.province,
    this.city,
    this.district,
    this.street,
    this.streetNumber,
    this.cityCode,
    this.adCode,
    this.address,
    this.description,
  });

  final String locTime;
  final int locationType;
  final String latitude;
  final String longitude;
  final double accuracy;
  final String altitude;
  final double bearing;
  final double speed;
  final String? country;
  final String? province;
  final String? city;
  final String? district;
  final String? street;
  final String? streetNumber;
  final String? cityCode;
  final String? adCode;
  final String? address;
  final String? description;

  factory Location.fromJson(Map<String, dynamic> json) => Location(
      locTime: json['locTime'].toString(),
      locationType: json['locationType'] as int,
      latitude: json['latitude'].toString(),
      longitude: json['longitude'].toString(),
      accuracy: (json['accuracy'] as num).toDouble(),
      altitude: json['altitude'].toString(),
      bearing: (json['bearing'] as num).toDouble(),
      speed: (json['speed'] as num).toDouble(),
      country: json['country']?.toString(),
      province: json['province']?.toString(),
      city: json['city']?.toString(),
      district: json['district']?.toString(),
      street: json['street']?.toString(),
      streetNumber: json['streetNumber']?.toString(),
      cityCode: json['cityCode']?.toString(),
      adCode: json['adCode']?.toString(),
      address: json['address']?.toString(),
      description: json['description']?.toString());

  Map<String, dynamic> toJson() => {
        'locTime': locTime,
        'locationType': locationType,
        'latitude': latitude,
        'longitude': longitude,
        'accuracy': accuracy,
        'altitude': altitude,
        'bearing': bearing,
        'speed': speed,
        'country': country,
        'province': province,
        'city': city,
        'district': district,
        'street': street,
        'streetNumber': streetNumber,
        'cityCode': cityCode,
        'adCode': adCode,
        'address': address,
        'description': description
      };

  Location clone() => Location(
      locTime: locTime,
      locationType: locationType,
      latitude: latitude,
      longitude: longitude,
      accuracy: accuracy,
      altitude: altitude,
      bearing: bearing,
      speed: speed,
      country: country,
      province: province,
      city: city,
      district: district,
      street: street,
      streetNumber: streetNumber,
      cityCode: cityCode,
      adCode: adCode,
      address: address,
      description: description);

  Location copyWith(
          {String? locTime,
          int? locationType,
          String? latitude,
          String? longitude,
          double? accuracy,
          String? altitude,
          double? bearing,
          double? speed,
          String? country,
          String? province,
          String? city,
          String? district,
          String? street,
          String? streetNumber,
          String? cityCode,
          String? adCode,
          String? address,
          String? description}) =>
      Location(
        locTime: locTime ?? this.locTime,
        locationType: locationType ?? this.locationType,
        latitude: latitude ?? this.latitude,
        longitude: longitude ?? this.longitude,
        accuracy: accuracy ?? this.accuracy,
        altitude: altitude ?? this.altitude,
        bearing: bearing ?? this.bearing,
        speed: speed ?? this.speed,
        country: country ?? this.country,
        province: province ?? this.province,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Location &&
          locTime == other.locTime &&
          locationType == other.locationType &&
          latitude == other.latitude &&
          longitude == other.longitude &&
          accuracy == other.accuracy &&
          altitude == other.altitude &&
          bearing == other.bearing &&
          speed == other.speed &&
          country == other.country &&
          province == other.province &&
          city == other.city &&
          district == other.district &&
          street == other.street &&
          streetNumber == other.streetNumber &&
          cityCode == other.cityCode &&
          adCode == other.adCode &&
          address == other.address &&
          description == other.description;

  @override
  int get hashCode =>
      locTime.hashCode ^
      locationType.hashCode ^
      latitude.hashCode ^
      longitude.hashCode ^
      accuracy.hashCode ^
      altitude.hashCode ^
      bearing.hashCode ^
      speed.hashCode ^
      country.hashCode ^
      province.hashCode ^
      city.hashCode ^
      district.hashCode ^
      street.hashCode ^
      streetNumber.hashCode ^
      cityCode.hashCode ^
      adCode.hashCode ^
      address.hashCode ^
      description.hashCode;
}
