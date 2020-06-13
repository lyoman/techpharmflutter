import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:prueleo/searchealthtips/healthtips.dart';
import 'package:prueleo/searchealthtips/tipdetail.dart';

class CategoryList extends StatelessWidget {
  final List<TipCategory> category;

  CategoryList({Key key, this.category}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
        padding: EdgeInsets.all(8),
        itemCount: category == null ? 0 : category.length,
        itemBuilder: (BuildContext context, int index) {
          return
            new Card(
                  child: Column(
                    children: <Widget>[
                      ListTile(
                              leading: Icon(Icons.settings, color: Colors.deepPurpleAccent,),
                              title: Text(category[index].name, 
                                      style: TextStyle(color: Colors.deepPurpleAccent)
                                      ),
                              // subtitle: Text('Last edited on ${formatDateTime(snapshot.data[index].timestamp)}'),
                              trailing: Icon(Icons.arrow_forward, color: Colors.deepPurpleAccent,),

                              onTap: () {
                                Navigator.push(context, 
                                  new MaterialPageRoute(builder: (context) => TipDetail(category[index]))
                                );
                              },
                            )
                    ],
                  ),
                );
        });
  }
}
