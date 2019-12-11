import 'package:reddit_google_search/Result.dart';

enum SearchEngine{google,ddg}
class Globals{
  static List<Result> results = new List();
  static bool loading = false; 
  static SearchEngine searchEngine = SearchEngine.ddg;
}