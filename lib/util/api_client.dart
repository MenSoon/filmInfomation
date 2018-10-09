import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:filminfomation/model/SearchResult.dart';
import 'package:filminfomation/model/cast.dart';
import 'package:filminfomation/model/episode.dart';
import 'package:filminfomation/model/mediaitem.dart';
import 'package:filminfomation/model/tvseason.dart';
import 'package:filminfomation/util/constants.dart';

class ApiClient {
  final String baseUrl = "api.themoviedb.org";
  final _http = HttpClient();

  Future<dynamic> _getJson(Uri url) async {
    var response = await (await _http.getUrl(url)).close();
    var transformedResponse = await response.transform(utf8.decoder).join();
    return json.decode(transformedResponse);
  }

  Future<List<MediaItem>> getSimilarMedia(int mediaId,
      {String type: 'movie'}) async {
    var url = Uri.https(baseUrl, '3/$type/$mediaId/similar', {
      'api_key': API_KEY,
    });
    return _getJson(url).then((json) => json['results']).then((data) => data
        .map<MediaItem>((item) => MediaItem(
            item, (type == 'movie') ? MediaType.movie : MediaType.show))
        .toList());
  }

  Future<List<MediaItem>> getMoviesForActor(int actorId) async {
    var url = Uri.https(baseUrl, '3/discover/movie', {
      'api_key': API_KEY,
      'with_cast': actorId.toString(),
      'sort_by': 'popularity.desc'
    });
    return _getJson(url).then((json) => json['results']).then((data) => data
        .map<MediaItem>((item) => MediaItem(item, MediaType.movie))
        .toList());
  }

  Future<List<MediaItem>> getShowForActor(int actorId) async {
    var url = Uri.https(baseUrl, '3/person/$actorId/tv_credits', {
      'api_key': API_KEY,
    });
    return _getJson(url).then((json) => json['cast']).then((data) => data
        .map<MediaItem>((item) => MediaItem(item, MediaType.show))
        .toList());
  }

  Future<dynamic> getMediaDetials(int mediaId, {String type: "movie"}) async {
    var url = Uri.https(baseUrl, '3/$type/$mediaId', {'api_key': API_KEY});
    return _getJson(url);
  }

  Future<List<Actor>> getMediaCredits(int mediaId,
      {String type: "movie"}) async {
    var url =
        Uri.https(baseUrl, '3/$type/$mediaId/credits', {'api_key': API_KEY});
    return _getJson(url).then((json) =>
        json['cast'].map<Actor>((item) => Actor.fromJson(item)).toList());
  }

  Future<List<MediaItem>> fetchMovies(
      {int page: 1, String category: "popular"}) async {
    var url = Uri.https(baseUrl, '3/movie/$category',
        {'api_key': API_KEY, 'page': page.toString()});
    return _getJson(url)
        .then((json) => json['results'])
        .then((data) => data.map<MediaItem>((item) {
              //先获取 数据 取出要遍历的数据 解析
              return MediaItem(item, MediaType.movie);
            }).toList()); //简写遍历 要加上toList()
  }

  Future<List<MediaItem>> fetchShows(
      {int page: 1, String category: "popular"}) async {
    var url = Uri.https(baseUrl, '3/tv/$category',
        {'api_key': API_KEY, 'page': page.toString()});
    return _getJson(url).then((json) => json['results']).then((data) => data
        .map<MediaItem>((item) => MediaItem(item, MediaType.show))
        .toList());
  }

  Future<List<TvSeason>> getShowSeason(int showId) async {
    var detailJson = await getMediaDetials(showId, type: 'tv');
    return detailJson['seasons']
        .map<TvSeason>((item) => TvSeason.formMap(item))
        .toList();
  }

  Future<List<SearchResult>> getSearchResults(String query) {
    var url = Uri
        .https(baseUrl, '3/search/multi', {'api_key': API_KEY, 'query': query});
    return _getJson(url).then((json) => json['results']
        .map<SearchResult>((item) => SearchResult.fromJson(item))
        .toList());
  }

  Future<List<Episode>> fetchEpisodes(int showId, int seasonNumber) {
    var url = Uri.https(
        baseUrl, '3/tv/$showId/season/$seasonNumber', {'api_key': API_KEY});
    return _getJson(url).then((json) => json['episodes']).then(
        (data) => data.map<Episode>((item) => Episode.fromJson(item)).toList());
  }
}
