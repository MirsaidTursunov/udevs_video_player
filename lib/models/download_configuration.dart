class DownloadConfiguration {

  DownloadConfiguration({
    this.title = '',
    required this.url,
  });
  String title;
  String url;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['title'] = title;
    map['url'] = url;
    return map;
  }

  @override
  String toString() => 'DownloadConfiguration{title: $title, url: $url}';
}
