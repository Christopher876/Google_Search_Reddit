import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:beautifulsoup/beautifulsoup.dart';

Future<http.Response> search() async {
  final response =
      await http.get('https://www.google.com/search?q=reddit%3Aunity');
  return response;
  if (response.statusCode == 200) {
    // If server returns an OK response, parse the JSON.

  } else {
    // If that response was not OK, throw an error.
    throw Exception('Failed to load post');
  }
}

Future<void> testSearch() async{
  var test = await search();
  print(test.body);
}