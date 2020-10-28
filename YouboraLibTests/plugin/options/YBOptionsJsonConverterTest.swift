//
//  YBOptionsJsonConverterTest.swift
//  YouboraLib
//
//  Created by Tiago Pereira on 28/10/2020.
//  Copyright © 2020 NPAW. All rights reserved.
//

import XCTest

class YBOptionsJsonConverterTest: XCTestCase {

    func testInvalidKeys() {
        var json: [String: Any] = [
            "a": "sdas",
            "b": "asdasd",
            "c": "asda",
            YBOptionsKeys.getPropertyKey(property: YBOptionsKeys.Property.enabled): true
        ]
        
        _ = YBOptionsJsonConverter.updateWithJson(json: json, options: YBOptions())
        
        XCTAssertTrue(YBOptionsJsonConverter.invalidKeys.count == 3)
        
        json = [
            YBOptionsKeys.getPropertyKey(property: YBOptionsKeys.Property.enabled): true,
            YBOptionsKeys.getPropertyKey(property: YBOptionsKeys.Property.accountCode): "accountCode"
        ]
        
        _ = YBOptionsJsonConverter.updateWithJson(json: json, options: YBOptions())
        XCTAssertTrue(YBOptionsJsonConverter.invalidKeys.count == 0)
    }

    func testDobleCastOptions() {
        var options = YBOptions()
        
        XCTAssertNil(options.isInfinity)
        XCTAssertNil(options.userObfuscateIp)
        XCTAssertNil(options.networkObfuscateIp)
        XCTAssertNil(options.contentIsLive)
        XCTAssertFalse(options.sendTotalBytes.boolValue)
        XCTAssertFalse(options.contentIsLiveNoSeek.boolValue)
        
        var json: [String: Any] = [
            YBOptionsKeys.getPropertyKey(property: YBOptionsKeys.Property.isInfinity): true,
            YBOptionsKeys.getPropertyKey(property: YBOptionsKeys.Property.userObfuscateIp): true,
            YBOptionsKeys.getPropertyKey(property: YBOptionsKeys.Property.contentIsLive): true,
            YBOptionsKeys.getPropertyKey(property: YBOptionsKeys.Property.sendTotalBytes): true,
            YBOptionsKeys.getPropertyKey(property: YBOptionsKeys.Property.contentIsLiveNoSeek): true,
            YBOptionsKeys.getPropertyKey(property: YBOptionsKeys.Property.networkObfuscateIp): true
        ]
        
        options = YBOptionsJsonConverter.updateWithJson(json: json, options: options)
        
        XCTAssertNotNil(options.isInfinity)
        XCTAssertNotNil(options.userObfuscateIp)
        XCTAssertNotNil(options.contentIsLive)
        XCTAssertNotNil(options.sendTotalBytes)
        XCTAssertTrue(options.isInfinity!.boolValue)
        XCTAssertTrue(options.userObfuscateIp!.boolValue)
        XCTAssertTrue(options.contentIsLive!.boolValue)
        XCTAssertTrue(options.sendTotalBytes.boolValue)
        XCTAssertTrue(options.contentIsLiveNoSeek.boolValue)
        XCTAssertTrue(options.networkObfuscateIp!.boolValue)
        
        json = [
            YBOptionsKeys.getPropertyKey(property: YBOptionsKeys.Property.isInfinity): NSNumber(value: false),
            YBOptionsKeys.getPropertyKey(property: YBOptionsKeys.Property.userObfuscateIp): NSNumber(value: false),
            YBOptionsKeys.getPropertyKey(property: YBOptionsKeys.Property.contentIsLive): NSNumber(value: false),
            YBOptionsKeys.getPropertyKey(property: YBOptionsKeys.Property.sendTotalBytes): NSNumber(value: false),
            YBOptionsKeys.getPropertyKey(property: YBOptionsKeys.Property.contentIsLiveNoSeek): NSNumber(value: false),
            YBOptionsKeys.getPropertyKey(property: YBOptionsKeys.Property.networkObfuscateIp): NSNumber(value: false)
        ]
        
        options = YBOptionsJsonConverter.updateWithJson(json: json, options: options)
        
        XCTAssertNotNil(options.isInfinity)
        XCTAssertNotNil(options.userObfuscateIp)
        XCTAssertNotNil(options.contentIsLive)
        XCTAssertNotNil(options.sendTotalBytes)
        XCTAssertFalse(options.isInfinity!.boolValue)
        XCTAssertFalse(options.userObfuscateIp!.boolValue)
        XCTAssertFalse(options.contentIsLive!.boolValue)
        XCTAssertFalse(options.sendTotalBytes.boolValue)
        XCTAssertFalse(options.contentIsLiveNoSeek.boolValue)
        XCTAssertFalse(options.networkObfuscateIp!.boolValue)
        
        json = [
            YBOptionsKeys.getPropertyKey(property: YBOptionsKeys.Property.isInfinity): "test",
            YBOptionsKeys.getPropertyKey(property: YBOptionsKeys.Property.userObfuscateIp): "test",
            YBOptionsKeys.getPropertyKey(property: YBOptionsKeys.Property.contentIsLive): "test",
            YBOptionsKeys.getPropertyKey(property: YBOptionsKeys.Property.sendTotalBytes): "test",
            YBOptionsKeys.getPropertyKey(property: YBOptionsKeys.Property.contentIsLiveNoSeek): "test",
            YBOptionsKeys.getPropertyKey(property: YBOptionsKeys.Property.networkObfuscateIp):"test"
        ]
        
        options = YBOptionsJsonConverter.updateWithJson(json: json, options: options)
        
        XCTAssertNotNil(options.isInfinity)
        XCTAssertNotNil(options.userObfuscateIp)
        XCTAssertNotNil(options.contentIsLive)
        XCTAssertNotNil(options.sendTotalBytes)
        XCTAssertFalse(options.isInfinity!.boolValue)
        XCTAssertFalse(options.userObfuscateIp!.boolValue)
        XCTAssertFalse(options.contentIsLive!.boolValue)
        XCTAssertFalse(options.sendTotalBytes.boolValue)
        XCTAssertFalse(options.contentIsLiveNoSeek.boolValue)
        XCTAssertFalse(options.networkObfuscateIp!.boolValue)
    }
    
    func testUpdateWithJson() {
        var accountCode = "accountCode"
        let enabled = false
        let parseCdnNodeList = ["a", "b", "c"]
        let networkIp = "networkIP"
        var sessionMetrics: [String: AnyHashable]? = [
            "a": "ada",
            "b": true,
            "c": 12
        ]
        let contentIsLive = false
        
        var json: [String: Any] = [
            YBOptionsKeys.getPropertyKey(property: YBOptionsKeys.Property.accountCode): accountCode,
            YBOptionsKeys.getPropertyKey(property: YBOptionsKeys.Property.enabled): enabled,
            YBOptionsKeys.getPropertyKey(property: YBOptionsKeys.Property.parseCdnNodeList): parseCdnNodeList,
            YBOptionsKeys.getPropertyKey(property: YBOptionsKeys.Property.networkIP): networkIp,
            YBOptionsKeys.getPropertyKey(property: YBOptionsKeys.Property.sessionMetrics): sessionMetrics as Any,
            YBOptionsKeys.getPropertyKey(property: YBOptionsKeys.Property.contentIsLive): contentIsLive
        ]
        
        var options = YBOptionsJsonConverter.updateWithJson(json: json, options: YBOptions())
        
        XCTAssertEqual(options.accountCode, accountCode)
        XCTAssertEqual(options.enabled, enabled)
        XCTAssertEqual(options.parseCdnNodeList, parseCdnNodeList)
        XCTAssertEqual(options.networkIP, networkIp)
        XCTAssertEqual(options.sessionMetrics, sessionMetrics)
        XCTAssertEqual(options.contentIsLive?.boolValue, contentIsLive)
        
        sessionMetrics = nil
        accountCode = "newAccount"
        
        json = [
            YBOptionsKeys.getPropertyKey(property: YBOptionsKeys.Property.accountCode): accountCode,
            YBOptionsKeys.getPropertyKey(property: YBOptionsKeys.Property.sessionMetrics): sessionMetrics as Any
        ]
        
        options = YBOptionsJsonConverter.updateWithJson(json: json, options: options)
        
        XCTAssertEqual(options.accountCode, accountCode)
        XCTAssertEqual(options.enabled, enabled)
        XCTAssertEqual(options.parseCdnNodeList, parseCdnNodeList)
        XCTAssertEqual(options.networkIP, networkIp)
        XCTAssertNil(options.sessionMetrics)
        XCTAssertEqual(options.contentIsLive?.boolValue, contentIsLive)
    }
    
    func testUpdateWithJsonAllOptions() {
        var json: [String: Any] = [:]
        
        for property in YBOptionsKeys.Property.allCases {
            switch property {
            case .enabled:  json["enabled"] = true
            case .httpSecure:  json["httpSecure"] = "test"
            case .host:   json["host"] = "test"
            case .accountCode:  json["accountCode"] = "test"
            case .parseResource: json["parseResource"] = "test"
            case .parseHls:  json["parseHls"] = "test"
            case .parseDash:  json["parseDash"] = "test"
            case .parseLocationHeader: json["parseLocationHeader"] = "test"
            case .parseCdnNameHeader: json["parseCdnNameHeader"] = "test"
            case .parseCdnNode: json["parseCdnNode"] = "test"
            case .parseCdnNodeList: json["parseCdnNodeList"] = "test"
            case .cdnSwitchHeader: json["cdnSwitchHeader"] = "test"
            case .cdnTTL:  json["cdnTTL"] = "test"
            case .experimentIds: json["experimentIds"] = "test"
            case .networkIP:  json["networkIP"] = "test"
            case .networkIsp:  json["networkIsp"] = "test"
            case .networkConnectionType: json["networkConnectionType"] = "test"
            case .forceInit:  json["forceInit"] = "test"
            case .sendTotalBytes: json["sendTotalBytes"] = "test"
            case .sessionMetrics: json["sessionMetrics"] = "test"
            case .autoDetectBackground: json["autoDetectBackground"] = "test"
            case .offline:  json["offline"] = "test"
            case .isInfinity:  json["isInfinity"] = NSNumber(value: false)
            case .smartswitchConfigCode: json["smartswitchConfigCode"] = "test"
            case .smartswitchGroupCode: json["smartswitchGroupCode"] = "test"
            case .smartswitchContractCode: json["smartswitchContractCode"] = "test"
            case .appName:  json["appName"] = "test"
            case .appReleaseVersion: json["appReleaseVersion"] = "test"
            case .waitForMetadata: json["waitForMetadata"] = "test"
            case .pendingMetadata: json["pendingMetadata"] = "test"
            case .username:  json["username"] = "test"
            case .userType:  json["userType"] = "test"
            case .userEmail:  json["userEmail"] = "test"
            case .networkObfuscateIp: json["networkObfuscateIp"] = "test"
            case .userObfuscateIp: json["userObfuscateIp"] = "test"
            case .anonymousUser: json["anonymousUser"] = "test"
            case .deviceCode:  json["deviceCode"] = "test"
            case .deviceModel:  json["deviceModel"] = "test"
            case .deviceBrand:  json["deviceBrand"] = "test"
            case .deviceType:  json["deviceType"] = "test"
            case .deviceName:  json["deviceName"] = "test"
            case .deviceOsName: json["deviceOsName"] = "test"
            case .deviceOsVersion: json["deviceOsVersion"] = "test"
            case .deviceIsAnonymous: json["deviceIsAnonymous"] = "test"
            case .contentResource: json["contentResource"] = "test"
            case .contentIsLive: json["contentIsLive"] = "test"
            case .contentTitle: json["contentTitle"] = "test"
            case .contentTitle2: json["contentTitle2"] = "test"
            case .program:  json["program"] = "test"
            case .contentDuration: json["contentDuration"] = "test"
            case .contentTransactionCode: json["contentTransactionCode"] = "test"
            case .contentBitrate: json["contentBitrate"] = "test"
            case .contentStreamingProtocol: json["contentStreamingProtocol"] = "test"
            case .contentTransportFormat: json["contentTransportFormat"] = "test"
            case .contentThroughput: json["contentThroughput"] = "test"
            case .contentRendition: json["contentRendition"] = "test"
            case .contentCdn:  json["contentCdn"] = "test"
            case .contentFps:  json["contentFps"] = "test"
            case .contentMetadata: json["contentMetadata"] = "test"
            case .contentMetrics: json["contentMetrics"] = "test"
            case .contentIsLiveNoSeek: json["contentIsLiveNoSeek"] = false
            case .contentPackage: json["contentPackage"] = "test"
            case .contentSaga:  json["contentSaga"] = "test"
            case .contentTvShow: json["contentTvShow"] = "test"
            case .contentSeason: json["contentSeason"] = "test"
            case .contentEpisodeTitle: json["contentEpisodeTitle"] = "test"
            case .contentChannel: json["contentChannel"] = "test"
            case .contentId:  json["contentId"] = "test"
            case .contentImdbId: json["contentImdbId"] = "test"
            case .contentGracenoteId: json["contentGracenoteId"] = "test"
            case .contentType:  json["contentType"] = "test"
            case .contentGenre: json["contentGenre"] = "test"
            case .contentLanguage: json["contentLanguage"] = "test"
            case .contentSubtitles: json["contentSubtitles"] = "test"
            case .contentContractedResolution: json["contentContractedResolution"] = "test"
            case .contentCost:  json["contentCost"] = "test"
            case .contentPrice: json["contentPrice"] = "test"
            case .contentPlaybackType: json["contentPlaybackType"] = "test"
            case .contentDrm:  json["contentDrm"] = "test"
            case .contentEncodingVideoCodec: json["contentEncodingVideoCodec"] = "test"
            case .contentEncodingAudioCodec: json["contentEncodingAudioCodec"] = "test"
            case .contentEncodingCodecSettings: json["contentEncodingCodecSettings"] = "test"
            case .contentEncodingCodecProfile: json["contentEncodingCodecProfile"] = "test"
            case .contentEncodingContainerFormat: json["contentEncodingContainerFormat"] = "test"
            case .contentCustomDimension1: json["contentCustomDimension1"] = "test"
            case .contentCustomDimension2: json["contentCustomDimension2"] = "test"
            case .contentCustomDimension3: json["contentCustomDimension3"] = "test"
            case .contentCustomDimension4: json["contentCustomDimension4"] = "test"
            case .contentCustomDimension5: json["contentCustomDimension5"] = "test"
            case .contentCustomDimension6: json["contentCustomDimension6"] = "test"
            case .contentCustomDimension7: json["contentCustomDimension7"] = "test"
            case .contentCustomDimension8: json["contentCustomDimension8"] = "test"
            case .contentCustomDimension9: json["contentCustomDimension9"] = "test"
            case .contentCustomDimension10: json["contentCustomDimension10"] = "test"
            case .contentCustomDimension11: json["contentCustomDimension11"] = "test"
            case .contentCustomDimension12: json["contentCustomDimension12"] = "test"
            case .contentCustomDimension13: json["contentCustomDimension13"] = "test"
            case .contentCustomDimension14: json["contentCustomDimension14"] = "test"
            case .contentCustomDimension15: json["contentCustomDimension15"] = "test"
            case .contentCustomDimension16: json["contentCustomDimension16"] = "test"
            case .contentCustomDimension17: json["contentCustomDimension17"] = "test"
            case .contentCustomDimension18: json["contentCustomDimension18"] = "test"
            case .contentCustomDimension19: json["contentCustomDimension19"] = "test"
            case .contentCustomDimension20: json["contentCustomDimension20"] = "test"
            case .customDimension1: json["customDimension1"] = "test"
            case .customDimension2: json["customDimension2"] = "test"
            case .customDimension3: json["customDimension3"] = "test"
            case .customDimension4: json["customDimension4"] = "test"
            case .customDimension5: json["customDimension5"] = "test"
            case .customDimension6: json["customDimension6"] = "test"
            case .customDimension7: json["customDimension7"] = "test"
            case .customDimension8: json["customDimension8"] = "test"
            case .customDimension9: json["customDimension9"] = "test"
            case .customDimension10: json["customDimension10"] = "test"
            case .customDimension11: json["customDimension11"] = "test"
            case .customDimension12: json["customDimension12"] = "test"
            case .customDimension13: json["customDimension13"] = "test"
            case .customDimension14: json["customDimension14"] = "test"
            case .customDimension15: json["customDimension15"] = "test"
            case .customDimension16: json["customDimension16"] = "test"
            case .customDimension17: json["customDimension17"] = "test"
            case .customDimension18: json["customDimension18"] = "test"
            case .customDimension19: json["customDimension19"] = "test"
            case .customDimension20: json["customDimension20"] = "test"
            case .adMetadata:  json["adMetadata"] = "test"
            case .adsAfterStop: json["adsAfterStop"] = "test"
            case .adCampaign:  json["adCampaign"] = "test"
            case .adTitle:  json["adTitle"] = "title"
            case .adResource:  json["adResource"] = "test"
            case .adGivenBreaks: json["adGivenBreaks"] = "test"
            case .adExpectedBreaks: json["adExpectedBreaks"] = "test"
            case .adExpectedPattern: json["adExpectedPattern"] = "test"
            case .adBreaksTime: json["adBreaksTime"] = "test"
            case .adGivenAds: json["adGivenAds"] = "test"
            case .adCreativeId: json["adCreativeId"] = "test"
            case .adProvider: json["adProvider"] = "test"
            case .adCustomDimension1: json["adCustomDimension1"] = "test"
            case .adCustomDimension2: json["adCustomDimension2"] = "test"
            case .adCustomDimension3: json["adCustomDimension3"] = "test"
            case .adCustomDimension4: json["adCustomDimension4"] = "test"
            case .adCustomDimension5: json["adCustomDimension5"] = "test"
            case .adCustomDimension6: json["adCustomDimension6"] = "test"
            case .adCustomDimension7: json["adCustomDimension7"] = "test"
            case .adCustomDimension8: json["adCustomDimension8"] = "test"
            case .adCustomDimension9: json["adCustomDimension9"] = "test"
            case .adCustomDimension10: json["adCustomDimension10"] = "test"
            case .adExtraparam1: json["adExtraparam1"] = "test"
            case .adExtraparam2: json["adExtraparam2"] = "test"
            case .adExtraparam3: json["adExtraparam3"] = "test"
            case .adExtraparam4: json["adExtraparam4"] = "test"
            case .adExtraparam5: json["adExtraparam5"] = "test"
            case .adExtraparam6: json["adExtraparam6"] = "test"
            case .adExtraparam7: json["adExtraparam7"] = "test"
            case .adExtraparam8: json["adExtraparam8"] = "test"
            case .adExtraparam9: json["adExtraparam9"] = "test"
            case .adExtraparam10: json["adExtraparam10"] = "test"
            }
        }
        
        let defaultOptions = YBOptions()
        let options = YBOptionsJsonConverter.updateWithJson(json: json, options: defaultOptions)
        
        XCTAssertEqual(options.enabled, true)
        XCTAssertEqual(options.isInfinity?.boolValue, false)
        XCTAssertEqual(options.contentIsLiveNoSeek.boolValue, false)
        XCTAssertEqual(options.contentDuration, nil)
        XCTAssertEqual(options.httpSecure, defaultOptions.httpSecure)
        
        json["contentIsLiveNoSeek"] = "test"
        
        let lastOptions = YBOptionsJsonConverter.updateWithJson(json: json, options: options)
        
        XCTAssertEqual(options.contentIsLiveNoSeek, lastOptions.contentIsLiveNoSeek)
        
    }
    
    func testConvertOptions() {
        let options = YBOptions()
        
        let json = YBOptionsJsonConverter.convertOptions(options: options)
        
        let accountCode = json[YBOptionsKeys.getPropertyKey(property: YBOptionsKeys.Property.accountCode)] as? String
        let enabled = json[YBOptionsKeys.getPropertyKey(property: YBOptionsKeys.Property.enabled)] as? Bool
        let parseCdnNodeList = json[YBOptionsKeys.getPropertyKey(property: YBOptionsKeys.Property.parseCdnNodeList)] as? [String]
        let networkIP = json[YBOptionsKeys.getPropertyKey(property: YBOptionsKeys.Property.networkIP)] as? String
        let sessionMetrics = json[YBOptionsKeys.getPropertyKey(property: YBOptionsKeys.Property.sessionMetrics)] as? [String: AnyHashable]
        let contentIsLive = json[YBOptionsKeys.getPropertyKey(property: YBOptionsKeys.Property.contentIsLive)] as? NSNumber
        
        XCTAssertEqual(options.accountCode, accountCode)
        XCTAssertEqual(options.enabled, enabled)
        XCTAssertEqual(options.parseCdnNodeList, parseCdnNodeList)
        XCTAssertEqual(options.networkIP, networkIP)
        XCTAssertEqual(options.sessionMetrics, sessionMetrics)
    }
}
