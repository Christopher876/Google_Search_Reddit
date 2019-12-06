import 'package:http/http.dart' as http;
import 'package:beautifulsoup/beautifulsoup.dart';
import 'package:reddit_google_search/Globals.dart';
import 'package:reddit_google_search/Result.dart';

class DDGSearch{
  List<Result> _parseResults(http.Response response){
    Beautifulsoup soup = Beautifulsoup(response.body);
    var entries = soup.find_all("h2").map((e) => e.getElementsByClassName("result__title")).toList();
    for(var entry in entries){
      try{
        String title = entry[0].getElementsByTagName("a")[0].innerHtml;
        String url = entry[0].getElementsByTagName("a")[0].attributes["href"].replaceFirst("/l/?kh=-1&uddg=", "").replaceAll("%3A", ":").replaceAll("%2F", "/");
        Globals.results.add(new Result(title,url));
      }catch(e){
        continue;
      }
    }
    return Globals.results;
  }

  Future<List<Result>> search(String term) async {
    final response =
        await http.get('https://www.duckduckgo.com/html/q=pixel+4+site%3Areddit.com');
    if (response.statusCode == 200) {
      //Get the first page
      _parseResults(response);
      print(response.body);
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }

    final response2 = await http.get('https://www.google.com/search?q=reddit%3A'+term+"&start=10");
    if (response2.statusCode == 200) {
      //Get the first page
      _parseResults(response2);
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }

    Globals.loading = false;
    return Globals.results;
  }
}