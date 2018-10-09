import 'dart:async';

import 'package:filminfomation/model/cast.dart';
import 'package:filminfomation/model/mediaitem.dart';
import 'package:filminfomation/util/api_client.dart';
import 'package:filminfomation/util/styles.dart';
import 'package:filminfomation/widgets/media_list/media_list_item.dart';
import 'package:filminfomation/widgets/utilviews/fitted_circle_avatar.dart';
import 'package:flutter/material.dart';

class ActorDetialScreen extends StatelessWidget {
  final Actor _actor;
  final ApiClient _apiClient = ApiClient();

  ActorDetialScreen(this._actor);

  @override
  Widget build(BuildContext context) {
    var movieFuture = _apiClient.getMoviesForActor(_actor.id);
    var showFuture = _apiClient.getShowForActor(_actor.id);

    // TODO: implement build
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: primary,
          body: NestedScrollView(
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return [_buildAppBar(context, _actor)];
              },
              body: TabBarView(children: [
                _buildMoviesSection(movieFuture),
                _buildMoviesSection(showFuture),
              ])),
        ));
  }

  Widget _buildAppBar(BuildContext context, Actor actor) {
    return SliverAppBar(
      expandedHeight: 240.0,
      bottom: TabBar(tabs: [
        Tab(
          icon: Icon(Icons.movie),
        ),
        Tab(
          icon: Icon(Icons.tv),
        ),
      ]),
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
            const Color(0xff2b5876),
            const Color(0xff4e4376),
          ])),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).padding.top,
              ),
              Hero(
                  tag: 'Cast-Hero${actor.id}',
                  child: Container(
                    width: 112.0,
                    height: 112.0,
                    child: FittedCircleAvatar(
                      backgroundImage: NetworkImage(actor.profilePictureUrl),
                    ),
                  )),
              Container(
                height: 8.0,
              ),
              Text(
                actor.name,
                style: whiteBody.copyWith(fontSize: 22.0),
              ),
              Container(
                height: 16.0,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMoviesSection(Future<List<MediaItem>> future) {
    return FutureBuilder(
      builder: (BuildContext context, AsyncSnapshot<List<MediaItem>> snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return MediaListItem(snapshot.data[index]);
                })
            : Padding(
                padding: const EdgeInsets.all(32.0),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
      },
      future: future,
    );
  }
}
