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
        self.parseHls = [[decoder decodeObjectForKey:@"parseHls"] isEqualToValue:@YES];
        self.parseCdnNameHeader = [decoder decodeObjectForKey:@"parseCdnNameHeader"];
        self.parseCdnNode = [[decoder decodeObjectForKey:@"parseCdnNode"] isEqualToValue:@YES];
        self.parseCdnNodeList = [decoder decodeObjectForKey:@"parseCdnNodeList"];
        self.networkIP = [decoder decodeObjectForKey:@"networkIP"];
        self.networkIsp = [decoder decodeObjectForKey:@"networkIsp"];
        self.networkConnectionType = [decoder decodeObjectForKey:@"networkConnectionType"];
        self.deviceCode = [decoder decodeObjectForKey:@"deviceCode"];
        self.contentResource = [decoder decodeObjectForKey:@"contentResource"];
        self.contentIsLive = [decoder decodeObjectForKey:@"contentIsLive"];
        self.contentTitle = [decoder decodeObjectForKey:@"contentTitle"];
        self.contentTitle2 = [decoder decodeObjectForKey:@"contentTitle2"];
        self.contentDuration = [decoder decodeObjectForKey:@"contentDuration"];
        self.contentTransactionCode = [decoder decodeObjectForKey:@"contentTransactionCode"];
        self.contentBitrate = [decoder decodeObjectForKey:@"contentBitrate"];
        self.contentThroughput = [decoder decodeObjectForKey:@"contentThroughput"];
        self.contentRendition = [decoder decodeObjectForKey:@"contentRendition"];
        self.contentCdn = [decoder decodeObjectForKey:@"contentCdn"];
        self.contentFps = [decoder decodeObjectForKey:@"contentFps"];
        self.contentMetadata = [decoder decodeObjectForKey:@"contentMetadata"];
        self.adMetadata = [decoder decodeObjectForKey:@"adMetadata"];
        self.autoDetectBackground = [decoder decodeObjectForKey:@"autoDetectBackground"];
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
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:@(self.enabled) forKey:@"enabled"];
    [coder encodeObject:@(self.httpSecure) forKey:@"httpSecure"];
    [coder encodeObject:self.host forKey:@"host"];
    [coder encodeObject:self.accountCode forKey:@"accountCode"];
    [coder encodeObject:self.username forKey:@"username"];
    [coder encodeObject:@(self.parseHls) forKey:@"parseHls"];
    [coder encodeObject:self.parseCdnNameHeader forKey:@"parseCdnNameHeader"];
    [coder encodeObject:@(self.parseCdnNode) forKey:@"parseCdnNode"];
    [coder encodeObject:self.parseCdnNodeList forKey:@"parseCdnNodeList"];
    [coder encodeObject:self.networkIP forKey:@"networkIP"];
    [coder encodeObject:self.networkIsp forKey:@"networkIsp"];
    [coder encodeObject:self.networkConnectionType forKey:@"networkConnectionType"];
    [coder encodeObject:self.deviceCode forKey:@"deviceCode"];
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
    [coder encodeObject:self.adMetadata forKey:@"adMetadata"];
    [coder encodeObject:@(self.autoDetectBackground) forKey:@"autoDetectBackground"];
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
}

- (void) defaultValues {
    self.enabled = true;
    self.httpSecure = true;
    self.host = @"nqs.nice264.com";
    self.accountCode = @"nicetest";
    self.username = nil;
    
    self.parseHls = false;
    self.parseCdnNameHeader = @"x-cdn-forward";
    self.parseCdnNode = false;
    // TODO: Node list constants
    self.parseCdnNodeList = [NSMutableArray arrayWithObjects:YouboraCDNNameAkamai, YouboraCDNNameCloudfront, YouboraCDNNameLevel3, YouboraCDNNameFastly, YouboraCDNNameHighwinds, nil];
    
    self.networkIP = nil;
    self.networkIsp = nil;
    self.networkConnectionType = nil;
    
    self.deviceCode = nil;
    
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
    
    self.adMetadata = [NSMutableDictionary dictionary];
    
    self.autoDetectBackground = NO;
    
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
}

@end
