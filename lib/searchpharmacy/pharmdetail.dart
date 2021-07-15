import 'package:flutter/material.dart';
import 'package:prueleo/searchpharmacy/pharmacy.dart';
import 'dart:math' show cos, sqrt, asin;
import 'package:url_launcher/url_launcher.dart';

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

  // const url ='https://www.google.com/maps/dir/?api=1&origin=43.7967876,-79.5331616&destination=43.5184049,-79.8473993&waypoints=43.1941283,-79.59179|43.7991083,-79.5339667|43.8387033,-79.3453417|43.836424,-79.3024487&travelmode=driving&dir_action=navigate';
  _launchURL(
      double origlatitude, origlongitude, destlatitude, destlongitude) async {
    var url =
        'https://www.google.com/maps/dir/?api=1&origin=$origlatitude,$origlongitude&destination=$destlatitude,$destlongitude&travelmode=driving';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
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
        const SizedBox(height: 30),
        RaisedButton(
          onPressed: () {
            _launchURL(
                this.yolatitude,
                this.yolongitude,
                double.parse(product.latitude),
                double.parse(product.longitude));
          },
          textColor: Colors.white,
          padding: const EdgeInsets.all(0.0),
          child: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: <Color>[
                  // Color(0xFF0D47A1),
                  Color(0xff6200ee),
                  Color(0xFF0D47A1),
                  Color(0xFF1976D2),
                  // Color(0xFF42A5F5),
                ],
              ),
            ),
            padding: const EdgeInsets.all(10.0),
            child:
                const Text('Start Navigation', style: TextStyle(fontSize: 20)),
          ),
        ),
      ],
    ));
  }
}
