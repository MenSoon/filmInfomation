import 'package:filminfomation/model/episode.dart';
import 'package:filminfomation/util/styles.dart';
import 'package:filminfomation/util/utils.dart';
import 'package:flutter/material.dart';

class EpisodeCard extends StatelessWidget {
  final Episode episode;

  EpisodeCard(this.episode);

  @override
  Widget build(BuildContext context) {
    print('这里是什么地址${episode.stilUrl}');
    // TODO: implement build
    return Card(
      child: InkWell(
        onTap: () {},
        child: Column(
          children: <Widget>[
            FadeInImage.assetNetwork(
              fit: BoxFit.cover,
              height: 220.0,
              width: double.infinity,
              placeholder: 'assets/placeholder.jpeg',
              image: episode.stilUrl,
            ),
            ListTile(
              title: Text(episode.title),
              subtitle: Text(formatDate(episode.airDate)),
              leading: CircleAvatar(
                child: Text(episode.episodeNumber.toString()),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
              child: Text(
                episode.overview,
                style: captionStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
