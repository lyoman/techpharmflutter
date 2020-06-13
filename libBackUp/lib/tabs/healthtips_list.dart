import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../pharm/healthtip_detail.dart';

class HealthtipPage extends StatefulWidget {
  HealthtipPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<HealthtipPage> {

  //   String formatDateTime(DateTime dateTime) {
  //   return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  // }

  Future<List<Category>> _getCategories() async {

    var data = await http.get("http://techpharm.pythonanywhere.com/api/healthtips/categories");

    var jsonData = json.decode(data.body);
    print(jsonData);

    List<Category> users = [];

    for(var u in jsonData){

      Category user = Category( u["id"], 
                                u["icon"], 
                                u["name"], 
                                u["timestamp"],
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
          future: _getCategories(),
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
                              leading: Icon(Icons.settings, color: Colors.deepPurpleAccent,),
                              title: Text(snapshot.data[index].name, 
                                      style: TextStyle(color: Colors.deepPurpleAccent)
                                      ),
                              // subtitle: Text('Last edited on ${formatDateTime(snapshot.data[index].timestamp)}'),
                              trailing: Icon(Icons.arrow_forward, color: Colors.deepPurpleAccent,),

                              onTap: () {
                                Navigator.push(context, 
                                  new MaterialPageRoute(builder: (context) => HealthTipScreen(snapshot.data[index]))
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


class Category {
  final int id;
  final String icon;
  final String name;
  final String timestamp;

  Category(this.id, this.icon, this.name, this.timestamp);

}