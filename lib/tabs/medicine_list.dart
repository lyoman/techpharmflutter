import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../pharm/medicine_detail.dart';

class MedicinePage extends StatefulWidget {
  MedicinePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MedicinePage> {

  // @override
  // void initState() {
  //   super.initState();
  //   _getUsers();
  // }

  Future<List<Medicine>> _getUsers() async {

    var data = await http.get("http://techpharm.pythonanywhere.com/api/medicine");

    var jsonData = json.decode(data.body);
    print(jsonData);

    List<Medicine> users = [];

    for(var u in jsonData){

      Medicine user = Medicine( u["id"], 
                        u["product_name"], 
                        u["productprice"], 
                        u["pharmacy"]["pharmacy_name"], 
                        u["pharmacy"]["pharmacy_logo"],
                        u["pharmacy"]["id"],
                        u["pharmacy"]["city"],
                        u["pharmacy"]["location"],
                        u["pharmacy"]["address"],
                        u["pharmacy"]["latitude"],
                        u["pharmacy"]["longitude"],
                      );
      users.add(user);
      // print(u['pharmacy']['pharmacy_logo']);
    }

    print(users.length);

    return users;

  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg.jpg"),
            fit: BoxFit.cover,
          ),
        ),

        child: FutureBuilder(
          future: _getUsers(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if(snapshot.hasData){
              print((snapshot.data));
              return ListView.builder(
                  padding: EdgeInsets.all(8),
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index){
                    return
                      Card(
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              leading: CircleAvatar(
                                radius: 30,
                                backgroundColor: Colors.white,
                                backgroundImage: NetworkImage('http://techpharm.pythonanywhere.com/'+snapshot.data[index].pharmacy_logo)),
                              title: Text(snapshot.data[index].product_name + ",  \$ " + snapshot.data[index].productprice),
                              subtitle: Text( snapshot.data[index].pharmacy_name + ", " +
                                              snapshot.data[index].address,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                              trailing: Text('\$ ' + snapshot.data[index].productprice.toString()),

                              onTap: () {
                                Navigator.push(context, 
                                  new MaterialPageRoute(builder: (context) => MedDetailScreen(snapshot.data[index]))
                                );
                              },
                            )
                          ],
                        ),
                      );
                  });
            }else {
              return Center(child: CircularProgressIndicator());
            }
          },


        ),
      );
      
  }
}

class Medicine {
  final int id;
  final String product_name;
  final String productprice;
  final String pharmacy_name;
  final String pharmacy_logo;
  final int pharmacy_id;
  final String city;
  final String location;
  final String address;
  final String latitude;
  final String longitude;

  Medicine( this.id, 
        this.product_name, 
        this.productprice, 
        this.pharmacy_name, 
        this.pharmacy_logo,
        this.pharmacy_id,
        this.city,
        this.location,
        this.address,
        this.latitude,
        this.longitude,
      );

}