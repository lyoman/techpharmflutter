import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:prueleo/search/medicine.dart';
import 'package:prueleo/search/medetail.dart';

class CountyList extends StatelessWidget {
  final List<Product> product;

  CountyList({Key key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
        padding: EdgeInsets.all(8),
        itemCount: product == null ? 0 : product.length,
        itemBuilder: (BuildContext context, int index) {
          return
            new Card(
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white,
                          backgroundImage: NetworkImage('http://techpharm.pythonanywhere.com/'+product[index].pharmacy_logo)),
                        title: Text(product[index].product_name + ",  \$ " + product[index].productprice),
                        subtitle: Text( product[index].pharmacy_name + ", " +
                                        product[index].address,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                        trailing: Text('\$ ' + product[index].productprice.toString()),

                        onTap: () {
                          Navigator.push(context, 
                            new MaterialPageRoute(builder: (context) => MedDetail(product[index]))
                          );
                        },
                      )
                    ],
                  ),
                );
                // new Card(

                //   child: new Container(
                //     child: new Center(
                //         child: new Column(
                //       // Stretch the cards in horizontal axis
                //       crossAxisAlignment: CrossAxisAlignment.stretch,
                //       children: <Widget>[

                //         new Text(
                //           // Read the name field value and set it in the Text widget
                //           product[index].product_name,
                //           // set some style to text
                //           style: new TextStyle(
                //               fontSize: 20.0, color: Colors.lightBlueAccent),
                //         ),
                //         new Text(
                //           // Read the name field value and set it in the Text widget
                //           "Capital:- " + product[index].city,
                //           // set some style to text
                //           style: new TextStyle(
                //               fontSize: 20.0, color: Colors.amber),
                //         ),
                //       ],
                //     )),
                //     padding: const EdgeInsets.all(15.0),
                //   ),
                // );

        });
  }
}
