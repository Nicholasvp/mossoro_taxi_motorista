import 'package:firebase_database/firebase_database.dart';

class Driver {
  String fullName;
  String email;
  String phone;
  String id;
  String vehicleType;
  String vehicleModel;
  String vehicleColor;
  String vehicleNumber;
  String? photoUrl;

  Driver({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.id,
    required this.vehicleType,
    required this.vehicleModel,
    required this.vehicleColor,
    required this.vehicleNumber,
    required this.photoUrl,
  });

  static fromSnapshot(DataSnapshot snapshot) {
    var data = Map<String, dynamic>.from(snapshot.value as Map);
    return Driver(
      id: snapshot.key!,
      phone: data['phone'],
      email: data['email'],
      fullName: data['fullname'],
      vehicleType: data['vehicle_details']['vehicle_type'],
      vehicleModel: data['vehicle_details']['vehicle_model'],
      vehicleColor: data['vehicle_details']['vehicle_color'],
      vehicleNumber: data['vehicle_details']['vehicle_number'],
      photoUrl: data['photoUrl'],
    );
  }
}
