import 'package:filminfomation/model/SearchResult.dart';
import 'package:filminfomation/util/styles.dart';
import 'package:flutter/material.dart';
import 'package:filminfomation/util/navigator.dart';

class SearchItemCard extends StatelessWidget {
  final SearchResult item;

  SearchItemCard(this.item);

  @override
  Widget build(BuildContext context) {
    print('搜索结果${item.title}');// TODO: implement build
    return Card(
      child: InkWell(
        onTap: ()=>_handleTap(context),
        child: Row(
          children: <Widget>[
            FadeInImage.assetNetwork(
              placeholder: 'assets/placeholder.jpeg',
              image: item.imageUrl,
              fit: BoxFit.cover,
              width: 100.0,
              height: 150.0,
            ),
            Container(
              width: 8.0,
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: primaryDark,
                    borderRadius: BorderRadius.all(Radius.circular(4.0)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      item.mediaType.toUpperCase(),
                      style: TextStyle(color: colorAccent),
                    ),
                  ),
                ),
                Container(
                  height: 4.0,
                ),
                Text(
                  item.title,
                  style: TextStyle(fontSize: 18.0),
                ),
                Container(
                  height: 4.0,
                ),
                Text(
                  item.subtitle,
                  style: captionStyle,
                ),
              ],
            )),
          ],
        ),
      ),
    );
  }

  _handleTap(BuildContext context) {
    switch (item.mediaType) {
      case 'movie':
        goToMovieDetials(context, item.asMovie);
        return;
      case 'tv':
        goToMovieDetials(context, item.asShow);
        return;
      case 'person':
        goToActorDetials(context, item.asActor);
        return;

    }
  }
}
