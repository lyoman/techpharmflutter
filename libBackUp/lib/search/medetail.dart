import 'package:flutter/material.dart';
import 'package:prueleo/search/medicine.dart';


class MedDetail extends StatelessWidget {
  final Product user;

  MedDetail(this.user);

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