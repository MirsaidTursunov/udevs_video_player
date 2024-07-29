//
//  AdvertisementRequest.swift
//  udevs_video_player
//
//  Created by Abdurahmon on 26/07/2024.
//

import Foundation


struct AdvertisementRequest{
    
    var device: String = "mobile"
    var format: String = "player"
    var age: Int
    var gender:String
    var paymentType: String
    var region: String
    var userId: String
    
    
    func toMap()->[String:Any]{
        return [
            "device": device,
            "format":format,
            "age":age,
            "gender":gender,
            "payment_type":paymentType,
            "region":region,
            "user_id":userId
        ]
    }
}
