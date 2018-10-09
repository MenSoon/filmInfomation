import 'package:filminfomation/util/utils.dart';
import 'package:flutter/material.dart';

class MetaSection extends StatelessWidget {
  final dynamic data;

  MetaSection(this.data);

  @override
  Widget build(BuildContext context) {
    print('获取到的影片信息$data');
    // TODO: implement build
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '关于',
          style: TextStyle(color: Colors.white),
        ),
        Container(
          height: 8.0,
        ),
        _getSectionOrContainer('原标题', 'original_title'),
        _getSectionOrContainer('原标题', 'original_name'),
        _getSectionOrContainer('状态', 'status'),
        _getSectionOrContainer('当前', 'runtime',
            formatterFunction: formatRuntime),
        _getCollectionSectionOrContainer('类型', 'genres', 'name'),
        _getCollectionSectionOrContainer('作者', 'created_by', 'name'),
        _getCollectionSectionOrContainer('网络', 'networks', 'name'),
        (data['number_of_seasons'] != null &&
                data['number_of_episodes'] != null)
            ? _getMetaInfoSection(
                'Seasons',
                formatSeasonsAndEpisodes(
                    data['number_of_seasons'], data['number_of_episodes']))
            : Container(),
        _getSectionOrContainer('首映', 'release_date',
            formatterFunction: formatDate),
        _getSectionOrContainer('首映', 'first_air_date',
            formatterFunction: formatDate),
        _getSectionOrContainer('最新/下一部', 'last_air_date',
            formatterFunction: formatDate),
        _getSectionOrContainer('预期', 'budget',
            formatterFunction: formatNumberToDollars),
        _getSectionOrContainer('收入', 'revenue',
            formatterFunction: formatNumberToDollars),
        _getSectionOrContainer('主页', 'homepage', isLink: true),
        _getSectionOrContainer('Imdb', 'imdb_id',
            formatterFunction: getImdbUrl, isLink: true),
      ],
    );
  }

  Widget _getSectionOrContainer(String title, String content,
      {dynamic formatterFunction, bool isLink: false}) {
    return data[content] == null
        ? Container()
        : _getMetaInfoSection(
            title,
            (formatterFunction != null
                ? formatterFunction(data[content])
                : data[content]),
            islink: isLink,
          );
  }

  Widget _getMetaInfoSection(String title, String content,
      {bool islink: false}) {
    if (content == null) return Container();
    var contentSection = Expanded(
        flex: 4,
        child: GestureDetector(
          onTap: () => islink ? launchUrl(content) : null,
          child: Text(
            content,
            style: TextStyle(
                color: islink ? Colors.blue : Colors.white, fontSize: 11.0),
          ),
        ));
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: <Widget>[
          Expanded(
              flex: 2,
              child: Text(
                '$title',
                style: TextStyle(color: Colors.grey, fontSize: 11.0),
              )),
          contentSection
        ],
      ),
    );
  }

  Widget _getCollectionSectionOrContainer(
      String title, String listKey, String mapKey) {
    return data[listKey] == null
        ? Container()
        : _getMetaInfoSection(title, concatListToString(data[listKey], mapKey));
  }
}
