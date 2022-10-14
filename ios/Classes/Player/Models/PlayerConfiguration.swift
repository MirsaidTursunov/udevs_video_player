//
//  PlayerConfiguration.swift
//  udevs_video_player
//
//  Created by Udevs on 08/10/22.
//

import Foundation

struct PlayerConfiguration{
    var initialResolution: [String:String]
    var resolutions: [String:String]
    var url, qualityText: String
    var speedText: String
    var lastPosition: Int
    var title: String
    var isSerial: Bool
    var episodeButtonText: String
    var nextButtonText: String
    var seasons: [Season]
    let videos: [Video]
    var isLive: Bool
    var tvProgramsText: String
    var programsInfoList: [ProgramsInfo]
    var showController: Bool
    var playVideoFromAsset: Bool
    var assetPath: String?
    var seasonIndex: Int
    var episodeIndex: Int
    var isMegogo: Bool
    var isStory: Bool
    var isPremier: Bool
    var videoId: String
    var sessionId: String
    var megogoAccessToken: String
    var authorization: String
    var autoText: String
    var baseUrl: String
    
    init(initialResolution: [String : String], resolutions: [String : String], qualityText: String, speedText: String, lastPosition: Int, title: String, isSerial: Bool, episodeButtonText: String, nextButtonText: String, seasons: [Season], isLive: Bool, tvProgramsText: String, programsInfoList: [ProgramsInfo], showController: Bool, playVideoFromAsset: Bool, assetPath: String? = nil, seasonIndex: Int, episodeIndex: Int, isMegogo: Bool, isPremier: Bool, videoId: String, sessionId: String, megogoAccessToken: String, authorization: String, autoText: String, baseUrl: String,url: String, isStory: Bool, videos: [Video]) {
        self.initialResolution = initialResolution
        self.resolutions = resolutions
        self.qualityText = qualityText
        self.speedText = speedText
        self.lastPosition = lastPosition
        self.title = title
        self.isSerial = isSerial
        self.episodeButtonText = episodeButtonText
        self.nextButtonText = nextButtonText
        self.seasons = seasons
        self.isLive = isLive
        self.tvProgramsText = tvProgramsText
        self.programsInfoList = programsInfoList
        self.showController = showController
        self.playVideoFromAsset = playVideoFromAsset
        self.assetPath = assetPath
        self.seasonIndex = seasonIndex
        self.episodeIndex = episodeIndex
        self.isMegogo = isMegogo
        self.isPremier = isPremier
        self.videoId = videoId
        self.sessionId = sessionId
        self.megogoAccessToken = megogoAccessToken
        self.authorization = authorization
        self.autoText = autoText
        self.baseUrl = baseUrl
        self.url = url
        self.isStory = isStory
        self.videos = videos
    }
    
    static func fromMap(map : [String:Any])->PlayerConfiguration {
        var season : [Season] = []
        var video : [Video] = []
        var programInfos: [ProgramsInfo] = []
        var programsInfoListMap : [Dictionary<String, Any>]?
        var seasonsMap : [Dictionary<String, Any>]?
        var videoMap : [Dictionary<String, Any>]?
        programsInfoListMap = map["programsInfoList"] as? [Dictionary<String, Any>]
        seasonsMap = map["seasons"] as? [Dictionary<String, Any>]
        videoMap = map["story"] as? [Dictionary<String, Any>]
        programsInfoListMap?.forEach({ data in
            let program = ProgramsInfo.fromMap(map: data)
            programInfos.append(program)
        })
        seasonsMap?.forEach({ data in
            let program = Season.fromMap(map: data)
            season.append(program)
        })
        videoMap?.forEach({ data in
            let v = Video.fromMap(map: data)
            video.append(v)
        })
        
        return PlayerConfiguration(initialResolution: map["initialResolution"] as! [String:String],
                                   resolutions: map["resolutions"] as! [String:String],
                                   qualityText: map["qualityText"] as! String,
                                   speedText: map["speedText"] as! String,
                                   lastPosition: map["lastPosition"] as! Int,
                                   title: map["title"] as! String,
                                   isSerial: map["isSerial"] as! Bool,
                                   episodeButtonText: map["episodeButtonText"] as! String,
                                   nextButtonText: map["nextButtonText"] as! String,
                                   seasons: season,
                                   isLive: map["isLive"] as! Bool,
                                   tvProgramsText: map["tvProgramsText"] as! String,
                                   programsInfoList: programInfos,
                                   showController : map["showController"] as! Bool,
                                   playVideoFromAsset : map["playVideoFromAsset"] as! Bool,
                                   assetPath:map["assetPath"] as! String,
                                   seasonIndex: map["seasonIndex"] as! Int,
                                   episodeIndex: map["episodeIndex"] as! Int,
                                   isMegogo: map["isMegogo"] as! Bool,
                                   isPremier: map["isPremier"] as! Bool,
                                   videoId: map["videoId"] as! String,
                                   sessionId: map["sessionId"] as! String,
                                   megogoAccessToken: map["megogoAccessToken"] as! String,
                                   authorization: map["authorization"] as! String,
                                   autoText: map["autoText"] as! String,
                                   baseUrl: map["baseUrl"] as! String,
                                   url: (map["initialResolution"] as! [String:String]).values.first ?? "",
                                   isStory: map["isStory"] as! Bool, videos: video
                                   
        )
    }
}

struct Season {
    var title: String?
    var movies: [Movie]
    init(title: String? = nil, movies: [Movie]) {
        self.title = title
        self.movies = movies
    }
    
    static func fromMap(map : [String:Any])->Season{
        var s: [Movie] = []
        var movies: [Dictionary<String, Any>]?
        movies = map["movies"] as! [Dictionary<String, Any>]?
        movies?.forEach { data in
            let movi = Movie.fromMap(map: data)
            s.append(movi)
        }
        return Season(title:  map["title"] as? String, movies: s)
    }
}

struct Movie{
    var id: String?
    var title: String?
    var description: String?
    var image: String?
    var duration: Int?
    var resolutions: [String:String]
    
    init(id: String? = nil, title: String? = nil, description: String? = nil, image: String? = nil, duration: Int? = nil, resolutions: [String : String]) {
        self.id = id
        self.title = title
        self.description = description
        self.image = image
        self.duration = duration
        self.resolutions = resolutions
    }
    
    static func fromMap(map : [String:Any])->Movie{
        return Movie(id: (map["id"] as? String),title: (map["title"] as? String), description: map["description"] as? String, image: (map["image"] as? String), duration: (map["druation"] as? Int), resolutions: (map["resolutions"] as! [String:String]))
    }
}

struct ProgramsInfo {
    var day: String
    var tvPrograms: [TvProgram]?
    init(day: String, tvPrograms: [TvProgram]? = nil) {
        self.day = day
        self.tvPrograms = tvPrograms
    }
    static func fromMap(map : [String:Any])->ProgramsInfo{
        var tv: [TvProgram] = []
        var tvPrograms: [Dictionary<String, Any>]?
        tvPrograms = map["tvPrograms"] as! [Dictionary<String, Any>]?
        tvPrograms?.forEach { data in
            let tvProgram = TvProgram.fromMap(map: data as! [String:String])
            tv.append(tvProgram)
        }
        return ProgramsInfo(day: map["day"] as! String,tvPrograms: tv )
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

struct Video {
    let id, width, height, duration: Int
    let url: String
    let image: String
    let user: User
    let videoFiles: [VideoFile]
    
    init(id: Int, width: Int, height: Int, duration: Int, url: String, image: String, user: User, videoFiles: [VideoFile]) {
        self.id = id
        self.width = width
        self.height = height
        self.duration = duration
        self.url = url
        self.image = image
        self.user = user
        self.videoFiles = videoFiles
    }
    static func fromMap(map : [String:Any])->Video{
        var tv: [VideoFile] = []
        var tvPrograms: [Dictionary<String, Any>]?
        tvPrograms = map["video_files"] as! [Dictionary<String, Any>]?
        tvPrograms?.forEach { data in
            print("TTTTTTTTT")
            print(data)
            let tvProgram = VideoFile.fromMap(map: data)
            tv.append(tvProgram)
        }
        return Video(
            id: map["id"] as! Int, width: map["width"] as! Int, height: map["height"] as! Int, duration: map["duration"] as! Int, url: map["url"] as! String, image: map["image"] as! String, user: User.fromMap(map: map["user"] as! [String : Any]), videoFiles: tv
        )
    }
}

// MARK: - User
struct User {
    let id: Int
    let name: String
    let url: String
    
    init(id: Int, name: String, url: String) {
        self.id = id
        self.name = name
        self.url = url
    }
    
    static func fromMap(map : [String:Any])-> User {
        return User(id: map["id"] as! Int, name: map["name"] as! String, url: map["url"] as! String)
    }
}

// MARK: - VideoFile
struct VideoFile {
    let id: Int
    let quality: String
    let fileType: String
    let width, height: Int?
    let link: String

    init(id: Int, quality: String, fileType: String, width: Int?, height: Int?, link: String) {
        self.id = id
        self.quality = quality
        self.fileType = fileType
        self.width = width
        self.height = height
        self.link = link
    }
    
    static func fromMap(map : [String:Any])-> VideoFile {
        print(map)
        print(map["id"])
        return VideoFile(id: map["id"] as! Int, quality: map["quality"] as! String, fileType: map["file_type"] as! String, width: map["width"] as? Int, height: map["height"] as? Int, link: map["link"] as! String)
    }
}

enum FileType: String {
    case videoMp4 = "video/mp4"
}

enum Quality: String {
    case hd = "hd"
    case hls = "hls"
    case sd = "sd"
}
