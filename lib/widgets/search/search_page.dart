import 'package:filminfomation/model/SearchResult.dart';
import 'package:filminfomation/util/api_client.dart';
import 'package:filminfomation/util/utils.dart';
import 'package:filminfomation/widgets/search/search_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:rxdart/rxdart.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _SearchPageState();
  }
}

class _SearchPageState extends State<SearchScreen> {
  SearchBar searchBar;
  TextEditingController textEditingController = TextEditingController();
  LoadingState _currentState = LoadingState.WAITING;
  PublishSubject<String> querySubject = PublishSubject();
  ApiClient _apiClient = ApiClient();
  List<SearchResult> _resultList = List();

  _SearchPageState() {
    searchBar = SearchBar(
        controller: textEditingController,
        inBar: true,
        setState: setState,
        //
        onSubmitted: querySubject.add,
        buildDefaultAppBar: _buildAppBar);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    textEditingController.addListener(() {
      querySubject.add(textEditingController.text);
    });
    //引入rx编程
    querySubject.stream
        .where((query) => query.isNotEmpty)
        .debounce(Duration(milliseconds: 250))
        .distinct()
        .switchMap((query) =>
            Observable.fromFuture(_apiClient.getSearchResults(query)))
        .listen(_setResults);
  }

  void _setResults(List<SearchResult> results) {
    setState(() {
      _resultList = results;
      print('搜索结果$results');
      _currentState = LoadingState.DONE;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: searchBar.build(context),
      body: _buildContentSection(),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        '搜索',
      ),
      actions: <Widget>[searchBar.getSearchAction(context)],
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    querySubject.close(); //关闭rx编程
    textEditingController.dispose();
  }

  Widget _buildContentSection() {
    switch (_currentState) {
      case LoadingState.WAITING:
        return Center(
          child: Text('搜索电影，显示作者'),
        );
      case LoadingState.ERROR:
        return Center(
          child: Text('搜索出错了'),
        );
      case LoadingState.LOADING:
        return Center(
          child: CircularProgressIndicator(),
        );
      case LoadingState.DONE:
        return (_resultList == null || _resultList.length == 0)
            ? Center(
                child: Text('没有搜索结果'),
              )
            : ListView.builder(
                itemCount: _resultList.length,
                itemBuilder: (BuildContext context, int index) {
                  return SearchItemCard(_resultList[index]);
                });
      default:
        return Container();
    }
  }
}
