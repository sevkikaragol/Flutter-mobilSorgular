import 'package:cloud_firestore/cloud_firestore.dart';

class Zone {
  final String id;
  final int locationID;
  final String zone;
  final double longtitude;
  final double latitude;

  Zone({this.id, this.locationID, this.zone, this.longtitude, this.latitude});

  factory Zone.dokumandanOlustur(DocumentSnapshot doc) {
    return Zone(
      id: doc.documentID,
      locationID: doc.data["LocationID"],
      zone: doc.data["zone"],
      longtitude: doc.data["longitude"],
      latitude: doc.data["latitude"],
    );
  }
}
