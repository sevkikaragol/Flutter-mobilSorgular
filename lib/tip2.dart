import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cupertino_date_textbox/cupertino_date_textbox.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobil_sorgular/models/zone.dart';
import 'package:mobil_sorgular/zones.dart';

import 'models/trip.dart';
import 'models/zone.dart';
import 'dart:async';

class Tip2 extends StatefulWidget {
  @override
  _Tip2State createState() => _Tip2State();
}

class _Tip2State extends State<Tip2> {
  static int x = 0;

  final db = Firestore.instance;
  Zones zones = Zones();
  String dropdownValue = "Newark Airport";

  Future<List<Trip>> veriGetir() async {
    alanAdiGetir();
    await Future.delayed(Duration(seconds: 1));

    QuerySnapshot snapshot = await db
        .collection("yellowtrip")
        .where("tpep_pickup_datetime",
            isGreaterThanOrEqualTo: tarihCevir(_selectedDateTime))
        .where("tpep_pickup_datetime",
            isLessThanOrEqualTo: tarihCevir(_selectedDateTime2))
        .where("PULocationID", isEqualTo: x.toString())
        .getDocuments();

    List<Trip> yolculuklar = snapshot.documents.map((doc) {
      return Trip.dokumandanOlustur(doc);
    }).toList();

    return yolculuklar;
  }

  Future<List<Zone>> alanAdiGetir() async {
    var snapshot2 = await db
        .collection("zones")
        .where("zone", isEqualTo: dropdownValue)
        .limit(1)
        .getDocuments();

    List<Zone> alanlar = snapshot2.documents.map((doc) {
      return Zone.dokumandanOlustur(doc);
    }).toList();

    x = alanlar[0].locationID;

    return alanlar;
  }

  DateTime _selectedDateTime =
      DateTime.fromMillisecondsSinceEpoch(1606780800000);
  DateTime _selectedDateTime2 =
      DateTime.fromMillisecondsSinceEpoch(1609459199000);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10.0,
        backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        title: Text(
          "TIP 2 SORGU",
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
        children: [
          SizedBox(height: 6.0),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(5.0, 2.0, 5.0, 3.0),
              child: Material(
                color: Colors.orange.shade400,
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text('Başlangıç tarihini seçiniz.',
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
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(5.0, 2.0, 5.0, 2.0),
              child: Material(
                color: Colors.orange.shade400,
                child: new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text('Bitiş tarihini seçiniz',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.0,
                          fontWeight: FontWeight.bold,
                        )),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 1.5),
                    ),
                    CupertinoDateTextBox(
                        initialValue: _selectedDateTime2,
                        onDateChange: onDayChange2,
                        hintText:
                            DateFormat.yMMMMd().format(_selectedDateTime2)),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: DropdownButton<String>(
              dropdownColor: Colors.orange.shade100,
              value: dropdownValue,
              elevation: 16,
              style: const TextStyle(color: Colors.black, fontSize: 18),
              underline: Container(
                height: 1,
                color: Colors.black,
              ),
              onChanged: (String newValue) {
                setState(() {
                  dropdownValue = newValue;
                });
              },
              items: zones.zonesString
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          Expanded(
            flex: 6,
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
                              leading: Text(
                                (pozisyon + 1).toString(),
                                style: TextStyle(
                                    fontSize: 45.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              title: Text(
                                "->Tarih: " +
                                    tarihGonder(snapshot.data[pozisyon].put),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                "    Mesafe: " +
                                    snapshot.data[pozisyon].distance
                                        .toString() +
                                    " km",
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

  void onDayChange2(DateTime day) {
    setState(() {
      _selectedDateTime2 = day;
    });
  }
}

String tarihGonder(var timeInMillis) {
  var date = DateTime.fromMillisecondsSinceEpoch(timeInMillis * 1000);
  var formattedDate = DateFormat.yMMMMd('tr').format(date).toString();
  return formattedDate;
}

int tarihCevir(DateTime x) {
  int tarih = x.millisecondsSinceEpoch;

  // ignore: division_optimization
  return ((tarih / 1000) + 75600)
      .toInt(); //-10800 + 86400 Lokal zamana göre dengelemek için eklenmiştir.
}
