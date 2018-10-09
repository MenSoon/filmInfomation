import 'package:filminfomation/model/cast.dart';
import 'package:filminfomation/model/mediaitem.dart';
import 'package:filminfomation/model/tvseason.dart';
import 'package:filminfomation/util/mediaproviders.dart';
import 'package:filminfomation/widgets/favorites/favorite_screen.dart';
import 'package:filminfomation/widgets/media_detial/actor_detial.dart';
import 'package:filminfomation/widgets/media_detial/media_detial.dart';
import 'package:filminfomation/widgets/search/search_page.dart';
import 'package:filminfomation/widgets/season_detial/season_detail_screen.dart';
import 'package:flutter/material.dart';

goToMovieDetials(BuildContext context, MediaItem move) {
  MediaProvider provider =
      (move.type == MediaType.movie) ? MovieProvider() : ShowProvider();
  _pushWidgetWithFade(context, MediaDetialScreen(move, provider));
}

goToSeasonDetails(BuildContext context, MediaItem show, TvSeason season) =>
    _pushWidgetWithFade(context, SeasonDetailScreen(show, season));

goToActorDetials(BuildContext context, Actor actor) {
  _pushWidgetWithFade(context, ActorDetialScreen(actor));
}
goToSearch(BuildContext context){
  _pushWidgetWithFade(context, SearchScreen());
}
goToFavorites(BuildContext context){
_pushWidgetWithFade(context, FavoriteScreen());
}
_pushWidgetWithFade(BuildContext context, Widget widget) {
  Navigator.of(context).push(PageRouteBuilder(
      transitionsBuilder: (context, animation, secondaryAnimation, child) =>
          FadeTransition(
            opacity: animation,
            child: child,
          ),
      pageBuilder: (BuildContext context, Animation animation,
          Animation secondaryAnimation) {
        return widget;
      }));
}
