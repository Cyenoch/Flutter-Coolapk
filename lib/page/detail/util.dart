part of 'feed_detail.page.dart';

void handleOnLinkTap(String url, final BuildContext context,
    {final Function onEmptyUrl}) {
  final surl = url;
  url = url
      .replaceAll(RegExp(r'https://'), "http://")
      .replaceAll("http://www.coolapk.com/u/", "/u/")
      .replaceAll("http://www.coolapk.com/feed/", "/feed/")
      .replaceAll("user=", "/u/")
      .replaceAll("/user/", "/u/");
  if (url.startsWith("pic=")) {
    ImageBox.push(context, urls: [url.split("=")[1]]);
  } else if (url.startsWith(RegExp(r'/u/'))) {
    var username = url.replaceAll(RegExp(r'/u/'), "");
    if (username is String) {
      // TODO:
    } else {
      UserSpacePage.entry(context, url.replaceAll(RegExp(r'/u/'), ""));
    }
  } else if (url.startsWith(RegExp(r'/feed/'))) {
    Navigator.push(
        context,
        ScaleInRoute(
            widget: FeedDetailPage(
          feedId: url.replaceAll(RegExp(r'/feed/'), ""),
        )));
  } else if (url.startsWith(RegExp(r'^/t/'))) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TopicDetailPage(
            tag: url
                .replaceAll("/t/", "")
                .replaceAll(RegExp(r'\?type=([0-9]*)'), "")),
      ),
    );
  } else {
    if ((url.isEmpty)) {
      onEmptyUrl?.call();
      return;
    }
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("链接内容:"),
          content: TextField(
            controller: TextEditingController(text: url),
            obscureText: false,
            autofocus: false,
            maxLines: 100,
            minLines: 1,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(
              isDense: true,
              filled: true,
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text("使用酷安打开"),
              onPressed: () => showQRCode(context, surl),
            ),
            FlatButton(
              child: Text("取消"),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }
}
