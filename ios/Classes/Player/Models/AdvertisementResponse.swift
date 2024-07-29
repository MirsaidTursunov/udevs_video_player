//
//  AdvertisementResponse.swift
//  udevs_video_player
//
//  Created by Abdurahmon on 26/07/2024.
//

import Foundation

// MARK: - AdvertisementResponse
struct AdvertisementResponse: Decodable {
    let bannerImage: BannerImage?
    let skipDuration: Int?
    let id, link, video: String?

    enum CodingKeys: String, CodingKey {
        case bannerImage = "banner_image"
        case skipDuration = "skip_duration"
        case id, link, video
    }
    
    static func fromMap(map : [String:Any]?)-> AdvertisementResponse?{
        if(map == nil){
            return nil
        }
        let bannerImage = BannerImage.fromMap(map:  map?["banner_image"] as? [String :Any])
        let skipDuration = map?[ "skip_duration"] as? Int
        let id = map?["id"] as? String
        let link = map?["link"] as? String
        let video = map?["video"] as? String
        return AdvertisementResponse(bannerImage: bannerImage, skipDuration: skipDuration, id: id, link: link, video: video)
    }
}

// MARK: - BannerImage
struct BannerImage: Decodable {
    let mobileImage, tvImage, webImage: String?

    enum CodingKeys: String, CodingKey {
        case mobileImage = "mobile_image"
        case tvImage = "tv_image"
        case webImage = "web_image"
    }
    
    static func fromMap(map : [String:Any]?)-> BannerImage?{
        if(map==nil) {return nil}
        let mobile = map?["mobile_image"] as? String
        let tv = map?["tv_image"] as? String
        let web = map?["web_image"] as? String
        return BannerImage(
        mobileImage: mobile, tvImage: tv, webImage: web)
    }
}

extension AdvertisementResponse {
    init(data: Data) throws {
        self = try newJSONDecoderAds().decode(AdvertisementResponse.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        bannerImage: BannerImage? = nil,
        skipDuration: Int? = nil,
        id: String? = nil,
        link: String? = nil,
        video: String? = nil
    ) -> AdvertisementResponse {
        return AdvertisementResponse(
            bannerImage: bannerImage ?? self.bannerImage,
            skipDuration: skipDuration ?? self.skipDuration,
            id: id ?? self.id,
            link: link ?? self.link,
            video: video ?? self.video
        )
    }

//    func jsonData() throws -> Data {
//        return try newJSONEncoderAds().encode(self)
//    }

//    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
//        return String(data: try self.jsonData(), encoding: encoding)
//    }
}

extension BannerImage {
    init(data: Data) throws {
        self = try newJSONDecoderAds().decode(BannerImage.self, from: data)
    }

    init(_ json: String, using encoding: String.Encoding = .utf8) throws {
        guard let data = json.data(using: encoding) else {
            throw NSError(domain: "JSONDecoding", code: 0, userInfo: nil)
        }
        try self.init(data: data)
    }

    init(fromURL url: URL) throws {
        try self.init(data: try Data(contentsOf: url))
    }

    func with(
        mobileImage: String? = nil,
        tvImage: String? = nil,
        webImage: String? = nil
    ) -> BannerImage {
        return BannerImage(
            mobileImage: mobileImage ?? self.mobileImage,
            tvImage: tvImage ?? self.tvImage,
            webImage: webImage ?? self.webImage
        )
    }

//    func jsonData() throws -> Data {
//        return try newJSONEncoderAds().encode(self)
//    }

//    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
//        return String(data: try self.jsonData(), encoding: encoding)
//    }
}

// MARK: - Helper functions for creating encoders and decoders
//
func newJSONDecoderAds() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoderAds() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}
