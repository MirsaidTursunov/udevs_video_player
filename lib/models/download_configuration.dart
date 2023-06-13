class DownloadConfiguration {
  String title;
  String url;

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['title'] = title;
    map['url'] = url;
    return map;
  }

  @override
  String toString() {
    return 'DownloadConfiguration{title: $title, url: $url}';
  }

  DownloadConfiguration({
    this.title = '',
    required this.url,
  });
}
