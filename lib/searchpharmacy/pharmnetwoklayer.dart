import 'dart:async';

import 'package:http/http.dart' as http;

Future<String> fetchPharmacy(http.Client client) async {
  final response = await client.get('http://techpharm.pythonanywhere.com/api/pharmacies');
  // Use the compute function to run parsePhotos in a separate isolate
  return response.body;
}
