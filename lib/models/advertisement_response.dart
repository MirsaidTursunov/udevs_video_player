class AdvertisementResponse {
  AdvertisementResponse({
    this.bannerImage,
    this.id,
    this.link,
    this.skipDuration,
    this.video,
  });

  AdvertisementResponse.fromJson(Map<String, dynamic> json) {
    bannerImage = json['banner_image'] != null
        ? BannerImage.fromJson(json['banner_image'])
        : null;
    id = json['id'];
    link = json['link'];
    skipDuration = json['skip_duration'];
    video = json['video'];
  }

  BannerImage? bannerImage;
  String? id;
  String? link;
  num? skipDuration;
  String? video;

  AdvertisementResponse copyWith({
    BannerImage? bannerImage,
    String? id,
    String? link,
    num? skipDuration,
    String? video,
  }) =>
      AdvertisementResponse(
        bannerImage: bannerImage ?? this.bannerImage,
        id: id ?? this.id,
        link: link ?? this.link,
        skipDuration: skipDuration ?? this.skipDuration,
        video: video ?? this.video,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (bannerImage != null) {
      map['banner_image'] = bannerImage?.toJson();
    }
    map['id'] = id;
    map['link'] = link;
    map['skip_duration'] = skipDuration;
    map['video'] = video;
    return map;
  }
}

class BannerImage {
  BannerImage({
    this.mobileImage,
    this.tvImage,
    this.webImage,
  });

  BannerImage.fromJson(Map<String, dynamic> json) {
    mobileImage = json['mobile_image'];
    tvImage = json['tv_image'];
    webImage = json['web_image'];
  }

  String? mobileImage;
  String? tvImage;
  String? webImage;

  BannerImage copyWith({
    String? mobileImage,
    String? tvImage,
    String? webImage,
  }) =>
      BannerImage(
        mobileImage: mobileImage ?? this.mobileImage,
        tvImage: tvImage ?? this.tvImage,
        webImage: webImage ?? this.webImage,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['mobile_image'] = mobileImage;
    map['tv_image'] = tvImage;
    map['web_image'] = webImage;
    return map;
  }
}
