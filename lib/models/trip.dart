import 'package:cloud_firestore/cloud_firestore.dart';

class Trip {
  final String id;
  final String dol;
  final String pul;
  final int dot;
  final int put;
  final double distance;

  Trip({this.id, this.dol, this.pul, this.dot, this.put, this.distance});

  factory Trip.dokumandanOlustur(DocumentSnapshot doc) {
    return Trip(
      id: doc.documentID,
      dol: doc.data["DOLocationID"],
      pul: doc.data["PULocationID"],
      dot: doc.data["tpep_dropoff_datetime"],
      put: doc.data["tpep_pickup_datetime"],
      distance: doc.data["trip_distance"],
    );
  }
}
