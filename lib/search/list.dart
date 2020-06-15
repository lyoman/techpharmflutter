import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:prueleo/search/medicine.dart';
import 'package:prueleo/search/medetail.dart';
import 'dart:math' show cos, sqrt, asin, sin, acos, pi;
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';

class CountyList extends StatelessWidget {
  final List<Product> product;
  final double yolatitude, yolongitude;
 

  CountyList({Key key, this.product, this.yolatitude, this.yolongitude}) : super(key: key);

  String calculateDistance(lat1, lon1, lat2, lon2){
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p)/2 + 
          c(lat1 * p) * c(lat2 * p) * 
          (1 - c((lon2 - lon1) * p))/2;
          var answer = 12742 * asin(sqrt(a));
    return answer.toStringAsFixed(2);
  }

  String distance(double lat1, double lon1, double lat2, double lon2) {
        double theta = lon1 - lon2;
        double dist = sin(deg2rad(lat1)) * sin(deg2rad(lat2)) +
        cos(deg2rad(lat1)) * cos(deg2rad(lat2)) * cos(deg2rad(theta));
        dist = acos(dist);
        dist = rad2deg(dist);
        dist = dist * 60 * 1.1515;
        dist = dist * 1.609344;

          return dist.toStringAsFixed(2);
        }

    double deg2rad(double deg) {
      return (deg * pi / 180.0);
    }

    double rad2deg(double rad) {
      return (rad * 180.0 / pi);
    }

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
        padding: EdgeInsets.all(8),
        itemCount: product == null ? 0 : product.length,
        itemBuilder: (BuildContext context, int index) {
          return
            new Card(
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white,
                          backgroundImage: NetworkImage('http://techpharm.pythonanywhere.com/'+product[index].pharmacy_logo)),
                        title: Text(product[index].product_name + ",  \$ " + product[index].productprice),
                        subtitle: Text( product[index].pharmacy_name + ", " +
                                        product[index].address,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                        // trailing: Text('\$ ' + product[index].productprice.toString()),
                        trailing: (this.yolatitude != null && this.yolongitude != null) ? Text(calculateDistance(this.yolatitude, 
                                                this.yolongitude, 
                                                double.parse(product[index].latitude), 
                                                double.parse(product[index].longitude)
                                                ) + " km"
                                                ) : Container(child: CircularProgressIndicator(value: 1.0,)),

                        onTap: () {
                          Navigator.push(context, 
                            new MaterialPageRoute(builder: (context) => MedDetail(product[index], this.yolatitude, this.yolongitude))
                          );
                        },
                      )
                    ],
                  ),
                );

        });
  }
}
