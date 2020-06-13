import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:prueleo/searchpharmacy/pharmacy.dart';
import 'package:prueleo/searchpharmacy/pharmdetail.dart';

class PharmacyList extends StatelessWidget {
  final List<Pharmacy> pharmacy;

  PharmacyList({Key key, this.pharmacy}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
        padding: EdgeInsets.all(8),
        itemCount: pharmacy == null ? 0 : pharmacy.length,
        itemBuilder: (BuildContext context, int index) {
          return
            new Card(
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        leading: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.white,
                          backgroundImage: NetworkImage(pharmacy[index].pharmacy_logo)),
                        title: Text(pharmacy[index].pharmacy_name),
                        subtitle: Text( pharmacy[index].location + ", " +
                                        pharmacy[index].address + ", " +
                                        pharmacy[index].city,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                        trailing: Text("4 km"),

                        onTap: () {
                          Navigator.push(context, 
                            new MaterialPageRoute(builder: (context) => PharmacyDetail(pharmacy[index]))
                          );
                        },
                      )
                    ],
                  ),
                );
        });
  }
}
