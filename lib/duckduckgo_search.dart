import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:beautifulsoup/beautifulsoup.dart';
import 'package:reddit_google_search/Globals.dart';
import 'package:reddit_google_search/Result.dart';

class DDGSearch{
  String _term; //search term
  int _page = 2; //The page that we are on

  List<Result> _parseResults(http.Response response){
    List<Result> results = new List();
    Beautifulsoup soup = Beautifulsoup(response.body);
    var entries = soup.find_all("h2").map((e)=> e.getElementsByClassName("result__a")).toList();
    for(var entry in entries){
      try{
        String title = entry[0].text;
        String url = entry[0].attributes["href"].replaceFirst("/l/?kh=-1&uddg=", "").replaceAll("%3A", ":").replaceAll("%2F", "/");
        results.add(new Result(title,url));
      }catch(e){
        print(e);
        continue;
      }
    }
    return results;
  }

  Future<List<Result>> search(String term) async {
    List<Result> results = new List();
    _term = term;
    final response =
        await http.get('https://www.duckduckgo.com/html/?q=$term+site%3Areddit.com');
    if (response.statusCode == 200) {
      //Get the first page
      results = _parseResults(response);
    } else {
      // If that response was not OK, throw an error.
      debugPrint(response.body.toString());
      throw Exception('Failed to load post');
    }
    Globals.loading = false;
    return results;
  }

  Future<List<Result>> searchNextPage() async { 
    final response =
        await http.get('https://duckduckgo.com/html/?q=$_term+site%3Areddit.com&s=${_page*30}&dc=${_page*30+1}&v=l&o=json&api=/d.js');
        _page++;
    if (response.statusCode == 200) {
      return _parseResults(response);
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
  }
}