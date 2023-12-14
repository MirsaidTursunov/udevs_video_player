//
//  MoreTvResponse.swift
//  udevs_video_player
//
//  Created by Mirsaid on 13/12/23.
//

import Foundation

// MARK: - MoreTvResponse
struct MoreTvResponse: Codable {
    let data: MoreTvDataClass
}

// MARK: MoreTvResponse convenience initializers and mutators

extension MoreTvResponse {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(MoreTvResponse.self, from: data)
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
        data: MoreTvDataClass? = nil
    ) -> MoreTvResponse {
        return MoreTvResponse(
            data: data ?? self.data
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

// MARK: - MoreTvDataClass
struct MoreTvDataClass: Codable {
    let ad_tag_url: String
    let audio: String
    let duration: Int
    let expire: Int
    let id: Int
    let mime_type: String
    let quality: String
    let url: String

    enum CodingKeys: String, CodingKey {
        case ad_tag_url
        case audio
        case duration
        case expire
        case id
        case mime_type
        case quality
        case url = "url"
    }
}

// MARK: MoreTvDataClass convenience initializers and mutators

extension MoreTvDataClass {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(MoreTvDataClass.self, from: data)
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
        ad_tag_url: String? = nil,
        audio: String? = nil,
        duration: Int? = nil,
        expire: Int? = nil,
        id: Int? = nil,
        mime_type: String? = nil,
        quality: String? = nil,
        url: String? = nil
    ) -> MoreTvDataClass {
        return MoreTvDataClass(
            ad_tag_url: ad_tag_url ?? self.ad_tag_url,
            audio: audio ?? self.audio,
            duration: duration ?? self.duration,
            expire: expire ?? self.expire,
            id: id ?? self.id,
            mime_type: mime_type ?? self.mime_type,
            quality: quality ?? self.quality,
            url: url ?? self.url
        )
    }

    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }

    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
