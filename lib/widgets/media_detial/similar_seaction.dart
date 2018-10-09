import 'package:filminfomation/model/mediaitem.dart';
import 'package:filminfomation/util/navigator.dart';
import 'package:flutter/material.dart';

class SimilarSection extends StatelessWidget {
  List<MediaItem> _similarMovies;

  SimilarSection(this._similarMovies);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(6.0),
          child: Text(
            '类似',
            style: TextStyle(color: Colors.white),
          ),
        ),
        Container(
          height: 300.0,
          child: GridView.count(
            //行数
            crossAxisCount: 2,
            //边距
            childAspectRatio: 1.5,
            //方向
            scrollDirection: Axis.horizontal,
            children: _similarMovies
                .map((MediaItem item) => GestureDetector(
                      //遍历
                      onTap: () {
                        goToMovieDetials(context, item);
                      },
                      child: FadeInImage.assetNetwork(
                        placeholder: 'assets/placeh'
                            'older.jpeg',
                        image: item.getPosterUrl(),
                        height: 150.0,
                        fit: BoxFit.cover,
                      ),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}
