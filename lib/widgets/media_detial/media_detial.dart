import 'dart:async';
import 'dart:math';

import 'package:filminfomation/model/cast.dart';
import 'package:filminfomation/model/mediaitem.dart';
import 'package:filminfomation/model/tvseason.dart';
import 'package:filminfomation/scoped_models/app_model.dart';
import 'package:filminfomation/util/api_client.dart';
import 'package:filminfomation/util/mediaproviders.dart';
import 'package:filminfomation/util/styles.dart';
import 'package:filminfomation/util/utils.dart';
import 'package:filminfomation/util/utilviews.dart';
import 'package:filminfomation/widgets/media_detial/cast_session.dart';
import 'package:filminfomation/widgets/media_detial/meta_section.dart';
import 'package:filminfomation/widgets/media_detial/season_section.dart';
import 'package:filminfomation/widgets/media_detial/similar_seaction.dart';
import 'package:filminfomation/widgets/utilviews/bottom_gradient.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class MediaDetialScreen extends StatefulWidget {
  final MediaItem _mediaItem;
  final MediaProvider provider;

  final ApiClient _apiclient = ApiClient();

  MediaDetialScreen(this._mediaItem, this.provider);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return MediaDetialScreentState();
  }
}

class MediaDetialScreentState extends State<MediaDetialScreen> {
  List<Actor> _actorList;
  List<MediaItem> _similarMedia;
  List<TvSeason> _seasonList;
  bool _visible = false;
  dynamic _mediaDetails;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadCast();
    _loadDetials();
    _loadSimilar();
    if (widget._mediaItem.type == MediaType.show) _loadSeasons();
    Timer(Duration(milliseconds: 400), () => setState(() => _visible = true));
  }

  void _loadSimilar() async {
    //异常捕获
    try {
      List<MediaItem> similar =
          await widget.provider.getSimilar(widget._mediaItem.id);
      setState(() {
        _similarMedia = similar;
      });
    } catch (e) {
      print("获取相关电影捕捉到异常");
    }
  }

  void _loadSeasons() async {
    try {
      dynamic detials =
          await widget._apiclient.getShowSeason(widget._mediaItem.id);
      setState(() {
        _seasonList = detials;
      });
    } catch (e) {}
  }

  void _loadDetials() async {
    try {
      dynamic detial = await widget.provider.getDetials(widget._mediaItem.id);
      setState(() => _mediaDetails = detial);
    } catch (e) {}
  }

  void _loadCast() async {
    try {
      List<Actor> cast = await widget.provider.loadCast(widget._mediaItem.id);
      setState(() => _actorList = cast);
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      backgroundColor: primary,
      body: CustomScrollView(
        slivers: <Widget>[
          _buildAppBar(widget._mediaItem),
          _buildContentSection(widget._mediaItem),
        ],
      ),
    );
  }

  Widget _buildAppBar(MediaItem movie) {
    return SliverAppBar(
      //透明
      expandedHeight: 240.0,
      pinned: true,
      actions: <Widget>[
        ScopedModelDescendant<AppModel>(
          builder: (context, child, AppModel model) {
            return IconButton(
                icon: Icon(model.isItemFavorites(widget._mediaItem)
                    ? Icons.favorite
                    : Icons.favorite_border),
                onPressed: () => model.toggleFavorites(widget._mediaItem));
          },
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        //可以伸缩的
        background: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Hero(
              tag: 'Movie-Tag-${widget._mediaItem.id}',
              child: FadeInImage.assetNetwork(
                  placeholder: "assets/placeholde"
                      "r.jpg",
                  image: widget._mediaItem.getBackDropUrl()),
            ),
            BottomGradient(),
            _buildMetaSection(movie),
          ],
        ),
      ),
    );
  }

  Widget _buildMetaSection(MediaItem mediaItem) {
    return AnimatedOpacity(
      opacity: _visible ? 1.0 : 0.0,
      duration: Duration(milliseconds: 500),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 6.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                TextBubble(
                  mediaItem.getReleaseYear().toString(),
                  backgroundColor: Color(0xffF47663),
                ),
                Container(
                  width: 8.0,
                ),
                TextBubble(
                  mediaItem.voteAverage.toString(),
                  backgroundColor: Color(0xffF47663),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                mediaItem.title,
                style: TextStyle(color: Color(0xFFEEEEEE), fontSize: 20.0),
              ),
            ),
            Row(
              children: getGenresForIds(mediaItem.genreIds)
                  .sublist(0, min(5, mediaItem.genreIds.length))
                  .map((genre) => Row(
                        children: <Widget>[
                          TextBubble(genre),
                          Container(
                            width: 8.0,
                          ),
                        ],
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContentSection(MediaItem media) {
    return SliverList(
      delegate: SliverChildListDelegate(<Widget>[
        Container(
          decoration: BoxDecoration(
            color: const Color(0xff222128),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                '概要',
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              Container(
                height: 8.0,
              ),
              Text(
                media.overview,
                style: TextStyle(color: Colors.white, fontSize: 12.0),
              ),
              Container(
                height: 8.0,
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: primary,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _actorList == null
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : CastSection(_actorList),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: primaryDark,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _mediaDetails == null
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : MetaSection(_mediaDetails),
          ),
        ),
        (widget._mediaItem.type == MediaType.show)
            ? Container(
                decoration: BoxDecoration(
                  color: primary,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _seasonList == null
                      ? Container()
                      : SeasonSection(widget._mediaItem, _seasonList),
                ),
              )
            : Container(),
        Container(
          decoration: BoxDecoration(
              color: (widget._mediaItem.type == MediaType.movie
                  ? primary
                  : primaryDark)),
          child: _similarMedia == null
              ? Container()
              : SimilarSection(_similarMedia),
        ),
      ]),
    );
  }
}
