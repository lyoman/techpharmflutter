import 'package:flutter/material.dart';
import '../tabs/medicine_list.dart';


class MedDetailScreen extends StatelessWidget {
  final Medicine user;

  MedDetailScreen(this.user);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      
      appBar: AppBar(
        title: Text(user.pharmacy_name),
      ),

      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/bg.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        padding: EdgeInsets.all(16.0),
        child: Card(
                child: Row(
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.settings, color: Colors.deepPurpleAccent,),
                      title: Text(user.productprice),
                      subtitle: Text(user.product_name),
                    ),
                    Column(
                      children: <Widget>[
                        Row (
         
                        ),
                      ],
                    ),
                  ],
                  
                ),
              ),
        
      ),
    );
  }
}