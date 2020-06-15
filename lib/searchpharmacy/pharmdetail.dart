import 'package:flutter/material.dart';
import 'package:prueleo/searchpharmacy/pharmacy.dart';
import 'dart:math' show cos, sqrt, asin;


class PharmacyDetail extends StatelessWidget {
  final Pharmacy user;
  final double yolatitude, yolongitude;

  PharmacyDetail(this.user, this.yolatitude, this.yolongitude);

  String calculateDistance(lat1, lon1, lat2, lon2){
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p)/2 + 
          c(lat1 * p) * c(lat2 * p) * 
          (1 - c((lon2 - lon1) * p))/2;
          var answer = 12742 * asin(sqrt(a));
    return answer.toStringAsFixed(2);
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      
      appBar: AppBar(
        title: Text(user.pharmacy_name),
      ),
      // body: Padding(
      //   padding: EdgeInsets.all(16.0),
      //   child: Text(user.city),
        
      // ),

      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        padding: EdgeInsets.all(10.0),
        child:Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/bg.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              child: new FittedBox(
                child: Material(
                    color: Colors.white,
                    elevation: 14.0,
                    borderRadius: BorderRadius.circular(24.0),
                    shadowColor: Color(0x802196F3),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          width: 180,
                          height: 200,
                          child: ClipRRect(
                            borderRadius: new BorderRadius.circular(24.0),
                            child: Image(
                              fit: BoxFit.fill,
                              image: NetworkImage(user.pharmacy_logo),
                            ),
                          ),),
                          Container(
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: myDetailsContainer1(user.pharmacy_name, user.city, user.address, user.location, user.latitude, user.longitude),
                          ),
                        ),
                        Column(
                          children: <Widget>[
                            // Text("hello"),
                          ],
                        ),
                      ],)
                ),
              ),
  
            ),
          
      ),
    );

    //   body: Container(
    //     decoration: BoxDecoration(
    //       image: DecorationImage(
    //         image: AssetImage("assets/images/bg.jpg"),
    //         fit: BoxFit.cover,
    //       ),
    //     ),
    //     padding: EdgeInsets.all(16.0),
    //     child: Card(
    //             child: Column(
    //               children: <Widget>[
    //                 ListTile(
    //                   leading: Icon(Icons.settings, color: Colors.deepPurpleAccent,),
    //                   title: Text(user.pharmacy_name),
    //                   subtitle: Text(user.city),
    //                 ),
    //                 Text(user.address),
    //                 Text(this.yolatitude.toString()),
    //                 Text(this.yolongitude.toString()),
    //                 Text(user.location),
    //               ],
    //             ),
    //           ),
        
    //   ),
    // );
  }


    Widget myDetailsContainer1(String pharmacyName, city, address, location, pharmlatitude, pharmlongitude) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Container(
              child: Text(pharmacyName,
            style: TextStyle(
                color: Color(0xff6200ee),
                fontSize: 24.0,
                fontWeight: FontWeight.bold),
          )),
        ),
        SizedBox(height:5.0),
        Container(
                  child: Text(location,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 18.0,
                ),
              )),
        SizedBox(height:5.0),
        Container(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              SizedBox(height:5.0),
              Container(
                        child: Text(address,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 18.0,
                        // fontWeight: FontWeight.bold,
                      ),
                    )),
              Container(
                child: Text(", " + city,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 18.0,
                ),
              ),
              ),
            ],
          )
          ),

          SizedBox(height:5.0),
        Container(
            child: (this.yolatitude != null && this.yolongitude != null) ? Text(
          "Distance: " + calculateDistance(
                            this.yolatitude,this.yolongitude, 
                            double.parse(pharmlatitude), 
                            double.parse(pharmlongitude)
                          ) + " km",
          style: TextStyle(
              color: Colors.black54,
              fontSize: 18.0,
              fontWeight: FontWeight.bold),
        ) : Text("km"),),
          
        SizedBox(height:5.0),
        Container(
            child: Text(
          "Currently Open",
          style: TextStyle(
              color: Colors.black54,
              fontSize: 18.0,
              fontWeight: FontWeight.bold),
        )),
      ],
    );
  }
}