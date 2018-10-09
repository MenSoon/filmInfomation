import 'package:filminfomation/model/episode.dart';
import 'package:filminfomation/model/mediaitem.dart';
import 'package:filminfomation/model/tvseason.dart';
import 'package:filminfomation/util/api_client.dart';
import 'package:filminfomation/util/styles.dart';
import 'package:filminfomation/widgets/season_detial/episode_card.dart';
import 'package:flutter/material.dart';

class SeasonDetailScreen extends StatelessWidget {
  final MediaItem show;
  final TvSeason season;
  final ApiClient _apiClient = ApiClient();
  SeasonDetailScreen(this.show, this.season);
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: primary,
      body: CustomScrollView(
        slivers: <Widget>[
          _buildAppBar(),
          _buildEpisodesList(),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 300.0,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          alignment: AlignmentDirectional.bottomStart,
          children: <Widget>[
            Column(
              children: <Widget>[
                FadeInImage.assetNetwork(
                    fit: BoxFit.cover,
                    height: 230.0,
                    width: double.infinity,
                    placeholder: 'assets/placeholder.jpeg',
                    image: show.getBackDropUrl()),
                Expanded(
                    child: Container(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          show.title,
                          style: captionStyle,
                        ),
                        Container(
                          height: 4.0,
                        ),
                        Text(
                          '季 ${season.seasonNumber}',
                          style: whiteBody.copyWith(fontSize: 18.0),
                        ),
                        Container(
                          height: 4.0,
                        ),
                        Text(
                          '${season.getReleaseYear()}-${season
                                  .episodeCount} 情节',
                          style: captionStyle,
                        ),
                      ],
                    ),
                  ),
                  color: primaryDark,
                )),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Hero(
                tag: 'Season-tag-${season.id}',
                child: FadeInImage.assetNetwork(
                    width: 100.0,
                    placeholder: 'assets/placeholder.jpeg',
                    image: season.getPosterUrl()),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEpisodesList() {
    return SliverList(
        delegate: SliverChildListDelegate([
      FutureBuilder(
        builder: (BuildContext context, AsyncSnapshot<List<Episode>> snapsho) {
          return snapsho.connectionState != ConnectionState.done
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              : Column(
                  children: snapsho.data
                      .map((Episode episode) => EpisodeCard(episode))
                      .toList(),
                );
        },
        future: _apiClient.fetchEpisodes(show.id, season.seasonNumber),
      ),
    ]));
  }
}
