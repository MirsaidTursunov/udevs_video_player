//
//  MovieTrackRequest.swift
//  udevs_video_player
//
//  Created by Abdurahmon on 01/10/2024.
//

import Foundation

struct MovieTrackRequest: Codable {
    let duration: Int
    let element, episodeID, episodeKey: String
    let isMegogo, isPremier: Bool
    let movieKey, profileID, seasonKey: String
    let seconds: Int
    let userID: String
    
    
    func toMap()->[String:Any]{
        return [
            "duration": duration,
            "element":element,
            "episode_id":episodeID,
            "episode_key":episodeKey,
            "is_megogo":isMegogo,
            "is_premier": isPremier,
            "movie_key":movieKey,
            "profile_id":profileID,
            "season_key":seasonKey,
            "seconds":seconds,
            "user_id":userID
        ]
    }
}
