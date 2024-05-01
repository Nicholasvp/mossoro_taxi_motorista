import 'package:firebase_database/firebase_database.dart';

class History {
  String pickup;
  String destination;
  String fares;
  String status;
  String? paymentMethod;
  String type;
  String createdAt;

  History({
    required this.pickup,
    required this.destination,
    required this.fares,
    required this.status,
    this.paymentMethod,
    required this.type,
    required this.createdAt,
  });

  static fromSnapshot(DataSnapshot snapshot) {
    var data = Map<String, dynamic>.from(snapshot.value as Map);
    return History(
      pickup: data['pickup_address'],
      destination: data['destination_address'],
      fares: data['fares'].toString(),
      createdAt: data['created_at'],
      status: data['status'],
      type: data['type'],
    );
  }
}
