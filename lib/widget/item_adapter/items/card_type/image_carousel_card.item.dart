part of 'package:coolapk_flutter/widget/item_adapter/items/items.dart';

class ImageCarouselCard extends StatelessWidget {
  final Map<String, dynamic> source;
  const ImageCarouselCard({Key key, this.source}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (source["entities"][0]["pic"] == null) {
      return const SizedBox();
    }
    final double aspectRatio = getImageRatio(source["entities"][0]["pic"]);
    return MCard(
      padding: const EdgeInsets.all(0),
      child: CarouselSlider.builder(
        options: CarouselOptions(
          aspectRatio: aspectRatio <= 0.0 ? 1 : aspectRatio,
          viewportFraction: 1.0,
          autoPlay: true,
          enableInfiniteScroll: source["entities"].length > 1,
        ),
        itemCount: source["entities"].length,
        itemBuilder: (final context, final index, final realIndex) => InkWell(
          onTap: () {},
          child: ExtendedImage.network(
            source["entities"][index]["pic"],
            fit: BoxFit.cover,
            shape: BoxShape.rectangle,
            cache: true,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
