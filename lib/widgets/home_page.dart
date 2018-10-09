import 'package:filminfomation/model/mediaitem.dart';
import 'package:filminfomation/util/mediaproviders.dart';
import 'package:filminfomation/util/navigator.dart';
import 'package:filminfomation/widgets/media_list/media_list.dart';
import 'package:filminfomation/widgets/utilviews/toggle_theme_widget.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  PageController _pageController;
  int _page = 0;
  MediaType mediaType = MediaType.movie;
  final MediaProvider movieProvider = MovieProvider();
  final ShowProvider showProvider = ShowProvider();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('哈哈 首页'),
        actions: <Widget>[
          ToggleThemeButton(),
          IconButton(
            icon: Icon(Icons.search),
            color: Colors.white,
            onPressed: () => goToSearch(context),
          )
        ],
      ),
      //侧边栏
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
              padding: const EdgeInsets.all(0.0), //外边距
              child: Container(
                child: Image.network(
                  'https://ss1.bdstatic.com/70cFvXSh_Q1YnxGkpoWK1HF6hhy/it/u=2024669388,469028839&fm=27&gp=0.jpg',
                  fit: BoxFit.fill,
                ),
                //基础容器
                //组件
                decoration: BoxDecoration(
                  //组件的装饰类 如何装饰组件
                  border: Border.all(color: Colors.redAccent, width: 3.0),
                  gradient: LinearGradient(colors: [
                    //线性的颜色渐变
                    const Color(0xff2b5876),
                    const Color(0xff4e4376)
                  ]),
                ), //渐变色
              ),
            ),
            ListTile(
              title: Text('搜索'),
              trailing: Icon(Icons.search),
              onTap: (){
                goToSearch(context);
              } ,
            ), //简单组合信息
            ListTile(
              title: Text('喜欢'),
              trailing: Icon(Icons.favorite),
              onTap: () {
                goToFavorites(context);
              },
            ),
            Divider(
              height: 5.0,
            ),
            ListTile(
              title: Text('电影'),
              selected: mediaType == MediaType.movie,
              trailing: Icon(Icons.movie),
              onTap: () {
                _changeMediaType(MediaType.movie);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              trailing: Icon(Icons.tv),
              selected: mediaType == MediaType.show,
              title: Text('电视'),
              onTap: () {
                _changeMediaType(MediaType.show);
                Navigator.of(context).pop();
              },
            ),
            Divider(
              height: 5.0,
            ),
          ],
        ),
      ),
      body: PageView(
        children: _getMediaList(),
        pageSnapping: true,
        controller: _pageController,
        onPageChanged: (int index) {
          //点击的处理  //为了便于直接使用
          setState(() {
            _page = index;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: _getNavigatorBarItems(),
        onTap: _navigationTapped,
        currentIndex: _page,
      ),
    );
  }

  void _changeMediaType(MediaType type) {
    if (mediaType != type) {
      setState(() {
        mediaType = type;
      });
    }
  }

  List<Widget> _getMediaList() {
    return (mediaType == MediaType.movie)
        ? <Widget>[
            MediaList(
              movieProvider,
              'popular',
              key: Key('movie-popular'),
            ),
            MediaList(
              movieProvider,
              'upcoming',
              key: Key('movies-upcoming'),
            ),
            MediaList(
              movieProvider,
              'top_rated',
              key: Key('movies-top_rated'),
            ),
          ]
        : [
            MediaList(
              showProvider,
              'popular',
              key: Key('show-popular'),
            ),
            MediaList(
              showProvider,
              'on_the_air',
              key: Key('show-on_the_air'),
            ),
            MediaList(
              showProvider,
              'top_rated',
              key: Key('show-top_rated'),
            ),
          ];
  }

  void _navigationTapped(int page) {
    _pageController.animateToPage(
        //页面切换动画
        page,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn);
  }

  List<BottomNavigationBarItem> _getNavigatorBarItems() {
    if (mediaType == MediaType.movie) {
      return [
        BottomNavigationBarItem(icon: Icon(Icons.thumb_up), title: Text('流行')),
        BottomNavigationBarItem(icon: Icon(Icons.update), title: Text('最新')),
        BottomNavigationBarItem(icon: Icon(Icons.star), title: Text('评分'))
      ];
    } else {
      return [
        BottomNavigationBarItem(icon: Icon(Icons.thumb_up), title: Text('流行')),
        BottomNavigationBarItem(icon: Icon(Icons.live_tv), title: Text('云')),
        BottomNavigationBarItem(icon: Icon(Icons.star), title: Text('评分')),
      ];
    }
  }
}
