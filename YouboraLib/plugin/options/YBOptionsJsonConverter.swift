//
//  YBOptionsJsonConverter.swift
//  YouboraLib
//
//  Created by Tiago Pereira on 22/10/2020.
//  Copyright © 2020 NPAW. All rights reserved.
//

import UIKit

protocol YBOptionsJsonConverterInterface {
    static func buildFromJson(json: [String: Any]) -> YBOptions
    static func updateOptions(json: [String: Any], options: YBOptions) -> YBOptions
    static func convertToJson(options: YBOptions) -> [String: Any]
}

@objcMembers class YBOptionsJsonConverter: NSObject, YBOptionsJsonConverterInterface {
    static var invalidKeys: [String] = []
    
    static func buildFromJson(json: [String : Any]) -> YBOptions {
        return self.convertFromJson(json: json, options: YBOptions())
    }
    
    static func updateOptions(json: [String : Any], options: YBOptions) -> YBOptions {
        return self.convertFromJson(json: json, options: options)
    }
    
    private static func convertFromJson(json: [String : Any], options: YBOptions) -> YBOptions {
        self.invalidKeys = []
        
        for keyValue in json.keys {
            if let property = YBOptionsKeys.getProperty(key: keyValue) {
                switch property {
                case .enabled:
                    options.enabled = YBOptionsValidator<Bool>.validateValue(values: json, key: keyValue, defaultValue: options.enabled)
                case .httpSecure:
                    options.httpSecure = YBOptionsValidator<Bool>.validateValue(values: json, key: keyValue, defaultValue: options.httpSecure)
                case .host:
                    options.host = YBOptionsValidator<String>.validateValue(values: json, key: keyValue, defaultValue: options.host)
                case .accountCode:
                    options.accountCode = YBOptionsValidator<String>.validateValue(values: json, key: keyValue, defaultValue: options.accountCode)
                case .parseResource:
                    options.parseResource = YBOptionsValidator<Bool>.validateValue(values: json, key: keyValue, defaultValue: options.parseResource)
                case .parseHls:
                    options.parseHls = YBOptionsValidator<Bool>.validateValue(values: json, key: keyValue, defaultValue: options.parseHls)
                case .parseDash:
                    options.parseDash = YBOptionsValidator<Bool>.validateValue(values: json, key: keyValue, defaultValue: options.parseDash)
                case .parseLocationHeader:
                    options.parseLocationHeader = YBOptionsValidator<Bool>.validateValue(values: json, key: keyValue, defaultValue: options.parseLocationHeader)
                case .parseCdnNameHeader:
                    options.parseCdnNameHeader = YBOptionsValidator<String>.validateValue(values: json, key: keyValue, defaultValue: options.parseCdnNameHeader)
                case .parseCdnNode:
                    options.parseCdnNode = YBOptionsValidator<Bool>.validateValue(values: json, key: keyValue, defaultValue: options.parseCdnNode)
                case .parseCdnNodeList:
                    options.parseCdnNodeList = YBOptionsValidator<[String]>.validateValue(values: json, key: keyValue, defaultValue: options.parseCdnNodeList)
                case .cdnSwitchHeader:
                    options.cdnSwitchHeader = YBOptionsValidator<Bool>.validateValue(values: json, key: keyValue, defaultValue: options.cdnSwitchHeader)
                case .cdnTTL:
                    options.cdnTTL = YBOptionsValidator<TimeInterval>.validateValue(values: json, key: keyValue, defaultValue: options.cdnTTL)
                case .experimentIds:
                    options.experimentIds = YBOptionsValidator<[String]>.validateValue(values: json, key: keyValue, defaultValue: options.experimentIds)
                case .networkIP:
                    options.networkIP = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.networkIP)
                case .networkIsp:
                    options.networkIsp = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.networkIsp)
                case .networkConnectionType:
                    options.networkConnectionType = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.networkConnectionType)
                case .forceInit:
                    options.forceInit = YBOptionsValidator<Bool>.validateValue(values: json, key: keyValue, defaultValue: options.forceInit)
                case .sendTotalBytes:
                    options.sendTotalBytes = YBOptionsValidator<Bool>.validateValue(values: json, key: keyValue, defaultValue: options.sendTotalBytes)
                case .sessionMetrics:
                    options.sessionMetrics = YBOptionsValidator<[String: Any]>.validateValue(values: json, key: keyValue, defaultValue: options.sessionMetrics)
                case .autoDetectBackground:
                    options.autoDetectBackground = YBOptionsValidator<Bool>.validateValue(values: json, key: keyValue, defaultValue: options.autoDetectBackground)
                case .offline:
                    options.offline = YBOptionsValidator<Bool>.validateValue(values: json, key: keyValue, defaultValue: options.offline)
                case .isInfinity:
                    if let mainCast = YBOptionsValidator<Bool>.validateOptionalValue(values: json, key: keyValue, defaultValue: nil) {
                        options.isInfinity = NSNumber(value: mainCast)
                    } else {
                        options.isInfinity = YBOptionsValidator<NSNumber>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.isInfinity)
                    }
                case .smartswitchConfigCode:
                    options.smartswitchConfigCode = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.smartswitchConfigCode)
                case .smartswitchGroupCode:
                    options.smartswitchGroupCode = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.smartswitchGroupCode)
                case .smartswitchContractCode:
                    options.smartswitchContractCode = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.smartswitchContractCode)
                case .appName:
                    options.appName = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.appName)
                case .appReleaseVersion:
                    options.appReleaseVersion = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.appReleaseVersion)
                case .waitForMetadata:
                    options.waitForMetadata = YBOptionsValidator<Bool>.validateValue(values: json, key: keyValue, defaultValue: options.waitForMetadata)
                case .pendingMetadata:
                    options.pendingMetadata = YBOptionsValidator<[String]>.validateValue(values: json, key: keyValue, defaultValue: options.pendingMetadata)
                case .username:
                    options.username = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.username)
                case .userType:
                    options.userType = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.userType)
                case .userEmail:
                    options.userEmail = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.userEmail)
                case .networkObfuscateIp:
                    options.networkObfuscateIp = YBOptionsValidator<Bool>.validateValue(values: json, key: keyValue, defaultValue: options.networkObfuscateIp)
                case .userObfuscateIp:
                    options.userObfuscateIp = YBOptionsValidator<Bool>.validateValue(values: json, key: keyValue, defaultValue: options.userObfuscateIp)
                case .anonymousUser:
                    options.anonymousUser = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.anonymousUser)
                case .deviceCode:
                    options.deviceCode = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.deviceCode)
                case .deviceModel:
                    options.deviceModel = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.deviceModel)
                case .deviceBrand:
                    options.deviceBrand = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.deviceBrand)
                case .deviceType:
                    options.deviceType = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.deviceType)
                case .deviceName:
                    options.deviceName = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.deviceName)
                case .deviceOsName:
                    options.deviceOsName = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.deviceOsName)
                case .deviceOsVersion:
                    options.deviceOsVersion = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.deviceOsVersion)
                case .deviceIsAnonymous:
                    options.deviceIsAnonymous = YBOptionsValidator<Bool>.validateValue(values: json, key: keyValue, defaultValue: options.deviceIsAnonymous)
                case .contentResource:
                    options.contentResource = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.contentResource)
                case .contentIsLive:
                    // This one is a special case because it will propabably be defined as BOOL in the json but since objective c
                    // doesn't support Bool optional then we transform it on NSNumber in order to set it as a nil case no value
                    // defined by the user
                    if let mainCast = YBOptionsValidator<Bool>.validateOptionalValue(values: json, key: keyValue, defaultValue: nil) {
                        options.contentIsLive = NSNumber(value: mainCast)
                    } else {
                        options.contentIsLive = YBOptionsValidator<NSNumber>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.contentIsLive)
                    }
                case .contentTitle:
                    options.contentTitle = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.contentTitle)
                case .contentTitle2:
                    options.contentTitle2 = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.contentTitle2)
                case .program:
                    options.program = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.program)
                case .contentDuration:
                    options.contentDuration = YBOptionsValidator<NSNumber>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.contentDuration)
                case .contentTransactionCode:
                    options.contentTransactionCode = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.contentTransactionCode)
                case .contentBitrate:
                    options.contentBitrate = YBOptionsValidator<NSNumber>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.contentBitrate)
                case .contentStreamingProtocol:
                    options.contentStreamingProtocol = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.contentTransportFormat)
                case .contentTransportFormat:
                    options.contentTransportFormat = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.contentTransportFormat)
                case .contentThroughput:
                    options.contentThroughput = YBOptionsValidator<NSNumber>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.contentThroughput)
                case .contentRendition:
                    options.contentRendition = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.contentRendition)
                case .contentCdn:
                    options.contentCdn = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.contentCdn)
                case .contentFps:
                    options.contentFps = YBOptionsValidator<NSNumber>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.contentFps)
                case .contentMetadata:
                    options.contentMetadata = YBOptionsValidator<[String: Any]>.validateValue(values: json, key: keyValue, defaultValue: options.contentMetadata)
                case .contentMetrics:
                    options.contentMetrics = YBOptionsValidator<[String: Any]>.validateValue(values: json, key: keyValue, defaultValue: options.contentMetrics)
                case .contentIsLiveNoSeek:
                    options.contentIsLiveNoSeek = YBOptionsValidator<Bool>.validateValue(values: json, key: keyValue, defaultValue: options.contentIsLiveNoSeek)
                case .contentPackage:
                    options.contentPackage = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.contentPackage)
                case .contentSaga:
                    options.contentSaga = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.contentSaga)
                case .contentTvShow:
                    options.contentTvShow = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.contentTvShow)
                case .contentSeason:
                    options.contentSeason = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.contentSeason)
                case .contentEpisodeTitle:
                    options.contentEpisodeTitle = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.contentEpisodeTitle)
                case .contentChannel:
                    options.contentChannel = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.contentChannel)
                case .contentId:
                    options.contentId = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.contentId)
                case .contentImdbId:
                    options.contentImdbId = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.contentImdbId)
                case .contentGracenoteId:
                    options.contentGracenoteId = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.contentGracenoteId)
                case .contentType:
                    options.contentType = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.contentType)
                case .contentGenre:
                    options.contentGenre = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.contentGenre)
                case .contentLanguage:
                    options.contentLanguage = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.contentLanguage)
                case .contentSubtitles:
                    options.contentSubtitles = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.contentSubtitles)
                case .contentContractedResolution:
                    options.contentContractedResolution = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.contentContractedResolution)
                case .contentCost:
                    options.contentCost = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.contentCost)
                case .contentPrice:
                    options.contentPrice = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.contentPrice)
                case .contentPlaybackType:
                    options.contentPlaybackType = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.contentPlaybackType)
                case .contentDrm:
                    options.contentDrm = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.contentDrm)
                case .contentEncodingVideoCodec:
                    options.contentEncodingVideoCodec = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.contentEncodingVideoCodec)
                case .contentEncodingAudioCodec:
                    options.contentEncodingAudioCodec = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.contentEncodingAudioCodec)
                case .contentEncodingCodecSettings:
                    options.contentEncodingCodecSettings = YBOptionsValidator<[String : Any]>.validateValue(values: json, key: keyValue, defaultValue: options.contentEncodingCodecSettings)
                case .contentEncodingCodecProfile:
                    options.contentEncodingCodecProfile = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.contentEncodingCodecProfile)
                case .contentEncodingContainerFormat:
                    options.contentEncodingContainerFormat = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.contentEncodingContainerFormat)
                case .contentCustomDimension1:
                    options.contentCustomDimension1 = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.contentCustomDimension1)
                case .contentCustomDimension2:
                    options.contentCustomDimension2 = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.contentCustomDimension2)
                case .contentCustomDimension3:
                    options.contentCustomDimension3 = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.contentCustomDimension3)
                case .contentCustomDimension4:
                    options.contentCustomDimension4 = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.contentCustomDimension4)
                case .contentCustomDimension5:
                    options.contentCustomDimension5 = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.contentCustomDimension5)
                case .contentCustomDimension6:
                    options.contentCustomDimension6 = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.contentCustomDimension6)
                case .contentCustomDimension7:
                    options.contentCustomDimension7 = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.contentCustomDimension7)
                case .contentCustomDimension8:
                    options.contentCustomDimension8 = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.contentCustomDimension8)
                case .contentCustomDimension9:
                    options.contentCustomDimension9 = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.contentCustomDimension9)
                case .contentCustomDimension10:
                    options.contentCustomDimension10 = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.contentCustomDimension10)
                case .contentCustomDimension11:
                    options.contentCustomDimension11 = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.contentCustomDimension11)
                case .contentCustomDimension12:
                    options.contentCustomDimension12 = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.contentCustomDimension12)
                case .contentCustomDimension13:
                    options.contentCustomDimension13 = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.contentCustomDimension13)
                case .contentCustomDimension14:
                    options.contentCustomDimension14 = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.contentCustomDimension14)
                case .contentCustomDimension15:
                    options.contentCustomDimension15 = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.contentCustomDimension15)
                case .contentCustomDimension16:
                    options.contentCustomDimension16 = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.contentCustomDimension16)
                case .contentCustomDimension17:
                    options.contentCustomDimension17 = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.contentCustomDimension17)
                case .contentCustomDimension18:
                    options.contentCustomDimension18 = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.contentCustomDimension18)
                case .contentCustomDimension19:
                    options.contentCustomDimension19 = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.contentCustomDimension19)
                case .contentCustomDimension20:
                    options.contentCustomDimension20 = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.contentCustomDimension20)
                case .customDimension1:
                    options.customDimension1 = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.customDimension1)
                case .customDimension2:
                    options.customDimension2 = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.customDimension2)
                case .customDimension3:
                    options.customDimension3 = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.customDimension3)
                case .customDimension4:
                    options.customDimension4 = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.customDimension4)
                case .customDimension5:
                    options.customDimension5 = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.customDimension5)
                case .customDimension6:
                    options.customDimension6 = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.customDimension6)
                case .customDimension7:
                    options.customDimension7 = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.customDimension7)
                case .customDimension8:
                    options.customDimension8 = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.customDimension8)
                case .customDimension9:
                    options.customDimension9 = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.customDimension9)
                case .customDimension10:
                    options.customDimension10 = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.customDimension10)
                case .customDimension11:
                    options.customDimension11 = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.customDimension11)
                case .customDimension12:
                    options.customDimension12 = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.customDimension12)
                case .customDimension13:
                    options.customDimension13 = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.customDimension13)
                case .customDimension14:
                    options.customDimension14 = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.customDimension14)
                case .customDimension15:
                    options.customDimension15 = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.customDimension15)
                case .customDimension16:
                    options.customDimension16 = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.customDimension16)
                case .customDimension17:
                    options.customDimension17 = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.customDimension17)
                case .customDimension18:
                    options.customDimension18 = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.customDimension18)
                case .customDimension19:
                    options.customDimension19 = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.customDimension19)
                case .customDimension20:
                    options.customDimension20 = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.customDimension20)
                case .adMetadata:
                    options.adMetadata = YBOptionsValidator<[String: Any]>.validateValue(values: json, key: keyValue, defaultValue: options.adMetadata)
                case .adsAfterStop:
                    options.adsAfterStop = YBOptionsValidator<NSNumber>.validateValue(values: json, key: keyValue, defaultValue: options.adsAfterStop)
                case .adCampaign:
                    options.adCampaign = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.adCampaign)
                case .adTitle:
                    options.adTitle = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.adTitle)
                case .adResource:
                    options.adResource = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.adResource)
                case .adGivenBreaks:
                    options.adGivenBreaks = YBOptionsValidator<NSNumber>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.adGivenBreaks)
                case .adExpectedBreaks:
                    options.adExpectedBreaks = YBOptionsValidator<NSNumber>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.adExpectedBreaks)
                case .adExpectedPattern:
                    options.adExpectedPattern = YBOptionsValidator<[String: [NSNumber]]>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.adExpectedPattern)
                case .adBreaksTime:
                    options.adBreaksTime = YBOptionsValidator<[Any]>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.adBreaksTime)
                case .adGivenAds:
                    options.adGivenAds = YBOptionsValidator<NSNumber>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.adGivenAds)
                case .adCreativeId:
                    options.adCreativeId = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.adCreativeId)
                case .adProvider:
                    options.adProvider = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.adProvider)
                case .adCustomDimension1:
                    options.adCustomDimension1 = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.adCustomDimension1)
                case .adCustomDimension2:
                    options.adCustomDimension2 = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.adCustomDimension2)
                case .adCustomDimension3:
                    options.adCustomDimension3 = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.adCustomDimension3)
                case .adCustomDimension4:
                    options.adCustomDimension4 = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.adCustomDimension4)
                case .adCustomDimension5:
                    options.adCustomDimension5 = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.adCustomDimension5)
                case .adCustomDimension6:
                    options.adCustomDimension6 = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.adCustomDimension6)
                case .adCustomDimension7:
                    options.adCustomDimension7 = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.adCustomDimension7)
                case .adCustomDimension8:
                    options.adCustomDimension8 = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.adCustomDimension8)
                case .adCustomDimension9:
                    options.adCustomDimension9 = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.adCustomDimension9)
                case .adCustomDimension10:
                    options.adCustomDimension10 = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.adCustomDimension10)
                case .adExtraparam1:
                    options.adExtraparam1 = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.adExtraparam1)
                case .adExtraparam2:
                    options.adExtraparam2 = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.adExtraparam2)
                case .adExtraparam3:
                    options.adExtraparam3 = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.adExtraparam3)
                case .adExtraparam4:
                    options.adExtraparam4 = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.adExtraparam4)
                case .adExtraparam5:
                    options.adExtraparam5 = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.adExtraparam5)
                case .adExtraparam6:
                    options.adExtraparam6 = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.adExtraparam6)
                case .adExtraparam7:
                    options.adExtraparam7 = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.adExtraparam7)
                case .adExtraparam8:
                    options.adExtraparam8 = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.adExtraparam8)
                case .adExtraparam9:
                    options.adExtraparam9 = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.adExtraparam9)
                case .adExtraparam10:
                    options.adExtraparam10 = YBOptionsValidator<String>.validateOptionalValue(values: json, key: keyValue, defaultValue: options.adExtraparam10)
                }
            } else {
                invalidKeys.append(keyValue)
            }
        }
        
        if invalidKeys.count > 0 {
            let invalidResult = invalidKeys.reduce("", { (accumulator, invalidKey) -> String in
                if accumulator.isEmpty {
                    return invalidKey
                } else {
                    return "\(accumulator), \(invalidKey)"
                }
            })
            
            YBSwiftLog.warn("the follow properties %@ don't exist ", invalidResult)
        }
        
        return options
    }
    
    static func convertToJson(options: YBOptions) -> [String : Any] {
        var json: [String: Any] = [:]
        
        for property in YBOptionsKeys.Property.allCases {
            let keyValue = YBOptionsKeys.getPropertyKey(property: property)
            switch property {
            case .enabled: json[keyValue] = options.enabled
            case .httpSecure: json[keyValue] = options.httpSecure
            case .host: json[keyValue] = options.host
            case .accountCode: json[keyValue] = options.accountCode
            case .parseResource: json[keyValue] = options.parseResource
            case .parseHls: json[keyValue] = options.parseHls
            case .parseDash: json[keyValue] = options.parseDash
            case .parseLocationHeader: json[keyValue] = options.parseLocationHeader
            case .parseCdnNameHeader: json[keyValue] = options.parseCdnNameHeader
            case .parseCdnNode: json[keyValue] = options.parseCdnNode
            case .parseCdnNodeList: json[keyValue] = options.parseCdnNodeList
            case .cdnSwitchHeader: json[keyValue] = options.cdnSwitchHeader
            case .cdnTTL: json[keyValue] = options.cdnTTL
            case .experimentIds: json[keyValue] = options.experimentIds
            case .networkIP: json[keyValue] = options.networkIP
            case .networkIsp: json[keyValue] = options.networkIsp
            case .networkConnectionType: json[keyValue] = options.networkConnectionType
            case .forceInit: json[keyValue] = options.forceInit
            case .sendTotalBytes: json[keyValue] = options.sendTotalBytes
            case .sessionMetrics: json[keyValue] = options.sessionMetrics
            case .autoDetectBackground: json[keyValue] = options.autoDetectBackground
            case .offline: json[keyValue] = options.offline
            case .isInfinity: json[keyValue] = options.isInfinity
            case .smartswitchConfigCode: json[keyValue] = options.smartswitchConfigCode
            case .smartswitchGroupCode: json[keyValue] = options.smartswitchGroupCode
            case .smartswitchContractCode: json[keyValue] = options.smartswitchContractCode
            case .appName: json[keyValue] = options.appName
            case .appReleaseVersion: json[keyValue] = options.appReleaseVersion
            case .waitForMetadata: json[keyValue] = options.waitForMetadata
            case .pendingMetadata: json[keyValue] = options.pendingMetadata
            case .username: json[keyValue] = options.username
            case .userType: json[keyValue] = options.userType
            case .userEmail: json[keyValue] = options.userEmail
            case .networkObfuscateIp: json[keyValue] = options.networkObfuscateIp
            case .userObfuscateIp: json[keyValue] = options.userObfuscateIp
            case .anonymousUser: json[keyValue] = options.anonymousUser
            case .deviceCode: json[keyValue] = options.deviceCode
            case .deviceModel: json[keyValue] = options.deviceModel
            case .deviceBrand: json[keyValue] = options.deviceBrand
            case .deviceType: json[keyValue] = options.deviceType
            case .deviceName: json[keyValue] = options.deviceName
            case .deviceOsName: json[keyValue] = options.deviceOsName
            case .deviceOsVersion: json[keyValue] = options.deviceOsVersion
            case .deviceIsAnonymous: json[keyValue] = options.deviceIsAnonymous
            case .contentResource: json[keyValue] = options.contentResource
            case .contentIsLive: json[keyValue] = options.contentIsLive
            case .contentTitle: json[keyValue] = options.contentTitle
            case .contentTitle2: json[keyValue] = options.contentTitle2
            case .program: json[keyValue] = options.program
            case .contentDuration: json[keyValue] = options.contentDuration
            case .contentTransactionCode: json[keyValue] = options.contentTransactionCode
            case .contentBitrate: json[keyValue] = options.contentBitrate
            case .contentStreamingProtocol: json[keyValue] = options.contentStreamingProtocol
            case .contentTransportFormat: json[keyValue] = options.contentTransportFormat
            case .contentThroughput: json[keyValue] = options.contentThroughput
            case .contentRendition: json[keyValue] = options.contentRendition
            case .contentCdn: json[keyValue] = options.contentCdn
            case .contentFps: json[keyValue] = options.contentFps
            case .contentMetadata: json[keyValue] = options.contentMetadata
            case .contentMetrics: json[keyValue] = options.contentMetrics
            case .contentIsLiveNoSeek: json[keyValue] = options.contentIsLiveNoSeek
            case .contentPackage: json[keyValue] = options.contentPackage
            case .contentSaga: json[keyValue] = options.contentSaga
            case .contentTvShow: json[keyValue] = options.contentTvShow
            case .contentSeason: json[keyValue] = options.contentSeason
            case .contentEpisodeTitle: json[keyValue] = options.contentEpisodeTitle
            case .contentChannel: json[keyValue] = options.contentChannel
            case .contentId: json[keyValue] = options.contentId
            case .contentImdbId: json[keyValue] = options.contentImdbId
            case .contentGracenoteId: json[keyValue] = options.contentGracenoteId
            case .contentType: json[keyValue] = options.contentType
            case .contentGenre: json[keyValue] = options.contentGenre
            case .contentLanguage: json[keyValue] = options.contentLanguage
            case .contentSubtitles: json[keyValue] = options.contentSubtitles
            case .contentContractedResolution: json[keyValue] = options.contentContractedResolution
            case .contentCost: json[keyValue] = options.contentCost
            case .contentPrice: json[keyValue] = options.contentPrice
            case .contentPlaybackType: json[keyValue] = options.contentPlaybackType
            case .contentDrm: json[keyValue] = options.contentDrm
            case .contentEncodingVideoCodec: json[keyValue] = options.contentEncodingVideoCodec
            case .contentEncodingAudioCodec: json[keyValue] = options.contentEncodingAudioCodec
            case .contentEncodingCodecSettings: json[keyValue] = options.contentEncodingCodecSettings
            case .contentEncodingCodecProfile: json[keyValue] = options.contentEncodingCodecProfile
            case .contentEncodingContainerFormat: json[keyValue] = options.contentEncodingContainerFormat
            case .contentCustomDimension1: json[keyValue] = options.contentCustomDimension1
            case .contentCustomDimension2: json[keyValue] = options.contentCustomDimension2
            case .contentCustomDimension3: json[keyValue] = options.contentCustomDimension3
            case .contentCustomDimension4: json[keyValue] = options.contentCustomDimension4
            case .contentCustomDimension5: json[keyValue] = options.contentCustomDimension5
            case .contentCustomDimension6: json[keyValue] = options.contentCustomDimension6
            case .contentCustomDimension7: json[keyValue] = options.contentCustomDimension7
            case .contentCustomDimension8: json[keyValue] = options.contentCustomDimension8
            case .contentCustomDimension9: json[keyValue] = options.contentCustomDimension9
            case .contentCustomDimension10: json[keyValue] = options.contentCustomDimension10
            case .contentCustomDimension11: json[keyValue] = options.contentCustomDimension11
            case .contentCustomDimension12: json[keyValue] = options.contentCustomDimension12
            case .contentCustomDimension13: json[keyValue] = options.contentCustomDimension13
            case .contentCustomDimension14: json[keyValue] = options.contentCustomDimension14
            case .contentCustomDimension15: json[keyValue] = options.contentCustomDimension15
            case .contentCustomDimension16: json[keyValue] = options.contentCustomDimension16
            case .contentCustomDimension17: json[keyValue] = options.contentCustomDimension17
            case .contentCustomDimension18: json[keyValue] = options.contentCustomDimension18
            case .contentCustomDimension19: json[keyValue] = options.contentCustomDimension19
            case .contentCustomDimension20: json[keyValue] = options.contentCustomDimension20
            case .customDimension1: json[keyValue] = options.customDimension1
            case .customDimension2: json[keyValue] = options.customDimension2
            case .customDimension3: json[keyValue] = options.customDimension3
            case .customDimension4: json[keyValue] = options.customDimension4
            case .customDimension5: json[keyValue] = options.customDimension5
            case .customDimension6: json[keyValue] = options.customDimension6
            case .customDimension7: json[keyValue] = options.customDimension7
            case .customDimension8: json[keyValue] = options.customDimension8
            case .customDimension9: json[keyValue] = options.customDimension9
            case .customDimension10: json[keyValue] = options.customDimension10
            case .customDimension11: json[keyValue] = options.customDimension11
            case .customDimension12: json[keyValue] = options.customDimension12
            case .customDimension13: json[keyValue] = options.customDimension13
            case .customDimension14: json[keyValue] = options.customDimension14
            case .customDimension15: json[keyValue] = options.customDimension15
            case .customDimension16: json[keyValue] = options.customDimension16
            case .customDimension17: json[keyValue] = options.customDimension17
            case .customDimension18: json[keyValue] = options.customDimension18
            case .customDimension19: json[keyValue] = options.customDimension19
            case .customDimension20: json[keyValue] = options.customDimension20
            case .adMetadata: json[keyValue] = options.adMetadata
            case .adsAfterStop: json[keyValue] = options.adsAfterStop
            case .adCampaign: json[keyValue] = options.adCampaign
            case .adTitle: json[keyValue] = options.adTitle
            case .adResource: json[keyValue] = options.adResource
            case .adGivenBreaks: json[keyValue] = options.adGivenBreaks
            case .adExpectedBreaks: json[keyValue] = options.adExpectedBreaks
            case .adExpectedPattern: json[keyValue] = options.adExpectedPattern
            case .adBreaksTime: json[keyValue] = options.adBreaksTime
            case .adGivenAds: json[keyValue] = options.adGivenAds
            case .adCreativeId: json[keyValue] = options.adCreativeId
            case .adProvider: json[keyValue] = options.adProvider
            case .adCustomDimension1: json[keyValue] = options.adCustomDimension1
            case .adCustomDimension2: json[keyValue] = options.adCustomDimension2
            case .adCustomDimension3: json[keyValue] = options.adCustomDimension3
            case .adCustomDimension4: json[keyValue] = options.adCustomDimension4
            case .adCustomDimension5: json[keyValue] = options.adCustomDimension5
            case .adCustomDimension6: json[keyValue] = options.adCustomDimension6
            case .adCustomDimension7: json[keyValue] = options.adCustomDimension7
            case .adCustomDimension8: json[keyValue] = options.adCustomDimension8
            case .adCustomDimension9: json[keyValue] = options.adCustomDimension9
            case .adCustomDimension10: json[keyValue] = options.adCustomDimension10
            case .adExtraparam1: json[keyValue] = options.adExtraparam1
            case .adExtraparam2: json[keyValue] = options.adExtraparam2
            case .adExtraparam3: json[keyValue] = options.adExtraparam3
            case .adExtraparam4: json[keyValue] = options.adExtraparam4
            case .adExtraparam5: json[keyValue] = options.adExtraparam5
            case .adExtraparam6: json[keyValue] = options.adExtraparam6
            case .adExtraparam7: json[keyValue] = options.adExtraparam7
            case .adExtraparam8: json[keyValue] = options.adExtraparam8
            case .adExtraparam9: json[keyValue] = options.adExtraparam9
            case .adExtraparam10: json[keyValue] = options.adExtraparam10
            }
        }
        return json
    }
}

/// Class used to valid values that come from the json, the validation will check if the value exists
/// and if it contains a valid value format also it will set or not a default value depending on the validation result
class YBOptionsValidator<T>: NSObject {
    
    // Type alias to help with testing
    public typealias InvalidCompletion = () -> Void
    
    /**
     Method to validate if a value for key is valid or not and print an invalid message case not
     this method should only be called for non optional properties
     - Parameters:
     - values: Dictionary with all the values to be defined in options
     - key: key of the value to be validated
     - defaultValue: value to be returned case invalid or no result
     - invalidCompletion: completion block to allow to know when invalid is called during the testing
     - Returns: a valid result or default case value not founded or invalid
     */
    static public func validateValue(values: [String: Any?], key: String, defaultValue: T, invalidCompletion: InvalidCompletion? = nil) -> T {
        let containsValue = values[key] != nil
        
        if !containsValue { return defaultValue }
        
        guard let validValue = values[key] as? T else {
            printValueValidation(key: key, invalidCompletion: invalidCompletion)
            return defaultValue
        }
        
        return validValue
    }
    
    /**
     Method to validate if a value for key is valid or not and print an invalid message case not
     this method should only be called for optional properties
     - Parameters:
     - values: Dictionary with all the values to be defined in options
     - key: key of the value to be validated
     - defaultValue: value to be returned case invalid
     - invalidCompletion: completion block to allow to know when invalid is called during the testing
     - Returns: a valid result case everything ok, nil case no value defined or defaultValue case invalid
     */
    static public func validateOptionalValue(values: [String: Any?], key: String, defaultValue: T?, invalidCompletion: InvalidCompletion? = nil) -> T? {
        let containsValue = values[key] != nil
        
        if !containsValue { return nil }
        
        guard let validValue = values[key] as? T else {
            printValueValidation(key: key, invalidCompletion: invalidCompletion)
            return defaultValue
        }
        
        return validValue
    }
    
    /**
     Method to print error message case something wrong with the validation
     - Parameters:
     - key: key where the invalid value was found
     - invalidCompletion: completion block to allow to know when invalid is called during the testing
     */
    static public func printValueValidation(key: String, invalidCompletion: InvalidCompletion?) {
        
        if let invalidCompletion = invalidCompletion {
            invalidCompletion()
        }
        YBSwiftLog.warn("invalid value for option %@", key)
    }
}
