//
//  StoryAnaliticsResponse.swift
//  udevs_video_player
//
//  Created by Bekzod Kuvondikov on 09/11/22.
//

import Foundation

struct StoryAnalyticResponse: Codable {
    let id: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
    }
}

// MARK: PremierStreamResponse convenience initializers and mutators

extension StoryAnalyticResponse {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(StoryAnalyticResponse.self, from: data)
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
        seconds: Int? = nil
    ) -> StoryAnalyticResponse {
        return StoryAnalyticResponse(
            id: self.id
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}

class StoryAnalysticRequest{
    let episodeKey: String
    let isStory: Bool
    let movieKey: String
    let seasonKey: String
    let userId: String
    let videoPlatform: String
    
    init(episodeKey: String, isStory: Bool, movieKey: String, seasonKey: String, userId: String, videoPlatform: String){
        self.episodeKey = episodeKey
        self.isStory = isStory
        self.movieKey = movieKey
        self.seasonKey = seasonKey
        self.userId = userId
        self.videoPlatform = videoPlatform
    }
    
    enum CodingKeys: String, CodingKey {
        case episodeKey = "episode_key"
        case isStory = "is_story"
        case movieKey = "movie_key"
        case seasonKey = "season_key"
        case userId = "user_id"
        case videoPlatform = "video_platform"
    }
    
    static func fromMap(map : [String:Any]) -> StoryAnalysticRequest{
        return StoryAnalysticRequest(episodeKey: map["episode_key"] as! String,
                                     isStory: map["is_story"] as! Bool,
                                 movieKey: map["movie_key"] as! String,
                                 seasonKey: map["season_key"] as! String,
                                     userId:map["user_id"] as! String,
                                     videoPlatform:map["video_platform"] as! String)
    }
    
    func fromJson() -> [String: Any]{
        return [
            "episode_key" : episodeKey,
            "is_story":isStory,
            "movie_key":movieKey,
            "season_key":seasonKey,
            "user_id":userId,
            "video_platform":videoPlatform]
    }
    
    func with(
        episodeKey: String? = nil,
        isStory: Bool? = nil,
        movieKey: String? = nil,
        seasonKey: String? = nil,
        userId: String? = nil,
        videoPlatform: String? = nil
    ) -> StoryAnalysticRequest {
        return StoryAnalysticRequest(
            episodeKey: episodeKey ?? self.episodeKey, isStory: isStory ?? self.isStory, movieKey: movieKey ?? self.movieKey, seasonKey: seasonKey ?? self.seasonKey, userId:userId ?? self.userId, videoPlatform: videoPlatform ?? self.videoPlatform
        )
    }
}
