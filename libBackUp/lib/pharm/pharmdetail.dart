import 'package:flutter/material.dart';
import 'package:prueleo/models/pharmacy_model.dart';


class PharmDetailScreen extends StatelessWidget {
  final User user;

  PharmDetailScreen(this.user);

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
        padding: EdgeInsets.all(16.0),
        child: Card(
                child: Column(
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.settings, color: Colors.deepPurpleAccent,),
                      title: Text(user.pharmacy_name),
                      subtitle: Text(user.city),
                    ),
                    Text(user.address),
                    Text(user.latitude),
                    Text(user.longitude),
                    Text(user.location),
                  ],
                ),
              ),
        
      ),
    );
  }
}