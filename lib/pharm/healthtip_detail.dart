import 'package:flutter/material.dart';
import '../tabs/healthtips_list.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';


class HealthTipScreen extends StatelessWidget {
  final Category user;

  HealthTipScreen(this.user);

    Future<List<User>> _getUsers() async {
    var id = user.id.toString();
    var data = await http.get("http://techpharm.pythonanywhere.com/api/healthtips?id=" + id);

    var jsonData = json.decode(data.body);
    print(jsonData);

    List<User> users = [];
    print(user.name);
    for(var u in jsonData){

      

      User user = User( u["id"], 
                        u["category"]["name"], 
                        u["name"], 
                        u["description"], 
                        u["category"]["icon"],
                      );

                      // if(user.name == u["category"]["name"]){
                      //   users.add(user);
                      // }

                      // else {
                      //   print(u["category"]["name"]);
                      //   users.add(user);
                      // }
              users.add(user);
    }

    print(users.length);

    return users;

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      
      appBar: AppBar(
        title: Text(user.name),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        padding: EdgeInsets.all(16.0),
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
                              leading: Text(index.toString()),
                              title: Text(snapshot.data[index].name, 
                                      style: TextStyle(color: Colors.deepPurpleAccent)
                                      ),
                              subtitle: Text(snapshot.data[index].description),
                              // trailing: Icon(Icons.arrow_forward, color: Colors.deepPurpleAccent,),

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
        
      )
    );
  }
}


class User {
  final int id;
  final String category;
  final String name;
  final String description;
  final String icon;

  User(this.id, this.category, this.name, this.description, this.icon);

}