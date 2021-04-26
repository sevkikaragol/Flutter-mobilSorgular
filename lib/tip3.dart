import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cupertino_date_textbox/cupertino_date_textbox.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobil_sorgular/tip3_harita.dart';
import 'models/trip.dart';
import 'dart:async';
import 'models/zone.dart';

class Tip3 extends StatefulWidget {
  @override
  _Tip3State createState() => _Tip3State();
}

class _Tip3State extends State<Tip3> {
  final db = Firestore.instance;

  double _originLatitude, _originLongitude, _destLatitude, _destLongitude;
  String zone1, zone2;

  var koordinatOrigin;
  var koordinatDest;

  Future<List<Trip>> veriGetir() async {
    //alanAdiGetir();

    QuerySnapshot snapshot = await db
        .collection("yellowtrip")
        .where("tpep_pickup_datetime", isEqualTo: tarihCevir(_selectedDateTime))
        .orderBy("trip_distance", descending: true)
        .limit(1)
        .getDocuments();

    List<Trip> yolculuklar = snapshot.documents.map((doc) {
      return Trip.dokumandanOlustur(doc);
    }).toList();
    await Future.delayed(Duration(seconds: 3));
    koordinatOrigin = await koordinatGetir(yolculuklar[0].pul);
    koordinatDest = await koordinatGetir(yolculuklar[0].dol);
    _originLatitude = koordinatOrigin[0];
    _originLongitude = koordinatOrigin[1];
    zone1 = koordinatOrigin[2];
    _destLatitude = koordinatDest[0];
    _destLongitude = koordinatDest[1];
    zone2 = koordinatDest[2];

    return yolculuklar;
  }

  koordinatGetir(String locationId) async {
    var snapshot2 = await db
        .collection("zones")
        .where("LocationID", isEqualTo: int.parse(locationId))
        .getDocuments();

    List<Zone> alanlar2 = snapshot2.documents.map((doc) {
      return Zone.dokumandanOlustur(doc);
    }).toList();

    return [alanlar2[0].latitude, alanlar2[0].longtitude, alanlar2[0].zone];
  }

  DateTime _selectedDateTime =
      DateTime.fromMillisecondsSinceEpoch(1606780800000);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10.0,
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title: Text(
          "TIP 3 SORGU",
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
        children: [
          SizedBox(height: 6.0),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(5.0, 2.0, 5.0, 3.0),
              child: Material(
                color: Colors.orange.shade400,
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text('Kontrol etmek istediğiniz tarihi seçiniz.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        )),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 1.5),
                    ),
                    CupertinoDateTextBox(
                        initialValue: _selectedDateTime,
                        onDateChange: onDayChange,
                        hintText:
                            DateFormat.yMMMMd().format(_selectedDateTime)),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: FutureBuilder<List<Trip>>(
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
                                "->Tarih: " +
                                    tarihGonder(snapshot.data[pozisyon].put) +
                                    "\n" +
                                    "    Mesafe: " +
                                    snapshot.data[pozisyon].distance
                                        .toString() +
                                    " km",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                "    Başlangıç noktası:\n          ->" +
                                    zone1 +
                                    "\n"
                                        "    Bitiş noktası:\n          ->" +
                                    zone2 +
                                    "\n",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              trailing: Icon(Icons.more_vert),
                            ),
                          );
                        }));
              },
            ),
          ),
          ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.orange.shade300, // background
                onPrimary: Colors.black, // foreground
              ),
              onPressed: () async {
                await veriGetir();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => Harita(
                            _originLatitude,
                            _originLongitude,
                            _destLatitude,
                            _destLongitude)));
              },
              child: Text("Haritada göster!")),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }

  void onDayChange(DateTime day) {
    setState(() {
      _selectedDateTime = day;
    });
  }

  String tarihGonder(var timeInMillis) {
    var date = DateTime.fromMillisecondsSinceEpoch(timeInMillis * 1000);
    var formattedDate = DateFormat.yMMMMd('tr').format(date).toString();
    print(formattedDate);

    return formattedDate;
  }

  int tarihCevir(DateTime x) {
    int tarih = x.millisecondsSinceEpoch;
    print(tarih.toString());
    // ignore: division_optimization
    return ((tarih / 1000) + 75600)
        .toInt(); //+75600 Lokal zamana göre dengelemek için eklenmiştir.
  }
}
