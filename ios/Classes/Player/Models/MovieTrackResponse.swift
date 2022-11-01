//
//  MovieTrackResponse.swift
//  udevs_video_player
//
//  Created by Udevs on 31/10/22.
//

import Foundation

// MARK: - MovieTrackResponse
struct MovieTrackResponse: Codable {
    let seconds: Int
    
    enum CodingKeys: String, CodingKey {
        case seconds = "seconds"
    }
}

// MARK: PremierStreamResponse convenience initializers and mutators

extension MovieTrackResponse {
    init(data: Data) throws {
        self = try newJSONDecoder().decode(MovieTrackResponse.self, from: data)
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
    ) -> MovieTrackResponse {
        return MovieTrackResponse(
            seconds: seconds ?? self.seconds
        )
    }
    
    func jsonData() throws -> Data {
        return try newJSONEncoder().encode(self)
    }
    
    func jsonString(encoding: String.Encoding = .utf8) throws -> String? {
        return String(data: try self.jsonData(), encoding: encoding)
    }
}


class MovieTrackRequest{
    let episodeKey, element: String
    let isMegogo: Bool
    let movieKey: String
    let seasonKey: String
    let seconds: Int
    let userId: String
    
    init(episodeKey: String,isMegogo:Bool, movieKey:String, seasonKey:String, seconds : Int, userId: String, element: String) {
        self.episodeKey = episodeKey
        self.isMegogo = isMegogo
        self.movieKey = movieKey
        self.seasonKey = seasonKey
        self.seconds = seconds
        self.userId = userId
        self.element = element
    }
    enum CodingKeys: String, CodingKey {
        case episodeKey = "episode_key"
        case isMegogo = "is_megogo"
        case movieKey = "movie_key"
        case seaconKey = "seacon_key"
        case seconds = "seconds"
        case userId = "user_id"
        case element = "element"
    }
    
    static func fromMap(map : [String:Any]) -> MovieTrackRequest{
        return MovieTrackRequest(episodeKey: map["episode_key"] as! String,
                                 isMegogo: map["is_megogo"] as! Bool,
                                 movieKey: map["movie_key"] as! String,
                                 seasonKey: map["season_key"] as! String,
                                 seconds:map["seconds"] as! Int,
                                 userId:map["user_id"] as! String,
                                 element:map["element"] as! String)
    }
    
    func fromJson() -> [String: Any]{
        return [
            "element" : element,
            "episode_key" : episodeKey,
            "is_megogo":isMegogo,
            "movie_key":movieKey,
            "season_key":seasonKey,
            "seconds":seconds,
            "user_id":userId]
    }
    
    func with(
        seconds: Int? = nil,
        episodeKey: String? = nil,
        seasonKey: String? = nil,
        userId: String? = nil,
        movieKey: String? = nil,
        isMegogo: Bool? = nil,
        element: String? = nil
    ) -> MovieTrackRequest {
        return MovieTrackRequest(
            episodeKey: episodeKey ?? self.episodeKey, isMegogo: isMegogo ?? self.isMegogo, movieKey: movieKey ?? self.movieKey, seasonKey: seasonKey ?? self.seasonKey, seconds: seconds ?? self.seconds, userId:userId ?? self.userId, element: element ?? self.element
        )
    }
}
