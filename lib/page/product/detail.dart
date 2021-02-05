import 'package:carousel_slider/carousel_slider.dart';
import 'package:coolapk_flutter/util/image_url_size_parse.dart';
import 'package:coolapk_flutter/widget/item_adapter/items/items.dart';
import 'package:coolapk_flutter/widget/primary_button.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ProductDetail extends StatelessWidget {
  final dynamic detail;
  const ProductDetail({Key key, this.detail}) : super(key: key);

  dynamic get _detail => detail;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(shrinkWrap: true, slivers: <Widget>[
      SliverToBoxAdapter(
        child: _buildCover(),
      ),
      SliverPadding(
        padding: const EdgeInsets.all(16).copyWith(bottom: 0),
        sliver: SliverToBoxAdapter(
          child: Container(
            height: 66,
            alignment: Alignment.center,
            child: Row(
              children: <Widget>[
                ExtendedImage.network(
                  _detail["logo"] + ".xs.jpg",
                  cache: true,
                  width: 58,
                  height: 58,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(4),
                ),
                const VerticalDivider(color: Colors.transparent),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Text(
                        _detail["title"],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      Text(
                        "${_detail["hot_num_txt"]}热度 ${_detail["feed_comment_num"]}讨论",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      SliverPadding(
        padding: const EdgeInsets.all(16).copyWith(bottom: 0),
        sliver: SliverToBoxAdapter(
          child: Row(
            children: ((_detail["recent_follow_list"] as List<dynamic>)
                .map<Widget>((user) {
              return ExtendedImage.network(
                user["userAvatar"] + ".xs.jpg",
                cache: true,
                shape: BoxShape.circle,
                width: 24,
                height: 24,
              );
            }).toList())
              ..addAll([
                const VerticalDivider(color: Colors.transparent),
                Expanded(child: Text("${_detail["follow_num"]}关注>")),
                PrimaryButton(
                  text: "关注",
                  onPressed: () {
                    // TODO:
                  },
                ),
              ]),
          ),
        ),
      ),
      SliverToBoxAdapter(
        child: _buildRecommendContent(context),
      ),
      SliverToBoxAdapter(
        child: _buildCoolapkRating(context),
      ),
      (_detail["description"] ?? "").length == 0
          ? const SliverToBoxAdapter(child: SizedBox())
          : SliverPadding(
              padding: const EdgeInsets.all(16).copyWith(bottom: 0),
              sliver: SliverToBoxAdapter(
                child: Text(_detail["description"] ?? ""),
              ),
            ),
      SliverToBoxAdapter(
        child: _buildProductTag(context),
      ),
      SliverToBoxAdapter(
        child: _buildProductBranch(context),
      ),
      SliverToBoxAdapter(
        child: _buildCoolapkRatingDetail(context),
      ),
      SliverPadding(
        padding: const EdgeInsets.only(top: 16),
      ),
    ]);
  }

  Widget _buildRecommendContent(final BuildContext context) {
    if (detail["recommend_content"] == null ||
        detail["recommend_content"].length == 0) {
      return const SizedBox();
    }
    return MCard(
      padding: const EdgeInsets.all(0),
      child: InkWell(
        onTap: () {
          // TODO:
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: detail["recommend_content"].map<Widget>((entity) {
            if (entity["entityType"] != "headline") {
              return const SizedBox();
            }
            final url = entity["url"];
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: Text(
                    entity["entityTypeName"],
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontSize: 16,
                    ),
                  )),
                  IconButton(
                    padding: const EdgeInsets.all(0),
                    constraints: BoxConstraints(maxHeight: 30),
                    icon: Icon(
                      Icons.arrow_forward_ios,
                      size: 20,
                    ),
                    onPressed: null,
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildCover() {
    final covers = _detail["coverArr"];
    if (covers.length == 0) {
      return const SizedBox();
    }
    final height = getImageSizeFromUrl(covers[0]).height;
    return CarouselSlider.builder(
      itemCount: covers.length,
      options: CarouselOptions(
        viewportFraction: 1.0,
        autoPlay: false,
        height: height > 300 ? 300 : height,
      ),
      itemBuilder: (final context, final index, final realIndex) {
        return InkWell(
          child: ExtendedImage.network(
            covers[index] + ".s.jpg",
            fit: BoxFit.cover,
            width: double.infinity,
            cache: true,
          ),
        );
      },
    );
  }

  Widget _buildProductTag(final BuildContext context) {
    if ((_detail["tagArr"] ?? []).length == 0) return const SizedBox();
    return Padding(
      padding: const EdgeInsets.all(16).copyWith(bottom: 0),
      child: Wrap(
        spacing: 16,
        children: (_detail["tagArr"] as Iterable<dynamic>).map<Widget>((tag) {
          return Chip(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            backgroundColor: Theme.of(context).accentColor.withAlpha(40),
            label: Text(
              tag,
              style: TextStyle(
                color: Theme.of(context).accentColor,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildProductBranch(final BuildContext context) {
    if ((_detail["configRows"] ?? []).length == 0) {
      return const SizedBox();
    }
    return MCard(
      margin: const EdgeInsets.all(16).copyWith(bottom: 0),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            "版本配置",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          )
        ]..addAll((_detail["configRows"] as Iterable<dynamic>)
              .map<Widget>((config) {
            return Container(
              decoration: BoxDecoration(
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(8),
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              margin: const EdgeInsets.only(top: 16),
              child: ListTile(
                onTap: () {
                  // TODO:
                },
                title: Text(
                  config["title"],
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                trailing: SizedBox(
                  height: 24,
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: "￥${config["price"]}",
                      style: TextStyle(
                          color: Theme.of(context)
                              .textTheme
                              .bodyText1
                              .color
                              .withAlpha(100),
                          fontSize: 18),
                      children: [
                        WidgetSpan(
                            child: Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Icon(
                            Icons.arrow_forward_ios,
                            size: 22,
                          ),
                        )),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList()),
      ),
    );
  }

  Widget _buildCoolapkRatingDetail(final BuildContext context) {
    return MCard(
      margin: const EdgeInsets.all(16).copyWith(bottom: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            "酷安评分",
            style: TextStyle(
              color: Theme.of(context).accentColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      _detail["rating_average_score"].toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 38,
                      ),
                    ),
                    RatingBar.builder(
                      tapOnlyMode: true,
                      maxRating: 10,
                      minRating: 0,
                      initialRating: _detail["rating_average_score"].toDouble(),
                      onRatingUpdate: (value) {},
                      itemCount: 5,
                      itemSize: 18,
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                    ),
                    const Divider(
                      color: Colors.transparent,
                      height: 4,
                    ),
                    Text(
                      " ${_detail["rating_total_num"]}人点评",
                      style: TextStyle(
                        color: Theme.of(context)
                            .textTheme
                            .bodyText1
                            .color
                            .withAlpha(100),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: (<int>[1, 2, 3, 4, 5]).map<Widget>((e) {
                    final count = _detail["star_${e}_count"];
                    final total = _detail["star_total_count"];
                    return Row(
                      children: <Widget>[
                        Text("$e\星"),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                              left: 8.0,
                              right: 8.0,
                            ),
                            child: LinearProgressIndicator(
                              value: count / total,
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: (<int>[1, 2, 3, 4, 5]).map<Widget>((e) {
                  return Text(
                    _detail["star_${e}_count"].toString(),
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCoolapkRating(final BuildContext context) {
    return MCard(
      padding: const EdgeInsets.all(16).copyWith(bottom: 8),
      margin: const EdgeInsets.all(16).copyWith(bottom: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            "酷安评分",
            style: TextStyle(
              color: Theme.of(context).accentColor,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                _detail["rating_average_score"].toString(),
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 38),
              ),
              const VerticalDivider(color: Colors.transparent),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    RatingBar.builder(
                      tapOnlyMode: true,
                      maxRating: 10,
                      minRating: 0,
                      initialRating: _detail["rating_average_score"].toDouble(),
                      onRatingUpdate: (value) {},
                      itemCount: 5,
                      itemSize: 18,
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                    ),
                    Text(" ${_detail["rating_total_num"]}人点评")
                  ],
                ),
              ),
              PrimaryButton(
                text: "加我一个",
                onPressed: () {
                  // TODO:
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
