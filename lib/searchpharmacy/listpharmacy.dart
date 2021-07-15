import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:prueleo/searchpharmacy/pharmacy.dart';
import 'package:prueleo/searchpharmacy/pharmdetail.dart';
import 'dart:math' show cos, sqrt, asin;
// import 'package:geolocator/geolocator.dart';

class PharmacyList extends StatelessWidget {
  final List<Pharmacy> pharmacy;
  final double yolatitude, yolongitude;

  PharmacyList({Key key, this.pharmacy, this.yolatitude, this.yolongitude}) : super(key: key);

    String calculateDistance(lat1, lon1, lat2, lon2){
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p)/2 + 
          c(lat1 * p) * c(lat2 * p) * 
          (1 - c((lon2 - lon1) * p))/2;
          var answer = 12742 * asin(sqrt(a));
    return answer.toStringAsFixed(2);
  }

  // static double latitude, longitude;

  // void _getUserLocation() async {
  //   Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  //   List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(position.latitude, position.longitude);

  //     latitude = position.latitude;
  //     longitude = position.longitude;
  //     print(latitude);
  //     print(longitude);
  //     print(placemark[0].locality);
  //     print('${placemark[0].name}');
  // }

  @override
  Widget build(BuildContext context) {
    // _getUserLocation();
    return new ListView.builder(
        padding: EdgeInsets.all(8),
        itemCount: pharmacy == null ? 0 : pharmacy.length,
        itemBuilder: (BuildContext context, int index) {
          return
            new Card(
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white,
                          backgroundImage: NetworkImage(pharmacy[index].pharmacy_logo)),
                        title: Text(pharmacy[index].pharmacy_name ?? 'No Pharmacy Name'),
                        subtitle: Text( pharmacy[index].location ?? 'No Location found!' + ", " +
                                        pharmacy[index].address ?? 'No Address Found!' + ", " +
                                        pharmacy[index].city ?? 'No City Found!',
                                        overflow: TextOverflow.ellipsis,
                                      ),
                        trailing: (this.yolatitude != null && this.yolongitude != null) ? Text(calculateDistance( this.yolatitude, 
                                                          this.yolongitude, 
                                                          double.parse(pharmacy[index].latitude ?? ''), 
                                                          double.parse(pharmacy[index].longitude ?? '')
                                                          ) + " km") : Text("..km"),

                        onTap: () {
                          Navigator.push(context, 
                            new MaterialPageRoute(builder: (context) => PharmacyDetail(pharmacy[index], this.yolatitude, yolongitude))
                          );
                        },
                      )
                    ],
                  ),
                );
        });
  }
}
