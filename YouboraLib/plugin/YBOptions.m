//
//  YBOptions.m
//  YouboraLib
//
//  Created by Joan on 17/03/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import "YBOptions.h"
#import "YBCdnParser.h"

@implementation YBOptions

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self defaultValues];
    }
    return self;
}

- (nullable instancetype)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self) {
        self.enabled = [[decoder decodeObjectForKey:@"enabled"] isEqualToValue:@YES];
        self.httpSecure = [[decoder decodeObjectForKey:@"httpSecure"] isEqualToValue:@YES];
        self.host = [decoder decodeObjectForKey:@"host"];
        self.accountCode = [decoder decodeObjectForKey:@"accountCode"];
        self.username = [decoder decodeObjectForKey:@"username"];
        self.userType = [decoder decodeObjectForKey:@"userType"];
        self.parseHls = [[decoder decodeObjectForKey:@"parseHls"] isEqualToValue:@YES];
        self.parseCdnNameHeader = [decoder decodeObjectForKey:@"parseCdnNameHeader"];
        self.parseCdnNode = [[decoder decodeObjectForKey:@"parseCdnNode"] isEqualToValue:@YES];
        self.parseCdnNodeList = [decoder decodeObjectForKey:@"parseCdnNodeList"];
        self.experimentIds = [decoder decodeObjectForKey:@"experiments"];
        self.networkIP = [decoder decodeObjectForKey:@"networkIP"];
        self.networkIsp = [decoder decodeObjectForKey:@"networkIsp"];
        self.networkConnectionType = [decoder decodeObjectForKey:@"networkConnectionType"];
        self.networkObfuscateIp = [decoder decodeObjectForKey:@"networkObfuscateIp"];
        self.deviceCode = [decoder decodeObjectForKey:@"deviceCode"];
        self.forceInit = [decoder decodeObjectForKey:@"forceInit"];
        self.deviceModel = [decoder decodeObjectForKey:@"deviceModel"];
        self.deviceBrand = [decoder decodeObjectForKey:@"deviceBrand"];
        self.deviceType = [decoder decodeObjectForKey:@"deviceType"];
        self.deviceOsName = [decoder decodeObjectForKey:@"deviceOsName"];
        self.deviceOsVersion = [decoder decodeObjectForKey:@"deviceOsVersion"];
        self.contentResource = [decoder decodeObjectForKey:@"contentResource"];
        self.contentIsLive = [decoder decodeObjectForKey:@"contentIsLive"];
        self.contentTitle = [decoder decodeObjectForKey:@"contentTitle"];
        self.program = [decoder decodeObjectForKey:@"program"];
        self.contentDuration = [decoder decodeObjectForKey:@"contentDuration"];
        self.contentTransactionCode = [decoder decodeObjectForKey:@"contentTransactionCode"];
        self.contentStreamingProtocol = [decoder decodeObjectForKey:@"contentStreamingProtocol"];
        self.contentBitrate = [decoder decodeObjectForKey:@"contentBitrate"];
        self.contentThroughput = [decoder decodeObjectForKey:@"contentThroughput"];
        self.contentRendition = [decoder decodeObjectForKey:@"contentRendition"];
        self.contentCdn = [decoder decodeObjectForKey:@"contentCdn"];
        self.contentFps = [decoder decodeObjectForKey:@"contentFps"];
        self.contentMetadata = [decoder decodeObjectForKey:@"contentMetadata"];
        self.contentIsLiveNoSeek = [decoder decodeObjectForKey:@"contentIsLiveNoSeek"];
        self.adMetadata = [decoder decodeObjectForKey:@"adMetadata"];
        self.adsAfterStop = [decoder decodeObjectForKey:@"adsAfterStop"];
        self.adCampaign = [decoder decodeObjectForKey:@"adCampaign"];
        self.adTitle = [decoder decodeObjectForKey:@"adTitle"];
        self.adResource = [decoder decodeObjectForKey:@"adResource"];
        self.autoDetectBackground = [decoder decodeObjectForKey:@"autoDetectBackground"];
        self.offline = [decoder decodeObjectForKey:@"offline"];
        self.anonymousUser = [decoder decodeObjectForKey:@"anonymousUser"];
        self.isInfinity = [decoder decodeObjectForKey:@"isInfinity"];
        self.smartswitchConfigCode = [decoder decodeObjectForKey:@"smartswitchConfigCode"];
        self.smartswitchGroupCode = [decoder decodeObjectForKey:@"smartswitchGroupCode"];
        self.smartswitchContractCode = [decoder decodeObjectForKey:@"smartswitchContractCode"];
        self.customDimension1 = [decoder decodeObjectForKey:@"customDimension1"];
        self.customDimension2 = [decoder decodeObjectForKey:@"customDimension2"];
        self.customDimension3 = [decoder decodeObjectForKey:@"customDimension3"];
        self.customDimension4 = [decoder decodeObjectForKey:@"customDimension4"];
        self.customDimension5 = [decoder decodeObjectForKey:@"customDimension5"];
        self.customDimension6 = [decoder decodeObjectForKey:@"customDimension6"];
        self.customDimension7 = [decoder decodeObjectForKey:@"customDimension7"];
        self.customDimension8 = [decoder decodeObjectForKey:@"customDimension8"];
        self.customDimension9 = [decoder decodeObjectForKey:@"customDimension9"];
        self.customDimension10 = [decoder decodeObjectForKey:@"customDimension10"];
        self.customDimension11 = [decoder decodeObjectForKey:@"customDimension11"];
        self.customDimension12 = [decoder decodeObjectForKey:@"customDimension12"];
        self.customDimension13 = [decoder decodeObjectForKey:@"customDimension13"];
        self.customDimension14 = [decoder decodeObjectForKey:@"customDimension14"];
        self.customDimension15 = [decoder decodeObjectForKey:@"customDimension15"];
        self.customDimension16 = [decoder decodeObjectForKey:@"customDimension16"];
        self.customDimension17 = [decoder decodeObjectForKey:@"customDimension17"];
        self.customDimension18 = [decoder decodeObjectForKey:@"customDimension18"];
        self.customDimension19 = [decoder decodeObjectForKey:@"customDimension19"];
        self.customDimension20 = [decoder decodeObjectForKey:@"customDimension20"];
        self.adCustomDimension1 = [decoder decodeObjectForKey:@"adCustomDimension1"];
        self.adCustomDimension2 = [decoder decodeObjectForKey:@"adCustomDimension2"];
        self.adCustomDimension3 = [decoder decodeObjectForKey:@"adCustomDimension3"];
        self.adCustomDimension4 = [decoder decodeObjectForKey:@"adCustomDimension4"];
        self.adCustomDimension5 = [decoder decodeObjectForKey:@"adCustomDimension5"];
        self.adCustomDimension6 = [decoder decodeObjectForKey:@"adCustomDimension6"];
        self.adCustomDimension7 = [decoder decodeObjectForKey:@"adCustomDimension7"];
        self.adCustomDimension8 = [decoder decodeObjectForKey:@"adCustomDimension8"];
        self.adCustomDimension9 = [decoder decodeObjectForKey:@"adCustomDimension9"];
        self.adCustomDimension10 = [decoder decodeObjectForKey:@"adCustomDimension10"];
        self.appName = [decoder decodeObjectForKey:@"appName"];
        self.appReleaseVersion = [decoder decodeObjectForKey:@"appReleaseVersion"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:@(self.enabled) forKey:@"enabled"];
    [coder encodeObject:@(self.httpSecure) forKey:@"httpSecure"];
    [coder encodeObject:self.host forKey:@"host"];
    [coder encodeObject:self.accountCode forKey:@"accountCode"];
    [coder encodeObject:self.username forKey:@"username"];
    [coder encodeObject:self.userType forKey:@"userType"];
    [coder encodeObject:@(self.parseHls) forKey:@"parseHls"];
    [coder encodeObject:self.parseCdnNameHeader forKey:@"parseCdnNameHeader"];
    [coder encodeObject:@(self.parseCdnNode) forKey:@"parseCdnNode"];
    [coder encodeObject:self.parseCdnNodeList forKey:@"parseCdnNodeList"];
    [coder encodeObject:self.experimentIds forKey:@"experiments"];
    [coder encodeObject:self.networkIP forKey:@"networkIP"];
    [coder encodeObject:self.networkIsp forKey:@"networkIsp"];
    [coder encodeObject:self.networkConnectionType forKey:@"networkConnectionType"];
    [coder encodeObject:self.networkObfuscateIp forKey:@"networkObfuscateIp"];
    [coder encodeObject:self.deviceCode forKey:@"deviceCode"];
    [coder encodeObject:@(self.forceInit) forKey:@"forceInit"];
    [coder encodeObject:self.deviceModel forKey:@"deviceModel"];
    [coder encodeObject:self.deviceBrand forKey:@"deviceBrand"];
    [coder encodeObject:self.deviceType forKey:@"deviceType"];
    [coder encodeObject:self.deviceName forKey:@"deviceName"];
    [coder encodeObject:self.deviceOsName forKey:@"deviceOsName"];
    [coder encodeObject:self.deviceOsVersion forKey:@"deviceOsVersion"];
    [coder encodeObject:self.contentStreamingProtocol forKey:@"contentStreamingProtocol"];
    [coder encodeObject:self.contentResource forKey:@"contentResource"];
    [coder encodeObject:self.contentIsLive forKey:@"contentIsLive"];
    [coder encodeObject:self.contentTitle forKey:@"contentTitle"];
    [coder encodeObject:self.program forKey:@"program"];
    [coder encodeObject:self.contentDuration forKey:@"contentDuration"];
    [coder encodeObject:self.contentTransactionCode forKey:@"contentTransactionCode"];
    [coder encodeObject:self.contentBitrate forKey:@"contentBitrate"];
    [coder encodeObject:self.contentThroughput forKey:@"contentThroughput"];
    [coder encodeObject:self.contentRendition forKey:@"contentRendition"];
    [coder encodeObject:self.contentCdn forKey:@"contentCdn"];
    [coder encodeObject:self.contentFps forKey:@"contentFps"];
    [coder encodeObject:self.contentMetadata forKey:@"contentMetadata"];
    [coder encodeObject:self.contentIsLiveNoSeek forKey:@"contentIsLiveNoSeek"];
    [coder encodeObject:self.adMetadata forKey:@"adMetadata"];
    [coder encodeObject:self.adsAfterStop forKey:@"adsAfterStop"];
    [coder encodeObject:self.adCampaign forKey:@"adCampaign"];
    [coder encodeObject:self.adTitle forKey:@"adTitle"];
    [coder encodeObject:self.adResource forKey:@"adResource"];
    [coder encodeObject:@(self.autoDetectBackground) forKey:@"autoDetectBackground"];
    [coder encodeObject:@(self.offline) forKey:@"offline"];
    [coder encodeObject:self.anonymousUser forKey:@"anonymousUser"];
    [coder encodeObject:self.isInfinity forKey:@"isInfinity"];
    [coder encodeObject:self.smartswitchConfigCode forKey:@"smartswitchConfigCode"];
    [coder encodeObject:self.smartswitchGroupCode forKey:@"smartswitchGroupCode"];
    [coder encodeObject:self.smartswitchContractCode forKey:@"smartswitchContractCode"];
    [coder encodeObject:self.customDimension1 forKey:@"customDimension1"];
    [coder encodeObject:self.customDimension2 forKey:@"customDimension2"];
    [coder encodeObject:self.customDimension3 forKey:@"customDimension3"];
    [coder encodeObject:self.customDimension4 forKey:@"customDimension4"];
    [coder encodeObject:self.customDimension5 forKey:@"customDimension5"];
    [coder encodeObject:self.customDimension6 forKey:@"customDimension6"];
    [coder encodeObject:self.customDimension7 forKey:@"customDimension7"];
    [coder encodeObject:self.customDimension8 forKey:@"customDimension8"];
    [coder encodeObject:self.customDimension9 forKey:@"customDimension9"];
    [coder encodeObject:self.customDimension10 forKey:@"customDimension10"];
    [coder encodeObject:self.customDimension11 forKey:@"customDimension11"];
    [coder encodeObject:self.customDimension12 forKey:@"customDimension12"];
    [coder encodeObject:self.customDimension13 forKey:@"customDimension13"];
    [coder encodeObject:self.customDimension14 forKey:@"customDimension14"];
    [coder encodeObject:self.customDimension15 forKey:@"customDimension15"];
    [coder encodeObject:self.customDimension16 forKey:@"customDimension16"];
    [coder encodeObject:self.customDimension17 forKey:@"customDimension17"];
    [coder encodeObject:self.customDimension18 forKey:@"customDimension18"];
    [coder encodeObject:self.customDimension19 forKey:@"customDimension19"];
    [coder encodeObject:self.customDimension20 forKey:@"customDimension20"];
    [coder encodeObject:self.adCustomDimension1 forKey:@"adCustomDimension1"];
    [coder encodeObject:self.adCustomDimension2 forKey:@"adCustomDimension2"];
    [coder encodeObject:self.adCustomDimension3 forKey:@"adCustomDimension3"];
    [coder encodeObject:self.adCustomDimension4 forKey:@"adCustomDimension4"];
    [coder encodeObject:self.adCustomDimension5 forKey:@"adCustomDimension5"];
    [coder encodeObject:self.adCustomDimension6 forKey:@"adCustomDimension6"];
    [coder encodeObject:self.adCustomDimension7 forKey:@"adCustomDimension7"];
    [coder encodeObject:self.adCustomDimension8 forKey:@"adCustomDimension8"];
    [coder encodeObject:self.adCustomDimension9 forKey:@"adCustomDimension9"];
    [coder encodeObject:self.adCustomDimension10 forKey:@"adCustomDimension10"];
    [coder encodeObject:self.appName forKey:@"appName"];
    [coder encodeObject:self.appReleaseVersion forKey:@"appReleaseVersion"];
}

- (void) defaultValues {
    self.enabled = true;
    self.httpSecure = true;
    self.host = @"nqs.nice264.com";
    self.accountCode = @"nicetest";
    self.username = nil;
    self.userType = nil;
    self.anonymousUser = nil;
    
    self.parseHls = false;
    self.parseCdnNameHeader = @"x-cdn-forward";
    self.parseCdnNode = false;
    // TODO: Node list constants
    self.parseCdnNodeList = [NSMutableArray arrayWithObjects:YouboraCDNNameAkamai, YouboraCDNNameCloudfront, YouboraCDNNameLevel3, YouboraCDNNameFastly, YouboraCDNNameHighwinds, YouboraCDNNameTelefonica, nil];
    
    self.experimentIds = [[NSMutableArray alloc] init];
    
    self.networkIP = nil;
    self.networkIsp = nil;
    self.networkConnectionType = nil;
    self.networkObfuscateIp = nil;
    
    self.deviceCode = nil;
    self.deviceModel = nil;
    self.deviceBrand = nil;
    self.deviceType = nil;
    self.deviceName = nil;
    self.deviceOsName = nil;
    self.deviceOsVersion = nil;
    
    
    self.forceInit = false;
    
    self.contentStreamingProtocol = nil;
    self.contentResource = nil;
    self.contentIsLive = nil;
    self.contentTitle = nil;
    self.program = nil;
    self.contentDuration = nil;
    self.contentTransactionCode = nil;
    self.contentBitrate = nil;
    self.contentThroughput = nil;
    self.contentRendition = nil;
    self.contentCdn = nil;
    self.contentFps = nil;
    self.contentMetadata = [NSMutableDictionary dictionary];
    self.contentIsLiveNoSeek = nil;
    
    self.adMetadata = [NSMutableDictionary dictionary];
    self.adsAfterStop = @0;
    self.adCampaign = nil;
    self.adTitle = nil;
    self.adResource = nil;
    
    self.autoDetectBackground = YES;
    self.offline = NO;
    
    self.isInfinity = nil;
    
    //SmartSwitch
    self.smartswitchConfigCode = nil;
    self.smartswitchGroupCode = nil;
    self.smartswitchContractCode = nil;
    
    self.customDimension1 = nil;
    self.customDimension2 = nil;
    self.customDimension3 = nil;
    self.customDimension4 = nil;
    self.customDimension5 = nil;
    self.customDimension6 = nil;
    self.customDimension7 = nil;
    self.customDimension8 = nil;
    self.customDimension9 = nil;
    self.customDimension10 = nil;
    self.customDimension11 = nil;
    self.customDimension12 = nil;
    self.customDimension13 = nil;
    self.customDimension14 = nil;
    self.customDimension15 = nil;
    self.customDimension16 = nil;
    self.customDimension17 = nil;
    self.customDimension18 = nil;
    self.customDimension19 = nil;
    self.customDimension20 = nil;
    
    self.adCustomDimension1 = nil;
    self.adCustomDimension2 = nil;
    self.adCustomDimension3 = nil;
    self.adCustomDimension4 = nil;
    self.adCustomDimension5 = nil;
    self.adCustomDimension6 = nil;
    self.adCustomDimension7 = nil;
    self.adCustomDimension8 = nil;
    self.adCustomDimension9 = nil;
    self.adCustomDimension10 = nil;
    
    self.appName = nil;
    self.appReleaseVersion = nil;
}

- (void) setContentTitle2:(NSString *)contentTitle2 {
    self.program = contentTitle2;
}

- (void) setExtraParam1:(NSString *)extraparam1 {
    self.customDimension1 = extraparam1;
}

- (void) setExtraParam2:(NSString *)extraparam2 {
    self.customDimension2 = extraparam2;
}

- (void) setExtraParam3:(NSString *)extraparam3 {
    self.customDimension3 = extraparam3;
}

- (void) setExtraParam4:(NSString *)extraparam4 {
    self.customDimension4 = extraparam4;
}

- (void) setExtraParam5:(NSString *)extraparam5 {
    self.customDimension5 = extraparam5;
}

- (void) setExtraParam6:(NSString *)extraparam6 {
    self.customDimension6 = extraparam6;
}

- (void) setExtraParam7:(NSString *)extraparam7 {
    self.customDimension7 = extraparam7;
}

- (void) setExtraParam8:(NSString *)extraparam8 {
    self.customDimension8 = extraparam8;
}

- (void) setExtraParam9:(NSString *)extraparam9 {
    self.customDimension9 = extraparam9;
}

- (void) setExtraParam10:(NSString *)extraparam10 {
    self.customDimension10 = extraparam10;
}

- (void) setExtraParam11:(NSString *)extraparam11 {
    self.customDimension11 = extraparam11;
}

- (void) setExtraParam12:(NSString *)extraparam12 {
    self.customDimension12 = extraparam12;
}

- (void) setExtraParam13:(NSString *)extraparam13 {
    self.customDimension13 = extraparam13;
}

- (void) setExtraParam14:(NSString *)extraparam14 {
    self.customDimension14 = extraparam14;
}

- (void) setExtraParam15:(NSString *)extraparam15 {
    self.customDimension15 = extraparam15;
}

- (void) setExtraParam16:(NSString *)extraparam16 {
    self.customDimension16 = extraparam16;
}

- (void) setExtraParam17:(NSString *)extraparam17 {
    self.customDimension17 = extraparam17;
}

- (void) setExtraParam18:(NSString *)extraparam18 {
    self.customDimension18 = extraparam18;
}

- (void) setExtraParam19:(NSString *)extraparam19 {
    self.customDimension19 = extraparam19;
}

- (void) setExtraParam20:(NSString *)extraparam20 {
    self.customDimension20 = extraparam20;
}

- (void) setAdExtraParam1:(NSString *)adExtraparam1 {
    self.adCustomDimension1 = adExtraparam1;
}

- (void) setAdExtraParam2:(NSString *)adExtraparam2 {
    self.adCustomDimension2 = adExtraparam2;
}

- (void) setAdExtraParam3:(NSString *)adExtraparam3 {
    self.adCustomDimension3 = adExtraparam3;
}

- (void) setAdExtraParam4:(NSString *)adExtraparam4 {
    self.adCustomDimension4 = adExtraparam4;
}

- (void) setAdExtraParam5:(NSString *)adExtraparam5 {
    self.adCustomDimension5 = adExtraparam5;
}

- (void) setAdExtraParam6:(NSString *)adExtraparam6 {
    self.adCustomDimension6 = adExtraparam6;
}

- (void) setAdExtraParam7:(NSString *)adExtraparam7 {
    self.adCustomDimension7 = adExtraparam7;
}

- (void) setAdExtraParam8:(NSString *)adExtraparam8 {
    self.adCustomDimension8 = adExtraparam8;
}

- (void) setAdExtraParam9:(NSString *)adExtraparam9 {
    self.adCustomDimension9 = adExtraparam9;
}

- (void) setAdExtraParam10:(NSString *)adExtraparam10 {
    self.adCustomDimension10 = adExtraparam10;
}

@end
