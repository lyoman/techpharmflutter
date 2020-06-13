import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';

// import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:prueleo/models/pharmacy_model.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();

  final User pharmacy;

  HomePage(this.pharmacy);

}

class HomePageState extends State<HomePage> {
  Completer<GoogleMapController> _controller = Completer();

  Future<List<User>> _getPharmacies() async {

    var data = await http.get("http://techpharm.pythonanywhere.com/api/pharmacies");

    var jsonData = json.decode(data.body)['results'];
    print(jsonData);

    List<User> users = [];

    for(var u in jsonData){

      User user = User( u["id"], 
                        u["pharmacy_name"], 
                        u["location"], 
                        u["city"], 
                        u["pharmacy_logo"],
                        u["address"], 
                        u["latitude"], 
                        u["longitude"],
                      );

      users.add(user);

    }

    print(users.length);

    return users;

  }

  static LatLng _initialPosition;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  void _getUserLocation() async {
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(position.latitude, position.longitude);
    setState(() {
      _initialPosition = LatLng(position.latitude, position.longitude);
      print('${placemark[0].name}');
    });
  }

  // @override
  // void initState() {
  //   super.initState();
  // }
    double zoomVal=5.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // leading: IconButton(
        //     icon: Icon(FontAwesomeIcons.arrowLeft),
        //     onPressed: () {
        //       //
        //     }),
       
        title: Text("Pharmacies Map"),
        actions: <Widget>[
          IconButton(
              icon: Icon(FontAwesomeIcons.search),
              onPressed: () {
                //
              }),
        ],
      ),
      body: Stack(
        children: <Widget>[
          _buildGoogleMap(context),
          _zoomminusfunction(),
          _zoomplusfunction(),
          _buildContainer(),
        ],
      ),
    );
  }

 Widget _zoomminusfunction() {

    return Align(
      alignment: Alignment.topLeft,
      child: IconButton(
            icon: Icon(FontAwesomeIcons.searchMinus,color:Color(0xff6200ee)),
            onPressed: () {
              zoomVal--;
             _minus( zoomVal);
            }),
    );
 }
 Widget _zoomplusfunction() {
   
    return Align(
      alignment: Alignment.topRight,
      child: IconButton(
            icon: Icon(FontAwesomeIcons.searchPlus,color:Color(0xff6200ee)),
            onPressed: () {
              zoomVal++;
              _plus(zoomVal);
            }),
    );
 }

 Future<void> _minus(double zoomVal) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(40.712776, -74.005974), zoom: zoomVal)));
  }
  Future<void> _plus(double zoomVal) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(40.712776, -74.005974), zoom: zoomVal)));
  }

  
  Widget _buildContainer() {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Container(

        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg.jpg"),
            fit: BoxFit.cover,
          ),
        ),

        margin: EdgeInsets.symmetric(vertical: 20.0),
        height: 150.0,

        child: FutureBuilder(
          future: _getPharmacies(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if(snapshot.hasData){
              print((snapshot.data));
              return ListView.builder(
                  // scrollDirection: Axis.horizontal,
                  // scrollDirection: Axis.horizontal,
                  // padding: EdgeInsets.all(8),
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index){
                    return
                      SizedBox(width: 10.0,
                      child: Padding(
                        // SizedBox(width: 10.0),
                        padding: const EdgeInsets.all(8.0),
                        child: _boxes(
                            snapshot.data[index].pharmacy_logo,
                            double.parse(snapshot.data[index].latitude), 
                            double.parse(snapshot.data[index].longitude),
                            snapshot.data[index].pharmacy_name,
                          ),
                      ),
                      );
                      
                    }
                  );
            }else {
              return Center(child: CircularProgressIndicator());
            }
          },


        ),
                    
        // child: ListView(
        //   scrollDirection: Axis.horizontal,
        //   children: <Widget>[
        //     // FutureBuilder(
        //     // future: _getPharmacies(),
        //     // builder: (BuildContext context, AsyncSnapshot snapshot) {
        //     // if(snapshot.hasData){
        //     //   print((snapshot.data));
        //     // }}),
        //     SizedBox(width: 10.0),
        //     Padding(
        //       padding: const EdgeInsets.all(8.0),
        //       child: _boxes(
        //           "https://lh5.googleusercontent.com/p/AF1QipO3VPL9m-b355xWeg4MXmOQTauFAEkavSluTtJU=w225-h160-k-no",
        //           40.738380, -73.988426,"Gramercy Tavern"),
        //     ),
        //     SizedBox(width: 10.0),
        //     Padding(
        //       padding: const EdgeInsets.all(8.0),
        //       child: _boxes(
        //           "https://lh5.googleusercontent.com/p/AF1QipMKRN-1zTYMUVPrH-CcKzfTo6Nai7wdL7D8PMkt=w340-h160-k-no",
        //           40.761421, -73.981667,"Le Bernardin"),
        //     ),
        //     SizedBox(width: 10.0),
        //     Padding(
        //       padding: const EdgeInsets.all(8.0),
        //       child: _boxes(
        //           "https://images.unsplash.com/photo-1504940892017-d23b9053d5d4?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60",
        //           40.732128, -73.999619,"Blue Hill"),
        //     ),
        //   ],
        // ),
      ),
    );
  }

  Widget _boxes(String _image, double lat,double long,String restaurantName) {
    return  GestureDetector(
        onTap: () {
          _gotoLocation(lat,long);
        },
        child:Container(
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
                              image: NetworkImage(_image),
                            ),
                          ),),
                          Container(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: myDetailsContainer1(restaurantName),
                          ),
                        ),

                      ],)
                ),
              ),
            ),
    );
  }

  Widget myDetailsContainer1(String restaurantName) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Container(
              child: Text(restaurantName,
            style: TextStyle(
                color: Color(0xff6200ee),
                fontSize: 24.0,
                fontWeight: FontWeight.bold),
          )),
        ),
        SizedBox(height:5.0),
        Container(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Container(
                  child: Text(
                "4.1",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 18.0,
                ),
              )),
              Container(
                child: Icon(
                  FontAwesomeIcons.solidStar,
                  color: Colors.amber,
                  size: 15.0,
                ),
              ),
              Container(
                child: Icon(
                  FontAwesomeIcons.solidStar,
                  color: Colors.amber,
                  size: 15.0,
                ),
              ),
              Container(
                child: Icon(
                  FontAwesomeIcons.solidStar,
                  color: Colors.amber,
                  size: 15.0,
                ),
              ),
              Container(
                child: Icon(
                  FontAwesomeIcons.solidStar,
                  color: Colors.amber,
                  size: 15.0,
                ),
              ),
              Container(
                child: Icon(
                  FontAwesomeIcons.solidStarHalf,
                  color: Colors.amber,
                  size: 15.0,
                ),
              ),
               Container(
                  child: Text(
                "(946)",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 18.0,
                ),
              )),
            ],
          )),
          SizedBox(height:5.0),
        Container(
                  child: Text(
                "American \u00B7 \u0024\u0024 \u00B7 1.6 mi",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 18.0,
                ),
              )),
              SizedBox(height:5.0),
        Container(
            child: Text(
          "Closed \u00B7 Opens 17:00 Thu",
          style: TextStyle(
              color: Colors.black54,
              fontSize: 18.0,
              fontWeight: FontWeight.bold),
        )),
      ],
    );
  }




  Widget _buildGoogleMap(BuildContext context) {

    print(_initialPosition);
      Marker prueleoMarker = Marker(
          markerId: MarkerId('PrueLeo'),
          // position: LatLng(-17.781340, 31.057491),
          position: _initialPosition,
          infoWindow: InfoWindow(title: 'PrueLeo Technologies'),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueViolet,
          ),
        );

        return FutureBuilder(
          future: _getPharmacies(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if(snapshot.hasData){
              print((snapshot.data));
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index){
                  return Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: GoogleMap(
                        mapType: MapType.normal,
                        initialCameraPosition:  CameraPosition(target: _initialPosition, zoom: 14),
                        onMapCreated: (GoogleMapController controller) {
                          _controller.complete(controller);
                        },
                        markers: {
                          prueleoMarker,
                          newyork1Marker,
                          newyork2Marker,
                          newyork3Marker,
                          gramercyMarker,
                          bernardinMarker,
                          blueMarker,

                          Marker(
                          markerId: MarkerId(snapshot.data[index].pharmacy_name),
                          // position: LatLng(-17.781340, 31.057491),
                          position: LatLng(double.parse(snapshot.data[index].latitude), double.parse(snapshot.data[index].longitude)),
                          infoWindow: InfoWindow(title: snapshot.data[index].pharmacy_name),
                          icon: BitmapDescriptor.defaultMarkerWithHue(
                            BitmapDescriptor.hueViolet,
                          ),
                        ),
                          
                        },
                      ),
                    );
                }
                  );
            }else {
              return Center(child: CircularProgressIndicator());
            }
          },


        );

    // return Container(
    //   height: MediaQuery.of(context).size.height,
    //   width: MediaQuery.of(context).size.width,
    //   child: GoogleMap(
    //     mapType: MapType.normal,
    //     initialCameraPosition:  CameraPosition(target: _initialPosition, zoom: 14),
    //     onMapCreated: (GoogleMapController controller) {
    //       _controller.complete(controller);
    //     },
    //     markers: {
    //       prueleoMarker,
    //       newyork1Marker,
    //       newyork2Marker,
    //       newyork3Marker,
    //       gramercyMarker,
    //       bernardinMarker,
    //       blueMarker,
          
    //     },
    //   ),
    // );
  }

  Future<void> _gotoLocation(double lat,double long) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: LatLng(lat, long), zoom: 15,tilt: 50.0,
      bearing: 45.0,)));
  }

  Marker gramercyMarker = Marker(
  markerId: MarkerId('gramercy'),
  position: LatLng(40.738380, -73.988426),
  infoWindow: InfoWindow(title: 'Gramercy Tavern'),
  icon: BitmapDescriptor.defaultMarkerWithHue(
    BitmapDescriptor.hueViolet,
  ),
);

}


Marker bernardinMarker = Marker(
  markerId: MarkerId('bernardin'),
  position: LatLng(40.761421, -73.981667),
  infoWindow: InfoWindow(title: 'Le Bernardin'),
  icon: BitmapDescriptor.defaultMarkerWithHue(
    BitmapDescriptor.hueViolet,
  ),
);
Marker blueMarker = Marker(
  markerId: MarkerId('bluehill'),
  position: LatLng(40.732128, -73.999619),
  infoWindow: InfoWindow(title: 'Blue Hill'),
  icon: BitmapDescriptor.defaultMarkerWithHue(
    BitmapDescriptor.hueViolet,
  ),
);
Marker newyork1Marker = Marker(
  markerId: MarkerId('newyork1'),
  position: LatLng(40.742451, -74.005959),
  infoWindow: InfoWindow(title: 'Los Tacos'),
  icon: BitmapDescriptor.defaultMarkerWithHue(
    BitmapDescriptor.hueViolet,
  ),
);
Marker newyork2Marker = Marker(
  markerId: MarkerId('newyork2'),
  position: LatLng(40.729640, -73.983510),
  infoWindow: InfoWindow(title: 'Tree Bistro'),
  icon: BitmapDescriptor.defaultMarkerWithHue(
    BitmapDescriptor.hueViolet,
  ),
);
Marker newyork3Marker = Marker(
  markerId: MarkerId('newyork3'),
  position: LatLng(40.719109, -74.000183),
  infoWindow: InfoWindow(title: 'Le Coucou'),
  icon: BitmapDescriptor.defaultMarkerWithHue(
    BitmapDescriptor.hueViolet,
  ),
);