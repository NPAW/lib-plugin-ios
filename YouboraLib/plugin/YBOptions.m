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
