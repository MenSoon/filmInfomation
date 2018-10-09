import 'package:filminfomation/model/mediaitem.dart';
import 'package:filminfomation/model/tvseason.dart';
import 'package:filminfomation/util/navigator.dart';
import 'package:filminfomation/util/styles.dart';
import 'package:filminfomation/widgets/utilviews/bottom_gradient.dart';
import 'package:flutter/material.dart';

class SeasonCard extends StatelessWidget {
  final double height;
  final double width;
  final TvSeason tvSeason;
  final MediaItem show;

  SeasonCard(this.show, this.tvSeason, {this.height: 140.0, this.width: 100.0});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      onTap:()=> goToSeasonDetails(context, show, tvSeason),
      child: Container(
        height: height,
        width: width,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Hero(
              tag: 'Season-Hero-${tvSeason.id}',
              child: FadeInImage.assetNetwork(
                placeholder: 'assets/placeholder.jpeg',
                image: tvSeason.getPosterUrl(),
                fit: BoxFit.cover,
                height: height,
                width: width,
              ),
            ),
            BottomGradient.noOffset(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                //左下角
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    tvSeason.getFormattedTitle(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 10.0,
                    ),
                  ),
                  Container(
                    height: 4.0,
                  ),
                  Row(
                    children: <Widget>[
                      Expanded(
                          child: Icon(
                        Icons.confirmation_number,
                        color: salmon,
                        size: 10.0,
                      )),
                      Container(
                        width: 4.0,
                      ),
                      Expanded(
                        child: Text(
                          '${tvSeason.episodeCount} Episodes',
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 8.0),
                        ),
                        flex: 8,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
