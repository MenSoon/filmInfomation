
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

enum LoadingState { DONE, LOADING, WAITING, ERROR }

final dollarFormat = NumberFormat("#,##0.00", "en_US");
final sourceFormat = DateFormat('yyyy-MM-dd');
final dateFormat = DateFormat.yMMMMd("en_US");

final String _imageUrlMedium = "https://image.tmdb.org/t/p/w300/";
final String _imageUrlLarge = "https://image.tmdb.org/t/p/w500/";
Map<int, String> _genreMap = {
  //关键字获取
  28: 'Action',
  12: 'Adventure',
  16: 'Animation',
  35: 'Comedy',
  80: 'Crime',
  99: 'Documentary',
  18: 'Drama',
  10751: 'Family',
  10762: 'Kids',
  10759: 'Action & Adventure',
  14: 'Fantasy',
  36: 'History',
  27: 'Horror',
  10402: 'Music',
  9648: 'Mystery',
  10749: 'Romance',
  878: 'Science Fiction',
  10770: 'TV Movie',
  53: 'Thriller',
  10752: 'War',
  37: 'Western',
  10763: '',
  10764: 'Reality',
  10765: 'Sci-Fi & Fantasy',
  10766: 'Soap',
  10767: 'Talk',
  10768: 'War & Politics',
};

List<String> getGenresForIds(List<int> getreIds) =>
    getreIds.map((id) => _genreMap[id]).toList();

launchUrl(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  }
}

//流写数据
String getGenreString(List<int> genreIds) {
  StringBuffer buffer = StringBuffer();
  buffer.writeAll(getGenresForIds(genreIds), ',');
  return buffer.toString();
}

String formatRuntime(int runtime) {
  int hours = runtime ~/ 60;
  int minutes = runtime % 60;
  return '$hours\h $minutes\m';
}

String concatListToString(List<dynamic> data, String mapKey) {
  StringBuffer buffer = StringBuffer();
  buffer.writeAll(data.map<String>((map) => map[mapKey]).toList(), ',');
  return buffer.toString();
}
String formatDate(String date){
  try{
    return dateFormat.format(sourceFormat.parse(date));
  }catch(Exception){
    return "";
  }
}
String getImdbUrl(String imdbId)=>'http://www.imdb.com/title/$imdbId';
String formatSeasonsAndEpisodes(int numberOfSeasons, int numberOfEpisodes) =>
    '$numberOfSeasons Seasons and $numberOfEpisodes Episodes';



String getMediumPictureUrl(String path) => _imageUrlMedium + path;

String getLargePictureUrl(String path) => _imageUrlLarge + path;

String formatNumberToDollars(int amount)=>"\$${dollarFormat.format(amount)}";