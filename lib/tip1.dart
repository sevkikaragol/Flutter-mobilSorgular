import 'package:flutter/material.dart';
import 'package:mobil_sorgular/models/trip.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class Tip1 extends StatelessWidget {
  final db = Firestore.instance;

  Future<List<Trip>> veriGetir() async {
    QuerySnapshot snapshot = await db
        .collection("yellowtrip")
        .orderBy("trip_distance", descending: true)
        .limit(5)
        .getDocuments();

    List<Trip> yolculuklar = snapshot.documents.map((doc) {
      return Trip.dokumandanOlustur(doc);
    }).toList();
    return yolculuklar;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10.0,
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title: Text(
          "EN UZUN MESAFELİ 5 YOLCULUK",
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: FutureBuilder<List<Trip>>(
        future: veriGetir(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context, pozisyon) {
                  return Card(
                    color: Colors.orange.shade400,
                    child: ListTile(
                      title: Text(
                        "->Tarih: " + tarihGonder(snapshot.data[pozisyon].put),
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        "    Mesafe: " +
                            snapshot.data[pozisyon].distance.toString() +
                            " km",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                }),
          );
        },
      ),
    );
  }
}

String tarihGonder(var timeInMillis) {
  var date = DateTime.fromMillisecondsSinceEpoch(timeInMillis * 1000);
  var formattedDate = DateFormat.yMMMMd('tr').format(date).toString();
  return formattedDate;
}
