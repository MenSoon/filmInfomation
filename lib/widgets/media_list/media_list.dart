import 'package:filminfomation/model/mediaitem.dart';
import 'package:filminfomation/util/mediaproviders.dart';
import 'package:filminfomation/util/utils.dart';
import 'package:filminfomation/widgets/media_list/media_list_item.dart';
import 'package:flutter/material.dart';

class MediaList extends StatefulWidget {
  MediaList(this.provider, this.category, {Key key}) : super(key: key);
  final MediaProvider provider;
  final String category;

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MediaListState();
  }
}

class _MediaListState extends State<MediaList> {
  List<MediaItem> _movies = List();
  int _pageNumber = 1;
  LoadingState _loadingState=LoadingState.LOADING;
  _loadNextPage() async {
    try {

      var nextMovies =
          await widget.provider.loadMedia(widget.category, page: _pageNumber);
      setState(() {
        _loadingState=LoadingState.DONE;
        _movies.addAll(nextMovies);
        _pageNumber++;
      });
    } catch (e) {
      if(_loadingState == LoadingState.LOADING){
        setState(() {
          return _loadingState=LoadingState.ERROR;
        });
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadNextPage();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: _getContentSection(),
    );
  }

  Widget _getContentSection() {
    switch (_loadingState){
      case LoadingState.DONE:
        return ListView.builder(
            itemCount: _movies.length,
            itemBuilder: (BuildContext context, int index) {
              if (index > _movies.length * 0.7) {
                _loadNextPage();
              }
              return MediaListItem(_movies[index]);
            });
      case LoadingState.ERROR:
        return Text('数据加载失败');
      case LoadingState.LOADING:
        return CircularProgressIndicator();
      default:
        return Container();

    }

  }
}
