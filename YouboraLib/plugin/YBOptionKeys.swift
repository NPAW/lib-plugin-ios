//
//  YBOptionKeysHelper.swift
//  YouboraLib
//
//  Created by Tiago Pereira on 10/03/2020.
//  Copyright © 2020 NPAW. All rights reserved.
//

import UIKit

// Enum to be used config utils in order to know the type of the prop
public enum OptionKeyType {
    case number
    case string
    case bool
    case valueBool
    case unknown
    case depretacted
}

public struct YBOptionUtilsKeys {
    static let keys: [String: OptionKeyType] = [
        YBOptionKeys.enabled: .bool,
        YBOptionKeys.httpSecure: .bool,
        YBOptionKeys.host: .string,
        YBOptionKeys.accountCode: .string,
        YBOptionKeys.username: .string,
        YBOptionKeys.userType: .string,
        YBOptionKeys.userEmail: .string,
        YBOptionKeys.parseResource: .bool,
        YBOptionKeys.parseHls: .depretacted,
        YBOptionKeys.parseDash: .depretacted,
        YBOptionKeys.parseLocationHeader: .depretacted,
        YBOptionKeys.parseCdnNameHeader: .string,
        YBOptionKeys.parseCdnNode: .bool,
        YBOptionKeys.parseCdnNodeList: .unknown,
        YBOptionKeys.experimentIds: .unknown,
        YBOptionKeys.networkIP: .string,
        YBOptionKeys.networkIsp: .string,
        YBOptionKeys.networkConnectionType: .string,
        YBOptionKeys.networkObfuscateIp: .depretacted,
        YBOptionKeys.userObfuscateIp: .valueBool,
        YBOptionKeys.forceInit: .bool,
        YBOptionKeys.deviceCode: .depretacted,
        YBOptionKeys.deviceModel: .string,
        YBOptionKeys.deviceBrand: .string,
        YBOptionKeys.deviceType: .string,
        YBOptionKeys.deviceName: .string,
        YBOptionKeys.deviceOsName: .string,
        YBOptionKeys.deviceOsVersion: .string,
        YBOptionKeys.deviceIsAnonymous: .bool,
        YBOptionKeys.contentResource: .string,
        YBOptionKeys.contentIsLive: .valueBool,
        YBOptionKeys.contentTitle: .string,
        YBOptionKeys.contentTitle2: .depretacted,
        YBOptionKeys.program: .string,
        YBOptionKeys.contentDuration: .number,
        YBOptionKeys.contentTransactionCode: .string,
        YBOptionKeys.contentBitrate: .number,
        YBOptionKeys.contentStreamingProtocol: .string,
        YBOptionKeys.contentThroughput: .number,
        YBOptionKeys.contentRendition: .string,
        YBOptionKeys.contentCdn: .string,
        YBOptionKeys.contentFps: .number,
        YBOptionKeys.contentMetadata: .unknown,
        YBOptionKeys.contentMetrics: .unknown,
        YBOptionKeys.sessionMetrics: .unknown,
        YBOptionKeys.contentIsLiveNoSeek: .valueBool,
        YBOptionKeys.contentPackage: .string,
        YBOptionKeys.contentSaga: .string,
        YBOptionKeys.contentTvShow: .string,
        YBOptionKeys.contentSeason: .string,
        YBOptionKeys.contentEpisodeTitle: .string,
        YBOptionKeys.contentChannel: .string,
        YBOptionKeys.contentId: .string,
        YBOptionKeys.contentImdbId: .string,
        YBOptionKeys.contentGracenoteId: .string,
        YBOptionKeys.contentType: .string,
        YBOptionKeys.contentGenre: .string,
        YBOptionKeys.contentLanguage: .string,
        YBOptionKeys.contentSubtitles: .string,
        YBOptionKeys.contentContractedResolution: .string,
        YBOptionKeys.contentCost: .string,
        YBOptionKeys.contentPrice: .string,
        YBOptionKeys.contentPlaybackType: .string,
        YBOptionKeys.contentDrm: .string,
        YBOptionKeys.contentEncodingVideoCodec: .string,
        YBOptionKeys.contentEncodingAudioCodec: .string,
        YBOptionKeys.contentEncodingCodecSettings: .unknown,
        YBOptionKeys.contentEncodingCodecProfile: .string,
        YBOptionKeys.contentEncodingContainerFormat: .string,
        YBOptionKeys.adMetadata: .unknown,
        YBOptionKeys.adsAfterStop: .number,
        YBOptionKeys.adCampaign: .string,
        YBOptionKeys.adTitle: .string,
        YBOptionKeys.adResource: .string,
        YBOptionKeys.adGivenBreaks: .number,
        YBOptionKeys.adExpectedBreaks: .number,
        YBOptionKeys.adExpectedPattern: .unknown,
        YBOptionKeys.adBreaksTime: .unknown,
        YBOptionKeys.adGivenAds: .number,
        YBOptionKeys.adCreativeId: .string,
        YBOptionKeys.adProvider: .string,
        YBOptionKeys.autoDetectBackground: .bool,
        YBOptionKeys.offline: .bool,
        YBOptionKeys.anonymousUser: .string,
        YBOptionKeys.isInfinity: .valueBool,
        YBOptionKeys.ssConfigCode: .string,
        YBOptionKeys.ssGroupCode: .string,
        YBOptionKeys.ssContractCode: .string,
        YBOptionKeys.contentCustomDimension1: .string,
        YBOptionKeys.contentCustomDimension2: .string,
        YBOptionKeys.contentCustomDimension3: .string,
        YBOptionKeys.contentCustomDimension4: .string,
        YBOptionKeys.contentCustomDimension5: .string,
        YBOptionKeys.contentCustomDimension6: .string,
        YBOptionKeys.contentCustomDimension7: .string,
        YBOptionKeys.contentCustomDimension8: .string,
        YBOptionKeys.contentCustomDimension9: .string,
        YBOptionKeys.contentCustomDimension10: .string,
        YBOptionKeys.contentCustomDimension11: .string,
        YBOptionKeys.contentCustomDimension12: .string,
        YBOptionKeys.contentCustomDimension13: .string,
        YBOptionKeys.contentCustomDimension14: .string,
        YBOptionKeys.contentCustomDimension15: .string,
        YBOptionKeys.contentCustomDimension16: .string,
        YBOptionKeys.contentCustomDimension17: .string,
        YBOptionKeys.contentCustomDimension18: .string,
        YBOptionKeys.contentCustomDimension19: .string,
        YBOptionKeys.contentCustomDimension20: .string,
        YBOptionKeys.adCustomDimension1: .string,
        YBOptionKeys.adCustomDimension2: .string,
        YBOptionKeys.adCustomDimension3: .string,
        YBOptionKeys.adCustomDimension4: .string,
        YBOptionKeys.adCustomDimension5: .string,
        YBOptionKeys.adCustomDimension6: .string,
        YBOptionKeys.adCustomDimension7: .string,
        YBOptionKeys.adCustomDimension8: .string,
        YBOptionKeys.adCustomDimension9: .string,
        YBOptionKeys.adCustomDimension10: .string,
        YBOptionKeys.appName: .string,
        YBOptionKeys.appReleaseVersion: .string,
        YBOptionKeys.waitForMetadata: .bool,
        YBOptionKeys.pendingMetadata: .unknown,
    ]
}

@objcMembers public class YBOptionKeys: NSObject {
    static let enabled = "enabled"
    static let httpSecure = "httpSecure"
    static let host = "host"
    static let accountCode = "config.accountCode"
    static let username = "username"
    static let anonymousUser = "anonymousUser"
    static let offline = "offline"
    static let isInfinity = "isInfinity"
    static let background = "autoDetectBackground"
    static let autoStart = "autoStart"
    static let forceInit = "forceInit"
    static let userType = "userType"
    static let userEmail = "user.email"
    static let experimentIds = "experiments"
    static let ssConfigCode = "smartswitch.configCode"
    static let ssGroupCode = "smartswitch.groupCode"
    static let ssContractCode = "smartswitch.contractCode"
    static let parseResource = "parse.resource"
    static let parseHls = "parse.Hls"
    static let parseDash = "parse.Dash"
    static let parseCdnNameHeader = "parse.CdnNameHeader"
    static let parseCdnNode = "parse.CdnNode"
    static let parseCdnNodeList = "parse.CdnNodeList"
    static let parseLocationHeader = "parse.LocationHeader"
    static let networkIP = "network.IP"
    static let networkIsp = "network.Isp"
    static let networkConnectionType = "network.connectionType"
    static let userObfuscateIp = "user.ObfuscateIp"
    static let deviceCode = "device.code"
    static let deviceModel = "device.model"
    static let deviceBrand = "device.brand"
    static let deviceType = "device.type"
    static let deviceName = "device.name"
    static let deviceOsNme = "device.osNme"
    static let deviceOsVersion = "device.osVersion"
    static let deviceIsAnonymous = "device.isAnonymous"
    static let contentResource = "content.resource"
    static let contentIsLive = "content.isLive"
    static let contentTitle = "content.title"
    static let contentProgram = "content.program"
    static let contentDuration = "content.duration"
    static let contentTransactionCode = "content.transactionCode"
    static let contentBitrate = "content.bitrate"
    static let contentThroughput = "content.throughput"
    static let contentRendition = "content.rendition"
    static let contentCdn = "content.cdn"
    static let contentFps = "content.fps"
    static let contentStreamingProtocol = "content.streamingProtocol"
    static let contentMetadata = "content.metadata"
    static let contentMetrics = "content.metrics"
    static let contentIsLiveNoSeek = "content.isLiveNoSeek"
    static let contentPackage = "content.package"
    static let contentSaga = "content.saga"
    static let contentTvShow = "content.tvShow"
    static let contentSeason = "content.season"
    static let contentEpisodeTitle = "content.episodeTitle"
    static let contentChannel = "content.Channel"
    static let contentId = "content.id"
    static let contentImdbId = "content.imdbId"
    static let contentGracenoteId = "content.gracenoteId"
    static let contentType = "content.type"
    static let contentGenre = "content.genre"
    static let contentLanguage = "content.language"
    static let contentSubtitles = "content.subtitles"
    static let contentContractedResolution = "content.contractedResolution"
    static let contentCost = "content.cost"
    static let contentPrice = "content.price"
    static let contentPlaybackType = "content.playbackType"
    static let contentDrm = "content.drm"
    static let contentEncodingVideoCodec = "content.encoding.videoCodec"
    static let contentEncodingAudioCodec = "content.encoding.audioCodec"
    static let contentEncodingCodecSettings = "content.encoding.codecSettings"
    static let contentEncodingCodecProfile = "content.encoding.codecProfile"
    static let contentEncodingContainerFormat = "content.encoding.containerFormat"
    static let adMetadata = "ad.metadata"
    static let adIgnore = "ad.ignore"
    static let adAfterStop = "ad.afterStop"
    static let adCampaign = "ad.campaign"
    static let adTitle = "ad.title"
    static let adResource = "ad.resource"
    static let adGivenBreaks = "ad.givenBreaks"
    static let adExpectedBreaks = "ad.expectedBreaks"
    static let adExpectedPattern = "ad.expectedPattern"
    static let adBreaksTime = "ad.breaksTime"
    static let adGivenAds = "ad.givenAds"
    static let adCreativeId = "ad.creativeId"
    static let adProvider = "ad.provider"
    static let contentCustomDimension1 = "contentCustom.dimension.1"
    static let contentCustomDimension2 = "contentCustom.dimension.2"
    static let contentCustomDimension3 = "contentCustom.dimension.3"
    static let contentCustomDimension4 = "contentCustom.dimension.4"
    static let contentCustomDimension5 = "contentCustom.dimension.5"
    static let contentCustomDimension6 = "contentCustom.dimension.6"
    static let contentCustomDimension7 = "contentCustom.dimension.7"
    static let contentCustomDimension8 = "contentCustom.dimension.8"
    static let contentCustomDimension9 = "contentCustom.dimension.9"
    static let contentCustomDimension10 = "contentCustom.dimension.10"
    static let contentCustomDimension11 = "contentCustom.dimension.11"
    static let contentCustomDimension12 = "contentCustom.dimension.12"
    static let contentCustomDimension13 = "contentCustom.dimension.13"
    static let contentCustomDimension14 = "contentCustom.dimension.14"
    static let contentCustomDimension15 = "contentCustom.dimension.15"
    static let contentCustomDimension16 = "contentCustom.dimension.16"
    static let contentCustomDimension17 = "contentCustom.dimension.17"
    static let contentCustomDimension18 = "contentCustom.dimension.18"
    static let contentCustomDimension19 = "contentCustom.dimension.19"
    static let contentCustomDimension20 = "contentCustom.dimension.20"
    static let adCustomDimension1 = "ad.custom.dimension.1"
    static let adCustomDimension2 = "ad.custom.dimension.2"
    static let adCustomDimension3 = "ad.custom.dimension.3"
    static let adCustomDimension4 = "ad.custom.dimension.4"
    static let adCustomDimension5 = "ad.custom.dimension.5"
    static let adCustomDimension6 = "ad.custom.dimension.6"
    static let adCustomDimension7 = "ad.custom.dimension.7"
    static let adCustomDimension8 = "ad.custom.dimension.8"
    static let adCustomDimension9 = "ad.custom.dimension.9"
    static let adCustomDimension10 = "ad.custom.dimension.10"
    static let appName = "app.name"
    static let appReleaseVersion = "app.release.version"
    static let waitMetadata = "waitForMetadata"
    static let pendingMetadata = "pendingMetadata"
    static let sessionMetrics = "session.metrics"
    static let adPositionPre = "pre"
    static let adPositionMid = "mid"
    static let adPositionPost = "post"
}
