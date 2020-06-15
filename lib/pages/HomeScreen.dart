import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
// import '../pharm/map_page.dart';

import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:prueleo/models/pharmacy_model.dart';

import 'package:prueleo/search/medicine.dart';
import 'package:prueleo/searchpharmacy/pharmacy.dart';
import 'package:prueleo/searchealthtips/healthtips.dart';
import 'package:prueleo/search/netwoklayer.dart';
import 'package:prueleo/searchpharmacy/pharmnetwoklayer.dart';
import 'package:prueleo/searchealthtips/tipnetwoklayer.dart';
import 'package:prueleo/search/list.dart';
import 'package:prueleo/searchpharmacy/listpharmacy.dart';
import 'package:prueleo/searchealthtips/listtips.dart';

import 'package:prueleo/searchpharmacy/pharmmap.dart';
import 'package:geolocator/geolocator.dart';

// import 'package:prueleo/tabs/pharmacies_list.dart';
// import 'package:prueleo/tabs/healthtips_list.dart';
// import 'package:prueleo/search/medetail.dart';
// import 'package:prueleo/tabs/medicine_list.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {


  static final GlobalKey<ScaffoldState> scaffoldKey =
  new GlobalKey<ScaffoldState>();

  TextEditingController _searchQuery;
  bool _isSearching = false;

  List<Product> filteredRecored;
  List<Pharmacy> filteredPharmacy;
  List<TipCategory> filteredCategory;

  double latitude, longitude;
  // static LatLng _initialPosition;
  void _getUserLocation() async {
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemark = await Geolocator().placemarkFromCoordinates(position.latitude, position.longitude);
      this.latitude = position.latitude;
      this.longitude = position.longitude;
      print('${placemark[0].name}');
  }

  @override
  void initState() {
    super.initState();
    _getUserLocation();
    _searchQuery = new TextEditingController();
    fetchProduct(new http.Client()).then((String) {
      parseData(String);
    });
    fetchPharmacy(new http.Client()).then((String) {
      parsePharmData(String);
    });
    fetchCategory(new http.Client()).then((String) {
      parseTipData(String);
    });
    controller = TabController(length: 3, vsync: this);
  }

  List<Product> allRecord;
  List<Pharmacy> allPharmacies;
  List<TipCategory> allCategories;

  parseData(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    setState(() {
      allRecord =
          parsed.map<Product>((json) => new Product.fromJson(json)).toList();
    });
    filteredRecored = new List<Product>();
    filteredRecored.addAll(allRecord);
  }

  parsePharmData(String responseBody) {
    final parsed = json.decode(responseBody)['results'].cast<Map<String, dynamic>>();
    // print(parsed);
    setState(() {
      allPharmacies =
          parsed.map<Pharmacy>((json) => new Pharmacy.fromJson(json)).toList();
    });
    filteredPharmacy = new List<Pharmacy>();
    filteredPharmacy.addAll(allPharmacies);
  }

  parseTipData(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    // print(parsed);
    setState(() {
      allCategories =
          parsed.map<TipCategory>((json) => new TipCategory.fromJson(json)).toList();
    });
    filteredCategory = new List<TipCategory>();
    filteredCategory.addAll(allCategories);
  }

  void _startSearch() {

    ModalRoute.of(context)
        .addLocalHistoryEntry(new LocalHistoryEntry(onRemove: _stopSearching));

    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearching() {
    _clearSearchQuery();

    setState(() {
      _isSearching = false;
      filteredRecored.addAll(allRecord);
      filteredPharmacy.addAll(allPharmacies);
      filteredCategory.addAll(allCategories);
    });
  }

  void _clearSearchQuery() {
    setState(() {
      _searchQuery.clear();
      updateSearchQuery("Search query");
    });
  }

  Widget _buildTitle(BuildContext context) {
    var horizontalTitleAlignment =
        Platform.isIOS ? CrossAxisAlignment.center : CrossAxisAlignment.start;

    return new InkWell(
      onTap: () => scaffoldKey.currentState.openDrawer(),
      child: new Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: horizontalTitleAlignment,
          children: <Widget>[
            new Text('Pharmacy Locator',
            style: new TextStyle(color: Colors.white),),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    return new TextField(
      controller: _searchQuery,
      autofocus: true,
      decoration: const InputDecoration(
        hintText: 'Search...',
        border: InputBorder.none,
        hintStyle: const TextStyle(color: Colors.white30),
      ),
      style: const TextStyle(color: Colors.white, fontSize: 16.0),
      onChanged: updateSearchQuery,
    );
  }

  void updateSearchQuery(String newQuery) {
    filteredRecored.clear();
    filteredPharmacy.clear();
    filteredCategory.clear();
    if (newQuery.length > 0) {
      Set<Product> set = Set.from(allRecord);
      set.forEach((element) => filterList(element, newQuery));

      Set<Pharmacy> set1 = Set.from(allPharmacies);
      set1.forEach((pharmelement) => filterPharmacyList(pharmelement, newQuery));

      Set<TipCategory> set2 = Set.from(allCategories);
      set2.forEach((categoryelement) => filterCategoryList(categoryelement, newQuery));
    }

    if (newQuery.isEmpty) {
      filteredRecored.addAll(allRecord);
      filteredPharmacy.addAll(allPharmacies);
      filteredCategory.addAll(allCategories);
    }

    setState(() {});
  }

  filterCategoryList(TipCategory category, String searchQuery) {
    setState(() {
      if (category.name.toLowerCase().contains(searchQuery) ||
          category.name.contains(searchQuery)) {
        filteredCategory.add(category);
      }
    });
  }

  filterPharmacyList(Pharmacy pharmacy, String searchQuery) {
    setState(() {
      if (pharmacy.pharmacy_name.toLowerCase().contains(searchQuery) ||
          pharmacy.pharmacy_name.contains(searchQuery)) {
        filteredPharmacy.add(pharmacy);
      }
    });
  }

  filterList(Product country, String searchQuery) {
    setState(() {
      if (country.product_name.toLowerCase().contains(searchQuery) ||
          country.product_name.contains(searchQuery)) {
        filteredRecored.add(country);
      }
    });
  }

  List<Widget> _buildActions() {
    if (_isSearching) {
      return <Widget>[
        new IconButton(
          icon: const Icon(Icons.clear,color: Colors.white,),
          onPressed: () {
            if (_searchQuery == null || _searchQuery.text.isEmpty) {
              Navigator.pop(context);
              return;
            }
            _clearSearchQuery();
          },
        ),
      ];
    }

    return <Widget>[
      new IconButton(
        icon: const Icon(Icons.search,color: Colors.white,),
        onPressed: _startSearch,
      ),
    ];
  }


    // List<User> pharmacies = [];
    var pharmacies;

    Future<List<User>> _getPharmacies() async {


      var data = await http.get("http://techpharm.pythonanywhere.com/api/pharmacies");

      var jsonData = json.decode(data.body)['results'];
      print("Json Data line 25"+jsonData);
      this.pharmacies = jsonData;

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
        // this.pharmacies.add(user);

    }

      print(users.length);

      // this.pharmacies = users;

      return users;

    }
 
TabController controller;
 Widget appBarTitle = new Text("Pharmacy Locator");
Icon actionIcon = new Icon(Icons.search);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        leading: _isSearching ? new BackButton( color: Colors.white,) : null,
        title: _isSearching ? _buildSearchField() : _buildTitle(context),
        actions: _buildActions(),
        

        bottom: TabBar(
          controller: controller,
          tabs: <Widget>[
            Tab(text: 'Medicine'),
            Tab(text: 'Pharmacies'),
            Tab(text: 'Health Tips'),
          ],
        ),
      ),



      drawer: new Drawer(
       
      child: ListView(
        //  var size = MediaQuery.of(context).size;
        padding: EdgeInsets.zero,
        children: <Widget>[
          
          DrawerHeader(
            // child: Text(
            //   'Pharmacy Locator',
            //   style: TextStyle(color: Colors.indigoAccent, fontSize: 25, backgroundColor: Colors.white),
            // ),
            child: Stack(children: <Widget>[
                Positioned(
                    bottom: 12.0,
                    left: 16.0,
                    child: Text("Pharmacy Locator",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.w500))),
              ]),
            decoration: BoxDecoration(
                color: Colors.green,
                image: DecorationImage(
                    // fit: BoxFit.fill,
                    repeat: ImageRepeat.repeatX,
                    image: AssetImage('assets/images/3.png'))),
                    
          ),

                ListTile(
                  leading: Icon(Icons.home, color: Colors.deepPurpleAccent),
                  title: Text('Home'),
                  onTap: () => {},
                ),
                ListTile(
                  leading: Icon(Icons.verified_user, color: Colors.deepPurpleAccent),
                  title: Text('Pharmacies'),
                  onTap: () => {Navigator.of(context).pop()},
                ),
                ListTile(
                  leading: Icon(Icons.settings, color: Colors.deepPurpleAccent),
                  title: Text('Medicine'),
                  onTap: () => {Navigator.of(context).pop()},
                ),
                ListTile(
                  leading: Icon(Icons.info, color: Colors.deepPurpleAccent),
                  title: Text('Healthtips'),
                  onTap: () => {Navigator.of(context).pop()},
                ),
                ListTile(
                  leading: Icon(Icons.feedback, color: Colors.deepPurpleAccent),
                  title: Text('Feedback'),
                  onTap: () => {Navigator.of(context).pop()},
                ),

                ListTile(
                  leading: Icon(Icons.call, color: Colors.deepPurpleAccent),
                  title: Text('Contact Us'),
                  onTap: () => {Navigator.of(context).pop()},
                ),

                // _createDrawerItem(icon: Icons.face, text: 'Authors'),

                ListTile(
                  leading: Icon(Icons.help, color: Colors.deepPurpleAccent),
                  title: Text('Help'),
                  onTap: () => {Navigator.of(context).pop()},
                ),
              ],
                          
            )
          // ),
        // ],
      // ),
    ),

      body: TabBarView(
        controller: controller,
        children: <Widget>[

          filteredRecored != null && filteredRecored.length > 0
          ? new CountyList(product: filteredRecored, yolatitude: this.latitude, yolongitude: this.longitude,)
          : allRecord == null
              ? new Center(child: new CircularProgressIndicator())
              : new Center(
                  child: new Text("No recored match!"),
                ),
                
          filteredPharmacy != null && filteredPharmacy.length > 0
          ? new PharmacyList(pharmacy: filteredPharmacy, yolatitude: this.latitude, yolongitude: this.longitude,)
          : allPharmacies == null
              ? new Center(child: new CircularProgressIndicator())
              : new Center(
                  child: new Text("No recored match!"),
                ),

          // MedicinePage(title: 'Medicine List'),
          // CountyList(product: filteredRecored),
          // PHomePage(title: 'Pharmacies List'),
          // HealthtipPage(title: 'Healthtips List'),

          filteredCategory != null && filteredCategory.length > 0
          ? new CategoryList(category: filteredCategory)
          : allCategories == null
              ? new Center(child: new CircularProgressIndicator())
              : new Center(
                  child: new Text("Category not found!"),
                ),

          
        ]),


        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Add your onPressed code here!
            // print(filteredPharmacy);
            Navigator.push(context, 
              new MaterialPageRoute(builder: (context) => MapHomePage())
            );
          },
          child: Icon(Icons.location_on),
          // child: Icon(Icons.map),
          backgroundColor: Colors.deepPurpleAccent,
        ),
    );
  }

  // Widget _createDrawerItem(
  //     {IconData icon, String text, GestureTapCallback onTap}) {
  //   return ListTile(
  //     title: Row(
  //       children: <Widget>[
  //         Icon(icon, color: Colors.deepPurpleAccent,),
  //         Padding(
  //           padding: EdgeInsets.only(left: 8.0),
  //           child: Text(text),
  //         )
  //       ],
  //     ),
  //     onTap: onTap,
  //   );
  // }
}