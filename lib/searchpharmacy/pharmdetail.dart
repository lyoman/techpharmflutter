import 'package:flutter/material.dart';
import 'package:prueleo/searchpharmacy/pharmacy.dart';
import 'dart:math' show cos, sqrt, asin;

class PharmacyDetail extends StatelessWidget {
  final Pharmacy pharmacy;
  final double yolatitude, yolongitude;

  PharmacyDetail(this.pharmacy, this.yolatitude, this.yolongitude);

  String calculateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    var answer = 12742 * asin(sqrt(a));
    return answer.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(pharmacy.pharmacy_name ?? ''),
        ),
        body: Container(
          padding: EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/bg.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: ListView(
            children: [
              ClipRRect(
                borderRadius: new BorderRadius.circular(24.0),
                child: Image(
                  fit: BoxFit.fill,
                  image: NetworkImage(pharmacy.pharmacy_logo),
                ),
              ),
              myDetailsContainer1(pharmacy)
            ],
          ),
        ));
  }

  Widget myDetailsContainer1(Pharmacy product) {
    return Container(
        child: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Container(
              child: Text(
            product.pharmacy_name ?? '',
            style: TextStyle(
                color: Color(0xff6200ee),
                fontSize: 24.0,
                fontWeight: FontWeight.bold),
          )),
        ),
        SizedBox(
          height: 10.0,
        ),
        Text(
          product.location ?? 'No location',
          style: TextStyle(
            color: Colors.black54,
            fontSize: 18.0,
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        Text(
          product.address ?? 'No Address',
          style: TextStyle(
            color: Colors.black54,
            fontSize: 18.0,
            // fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 5.0),
        Container(
          child: (this.yolatitude != null && this.yolongitude != null)
              ? Text(
                  "Distance: " +
                      calculateDistance(
                          this.yolatitude,
                          this.yolongitude,
                          double.parse(product.latitude),
                          double.parse(product.longitude)) +
                      " km",
                  style: TextStyle(
                      color: Colors.black54,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold),
                )
              : Text("km"),
        ),
      ],
    ));
  }
}
