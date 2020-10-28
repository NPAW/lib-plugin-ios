//
//  YBOptionsFactoryTest.swift
//  YouboraLib
//
//  Created by Tiago Pereira on 28/10/2020.
//  Copyright © 2020 NPAW. All rights reserved.
//

import XCTest

class YBOptionsFactoryTest: XCTestCase {

    var defaultOptions: YBOptions!
    
    override func setUp() {
        self.defaultOptions = YBOptions()
    }
    
    func testCreateOptions() {
        let options = YBOptionsFactory.createOptions()
        
        XCTAssertEqual(options.accountCode, defaultOptions.accountCode)
        XCTAssertEqual(options.enabled, defaultOptions.enabled)
        XCTAssertEqual(options.adMetadata, defaultOptions.adMetadata)
        XCTAssertEqual(options.contentIsLive, defaultOptions.contentIsLive)
    }
    
    func testCreateOptionsWithJson() {
        let accountCode = "accountCode"
        let enabled = false
        let parseCdnNodeList = ["a", "b", "c"]
        let networkIp = "networkIP"
        let sessionMetrics: [String: AnyHashable]? = [
            "a": "ada",
            "b": true,
            "c": 12
        ]
        let contentIsLive = false
        
        let json: [String: Any] = [
            YBOptionsKeys.getPropertyKey(property: YBOptionsKeys.Property.accountCode): accountCode,
            YBOptionsKeys.getPropertyKey(property: YBOptionsKeys.Property.enabled): enabled,
            YBOptionsKeys.getPropertyKey(property: YBOptionsKeys.Property.parseCdnNodeList): parseCdnNodeList,
            YBOptionsKeys.getPropertyKey(property: YBOptionsKeys.Property.networkIP): networkIp,
            YBOptionsKeys.getPropertyKey(property: YBOptionsKeys.Property.sessionMetrics): sessionMetrics as Any,
            YBOptionsKeys.getPropertyKey(property: YBOptionsKeys.Property.contentIsLive): contentIsLive
        ]
        
        let options = YBOptionsFactory.createOptions(json: json)
        
        XCTAssertEqual(options.accountCode, accountCode)
        XCTAssertEqual(options.enabled, enabled)
        XCTAssertEqual(options.parseCdnNodeList, parseCdnNodeList)
        XCTAssertEqual(options.networkIP, networkIp)
        XCTAssertEqual(options.sessionMetrics, sessionMetrics)
        XCTAssertEqual(options.contentIsLive?.boolValue, contentIsLive)
    }
    
    func testUpdateOptionsWithJson() {
        let options = YBOptions()
        
        XCTAssertEqual(options.accountCode, defaultOptions.accountCode)
        XCTAssertEqual(options.enabled, defaultOptions.enabled)
        XCTAssertEqual(options.parseCdnNodeList, defaultOptions.parseCdnNodeList)
        XCTAssertEqual(options.networkIP, defaultOptions.networkIP)
        XCTAssertEqual(options.sessionMetrics, defaultOptions.sessionMetrics)
        XCTAssertEqual(options.contentIsLive, defaultOptions.contentIsLive)
        
        let accountCode = "accountCode"
        let enabled = false
        let parseCdnNodeList = ["a", "b", "c"]
        let networkIp = "networkIP"
        let sessionMetrics: [String: AnyHashable]? = [
            "a": "ada",
            "b": true,
            "c": 12
        ]
        let contentIsLive = false
        
        let json: [String: Any] = [
            YBOptionsKeys.getPropertyKey(property: YBOptionsKeys.Property.accountCode): accountCode,
            YBOptionsKeys.getPropertyKey(property: YBOptionsKeys.Property.enabled): enabled,
            YBOptionsKeys.getPropertyKey(property: YBOptionsKeys.Property.parseCdnNodeList): parseCdnNodeList,
            YBOptionsKeys.getPropertyKey(property: YBOptionsKeys.Property.networkIP): networkIp,
            YBOptionsKeys.getPropertyKey(property: YBOptionsKeys.Property.sessionMetrics): sessionMetrics as Any,
            YBOptionsKeys.getPropertyKey(property: YBOptionsKeys.Property.contentIsLive): contentIsLive
        ]
        
        let newOptions = YBOptionsFactory.createOptions(json: json, options: options)
        
        XCTAssertEqual(newOptions.accountCode, accountCode)
        XCTAssertEqual(newOptions.enabled, enabled)
        XCTAssertEqual(newOptions.parseCdnNodeList, parseCdnNodeList)
        XCTAssertEqual(newOptions.networkIP, networkIp)
        XCTAssertEqual(newOptions.sessionMetrics, sessionMetrics)
        XCTAssertEqual(newOptions.contentIsLive?.boolValue, contentIsLive)
    }
    
    func testCreateJson() {
        let options = YBOptions()
        options.adCampaign = "test"
        options.adExpectedPattern = [
            "a": [2, 3, 4],
            "b": [1, 2, 3]
        ]
        options.cdnTTL = 10.0
        options.appReleaseVersion = "appReleaseVersion"
        options.contentDuration = NSNumber(10)
        options.contentThroughput = 20
        
        let json = YBOptionsFactory.createJson(options: options)
        
        let adCampaign = json[YBOptionsKeys.getPropertyKey(property: YBOptionsKeys.Property.adCampaign)] as? String
        let adExpectedPattern = json[YBOptionsKeys.getPropertyKey(property: YBOptionsKeys.Property.adExpectedPattern)] as? [String: [NSNumber]]
        let cdnTTL = json[YBOptionsKeys.getPropertyKey(property: YBOptionsKeys.Property.cdnTTL)] as? TimeInterval
        let appReleaseVersion = json[YBOptionsKeys.getPropertyKey(property: YBOptionsKeys.Property.appReleaseVersion)] as? String
        let contentDuration = json[YBOptionsKeys.getPropertyKey(property: YBOptionsKeys.Property.contentDuration)] as? NSNumber
        let contentThroughput = json[YBOptionsKeys.getPropertyKey(property: YBOptionsKeys.Property.contentThroughput)] as? NSNumber
        
        XCTAssertEqual(options.adCampaign, adCampaign)
        XCTAssertEqual(options.adExpectedPattern, adExpectedPattern)
        XCTAssertEqual(options.cdnTTL, cdnTTL)
        XCTAssertEqual(options.appReleaseVersion, appReleaseVersion)
        XCTAssertEqual(options.contentDuration, contentDuration)
        XCTAssertEqual(options.contentThroughput, contentThroughput)
    }

}
