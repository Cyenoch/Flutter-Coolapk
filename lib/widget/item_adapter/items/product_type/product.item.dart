part of 'package:coolapk_flutter/widget/item_adapter/items/items.dart';

class ProductItem extends StatelessWidget {
  final Map<String, dynamic> source;

  const ProductItem({Key key, this.source}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        final String url = source[
            "url"]; // e.g. /product/[productId] => /v6/product/detail?id=[productId]
        final productId = url.replaceAll(r'/product/', "");
        Navigator.of(context).push(ScaleInRoute(
          widget: ProductPage(
            productId: productId,
          ),
        ));
      },
      title: Text(
        source["title"],
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        "${source["hot_num_txt"]}热度 ${source["feed_comment_num"]}讨论",
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      leading: FittedBox(
        fit: BoxFit.contain,
        child: ExtendedImage.network(
          source["logo"],
          filterQuality: FilterQuality.low,
          width: 54,
          height: 54,
          cache: true,
        ),
      ),
      trailing: Container(
        width: 115,
        alignment: Alignment.center,
        child: _buildTrailing(context),
      ),
    );
  }

  _buildTrailing(final BuildContext context) {
    if (source["star_average_score"] > 0) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "${source["star_average_score"]}",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          RatingBar.builder(
            initialRating: double.parse(
              source["star_average_score"].toString(),
            ),
            minRating: 0,
            maxRating: 10,
            itemCount: 5,
            tapOnlyMode: true,
            itemSize: 18,
            itemBuilder: (context, _) => Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {},
          )
        ],
      );
    }
    if ((source["release_time"] != null || source["release_time"].length > 0) &&
        source["release_status"] == 0) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            source["release_time"],
            style: TextStyle(
              backgroundColor: Theme.of(context).accentColor.withAlpha(50),
              color: Theme.of(context).accentColor,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          Text(
            "发布时间",
            style: TextStyle(
              color: Theme.of(context).accentColor,
            ),
          ),
        ],
      );
    }
    return const Text("暂无人评分");
  }
}
