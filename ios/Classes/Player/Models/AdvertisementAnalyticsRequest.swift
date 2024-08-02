//
//  AdvertisementAnalyticsRequest.swift
//  udevs_video_player
//
//  Created by Abdurahmon on 01/08/2024.
//

import Foundation

struct AdvertisementAnalyticsRequest{
    let id:String
    let interested:Bool
    let click:Bool
    let viewTime: Int
    
    func toMap()->[String:Any]{
        return [
            "id": id,
            "interested":interested,
            "click":click,
            "view_time":viewTime
        ]
    }
}
