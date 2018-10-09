import 'dart:async';

import 'package:filminfomation/model/cast.dart';
import 'package:filminfomation/model/mediaitem.dart';
import 'package:filminfomation/util/api_client.dart';

abstract class MediaProvider {
  Future<List<MediaItem>> loadMedia(String category, {int page: 1});

  Future<List<Actor>> loadCast(int mediaId);

  Future<dynamic> getDetials(int mediaId);

  Future<List<MediaItem>> getSimilar(int mediaId);

}
class MovieProvider extends MediaProvider{
  MovieProvider();
  ApiClient _apiClien=ApiClient();
  @override
  Future getDetials(int mediaId) {
    // TODO: implement getDetials
    return _apiClien.getMediaDetials(mediaId,type: "movie");
  }

  @override
  Future<List<MediaItem>> getSimilar(int mediaId) {
    // TODO: implement getSimilar
      return _apiClien.getSimilarMedia(mediaId,type: 'movie');
  }
  @override
  Future<List<Actor>> loadCast(int mediaId) {
    // TODO: implement loadCast
    return _apiClien.getMediaCredits(mediaId,type: 'movie');
  }

  @override
  Future<List<MediaItem>> loadMedia(String category, {int page: 1}) {
    // TODO: implement loadMedia
    print('这是抽象化接口');
    return _apiClien.fetchMovies(category: category,page: page);
  }

}
class ShowProvider extends MediaProvider{
  ShowProvider();
  ApiClient _apiClien=ApiClient();
  @override
  Future getDetials(int mediaId) {
    // TODO: implement getDetials
    return _apiClien.getMediaDetials(mediaId,type: 'tv');
  }

  @override
  Future<List<MediaItem>> loadMedia(String category, {int page: 1}) {
    // TODO: implement loadMedia
    return _apiClien.fetchShows(page: page,category: category);
  }

  @override
  Future<List<Actor>> loadCast(int mediaId) {
    // TODO: implement loadCast
    return _apiClien.getMediaCredits(mediaId,type: 'tv');
  }

  @override
  Future<List<MediaItem>> getSimilar(int mediaId) {
    // TODO: implement getSimilar
    return _apiClien.getSimilarMedia(mediaId,type: 'tv');
  }

}
