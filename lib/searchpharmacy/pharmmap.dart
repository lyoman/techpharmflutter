import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:prueleo/models/pharmacy_model.dart';
import 'dart:math' show cos, sqrt, asin;

class MapHomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();

}

class HomePageState extends State<MapHomePage> {
  Completer<GoogleMapController> _controller = Completer();

  final Set<Marker> _markers = {};

  getAllPharmacies() async{
    var data = await http.get("http://techpharm.pythonanywhere.com/api/pharmacies");

    var jsonData = json.decode(data.body)['results'];

    for(var m=0; m<=jsonData.length; m++){
      _markers.add(
        Marker(
                markerId: MarkerId(jsonData[m]["pharmacy_name"]),
                position: LatLng(double.parse(jsonData[m]["latitude"]), double.parse(jsonData[m]["longitude"])),
                infoWindow: InfoWindow(title: jsonData[m]["pharmacy_name"]),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueViolet,
                ),
              ),
      );
      // print(jsonData[m]);
      // return _markers;
    }
    
  }

  Future<List<User>> _getPharmacies() async {

    var data = await http.get("http://techpharm.pythonanywhere.com/api/pharmacies");

    var jsonData = json.decode(data.body)['results'];
    // print(jsonData);

    List<User> users = [];

    for(var u in jsonData){

      User user = User( u["id"], 
                        u["pharmacy_name"], 
                        u["city"], 
                        u["location"], 
                        u["pharmacy_logo"],
                        u["address"], 
                        u["latitude"], 
                        u["longitude"],
                      );

      users.add(user);
      // print(user);
      // marker.add(user);

    }


    // print(users.length);

    return users;

  }

  static LatLng _initialPosition;
  static double latitude, longitude;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  
    // mapMarkers();
      }

  void _getUserLocation() async {
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(position.latitude, position.longitude);
    setState(() {
      getAllPharmacies();
      latitude = position.latitude;
      longitude = position.longitude;
      _initialPosition = LatLng(position.latitude, position.longitude);
      print('${placemark[0].name}');
    });
    _markers.add(
        Marker(
                markerId: MarkerId("Current Position"),
                // position: LatLng(-17.781340, 31.057491),
                position: _initialPosition,
                infoWindow: InfoWindow(title: placemark[0].name + ", " + placemark[0].locality + ", " + placemark[0].country),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueRed,
                ),
              ),
      );
  }

  String calculateDistance(lat1, lon1, lat2, lon2){
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p)/2 + 
          c(lat1 * p) * c(lat2 * p) * 
          (1 - c((lon2 - lon1) * p))/2;
          var answer = 12742 * asin(sqrt(a));
    return answer.toStringAsFixed(2);
  }

  double zoomVal=15.0;
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
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: _initialPosition, zoom: zoomVal)));
  }
  Future<void> _plus(double zoomVal) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(target: _initialPosition, zoom: zoomVal)));
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
              // print((snapshot.data));
              return ListView.builder(

                  scrollDirection: Axis.horizontal,
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index){

                    SizedBox(width: 10.0);
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: _boxes(
                          snapshot.data[index].pharmacy_logo,
                            double.parse(snapshot.data[index].latitude), 
                            double.parse(snapshot.data[index].longitude),
                            snapshot.data[index].pharmacy_name,
                            snapshot.data[index].location,
                          ),
                    );
                      
                    }
                  );
            }else {
              return Center(child: CircularProgressIndicator());
            }
          },


        ),

      ),
    );
  }

  Widget _boxes(String _image, double lat,double long,String restaurantName, location) {
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
                            child: myDetailsContainer1(restaurantName, location, lat, long),
                          ),
                        ),

                      ],)
                ),
              ),
            ),
    );
  }

  Widget myDetailsContainer1(String restaurantName, location, lat, long) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Container(
              child: Text(restaurantName ?? '',
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
                            location ?? '' + " " + "("+
                            calculateDistance( 
                                latitude, longitude, lat ?? '', long ?? ''
                              ) + " km)",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
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
          return Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: GoogleMap(
                mapType: MapType.normal,
                initialCameraPosition:  CameraPosition(target: _initialPosition, zoom: 14),
                onMapCreated: (GoogleMapController controller) {
                  _controller.complete(controller);
                },
                markers: _markers,
              )
            );
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