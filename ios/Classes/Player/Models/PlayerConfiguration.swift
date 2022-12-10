//
//  PlayerConfiguration.swift
//  udevs_video_player
//
//  Created by Sunnatillo Shavkatov on 08/10/22.
//

import Foundation

struct PlayerConfiguration{
    var initialResolution: [String:String]
    var resolutions: [String:String]
    var url, qualityText, platform, userId : String
    var speedText: String
    var type: PlayerType
    var lastPosition: Int
    var title: String
    var storyButtonText: String
    var episodeButtonText: String
    var nextButtonText: String
    var seasons: [Season]
    let story: [Story]
    var tvProgramsText: String
    var programsInfoList: [ProgramsInfo]
    var showController: Bool
    var playVideoFromAsset: Bool
    var assetPath: String
    var seasonIndex: Int
    var episodeIndex: Int
    var isMegogo: Bool
    var isPremier: Bool
    var videoId: String
    var sessionId: String
    var megogoAccessToken: String
    var authorization: String
    var autoText: String
    var baseUrl: String
    var closeText: String
    var seasonText: String
    var storyIndex: Int
    var movieTrack: MovieTrackRequest?
    
    init(initialResolution: [String : String], resolutions: [String : String], qualityText: String, speedText: String, lastPosition: Int, title: String, episodeButtonText: String, nextButtonText: String, seasons: [Season], tvProgramsText: String, programsInfoList: [ProgramsInfo], showController: Bool, playVideoFromAsset: Bool, assetPath: String, seasonIndex: Int, episodeIndex: Int, isMegogo: Bool, isPremier: Bool, videoId: String, sessionId: String, megogoAccessToken: String, authorization: String, autoText: String, baseUrl: String,url: String,  story: [Story], storyButtonText: String, closeText:String, seasonText:String, storyIndex: Int, movieTrack: MovieTrackRequest?, platform:String, type: PlayerType,userId:String) {
        self.initialResolution = initialResolution
        self.resolutions = resolutions
        self.qualityText = qualityText
        self.speedText = speedText
        self.lastPosition = lastPosition
        self.title = title
        self.episodeButtonText = episodeButtonText
        self.nextButtonText = nextButtonText
        self.seasons = seasons
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
        self.story = story
        self.storyButtonText = storyButtonText
        self.closeText = closeText
        self.seasonText = seasonText
        self.storyIndex = storyIndex
        self.movieTrack = movieTrack
        self.platform = platform
        self.type = type
        self.userId = userId
    }
    
    static func fromMap(map : [String:Any])->PlayerConfiguration {
        var season : [Season] = []
        var story : [Story] = []
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
            let v = Story.fromMap(map: data)
            story.append(v)
        })
        var movieTrack : MovieTrackRequest?
        if map["movieTrack"] != nil {
            movieTrack = MovieTrackRequest.fromMap(map: map["movieTrack"] as! [String:Any])
        }
        var type:PlayerType
        switch map["type"] as! String{
        case "tv":
            type = .tv
            break
        case "movie":
            type = .movie
            break
        case "story":
            type = .story
            break
        case "serial":
            type = .serial
            break
        case "trailer":
            type = .trailer
            break
        default:
            type = .movie
            break
        }
        
        return PlayerConfiguration(initialResolution: map["initialResolution"] as! [String:String],
                                   resolutions: map["resolutions"] as! [String:String],
                                   qualityText: map["qualityText"] as! String,
                                   speedText: map["speedText"] as! String,
                                   lastPosition: map["lastPosition"] as! Int,
                                   title: map["title"] as! String,
                                   episodeButtonText: map["episodeButtonText"] as! String,
                                   nextButtonText: map["nextButtonText"] as! String,
                                   seasons: season,
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
                                   story: story, storyButtonText:map["storyButtonText"] as! String, closeText:map["closeText"] as! String,
                                   seasonText:map["seasonText"] as! String, storyIndex: map["storyIndex"] as! Int, movieTrack: movieTrack, platform:map["platform"] as! String, type : type, userId: map["userId"] as! String
                                   
        )
    }
}

enum PlayerType {
    case movie, trailer, tv, story, serial
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
        return Movie(id: (map["id"] as? String),title: (map["title"] as? String), description: map["description"] as? String, image: (map["image"] as? String), duration: (map["duration"] as? Int), resolutions: (map["resolutions"] as! [String:String]))
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
            let tvProgram = TvProgram.fromMap(map: data as! [String:Any])
            tv.append(tvProgram)
        }
        return ProgramsInfo(day: map["day"] as! String,tvPrograms: tv )
    }
}

struct TvProgram {
    var scheduledTime: String?
    var programTitle: String?
    var isAvailable: Bool
    init(scheduledTime: String? = nil, programTitle: String? = nil,isAvailable:Bool ) {
        self.scheduledTime = scheduledTime
        self.programTitle = programTitle
        self.isAvailable = isAvailable
    }
    
    static func fromMap(map : [String:Any])->TvProgram{
        return TvProgram(scheduledTime: map["scheduledTime"] as! String, programTitle: map["programTitle"] as! String, isAvailable: map["isAvailable"] as! Bool)
    }
}

struct Video {
    let videoFiles: [Story]
    
    init(videoFiles: [Story]) {
        self.videoFiles = videoFiles
    }
}

// MARK: - VideoFile
struct Story {
    let id: String
    let title: String
    let quality: String
    let storyLink: String
    let duration: Int
    let slug: String
    let fileName: String
    let isAmediateka: Bool
    let isWatched: Bool
    
    init(id:String,title: String, quality: String, duration: Int, slug: String, fileName: String, isAmediateka: Bool, isWatched: Bool, storyLink: String) {
        self.id = id
        self.title = title
        self.quality = quality
        self.duration = duration
        self.slug = slug
        self.fileName = fileName
        self.isAmediateka = isAmediateka
        self.isWatched = isWatched
        self.storyLink = storyLink
    }
    
    static func fromMap(map : [String:Any])-> Story {
        return Story(id:map["id"] as! String, title: map["title"] as! String, quality: map["quality"] as! String, duration: map["duration"] as! Int, slug: map["slug"] as! String, fileName:  map["fileName"] as! String, isAmediateka: map["is_amediateka"] as! Bool, isWatched: map["is_watched"] as! Bool, storyLink: map["story_link"] as! String)
    }
}
