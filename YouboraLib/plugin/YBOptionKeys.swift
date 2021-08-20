//
//  YBOptionKeysHelper.swift
//  YouboraLib
//
//  Created by Tiago Pereira on 10/03/2020.
//  Copyright © 2020 NPAW. All rights reserved.
//

import Foundation

// Enum to be used config utils in order to know the type of the prop
public enum OptionKeyType {
    case number
    case string
    case bool
    case valueBool
    case unknown
    case depretacted
}

// Struct to be used in ConfigUtils in order to auto load new keys insert in the plugin
public struct YBOptionUtilsKeys {
    /// Dictionary with all keys, and for each key the type and the name of the prop in the YBOptions
    /// Basically [keyIdentifier: [propType:propNameInOptions]]
    public static let keys: [String: (OptionKeyType, String)] = [
        YBOptionKeys.enabled: (.bool, "enabled"),
        YBOptionKeys.httpSecure: (.bool, "httpSecure"),
        YBOptionKeys.host: (.string, "host"),
        YBOptionKeys.accountCode: (.string, "accountCode"),
        YBOptionKeys.username: (.string, "username"),
        YBOptionKeys.userType: (.string, "userType"),
        YBOptionKeys.userEmail: (.string, "userEmail"),
        YBOptionKeys.parseResource: (.bool, "parseResource"),
        YBOptionKeys.parseHls: (.depretacted, "parseHls"),
        YBOptionKeys.parseDash: (.depretacted, "parseDash"),
        YBOptionKeys.parseLocationHeader: (.depretacted, "parseLocationHeader"),
        YBOptionKeys.parseCdnNameHeader: (.string, "parseCdnNameHeader"),
        YBOptionKeys.parseCdnNode: (.bool, "parseCdnNode"),
        YBOptionKeys.parseCdnNodeList: (.unknown, "parseCdnNodeList"),
        YBOptionKeys.experimentIds: (.unknown, "experimentIds"),
        YBOptionKeys.networkIP: (.string, "networkIP"),
        YBOptionKeys.networkIsp: (.string, "networkIsp"),
        YBOptionKeys.networkConnectionType: (.string, "networkConnectionType"),
        YBOptionKeys.userObfuscateIp: (.valueBool, "networkObfuscateIp"),
        YBOptionKeys.forceInit: (.bool, "forceInit"),
        YBOptionKeys.deviceCode: (.string, "deviceCode"),
        YBOptionKeys.deviceModel: (.string, "deviceModel"),
        YBOptionKeys.deviceBrand: (.string, "deviceBrand"),
        YBOptionKeys.deviceType: (.string, "deviceType"),
        YBOptionKeys.deviceName: (.string, "deviceName"),
        YBOptionKeys.deviceOsNme: (.string, "deviceOsName"),
        YBOptionKeys.deviceOsVersion: (.string, "deviceOsVersion"),
        YBOptionKeys.deviceIsAnonymous: (.bool, "deviceIsAnonymous"),
        YBOptionKeys.deviceUUID: (.string, "deviceUUID"),
        YBOptionKeys.contentResource: (.string, "contentResource"),
        YBOptionKeys.contentIsLive: (.valueBool, "contentIsLive"),
        YBOptionKeys.contentTitle: (.string, "contentTitle"),
        YBOptionKeys.contentProgram: (.string, "program"),
        YBOptionKeys.contentDuration: (.number, "contentDuration"),
        YBOptionKeys.contentTransactionCode: (.string, "contentTransactionCode"),
        YBOptionKeys.contentBitrate: (.number, "contentBitrate"),
        YBOptionKeys.contentStreamingProtocol: (.string, "contentStreamingProtocol"),
        YBOptionKeys.contentTransportFormat: (.string, "contentTransportFormat"),
        YBOptionKeys.contentThroughput: (.number, "contentThroughput"),
        YBOptionKeys.contentRendition: (.string, "contentRendition"),
        YBOptionKeys.contentCdn: (.string, "contentCdn"),
        YBOptionKeys.contentFps: (.number, "contentFps"),
        YBOptionKeys.contentMetadata: (.unknown, "contentMetadata"),
        YBOptionKeys.contentMetrics: (.unknown, "contentMetrics"),
        YBOptionKeys.sessionMetrics: (.unknown, "sessionMetrics"),
        YBOptionKeys.contentIsLiveNoSeek: (.valueBool, "contentIsLiveNoSeek"),
        YBOptionKeys.contentPackage: (.string, "contentPackage"),
        YBOptionKeys.contentSaga: (.string, "contentSaga"),
        YBOptionKeys.contentTvShow: (.string, "contentTvShow"),
        YBOptionKeys.contentSeason: (.string, "contentSeason"),
        YBOptionKeys.contentEpisodeTitle: (.string, "contentEpisodeTitle"),
        YBOptionKeys.contentChannel: (.string, "contentChannel"),
        YBOptionKeys.contentId: (.string, "contentId"),
        YBOptionKeys.contentImdbId: (.string, "contentImdbId"),
        YBOptionKeys.contentGracenoteId: (.string, "contentGracenoteId"),
        YBOptionKeys.contentType: (.string, "contentType"),
        YBOptionKeys.contentGenre: (.string, "contentGenre"),
        YBOptionKeys.contentLanguage: (.string, "contentLanguage"),
        YBOptionKeys.contentSubtitles: (.string, "contentSubtitles"),
        YBOptionKeys.contentContractedResolution: (.string, "contentContractedResolution"),
        YBOptionKeys.contentCost: (.string, "contentCost"),
        YBOptionKeys.contentPrice: (.string, "contentPrice"),
        YBOptionKeys.contentPlaybackType: (.string, "contentPlaybackType"),
        YBOptionKeys.contentDrm: (.string, "contentDrm"),
        YBOptionKeys.contentEncodingVideoCodec: (.string, "contentEncodingVideoCodec"),
        YBOptionKeys.contentEncodingAudioCodec: (.string, "contentEncodingAudioCodec"),
        YBOptionKeys.contentEncodingCodecSettings: (.unknown, "contentEncodingCodecSettings"),
        YBOptionKeys.contentEncodingCodecProfile: (.string, "contentEncodingCodecProfile"),
        YBOptionKeys.contentEncodingContainerFormat: (.string, "contentEncodingContainerFormat"),
        YBOptionKeys.adMetadata: (.unknown, "adMetadata"),
        YBOptionKeys.adAfterStop: (.number, "adsAfterStop"),
        YBOptionKeys.adCampaign: (.string, "adCampaign"),
        YBOptionKeys.adTitle: (.string, "adTitle"),
        YBOptionKeys.adResource: (.string, "adResource"),
        YBOptionKeys.adGivenBreaks: (.number, "adGivenBreaks"),
        YBOptionKeys.adExpectedBreaks: (.number, "adExpectedBreaks"),
        YBOptionKeys.adExpectedPattern: (.unknown, "adExpectedPattern"),
        YBOptionKeys.adBreaksTime: (.unknown, "adBreaksTime"),
        YBOptionKeys.adGivenAds: (.number, "adGivenAds"),
        YBOptionKeys.adCreativeId: (.string, "adCreativeId"),
        YBOptionKeys.adProvider: (.string, "adProvider"),
        YBOptionKeys.background: (.bool, "autoDetectBackground"),
        YBOptionKeys.offline: (.bool, "offline"),
        YBOptionKeys.anonymousUser: (.string, "anonymousUser"),
        YBOptionKeys.isInfinity: (.valueBool, "isInfinity"),
        YBOptionKeys.ssConfigCode: (.string, "smartswitchConfigCode"),
        YBOptionKeys.ssGroupCode: (.string, "smartswitchGroupCode"),
        YBOptionKeys.ssContractCode: (.string, "smartswitchContractCode"),
        YBOptionKeys.contentCustomDimension1: (.string, "contentCustomDimension1"),
        YBOptionKeys.contentCustomDimension2: (.string, "contentCustomDimension2"),
        YBOptionKeys.contentCustomDimension3: (.string, "contentCustomDimension3"),
        YBOptionKeys.contentCustomDimension4: (.string, "contentCustomDimension4"),
        YBOptionKeys.contentCustomDimension5: (.string, "contentCustomDimension5"),
        YBOptionKeys.contentCustomDimension6: (.string, "contentCustomDimension6"),
        YBOptionKeys.contentCustomDimension7: (.string, "contentCustomDimension7"),
        YBOptionKeys.contentCustomDimension8: (.string, "contentCustomDimension8"),
        YBOptionKeys.contentCustomDimension9: (.string, "contentCustomDimension9"),
        YBOptionKeys.contentCustomDimension10: (.string, "contentCustomDimension10"),
        YBOptionKeys.contentCustomDimension11: (.string, "contentCustomDimension11"),
        YBOptionKeys.contentCustomDimension12: (.string, "contentCustomDimension12"),
        YBOptionKeys.contentCustomDimension13: (.string, "contentCustomDimension13"),
        YBOptionKeys.contentCustomDimension14: (.string, "contentCustomDimension14"),
        YBOptionKeys.contentCustomDimension15: (.string, "contentCustomDimension15"),
        YBOptionKeys.contentCustomDimension16: (.string, "contentCustomDimension16"),
        YBOptionKeys.contentCustomDimension17: (.string, "contentCustomDimension17"),
        YBOptionKeys.contentCustomDimension18: (.string, "contentCustomDimension18"),
        YBOptionKeys.contentCustomDimension19: (.string, "contentCustomDimension19"),
        YBOptionKeys.contentCustomDimension20: (.string, "contentCustomDimension20"),
        YBOptionKeys.contentCustomDimensions: (.string, "contentCustomDimensions"),
        YBOptionKeys.adCustomDimension1: (.string, "adCustomDimension1"),
        YBOptionKeys.adCustomDimension2: (.string, "adCustomDimension2"),
        YBOptionKeys.adCustomDimension3: (.string, "adCustomDimension3"),
        YBOptionKeys.adCustomDimension4: (.string, "adCustomDimension4"),
        YBOptionKeys.adCustomDimension5: (.string, "adCustomDimension5"),
        YBOptionKeys.adCustomDimension6: (.string, "adCustomDimension6"),
        YBOptionKeys.adCustomDimension7: (.string, "adCustomDimension7"),
        YBOptionKeys.adCustomDimension8: (.string, "adCustomDimension8"),
        YBOptionKeys.adCustomDimension9: (.string, "adCustomDimension9"),
        YBOptionKeys.adCustomDimension10: (.string, "adCustomDimension10"),
        YBOptionKeys.appName: (.string, "appName"),
        YBOptionKeys.appReleaseVersion: (.string, "appReleaseVersion"),
        YBOptionKeys.linkedViewId: (.string, "linkedViewId"),
        YBOptionKeys.waitMetadata: (.bool, "waitForMetadata"),
        YBOptionKeys.pendingMetadata: (.unknown, "pendingMetadata"),
        YBOptionKeys.sendTotalBytes: (.bool, "sendTotalBytes"),
        YBOptionKeys.cdnTTL: (.number, "cdnTTL"),
        YBOptionKeys.cdnSwitchHeader: (.bool, "cdnSwitchHeader")
    ]
}

@objcMembers public class YBOptionKeys: NSObject {
    public static let enabled = "enabled"
    public static let httpSecure = "httpSecure"
    public static let host = "host"
    public static let accountCode = "config.accountCode"
    public static let username = "username"
    public static let anonymousUser = "anonymousUser"
    public static let offline = "offline"
    public static let isInfinity = "isInfinity"
    public static let background = "autoDetectBackground"
    public static let autoStart = "autoStart"
    public static let forceInit = "forceInit"
    public static let userType = "userType"
    public static let userEmail = "user.email"
    public static let experimentIds = "experiments"
    public static let ssConfigCode = "smartswitch.configCode"
    public static let ssGroupCode = "smartswitch.groupCode"
    public static let ssContractCode = "smartswitch.contractCode"
    public static let parseResource = "parse.resource"
    public static let parseHls = "parse.Hls"
    public static let parseDash = "parse.Dash"
    public static let parseCdnNameHeader = "parse.CdnNameHeader"
    public static let parseCdnNode = "parse.CdnNode"
    public static let parseCdnNodeList = "parse.CdnNodeList"
    public static let parseLocationHeader = "parse.LocationHeader"
    public static let networkIP = "network.IP"
    public static let networkIsp = "network.Isp"
    public static let networkConnectionType = "network.connectionType"
    public static let userObfuscateIp = "user.ObfuscateIp"
    public static let deviceCode = "device.code"
    public static let deviceModel = "device.model"
    public static let deviceBrand = "device.brand"
    public static let deviceType = "device.type"
    public static let deviceName = "device.name"
    public static let deviceOsNme = "device.osNme"
    public static let deviceOsVersion = "device.osVersion"
    public static let deviceIsAnonymous = "device.isAnonymous"
    public static let deviceUUID = "device.uuid"
    public static let contentResource = "content.resource"
    public static let contentIsLive = "content.isLive"
    public static let contentTitle = "content.title"
    public static let contentProgram = "content.program"
    public static let contentDuration = "content.duration"
    public static let contentTransactionCode = "content.transactionCode"
    public static let contentBitrate = "content.bitrate"
    public static let contentThroughput = "content.throughput"
    public static let contentRendition = "content.rendition"
    public static let contentCdn = "content.cdn"
    public static let contentFps = "content.fps"
    public static let contentStreamingProtocol = "content.streamingProtocol"
    public static let contentTransportFormat = "content.transportFormat"
    public static let contentMetadata = "content.metadata"
    public static let contentMetrics = "content.metrics"
    public static let contentIsLiveNoSeek = "content.isLiveNoSeek"
    public static let contentPackage = "content.package"
    public static let contentSaga = "content.saga"
    public static let contentTvShow = "content.tvShow"
    public static let contentSeason = "content.season"
    public static let contentEpisodeTitle = "content.episodeTitle"
    public static let contentChannel = "content.Channel"
    public static let contentId = "content.id"
    public static let contentImdbId = "content.imdbId"
    public static let contentGracenoteId = "content.gracenoteId"
    public static let contentType = "content.type"
    public static let contentGenre = "content.genre"
    public static let contentLanguage = "content.language"
    public static let contentSubtitles = "content.subtitles"
    public static let contentContractedResolution = "content.contractedResolution"
    public static let contentCost = "content.cost"
    public static let contentPrice = "content.price"
    public static let contentPlaybackType = "content.playbackType"
    public static let contentDrm = "content.drm"
    public static let contentEncodingVideoCodec = "content.encoding.videoCodec"
    public static let contentEncodingAudioCodec = "content.encoding.audioCodec"
    public static let contentEncodingCodecSettings = "content.encoding.codecSettings"
    public static let contentEncodingCodecProfile = "content.encoding.codecProfile"
    public static let contentEncodingContainerFormat = "content.encoding.containerFormat"
    public static let adMetadata = "ad.metadata"
    public static let adIgnore = "ad.ignore"
    public static let adAfterStop = "ad.afterStop"
    public static let adCampaign = "ad.campaign"
    public static let adTitle = "ad.title"
    public static let adResource = "ad.resource"
    public static let adGivenBreaks = "ad.givenBreaks"
    public static let adExpectedBreaks = "ad.expectedBreaks"
    public static let adExpectedPattern = "ad.expectedPattern"
    public static let adBreaksTime = "ad.breaksTime"
    public static let adGivenAds = "ad.givenAds"
    public static let adCreativeId = "ad.creativeId"
    public static let adProvider = "ad.provider"
    public static let contentCustomDimension1 = "contentCustom.dimension.1"
    public static let contentCustomDimension2 = "contentCustom.dimension.2"
    public static let contentCustomDimension3 = "contentCustom.dimension.3"
    public static let contentCustomDimension4 = "contentCustom.dimension.4"
    public static let contentCustomDimension5 = "contentCustom.dimension.5"
    public static let contentCustomDimension6 = "contentCustom.dimension.6"
    public static let contentCustomDimension7 = "contentCustom.dimension.7"
    public static let contentCustomDimension8 = "contentCustom.dimension.8"
    public static let contentCustomDimension9 = "contentCustom.dimension.9"
    public static let contentCustomDimension10 = "contentCustom.dimension.10"
    public static let contentCustomDimension11 = "contentCustom.dimension.11"
    public static let contentCustomDimension12 = "contentCustom.dimension.12"
    public static let contentCustomDimension13 = "contentCustom.dimension.13"
    public static let contentCustomDimension14 = "contentCustom.dimension.14"
    public static let contentCustomDimension15 = "contentCustom.dimension.15"
    public static let contentCustomDimension16 = "contentCustom.dimension.16"
    public static let contentCustomDimension17 = "contentCustom.dimension.17"
    public static let contentCustomDimension18 = "contentCustom.dimension.18"
    public static let contentCustomDimension19 = "contentCustom.dimension.19"
    public static let contentCustomDimension20 = "contentCustom.dimension.20"
    public static let contentCustomDimensions = "contentCustom.dimensions"
    public static let adCustomDimension1 = "ad.custom.dimension.1"
    public static let adCustomDimension2 = "ad.custom.dimension.2"
    public static let adCustomDimension3 = "ad.custom.dimension.3"
    public static let adCustomDimension4 = "ad.custom.dimension.4"
    public static let adCustomDimension5 = "ad.custom.dimension.5"
    public static let adCustomDimension6 = "ad.custom.dimension.6"
    public static let adCustomDimension7 = "ad.custom.dimension.7"
    public static let adCustomDimension8 = "ad.custom.dimension.8"
    public static let adCustomDimension9 = "ad.custom.dimension.9"
    public static let adCustomDimension10 = "ad.custom.dimension.10"
    public static let appName = "app.name"
    public static let appReleaseVersion = "app.release.version"
    public static let linkedViewId = "linkedViewId"
    public static let waitMetadata = "waitForMetadata"
    public static let pendingMetadata = "pendingMetadata"
    public static let sessionMetrics = "session.metrics"
    public static let adPositionPre = "pre"
    public static let adPositionMid = "mid"
    public static let adPositionPost = "post"
    public static let sendTotalBytes = "sendTotalBytes"
    public static let cdnTTL = "cdnTTL"
    public static let cdnSwitchHeader = "cdnSwitchHeader"
}
