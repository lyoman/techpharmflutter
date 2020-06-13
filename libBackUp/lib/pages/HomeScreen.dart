import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:prueleo/tabs/pharmacies_list.dart';
// import 'package:prueleo/tabs/medicine_list.dart';
import 'package:prueleo/tabs/healthtips_list.dart';
import '../pharm/map_page.dart';

import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:prueleo/models/pharmacy_model.dart';

import 'package:prueleo/search/medicine.dart';
import 'package:prueleo/search/netwoklayer.dart';
import 'package:prueleo/search/medetail.dart';
import 'package:prueleo/search/list.dart';

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

  @override
  void initState() {
    super.initState();
    _searchQuery = new TextEditingController();
    fetchProduct(new http.Client()).then((String) {
      parseData(String);
    });
    controller = TabController(length: 3, vsync: this);
  }

  List<Product> allRecord;

  parseData(String responseBody) {
    final parsed = json.decode(responseBody).cast<Map<String, dynamic>>();
    setState(() {
      allRecord =
          parsed.map<Product>((json) => new Product.fromJson(json)).toList();
    });
    filteredRecored = new List<Product>();
    filteredRecored.addAll(allRecord);
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
    if (newQuery.length > 0) {
      Set<Product> set = Set.from(allRecord);
      set.forEach((element) => filterList(element, newQuery));
    }

    if (newQuery.isEmpty) {
      filteredRecored.addAll(allRecord);
    }

    setState(() {});
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
        // title: appBarTitle,
        // actions: <Widget>[
        //   new IconButton(icon: actionIcon,onPressed:(){
        //   setState(() {
        //     if ( this.actionIcon.icon == Icons.search){
        //     this.actionIcon = new Icon(Icons.close);
        //     this.appBarTitle = new TextField(
        //       style: new TextStyle(
        //         color: Colors.white,

        //       ),
        //       decoration: new InputDecoration(
        //         prefixIcon: new Icon(Icons.search,color: Colors.white),
        //         hintText: "Search...",
        //         hintStyle: new TextStyle(color: Colors.white)
        //       ),
        //     );}
        //     else {
        //       this.actionIcon = new Icon(Icons.search);
        //       this.appBarTitle = new Text("Pharmacy Locator");
        //     }


        //   });
        // } ,),],
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
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
              'Side menu',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            decoration: BoxDecoration(
                color: Colors.green,
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage('assets/images/prueleo1.png'))),
          ),

          Container(
              decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/3.png" ),
                // fit: BoxFit.cover,
                fit: BoxFit.fill,
                
                repeat: ImageRepeat.repeatY,
              ),
            ),
            child: Column(
              children: <Widget>[
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

                ListTile(
                  leading: Icon(Icons.help, color: Colors.deepPurpleAccent),
                  title: Text('Help'),
                  onTap: () => {Navigator.of(context).pop()},
                ),
              ],
                          
            )
          ),
        ],
      ),
    ),

      body: TabBarView(
        controller: controller,
        children: <Widget>[

          filteredRecored != null && filteredRecored.length > 0
          ? new CountyList(product: filteredRecored)
          : allRecord == null
              ? new Center(child: new CircularProgressIndicator())
              : new Center(
                  child: new Text("No recored match!"),
                ),
          // MedicinePage(title: 'Medicine List'),
          // CountyList(product: filteredRecored),
          PHomePage(title: 'Pharmacies List'),
          HealthtipPage(title: 'Healthtips List'),

          
        ]),


        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Add your onPressed code here!
            Navigator.push(context, 
              new MaterialPageRoute(builder: (context) => HomePage(this.pharmacies))
            );
          },
          child: Icon(Icons.location_on),
          // child: Icon(Icons.map),
          backgroundColor: Colors.deepPurpleAccent,
        ),
    );
  }
}