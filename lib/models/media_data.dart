// ignore_for_file: public_member_api_docs, sort_constructors_first
class MediaData {
  final String title;
  final String url;
  MediaData({
    required this.title,
    required this.url,
  });

  factory MediaData.fromJson(Map<String, dynamic> json) {
    return MediaData(
        title: json['title'] as String,
        url: json['url'] as String
    );
  }

  Map<dynamic, dynamic> toJson() {
    return {'title': title, 'url': url};
  }

}
