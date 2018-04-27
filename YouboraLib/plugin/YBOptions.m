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
        self.contentResource = [decoder decodeObjectForKey:@"contentResource"];
        self.contentIsLive = [decoder decodeObjectForKey:@"contentIsLive"];
        self.contentTitle = [decoder decodeObjectForKey:@"contentTitle"];
        self.contentTitle2 = [decoder decodeObjectForKey:@"contentTitle2"];
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
        self.extraparam1 = [decoder decodeObjectForKey:@"extraparam1"];
        self.extraparam2 = [decoder decodeObjectForKey:@"extraparam2"];
        self.extraparam3 = [decoder decodeObjectForKey:@"extraparam3"];
        self.extraparam4 = [decoder decodeObjectForKey:@"extraparam4"];
        self.extraparam5 = [decoder decodeObjectForKey:@"extraparam5"];
        self.extraparam6 = [decoder decodeObjectForKey:@"extraparam6"];
        self.extraparam7 = [decoder decodeObjectForKey:@"extraparam7"];
        self.extraparam8 = [decoder decodeObjectForKey:@"extraparam8"];
        self.extraparam9 = [decoder decodeObjectForKey:@"extraparam9"];
        self.extraparam10 = [decoder decodeObjectForKey:@"extraparam10"];
        self.extraparam11 = [decoder decodeObjectForKey:@"extraparam11"];
        self.extraparam12 = [decoder decodeObjectForKey:@"extraparam12"];
        self.extraparam13 = [decoder decodeObjectForKey:@"extraparam13"];
        self.extraparam14 = [decoder decodeObjectForKey:@"extraparam14"];
        self.extraparam15 = [decoder decodeObjectForKey:@"extraparam15"];
        self.extraparam16 = [decoder decodeObjectForKey:@"extraparam16"];
        self.extraparam17 = [decoder decodeObjectForKey:@"extraparam17"];
        self.extraparam18 = [decoder decodeObjectForKey:@"extraparam18"];
        self.extraparam19 = [decoder decodeObjectForKey:@"extraparam19"];
        self.extraparam20 = [decoder decodeObjectForKey:@"extraparam20"];
        self.adExtraparam1 = [decoder decodeObjectForKey:@"adExtraparam1"];
        self.adExtraparam2 = [decoder decodeObjectForKey:@"adExtraparam2"];
        self.adExtraparam3 = [decoder decodeObjectForKey:@"adExtraparam3"];
        self.adExtraparam4 = [decoder decodeObjectForKey:@"adExtraparam4"];
        self.adExtraparam5 = [decoder decodeObjectForKey:@"adExtraparam5"];
        self.adExtraparam6 = [decoder decodeObjectForKey:@"adExtraparam6"];
        self.adExtraparam7 = [decoder decodeObjectForKey:@"adExtraparam7"];
        self.adExtraparam8 = [decoder decodeObjectForKey:@"adExtraparam8"];
        self.adExtraparam9 = [decoder decodeObjectForKey:@"adExtraparam9"];
        self.adExtraparam10 = [decoder decodeObjectForKey:@"adExtraparam10"];
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
    [coder encodeObject:self.contentStreamingProtocol forKey:@"contentStreamingProtocol"];
    [coder encodeObject:self.contentResource forKey:@"contentResource"];
    [coder encodeObject:self.contentIsLive forKey:@"contentIsLive"];
    [coder encodeObject:self.contentTitle forKey:@"contentTitle"];
    [coder encodeObject:self.contentTitle2 forKey:@"contentTitle2"];
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
    [coder encodeObject:self.extraparam1 forKey:@"extraparam1"];
    [coder encodeObject:self.extraparam2 forKey:@"extraparam2"];
    [coder encodeObject:self.extraparam3 forKey:@"extraparam3"];
    [coder encodeObject:self.extraparam4 forKey:@"extraparam4"];
    [coder encodeObject:self.extraparam5 forKey:@"extraparam5"];
    [coder encodeObject:self.extraparam6 forKey:@"extraparam6"];
    [coder encodeObject:self.extraparam7 forKey:@"extraparam7"];
    [coder encodeObject:self.extraparam8 forKey:@"extraparam8"];
    [coder encodeObject:self.extraparam9 forKey:@"extraparam9"];
    [coder encodeObject:self.extraparam10 forKey:@"extraparam10"];
    [coder encodeObject:self.extraparam11 forKey:@"extraparam11"];
    [coder encodeObject:self.extraparam12 forKey:@"extraparam12"];
    [coder encodeObject:self.extraparam13 forKey:@"extraparam13"];
    [coder encodeObject:self.extraparam14 forKey:@"extraparam14"];
    [coder encodeObject:self.extraparam15 forKey:@"extraparam15"];
    [coder encodeObject:self.extraparam16 forKey:@"extraparam16"];
    [coder encodeObject:self.extraparam17 forKey:@"extraparam17"];
    [coder encodeObject:self.extraparam18 forKey:@"extraparam18"];
    [coder encodeObject:self.extraparam19 forKey:@"extraparam19"];
    [coder encodeObject:self.extraparam20 forKey:@"extraparam20"];
    [coder encodeObject:self.adExtraparam1 forKey:@"adExtraparam1"];
    [coder encodeObject:self.adExtraparam2 forKey:@"adExtraparam2"];
    [coder encodeObject:self.adExtraparam3 forKey:@"adExtraparam3"];
    [coder encodeObject:self.adExtraparam4 forKey:@"adExtraparam4"];
    [coder encodeObject:self.adExtraparam5 forKey:@"adExtraparam5"];
    [coder encodeObject:self.adExtraparam6 forKey:@"adExtraparam6"];
    [coder encodeObject:self.adExtraparam7 forKey:@"adExtraparam7"];
    [coder encodeObject:self.adExtraparam8 forKey:@"adExtraparam8"];
    [coder encodeObject:self.adExtraparam9 forKey:@"adExtraparam9"];
    [coder encodeObject:self.adExtraparam10 forKey:@"adExtraparam10"];
}

- (void) defaultValues {
    self.enabled = true;
    self.httpSecure = true;
    self.host = @"nqs.nice264.com";
    self.accountCode = @"nicetest";
    self.username = nil;
    self.userType = nil;
    
    self.parseHls = false;
    self.parseCdnNameHeader = @"x-cdn-forward";
    self.parseCdnNode = false;
    // TODO: Node list constants
    self.parseCdnNodeList = [NSMutableArray arrayWithObjects:YouboraCDNNameAkamai, YouboraCDNNameCloudfront, YouboraCDNNameLevel3, YouboraCDNNameFastly, YouboraCDNNameHighwinds, nil];
    
    self.experimentIds = [[NSMutableArray alloc] init];
    
    self.networkIP = nil;
    self.networkIsp = nil;
    self.networkConnectionType = nil;
    self.networkObfuscateIp = nil;
    
    self.deviceCode = nil;
    
    self.contentStreamingProtocol = nil;
    self.contentResource = nil;
    self.contentIsLive = nil;
    self.contentTitle = nil;
    self.contentTitle2 = nil;
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
    
    self.autoDetectBackground = NO;
    self.offline = NO;
    
    self.extraparam1 = nil;
    self.extraparam2 = nil;
    self.extraparam3 = nil;
    self.extraparam4 = nil;
    self.extraparam5 = nil;
    self.extraparam6 = nil;
    self.extraparam7 = nil;
    self.extraparam8 = nil;
    self.extraparam9 = nil;
    self.extraparam10 = nil;
    
    self.extraparam11 = nil;
    self.extraparam12 = nil;
    self.extraparam13 = nil;
    self.extraparam14 = nil;
    self.extraparam15 = nil;
    self.extraparam16 = nil;
    self.extraparam17 = nil;
    self.extraparam18 = nil;
    self.extraparam19 = nil;
    self.extraparam20 = nil;
    
    self.adExtraparam1 = nil;
    self.adExtraparam2 = nil;
    self.adExtraparam3 = nil;
    self.adExtraparam4 = nil;
    self.adExtraparam5 = nil;
    self.adExtraparam6 = nil;
    self.adExtraparam7 = nil;
    self.adExtraparam8 = nil;
    self.adExtraparam9 = nil;
    self.adExtraparam10 = nil;
}

@end
