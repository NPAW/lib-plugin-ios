//
//  YBOptionsKeysSwift.swift
//  YouboraLib iOS
//
//  Created by Tiago Pereira on 20/10/2020.
//  Copyright © 2020 NPAW. All rights reserved.
//

import Foundation

@available(*, deprecated, message: "This value will be removed in future release. Use YBOptionsKeys.Property instead")
public let YBOPTIONS_KEY_ENABLED = "enabled"

@available(*, deprecated, message: "This value will be removed in future release. Use YBOptionsKeys.Property instead")
public let YBOPTIONS_KEY_HTTP_SECURE = "httpSecure"

@available(*, deprecated, message: "This value will be removed in future release. Use YBOptionsKeys.Property instead")
public let YBOPTIONS_KEY_HOST = "host"

@available(*, deprecated, message: "This value will be removed in future release. Use YBOptionsKeys.Property instead")
public let YBOPTIONS_KEY_ACCOUNT_CODE = "config.accountCode"

@available(*, deprecated, message: "This value will be removed in future release. Use YBOptionsKeys.Property instead")
public let YBOPTIONS_KEY_USERNAME = "username"

public let YBOPTIONS_KEY_ANONYMOUS_USER = "anonymousUser"
public let YBOPTIONS_KEY_OFFLINE = "offline"
public let YBOPTIONS_KEY_IS_INFINITY = "isInfinity"
public let YBOPTIONS_KEY_BACKGROUND = "autoDetectBackground"
public let YBOPTIONS_KEY_FORCEINIT = "forceInit"
public let YBOPTIONS_KEY_USER_TYPE = "userType"
public let YBOPTIONS_KEY_USER_EMAIL = "user.email"
public let YBOPTIONS_KEY_EXPERIMENT_IDS = "experiments"
public let YBOPTIONS_KEY_SS_CONFIG_CODE = "smartswitch.configCode"
public let YBOPTIONS_KEY_SS_GROUP_CODE = "smartswitch.groupCode"
public let YBOPTIONS_KEY_SS_CONTRACT_CODE = "smartswitch.contractCode"

public let YBOPTIONS_KEY_PARSE_HLS = "parse.Hls"
public let YBOPTIONS_KEY_PARSE_DASH = "parse.Dash"
public let YBOPTIONS_KEY_PARSE_CDN_NAME_HEADER = "parse.CdnNameHeader"
public let YBOPTIONS_KEY_PARSE_CDN_NODE = "parse.CdnNode"
public let YBOPTIONS_KEY_PARSE_CDN_NODE_LIST = "parse.CdnNodeList"
public let YBOPTIONS_KEY_PARSE_LOCATION_HEADER = "parse.LocationHeader"

public let YBOPTIONS_KEY_NETWORK_IP = "network.IP"
public let YBOPTIONS_KEY_NETWORK_ISP = "network.Isp"
public let YBOPTIONS_KEY_NETWORK_CONNECTION_TYPE = "network.connectionType"
public let YBOPTIONS_KEY_USER_OBFUSCATE_IP = "user.ObfuscateIp"

public let YBOPTIONS_KEY_DEVICE_CODE = "device.code"
public let YBOPTIONS_KEY_DEVICE_MODEL = "device.model"
public let YBOPTIONS_KEY_DEVICE_BRAND = "device.brand"
public let YBOPTIONS_KEY_DEVICE_TYPE = "device.type"
public let YBOPTIONS_KEY_DEVICE_NAME = "device.name"
public let YBOPTIONS_KEY_DEVICE_OS_NAME = "device.osNme"
public let YBOPTIONS_KEY_DEVICE_OS_VERSION = "device.osVersion"
public let YBOPTIONS_KEY_DEVICE_IS_ANONYMOUS = "device.isAnonymous"

public let YBOPTIONS_KEY_CONTENT_RESOURCE = "content.resource"
public let YBOPTIONS_KEY_CONTENT_IS_LIVE = "content.isLive"
public let YBOPTIONS_KEY_CONTENT_TITLE = "content.title"
public let YBOPTIONS_KEY_CONTENT_PROGRAM = "content.program"
public let YBOPTIONS_KEY_CONTENT_DURATION = "content.duration"
public let YBOPTIONS_KEY_CONTENT_TRANSACTION_CODE = "content.transactionCode"
public let YBOPTIONS_KEY_CONTENT_BITRATE = "content.bitrate"
public let YBOPTIONS_KEY_CONTENT_THROUGHPUT = "content.throughput"
public let YBOPTIONS_KEY_CONTENT_RENDITION = "content.rendition"
public let YBOPTIONS_KEY_CONTENT_CDN = "content.cdn"
public let YBOPTIONS_KEY_CONTENT_FPS = "content.fps"
public let YBOPTIONS_KEY_CONTENT_STREAMING_PROTOCOL = "content.streamingProtocol"
public let YBOPTIONS_KEY_CONTENT_METADATA = "content.metadata"
public let YBOPTIONS_KEY_CONTENT_METRICS = "content.metrics"
public let YBOPTIONS_KEY_CONTENT_IS_LIVE_NO_SEEK = "content.isLiveNoSeek"

public let YBOPTIONS_KEY_CONTENT_PACKAGE = "content.package"
public let YBOPTIONS_KEY_CONTENT_SAGA = "content.saga"
public let YBOPTIONS_KEY_CONTENT_TV_SHOW = "content.tvShow"
public let YBOPTIONS_KEY_CONTENT_SEASON = "content.season"
public let YBOPTIONS_KEY_CONTENT_EPISODE_TITLE = "content.episodeTitle"
public let YBOPTIONS_KEY_CONTENT_CHANNEL = "content.Channel"
public let YBOPTIONS_KEY_CONTENT_ID = "content.id"
public let YBOPTIONS_KEY_CONTENT_IMDB_ID = "content.imdbId"
public let YBOPTIONS_KEY_CONTENT_GRACENOTE_ID = "content.gracenoteId"
public let YBOPTIONS_KEY_CONTENT_TYPE = "content.type"
public let YBOPTIONS_KEY_CONTENT_GENRE = "content.genre"
public let YBOPTIONS_KEY_CONTENT_LANGUAGE = "content.language"
public let YBOPTIONS_KEY_CONTENT_SUBTITLES = "content.subtitles"
public let YBOPTIONS_KEY_CONTENT_CONTRACTED_RESOLUTION = "content.contractedResolution"
public let YBOPTIONS_KEY_CONTENT_COST = "content.cost"
public let YBOPTIONS_KEY_CONTENT_PRICE = "content.price"
public let YBOPTIONS_KEY_CONTENT_PLAYBACK_TYPE = "content.playbackType"
public let YBOPTIONS_KEY_CONTENT_DRM = "content.drm"
public let YBOPTIONS_KEY_CONTENT_ENCODING_VIDEO_CODEC = "content.encoding.videoCodec"
public let YBOPTIONS_KEY_CONTENT_ENCODING_AUDIO_CODEC = "content.encoding.audioCodec"
public let YBOPTIONS_KEY_CONTENT_ENCODING_CODEC_SETTINGS = "content.encoding.codecSettings"
public let YBOPTIONS_KEY_CONTENT_ENCODING_CODEC_PROFILE = "content.encoding.codecProfile"
public let YBOPTIONS_KEY_CONTENT_ENCODING_CONTAINER_FORMAT = "content.encoding.containerFormat"

public let YBOPTIONS_KEY_AD_METADATA = "ad.metadata"
public let YBOPTIONS_KEY_AD_IGNORE = "ad.ignore"
public let YBOPTIONS_KEY_ADS_AFTERSTOP = "ad.afterStop"
public let YBOPTIONS_KEY_AD_CAMPAIGN = "ad.campaign"
public let YBOPTIONS_KEY_AD_TITLE = "ad.title"
public let YBOPTIONS_KEY_AD_RESOURCE = "ad.resource"
public let YBOPTIONS_KEY_AD_GIVEN_BREAKS = "ad.givenBreaks"
public let YBOPTIONS_KEY_AD_EXPECTED_BREAKS = "ad.expectedBreaks"
public let YBOPTIONS_KEY_AD_EXPECTED_PATTERN = "ad.expectedPattern"
public let YBOPTIONS_KEY_AD_BREAKS_TIME = "ad.breaksTime"
public let YBOPTIONS_KEY_AD_GIVEN_ADS = "ad.givenAds"
public let YBOPTIONS_KEY_AD_CREATIVEID = "ad.creativeId"
public let YBOPTIONS_KEY_AD_PROVIDER = "ad.provider"

public let YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_1 = "contentCustom.dimension.1"
public let YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_2 = "contentCustom.dimension.2"
public let YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_3 = "contentCustom.dimension.3"
public let YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_4 = "contentCustom.dimension.4"
public let YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_5 = "contentCustom.dimension.5"
public let YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_6 = "contentCustom.dimension.6"
public let YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_7 = "contentCustom.dimension.7"
public let YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_8 = "contentCustom.dimension.8"
public let YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_9 = "contentCustom.dimension.9"
public let YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_10 = "contentCustom.dimension.10"
public let YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_11 = "contentCustom.dimension.11"
public let YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_12 = "contentCustom.dimension.12"
public let YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_13 = "contentCustom.dimension.13"
public let YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_14 = "contentCustom.dimension.14"
public let YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_15 = "contentCustom.dimension.15"
public let YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_16 = "contentCustom.dimension.16"
public let YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_17 = "contentCustom.dimension.17"
public let YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_18 = "contentCustom.dimension.18"
public let YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_19 = "contentCustom.dimension.19"
public let YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_20 = "contentCustom.dimension.20"

public let YBOPTIONS_KEY_AD_CUSTOM_DIMENSION_1 = "ad.custom.dimension.1"
public let YBOPTIONS_KEY_AD_CUSTOM_DIMENSION_2 = "ad.custom.dimension.2"
public let YBOPTIONS_KEY_AD_CUSTOM_DIMENSION_3 = "ad.custom.dimension.3"
public let YBOPTIONS_KEY_AD_CUSTOM_DIMENSION_4 = "ad.custom.dimension.4"
public let YBOPTIONS_KEY_AD_CUSTOM_DIMENSION_5 = "ad.custom.dimension.5"
public let YBOPTIONS_KEY_AD_CUSTOM_DIMENSION_6 = "ad.custom.dimension.6"
public let YBOPTIONS_KEY_AD_CUSTOM_DIMENSION_7 = "ad.custom.dimension.7"
public let YBOPTIONS_KEY_AD_CUSTOM_DIMENSION_8 = "ad.custom.dimension.8"
public let YBOPTIONS_KEY_AD_CUSTOM_DIMENSION_9 = "ad.custom.dimension.9"
public let YBOPTIONS_KEY_AD_CUSTOM_DIMENSION_10 = "ad.custom.dimension.10"

public let YBOPTIONS_KEY_APP_NAME = "app.name"
public let YBOPTIONS_KEY_APP_RELEASE_VERSION = "app.release.version"

public let YBOPTIONS_KEY_WAIT_METADATA = "waitForMetadata"
public let YBOPTIONS_KEY_PENDING_METADATA = "pendingMetadata"

public let YBOPTIONS_KEY_SESSION_METRICS = "session.metrics"

/// Class that will contain all the keys for the options available to the plugin
@objcMembers public class YBOptionsKeys: NSObject {
    
    /// All available keys
    public enum Property: CaseIterable {
        case enabled
        case httpSecure
        case host
        case accountCode
        case parseResource
        case parseHls
        case parseDash
        case parseLocationHeader
        case parseCdnNameHeader
        case parseCdnNode
        case parseCdnNodeList
        case cdnSwitchHeader
        case cdnTTL
        case experimentIds
        case networkIP
        case networkIsp
        case networkConnectionType
        case forceInit
        case sendTotalBytes
        case sessionMetrics
        case autoDetectBackground
        case offline
        case isInfinity
        case smartswitchConfigCode
        case smartswitchGroupCode
        case smartswitchContractCode
        case appName
        case appReleaseVersion
        case waitForMetadata
        case pendingMetadata
        case username
        case userType
        case userEmail
        case networkObfuscateIp
        case userObfuscateIp
        case anonymousUser
        case deviceCode
        case deviceModel
        case deviceBrand
        case deviceType
        case deviceName
        case deviceOsName
        case deviceOsVersion
        case deviceIsAnonymous
        case contentResource
        case contentIsLive
        case contentTitle
        case contentTitle2
        case program
        case contentDuration
        case contentTransactionCode
        case contentBitrate
        case contentStreamingProtocol
        case contentTransportFormat
        case contentThroughput
        case contentRendition
        case contentCdn
        case contentFps
        case contentMetadata
        case contentMetrics
        case contentIsLiveNoSeek
        case contentPackage
        case contentSaga
        case contentTvShow
        case contentSeason
        case contentEpisodeTitle
        case contentChannel
        case contentId
        case contentImdbId
        case contentGracenoteId
        case contentType
        case contentGenre
        case contentLanguage
        case contentSubtitles
        case contentContractedResolution
        case contentCost
        case contentPrice
        case contentPlaybackType
        case contentDrm
        case contentEncodingVideoCodec
        case contentEncodingAudioCodec
        case contentEncodingCodecSettings
        case contentEncodingCodecProfile
        case contentEncodingContainerFormat
        case contentCustomDimension1
        case contentCustomDimension2
        case contentCustomDimension3
        case contentCustomDimension4
        case contentCustomDimension5
        case contentCustomDimension6
        case contentCustomDimension7
        case contentCustomDimension8
        case contentCustomDimension9
        case contentCustomDimension10
        case contentCustomDimension11
        case contentCustomDimension12
        case contentCustomDimension13
        case contentCustomDimension14
        case contentCustomDimension15
        case contentCustomDimension16
        case contentCustomDimension17
        case contentCustomDimension18
        case contentCustomDimension19
        case contentCustomDimension20
        case customDimension1
        case customDimension2
        case customDimension3
        case customDimension4
        case customDimension5
        case customDimension6
        case customDimension7
        case customDimension8
        case customDimension9
        case customDimension10
        case customDimension11
        case customDimension12
        case customDimension13
        case customDimension14
        case customDimension15
        case customDimension16
        case customDimension17
        case customDimension18
        case customDimension19
        case customDimension20
        case adMetadata
        case adsAfterStop
        case adCampaign
        case adTitle
        case adResource
        case adGivenBreaks
        case adExpectedBreaks
        case adExpectedPattern
        case adBreaksTime
        case adGivenAds
        case adCreativeId
        case adProvider
        case adCustomDimension1
        case adCustomDimension2
        case adCustomDimension3
        case adCustomDimension4
        case adCustomDimension5
        case adCustomDimension6
        case adCustomDimension7
        case adCustomDimension8
        case adCustomDimension9
        case adCustomDimension10
        case adExtraparam1
        case adExtraparam2
        case adExtraparam3
        case adExtraparam4
        case adExtraparam5
        case adExtraparam6
        case adExtraparam7
        case adExtraparam8
        case adExtraparam9
        case adExtraparam10
    }
    
    /**
     Method to translate enum in a string
     - Parameters:
        - key: option enum key from when we wanna to otain the string key
     - Returns: key in string
     */
    public static func getPropertyKey(property: Property) -> String {
        switch property {
        case .enabled:
            return "enabled"
        case .httpSecure:
            return "httpSecure"
        case .host:
            return "host"
        case .accountCode:
            return "accountCode"
        case .parseResource:
            return "parseResource"
        case .parseHls:
            return "parseHls"
        case .parseDash:
            return "parseDash"
        case .parseLocationHeader:
            return "parseLocationHeader"
        case .parseCdnNameHeader:
            return "parseCdnNameHeader"
        case .parseCdnNode:
            return "parseCdnNode"
        case .parseCdnNodeList:
            return "parseCdnNodeList"
        case .cdnSwitchHeader:
            return "cdnSwitchHeader"
        case .cdnTTL:
            return "cdnTTL"
        case .experimentIds:
            return "experimentIds"
        case .networkIP:
            return "networkIP"
        case .networkIsp:
            return "networkIsp"
        case .networkConnectionType:
            return "networkConnectionType"
        case .forceInit:
            return "forceInit"
        case .sendTotalBytes:
            return "sendTotalBytes"
        case .sessionMetrics:
            return "sessionMetrics"
        case .autoDetectBackground:
            return "autoDetectBackground"
        case .offline:
            return "offline"
        case .isInfinity:
            return "isInfinity"
        case .smartswitchConfigCode:
            return "smartswitchConfigCode"
        case .smartswitchGroupCode:
            return "smartswitchGroupCode"
        case .smartswitchContractCode:
            return "smartswitchContractCode"
        case .appName:
            return "appName"
        case .appReleaseVersion:
            return "appReleaseVersion"
        case .waitForMetadata:
            return "waitForMetadata"
        case .pendingMetadata:
            return "pendingMetadata"
        case .username:
            return "username"
        case .userType:
            return "userType"
        case .userEmail:
            return "userEmail"
        case .networkObfuscateIp:
            return "networkObfuscateIp"
        case .userObfuscateIp:
            return "userObfuscateIp"
        case .anonymousUser:
            return "anonymousUser"
        case .deviceCode:
            return "deviceCode"
        case .deviceModel:
            return "deviceModel"
        case .deviceBrand:
            return "deviceBrand"
        case .deviceType:
            return "deviceType"
        case .deviceName:
            return "deviceName"
        case .deviceOsName:
            return "deviceOsName"
        case .deviceOsVersion:
            return "deviceOsVersion"
        case .deviceIsAnonymous:
            return "deviceIsAnonymous"
        case .contentResource:
            return "contentResource"
        case .contentIsLive:
            return "contentIsLive"
        case .contentTitle:
            return "contentTitle"
        case .contentTitle2:
            return "contentTitle2"
        case .program:
            return "program"
        case .contentDuration:
            return "contentDuration"
        case .contentTransactionCode:
            return "contentTransactionCode"
        case .contentBitrate:
            return "contentBitrate"
        case .contentStreamingProtocol:
            return "contentStreamingProtocol"
        case .contentTransportFormat:
            return "contentTransportFormat"
        case .contentThroughput:
            return "contentThroughput"
        case .contentRendition:
            return "contentRendition"
        case .contentCdn:
            return "contentCdn"
        case .contentFps:
            return "contentFps"
        case .contentMetadata:
            return "contentMetadata"
        case .contentMetrics:
            return "contentMetrics"
        case .contentIsLiveNoSeek:
            return "contentIsLiveNoSeek"
        case .contentPackage:
            return "contentPackage"
        case .contentSaga:
            return "contentSaga"
        case .contentTvShow:
            return "contentTvShow"
        case .contentSeason:
            return "contentSeason"
        case .contentEpisodeTitle:
            return "contentEpisodeTitle"
        case .contentChannel:
            return "contentChannel"
        case .contentId:
            return "contentId"
        case .contentImdbId:
            return "contentImdbId"
        case .contentGracenoteId:
            return "contentGracenoteId"
        case .contentType:
            return "contentType"
        case .contentGenre:
            return "contentGenre"
        case .contentLanguage:
            return "contentLanguage"
        case .contentSubtitles:
            return "contentSubtitles"
        case .contentContractedResolution:
            return "contentContractedResolution"
        case .contentCost:
            return "contentCost"
        case .contentPrice:
            return "contentPrice"
        case .contentPlaybackType:
            return "contentPlaybackType"
        case .contentDrm:
            return "contentDrm"
        case .contentEncodingVideoCodec:
            return "contentEncodingVideoCodec"
        case .contentEncodingAudioCodec:
            return "contentEncodingAudioCodec"
        case .contentEncodingCodecSettings:
            return "contentEncodingCodecSettings"
        case .contentEncodingCodecProfile:
            return "contentEncodingCodecProfile"
        case .contentEncodingContainerFormat:
            return "contentEncodingContainerFormat"
        case .contentCustomDimension1:
            return "contentCustomDimension1"
        case .contentCustomDimension2:
            return "contentCustomDimension2"
        case .contentCustomDimension3:
            return "contentCustomDimension3"
        case .contentCustomDimension4:
            return "contentCustomDimension4"
        case .contentCustomDimension5:
            return "contentCustomDimension5"
        case .contentCustomDimension6:
            return "contentCustomDimension6"
        case .contentCustomDimension7:
            return "contentCustomDimension7"
        case .contentCustomDimension8:
            return "contentCustomDimension8"
        case .contentCustomDimension9:
            return "contentCustomDimension9"
        case .contentCustomDimension10:
            return "contentCustomDimension10"
        case .contentCustomDimension11:
            return "contentCustomDimension11"
        case .contentCustomDimension12:
            return "contentCustomDimension12"
        case .contentCustomDimension13:
            return "contentCustomDimension13"
        case .contentCustomDimension14:
            return "contentCustomDimension14"
        case .contentCustomDimension15:
            return "contentCustomDimension15"
        case .contentCustomDimension16:
            return "contentCustomDimension16"
        case .contentCustomDimension17:
            return "contentCustomDimension17"
        case .contentCustomDimension18:
            return "contentCustomDimension18"
        case .contentCustomDimension19:
            return "contentCustomDimension19"
        case .contentCustomDimension20:
            return "contentCustomDimension20"
        case .customDimension1:
            return "customDimension1"
        case .customDimension2:
            return "customDimension2"
        case .customDimension3:
            return "customDimension3"
        case .customDimension4:
            return "customDimension4"
        case .customDimension5:
            return "customDimension5"
        case .customDimension6:
            return "customDimension6"
        case .customDimension7:
            return "customDimension7"
        case .customDimension8:
            return "customDimension8"
        case .customDimension9:
            return "customDimension9"
        case .customDimension10:
            return "customDimension10"
        case .customDimension11:
            return "customDimension11"
        case .customDimension12:
            return "customDimension12"
        case .customDimension13:
            return "customDimension13"
        case .customDimension14:
            return "customDimension14"
        case .customDimension15:
            return "customDimension15"
        case .customDimension16:
            return "customDimension16"
        case .customDimension17:
            return "customDimension17"
        case .customDimension18:
            return "customDimension18"
        case .customDimension19:
            return "customDimension19"
        case .customDimension20:
            return "customDimension20"
        case .adMetadata:
            return "adMetadata"
        case .adsAfterStop:
            return "adsAfterStop"
        case .adCampaign:
            return "adCampaign"
        case .adTitle:
            return "adTitle"
        case .adResource:
            return "adResource"
        case .adGivenBreaks:
            return "adGivenBreaks"
        case .adExpectedBreaks:
            return "adExpectedBreaks"
        case .adExpectedPattern:
            return "adExpectedPattern"
        case .adBreaksTime:
            return "adBreaksTime"
        case .adGivenAds:
            return "adGivenAds"
        case .adCreativeId:
            return "adCreativeId"
        case .adProvider:
            return "adProvider"
        case .adCustomDimension1:
            return "adCustomDimension1"
        case .adCustomDimension2:
            return "adCustomDimension2"
        case .adCustomDimension3:
            return "adCustomDimension3"
        case .adCustomDimension4:
            return "adCustomDimension4"
        case .adCustomDimension5:
            return "adCustomDimension5"
        case .adCustomDimension6:
            return "adCustomDimension6"
        case .adCustomDimension7:
            return "adCustomDimension7"
        case .adCustomDimension8:
            return "adCustomDimension8"
        case .adCustomDimension9:
            return "adCustomDimension9"
        case .adCustomDimension10:
            return "adCustomDimension10"
        case .adExtraparam1:
            return "adExtraparam1"
        case .adExtraparam2:
            return "adExtraparam2"
        case .adExtraparam3:
            return "adExtraparam3"
        case .adExtraparam4:
            return "adExtraparam4"
        case .adExtraparam5:
            return "adExtraparam5"
        case .adExtraparam6:
            return "adExtraparam6"
        case .adExtraparam7:
            return "adExtraparam7"
        case .adExtraparam8:
            return "adExtraparam8"
        case .adExtraparam9:
            return "adExtraparam9"
        case .adExtraparam10:
            return "adExtraparam10"
        }
    }
    
    public static func getProperty(key: String) -> Property? {
        for property in YBOptionsKeys.Property.allCases {
            if self.getPropertyKey(property: property) == key {
                return property
            }
        }
        
        return nil
    }
}
