//
//  SessionActiveResponse.swift
//  udevs_video_player
//
//  Created by Sunnatillo Shavkatov on 13/12/22.
//

import Foundation

struct SessionActiveResponse: Codable {
    let sessionId: String
    let isWatched: String
    
    enum CodingKeys: String, CodingKey {
        case sessionId = "session_id"
        case isWatched = "is_watched"
    }
}

// MARK: PremierStreamResponse convenience initializers and mutators

extension SessionActiveResponse {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(SessionActiveResponse.self, from: data)
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
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}
