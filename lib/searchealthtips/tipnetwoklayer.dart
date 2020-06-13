import 'dart:async';

import 'package:http/http.dart' as http;

Future<String> fetchCategory(http.Client client) async {
  final response = await client.get('http://techpharm.pythonanywhere.com/api/healthtips/categories');
  // Use the compute function to run parsePhotos in a separate isolate
  return response.body;
}

Future<String> fetchTip(http.Client client, id) async {
  final response = await client.get("http://techpharm.pythonanywhere.com/api/healthtips?id=" + id);
  // Use the compute function to run parsePhotos in a separate isolate
  return response.body;
}
