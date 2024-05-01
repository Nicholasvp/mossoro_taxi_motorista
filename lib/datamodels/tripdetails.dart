import 'package:google_maps_flutter/google_maps_flutter.dart';

class TripDetails {
  String destinationAddress;
  String pickupAddress;
  LatLng pickup;
  LatLng destination;
  String rideID;
  String riderName;
  String riderPhone;
  String type;

  TripDetails({
    required this.pickupAddress,
    required this.rideID,
    required this.destinationAddress,
    required this.destination,
    required this.pickup,
    required this.riderName,
    required this.riderPhone,
    required this.type,
  });

  get paymentMethod => null;
}
