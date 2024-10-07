//
//  LivePlayerConfiguration.swift
//  udevs_video_player
//
//  Created by Abdurahmon on 17/07/2024.
//

import Foundation

struct LivePlayerConfiguration{
    var videoUrl:String
    var qualityText: String
    var speedText: String
    var title: String
    var tvProgramsText: String
    var programsInfoList: [ProgramInfo]
    var showController: Bool
    var sessionId: String
    var authorization: String
    var autoText: String
    var baseUrl: String
    var ip: String
    var selectChannelIndex: Int
    var selectTvCategoryIndex: Int
    var tvCategories: [TvCategories]
    var skipText:String
    var userId: String
    var age: Int
    var gender: String
    var region: String
    var advertisement: AdvertisementResponse?
    
    
    init(videoUrl:String, qualityText: String, speedText: String,
         title: String,
         tvProgramsText: String, programsInfoList: [ProgramInfo], showController: Bool,
         sessionId: String,
         authorization: String, autoText: String, baseUrl: String,
         ip : String, selectChannelIndex: Int, selectTvCategoryIndex: Int, tvCategories: [TvCategories],
     skipText:String,
     userId: String,
     age: Int,
     gender: String,
     region: String,
     advertisement: AdvertisementResponse?
    ) {
        self.videoUrl = videoUrl
        self.qualityText = qualityText
        self.speedText = speedText
        self.title = title
        self.tvProgramsText = tvProgramsText
        self.programsInfoList = programsInfoList
        self.showController = showController
        self.sessionId = sessionId
        self.authorization = authorization
        self.autoText = autoText
        self.baseUrl = baseUrl
        self.ip = ip
        self.selectChannelIndex = selectChannelIndex
        self.selectTvCategoryIndex = selectTvCategoryIndex
        self.tvCategories = tvCategories
        self.skipText = skipText
        self.userId = userId
        self.age = age
        self.gender = gender
        self.region = region
        self.advertisement = advertisement
    }
    
    static func fromMap(map : [String:Any])->LivePlayerConfiguration {
        var programInfos: [ProgramInfo] = []
        var tvCategories: [TvCategories] = []
        var programsInfoListMap : [Dictionary<String, Any>]?
        var tvCategoriesMap : [Dictionary<String, Any>]?
        programsInfoListMap = map["programsInfoList"] as? [Dictionary<String, Any>]
        tvCategoriesMap = map["tvCategories"] as? [Dictionary<String, Any>]
        programsInfoListMap?.forEach({ data in
            let program = ProgramInfo.fromMap(map: data)
            programInfos.append(program)
        })
        tvCategoriesMap?.forEach({ data in
            let program = TvCategories.fromMap(map: data)
            tvCategories.append(program)
        })
        
        return LivePlayerConfiguration(
                                    videoUrl: map["videoUrl"] as! String,
                                   qualityText: map["qualityText"] as! String,
                                   speedText: map["speedText"] as! String,
                                   title: map["title"] as! String,
                                   tvProgramsText: map["tvProgramsText"] as! String,
                                   programsInfoList: programInfos,
                                   showController : map["showController"] as! Bool,
                                   sessionId: map["sessionId"] as! String,
                                   authorization: map["authorization"] as! String,
                                   autoText: map["autoText"] as! String,
                                   baseUrl: map["baseUrl"] as! String,
                                   ip: map["ip"] as! String,
                                   selectChannelIndex: map["selectChannelIndex"] as? Int ?? 0, selectTvCategoryIndex: map["selectTvCategoryIndex"] as? Int ?? 0,
                                   tvCategories: tvCategories,
                                       skipText: map["skipText"] as! String,
                                       userId: map["userId"] as! String,
                                       age : map["age"] as! Int,
                                       gender: map["gender"] as! String,
                                       region: map["region"]as! String,
                                       advertisement: AdvertisementResponse.fromMap(map: map["advertisement"] as? [String:Any])
        )
    }
}

struct ProgramInfo {
    var day: String
    var tvPrograms: [TvProgram]?
    init(day: String, tvPrograms: [TvProgram]? = nil) {
        self.day = day
        self.tvPrograms = tvPrograms
    }
    static func fromMap(map : [String:Any])->ProgramInfo{
        var tv: [TvProgram] = []
        var tvPrograms: [Dictionary<String, Any>]?
        tvPrograms = map["tvPrograms"] as! [Dictionary<String, Any>]?
        tvPrograms?.forEach { data in
            let tvProgram = TvProgram.fromMap(map: data as! [String:String])
            tv.append(tvProgram)
        }
        return ProgramInfo(day: map["day"] as! String,tvPrograms: tv )
    }
}

struct TvProgram{
    var scheduledTime: String?
    var programTitle: String?
    init(scheduledTime: String? = nil, programTitle: String? = nil) {
        self.scheduledTime = scheduledTime
        self.programTitle = programTitle
    }
    
    static func fromMap(map : [String:String])->TvProgram{
        return TvProgram(scheduledTime: map["scheduledTime"]!, programTitle: map["programTitle"]!)
    }
}

struct Channel {
    var id: String?
    var image: String?
    var name: String?
    var resolutions: [String:String]
    var hasAccess: Bool
    var paymentType: String
    
    init(id: String? = nil, name: String? = nil, image: String? = nil, resolutions: [String : String], hasAccess: Bool?=nil, paymentType: String?=nil
    ) {
        self.id = id
        self.name = name
        self.image = image
        self.resolutions = resolutions
        self.hasAccess = hasAccess ?? false
        self.paymentType = paymentType ?? ""
    }
    
    static func fromMap(map : [String:Any])-> Channel{
        return Channel(
            id: (map["id"] as? String),
            name:(map["name"] as? String),
            image: (map["image"] as? String),
            resolutions: (map["resolutions"] as! [String:String]),
            hasAccess: (map["hasAccess"] as? Bool),
            paymentType: (map["paymentType"] as? String)
        )
    }
}

extension Channel: Equatable {
     static func == (lhs: Channel, rhs: Channel) -> Bool {
         lhs.id == rhs.id && lhs.name == rhs.name && lhs.image == rhs.image
     }
 }
struct TvCategories{
    var id: String?
    var title: String?
    var channels: [Channel]
    
    init(id: String? = nil, title: String? = nil, channels: [Channel]) {
        self.id = id
        self.title = title
        self.channels = channels
    }
    
    static func fromMap(map : [String:Any])-> TvCategories{
        var channels : [Channel] = []
        var channelsMap : [Dictionary<String, Any>]?
        channelsMap = map["tvChannels"] as? [Dictionary<String, Any>]
        channelsMap?.forEach({ data in
            let program = Channel.fromMap(map: data)
            channels.append(program)
        })
        return TvCategories(id: (map["id"] as? String),title: map["title"] as? String, channels: channels)
    }
}
