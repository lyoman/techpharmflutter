import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../pharm/pharmdetail.dart';
import 'package:prueleo/models/pharmacy_model.dart';

class PHomePage extends StatefulWidget {
  PHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<PHomePage> {

  Future<List<User>> _getUsers() async {

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
                                backgroundImage: NetworkImage(snapshot.data[index].pharmacy_logo)),
                              title: Text(snapshot.data[index].pharmacy_name),
                              subtitle: Text(snapshot.data[index].location),
                              trailing: Text(snapshot.data[index].city),

                              onTap: () {
                                Navigator.push(context, 
                                  new MaterialPageRoute(builder: (context) => PharmDetailScreen(snapshot.data[index]))
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

// class User {
//   final int id;
//   final String pharmacy_name;
//   final String city;
//   final String location;
//   final String pharmacy_logo;

//   User(this.id, this.pharmacy_name, this.city, this.location, this.pharmacy_logo);

// }