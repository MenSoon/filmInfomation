import 'package:filminfomation/model/mediaitem.dart';
import 'package:filminfomation/util/navigator.dart';
import 'package:filminfomation/util/utils.dart';
import 'package:flutter/material.dart';

class MediaListItem extends StatelessWidget {
  final MediaItem movie;

  MediaListItem(this.movie);

  Widget _getTitleSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: <Widget>[
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Text(
                  movie.title,
                  style: Theme
                      .of(context)
                      .textTheme
                      .subhead
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  getGenreString(movie.genreIds),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.body1,
                ),
              ),
            ],
          )),
          Container(
            width: 12.0,
          ), //空白的填充
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    movie.voteAverage.toString(),
                    style: Theme.of(context).textTheme.body1,
                  ),
                  Container(
                    width: 4.0,
                  ),
                  Icon(
                    Icons.star,
                    size: 16.0,
                  )
                ],
              ),
              Container(
                height: 4.0,
              ),
              Row(
                children: <Widget>[
                  Text(
                    movie.getReleaseYear().toString(),
                    style: Theme.of(context).textTheme.body1,
                  ),
                  Container(
                    width: 4.0,
                  ),
                  Icon(
                    Icons.date_range,
                    size: 16.0,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      child: InkWell(
        onTap: (){
          goToMovieDetials(context, movie);
        },
        child: Column(
          children: <Widget>[
            Hero(
              tag: 'Movie-Tag-${movie.id}',
              child: FadeInImage.assetNetwork(
                placeholder: 'assets/placeholde'
                    'r.jpeg',
                image: movie.getBackDropUrl(),
                fit: BoxFit.cover,
                width: double.infinity,
                height: 200.0,
                fadeInDuration: Duration(milliseconds: 50),
              ),
            ),
            _getTitleSection(context),
          ],
        ),
      ),
    );
  }
}
