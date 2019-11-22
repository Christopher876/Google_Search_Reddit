import 'package:http/http.dart' as http;
import 'package:beautifulsoup/beautifulsoup.dart';
import 'package:reddit_google_search/Result.dart';

List<Result> _parseResults(http.Response response){
  List<Result> results = new List(); 
  Beautifulsoup soup = Beautifulsoup(response.body);
  var entries = soup.find_all("div").map((e) => e.getElementsByClassName("kCrYT")).toList();
  for (var entry in entries) {
    try{
      if(entry.length == 2){
        for(int i = 0; i < entry.length;i++){
          String title = entry[i].getElementsByTagName("a")[0].getElementsByClassName("BNeawe vvjwJb AP7Wnd")[0].innerHtml;
          String url = entry[i].getElementsByTagName("a")[0].attributes["href"].replaceFirst("/url?q=", "");

          if(results.length != 0){
            if(title != results[results.length - 1].title){
              results.add(new Result(title,url));
            }
          }else{
            results.add(new Result(title,url));
          }
        }
      }
      else{
        continue;
      }
    }catch (e){

    }
    
  }
  for (var result in results) {
    print(result.title);
    print(result.url);
    print("-------------------------------");
  }
}

//Convert search term to a term that google will understand i.e. Not " " but instead +
String _convert_search_term(String term){
  if(term.contains(" "))
    term = term.replaceAll(" ", "+");
  return term;
}

Future<http.Response> search(String term) async {
  String search_term = _convert_search_term(term); 
  final response =
      await http.get('https://www.google.com/search?q=reddit%3A'+term);
  if (response.statusCode == 200) {
    // If server returns an OK response, parse the JSON.
    _parseResults(response);

  } else {
    // If that response was not OK, throw an error.
    throw Exception('Failed to load post');
  }
}