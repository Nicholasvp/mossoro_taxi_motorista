import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:mossorotaximotorista/datamodels/driver.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

User? currentFirebaseUser;

final CameraPosition googlePlex = CameraPosition(
  target: LatLng(-5.1928075, -37.3446682),
  zoom: 14.4746,
);

String mapKey = 'AIzaSyCIcNV0Qwf_p3bvtxQv38RWAfqeX_a0bV4';

StreamSubscription<Position>? homeTabPositionStream;

StreamSubscription<Position>? ridePositionStream;

final assetsAudioPlayer = AssetsAudioPlayer();

Position? currentPosition;

DatabaseReference? rideRef;

Driver? currentDriverInfo;
