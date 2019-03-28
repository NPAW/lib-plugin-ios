//
//  YBOptions.m
//  YouboraLib
//
//  Created by Joan on 17/03/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import "YBOptions.h"
#import "YBCdnParser.h"

NSString * const YBOPTIONS_KEY_ENABLED = @"enabled";
NSString * const YBOPTIONS_KEY_HTTP_SECURE = @"httpSecure";
NSString * const YBOPTIONS_KEY_HOST = @"host";
NSString * const YBOPTIONS_KEY_ACCOUNT_CODE = @"config.accountCode";
NSString * const YBOPTIONS_KEY_USERNAME = @"username";
NSString * const YBOPTIONS_KEY_ANONYMOUS_USER = @"anonymousUser";
NSString * const YBOPTIONS_KEY_OFFLINE = @"offline";
NSString * const YBOPTIONS_KEY_IS_INFINITY = @"isInfinity";
NSString * const YBOPTIONS_KEY_BACKGROUND = @"autoDetectBackground";
NSString * const YBOPTIONS_KEY_AUTOSTART = @"autoStart";
NSString * const YBOPTIONS_KEY_FORCEINIT = @"forceInit";
NSString * const YBOPTIONS_KEY_USER_TYPE = @"userType";
NSString * const YBOPTIONS_KEY_EXPERIMENT_IDS = @"experiments";
NSString * const YBOPTIONS_KEY_SS_CONFIG_CODE = @"smartswitch.configCode";
NSString * const YBOPTIONS_KEY_SS_GROUP_CODE = @"smartswitch.groupCode";
NSString * const YBOPTIONS_KEY_SS_CONTRACT_CODE = @"smartswitch.contractCode";

NSString * const YBOPTIONS_KEY_PARSE_HLS = @"parse.Hls";
NSString * const YBOPTIONS_KEY_PARSE_CDN_NAME_HEADER = @"parse.CdnNameHeader";
NSString * const YBOPTIONS_KEY_PARSE_CDN_NODE = @"parse.CdnNode";
NSString * const YBOPTIONS_KEY_PARSE_CDN_NODE_LIST = @"parse.CdnNodeList";

NSString * const YBOPTIONS_KEY_NETWORK_IP = @"network.IP";
NSString * const YBOPTIONS_KEY_NETWORK_ISP = @"network.Isp";
NSString * const YBOPTIONS_KEY_NETWORK_CONNECTION_TYPE = @"network.connectionType";
NSString * const YBOPTIONS_KEY_NETWORK_OBFUSCATE_IP = @"network.obfuscateIp";

NSString * const YBOPTIONS_KEY_DEVICE_CODE = @"device.code";
NSString * const YBOPTIONS_KEY_DEVICE_MODEL = @"device.model";
NSString * const YBOPTIONS_KEY_DEVICE_BRAND = @"device.brand";
NSString * const YBOPTIONS_KEY_DEVICE_TYPE = @"device.type";
NSString * const YBOPTIONS_KEY_DEVICE_NAME = @"device.name";
NSString * const YBOPTIONS_KEY_DEVICE_OS_NAME = @"device.osNme";
NSString * const YBOPTIONS_KEY_DEVICE_OS_VERSION = @"device.osVersion";

NSString * const YBOPTIONS_KEY_CONTENT_RESOURCE = @"content.resource";
NSString * const YBOPTIONS_KEY_CONTENT_IS_LIVE = @"content.isLive";
NSString * const YBOPTIONS_KEY_CONTENT_TITLE = @"content.title";
NSString * const YBOPTIONS_KEY_CONTENT_PROGRAM = @"content.program";
NSString * const YBOPTIONS_KEY_CONTENT_DURATION = @"content.duration";
NSString * const YBOPTIONS_KEY_CONTENT_TRANSACTION_CODE = @"content.transactionCode";
NSString * const YBOPTIONS_KEY_CONTENT_BITRATE = @"content.bitrate";
NSString * const YBOPTIONS_KEY_CONTENT_THROUGHPUT = @"content.throughput";
NSString * const YBOPTIONS_KEY_CONTENT_RENDITION = @"content.rendition";
NSString * const YBOPTIONS_KEY_CONTENT_CDN = @"content.cdn";
NSString * const YBOPTIONS_KEY_CONTENT_FPS = @"content.fps";
NSString * const YBOPTIONS_KEY_CONTENT_STREAMING_PROTOCOL = @"content.streamingProtocol";
NSString * const YBOPTIONS_KEY_CONTENT_METADATA = @"content.metadata";
NSString * const YBOPTIONS_KEY_CONTENT_METRICS = @"content.metrics";
NSString * const YBOPTIONS_KEY_CONTENT_IS_LIVE_NO_SEEK = @"content.isLiveNoSeek";

NSString * const YBOPTIONS_KEY_SESSION_METRICS = @"session.metrics";

NSString * const YBOPTIONS_KEY_AD_METADATA = @"ad.metadata";
NSString * const YBOPTIONS_KEY_AD_IGNORE = @"ad.ignore";
NSString * const YBOPTIONS_KEY_ADS_AFTERSTOP = @"ad.afterStop";
NSString * const YBOPTIONS_KEY_AD_CAMPAIGN = @"ad.campaign";
NSString * const YBOPTIONS_KEY_AD_TITLE = @"ad.title";
NSString * const YBOPTIONS_KEY_AD_RESOURCE = @"ad.resource";

NSString * const YBOPTIONS_KEY_CUSTOM_DIMENSION_1 = @"custom.dimension.1";
NSString * const YBOPTIONS_KEY_CUSTOM_DIMENSION_2 = @"custom.dimension.2";
NSString * const YBOPTIONS_KEY_CUSTOM_DIMENSION_3 = @"custom.dimension.3";
NSString * const YBOPTIONS_KEY_CUSTOM_DIMENSION_4 = @"custom.dimension.4";
NSString * const YBOPTIONS_KEY_CUSTOM_DIMENSION_5 = @"custom.dimension.5";
NSString * const YBOPTIONS_KEY_CUSTOM_DIMENSION_6 = @"custom.dimension.6";
NSString * const YBOPTIONS_KEY_CUSTOM_DIMENSION_7 = @"custom.dimension.7";
NSString * const YBOPTIONS_KEY_CUSTOM_DIMENSION_8 = @"custom.dimension.8";
NSString * const YBOPTIONS_KEY_CUSTOM_DIMENSION_9 = @"custom.dimension.9";
NSString * const YBOPTIONS_KEY_CUSTOM_DIMENSION_10 = @"custom.dimension.10";
NSString * const YBOPTIONS_KEY_CUSTOM_DIMENSION_11 = @"custom.dimension.11";
NSString * const YBOPTIONS_KEY_CUSTOM_DIMENSION_12 = @"custom.dimension.12";
NSString * const YBOPTIONS_KEY_CUSTOM_DIMENSION_13 = @"custom.dimension.13";
NSString * const YBOPTIONS_KEY_CUSTOM_DIMENSION_14 = @"custom.dimension.14";
NSString * const YBOPTIONS_KEY_CUSTOM_DIMENSION_15 = @"custom.dimension.15";
NSString * const YBOPTIONS_KEY_CUSTOM_DIMENSION_16 = @"custom.dimension.16";
NSString * const YBOPTIONS_KEY_CUSTOM_DIMENSION_17 = @"custom.dimension.17";
NSString * const YBOPTIONS_KEY_CUSTOM_DIMENSION_18 = @"custom.dimension.18";
NSString * const YBOPTIONS_KEY_CUSTOM_DIMENSION_19 = @"custom.dimension.19";
NSString * const YBOPTIONS_KEY_CUSTOM_DIMENSION_20 = @"custom.dimension.20";

NSString * const YBOPTIONS_KEY_AD_CUSTOM_DIMENSION_1 = @"ad.custom.dimension.1";
NSString * const YBOPTIONS_KEY_AD_CUSTOM_DIMENSION_2 = @"ad.custom.dimension.2";
NSString * const YBOPTIONS_KEY_AD_CUSTOM_DIMENSION_3 = @"ad.custom.dimension.3";
NSString * const YBOPTIONS_KEY_AD_CUSTOM_DIMENSION_4 = @"ad.custom.dimension.4";
NSString * const YBOPTIONS_KEY_AD_CUSTOM_DIMENSION_5 = @"ad.custom.dimension.5";
NSString * const YBOPTIONS_KEY_AD_CUSTOM_DIMENSION_6 = @"ad.custom.dimension.6";
NSString * const YBOPTIONS_KEY_AD_CUSTOM_DIMENSION_7 = @"ad.custom.dimension.7";
NSString * const YBOPTIONS_KEY_AD_CUSTOM_DIMENSION_8 = @"ad.custom.dimension.8";
NSString * const YBOPTIONS_KEY_AD_CUSTOM_DIMENSION_9 = @"ad.custom.dimension.9";
NSString * const YBOPTIONS_KEY_AD_CUSTOM_DIMENSION_10 = @"ad.custom.dimension.10";

NSString * const YBOPTIONS_KEY_APP_NAME = @"app.name";
NSString * const YBOPTIONS_KEY_APP_RELEASE_VERSION = @"app.release.version";

NSString * const YBOPTIONS_KEY_WAIT_METADATA = @"waitForMetadata";
NSString * const YBOPTIONS_KEY_PENDING_METADATA = @"pendingMetadata";

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
        self.enabled = [[decoder decodeObjectForKey:YBOPTIONS_KEY_ENABLED] isEqualToValue:@YES];
        self.httpSecure = [[decoder decodeObjectForKey:YBOPTIONS_KEY_HTTP_SECURE] isEqualToValue:@YES];
        self.host = [decoder decodeObjectForKey:YBOPTIONS_KEY_HOST];
        self.accountCode = [decoder decodeObjectForKey:YBOPTIONS_KEY_ACCOUNT_CODE];
        self.username = [decoder decodeObjectForKey:YBOPTIONS_KEY_USERNAME];
        self.userType = [decoder decodeObjectForKey:YBOPTIONS_KEY_USER_TYPE];
        self.parseHls = [[decoder decodeObjectForKey:YBOPTIONS_KEY_PARSE_HLS] isEqualToValue:@YES];
        self.parseCdnNameHeader = [decoder decodeObjectForKey:YBOPTIONS_KEY_PARSE_CDN_NAME_HEADER];
        self.parseCdnNode = [[decoder decodeObjectForKey:YBOPTIONS_KEY_PARSE_CDN_NODE] isEqualToValue:@YES];
        self.parseCdnNodeList = [decoder decodeObjectForKey:YBOPTIONS_KEY_PARSE_CDN_NODE_LIST];
        self.experimentIds = [decoder decodeObjectForKey:YBOPTIONS_KEY_EXPERIMENT_IDS];
        self.networkIP = [decoder decodeObjectForKey:YBOPTIONS_KEY_NETWORK_IP];
        self.networkIsp = [decoder decodeObjectForKey:YBOPTIONS_KEY_NETWORK_ISP];
        self.networkConnectionType = [decoder decodeObjectForKey:YBOPTIONS_KEY_NETWORK_CONNECTION_TYPE];
        self.networkObfuscateIp = [decoder decodeObjectForKey:YBOPTIONS_KEY_NETWORK_OBFUSCATE_IP];
        self.deviceCode = [decoder decodeObjectForKey:YBOPTIONS_KEY_DEVICE_CODE];
        self.forceInit = [decoder decodeObjectForKey:YBOPTIONS_KEY_FORCEINIT];
        self.deviceModel = [decoder decodeObjectForKey:YBOPTIONS_KEY_DEVICE_MODEL];
        self.deviceBrand = [decoder decodeObjectForKey:YBOPTIONS_KEY_DEVICE_BRAND];
        self.deviceType = [decoder decodeObjectForKey:YBOPTIONS_KEY_DEVICE_TYPE];
        self.deviceOsName = [decoder decodeObjectForKey:YBOPTIONS_KEY_DEVICE_OS_NAME];
        self.deviceOsVersion = [decoder decodeObjectForKey:YBOPTIONS_KEY_DEVICE_OS_VERSION];
        self.contentResource = [decoder decodeObjectForKey:YBOPTIONS_KEY_CONTENT_RESOURCE];
        self.contentIsLive = [decoder decodeObjectForKey:YBOPTIONS_KEY_CONTENT_IS_LIVE];
        self.contentTitle = [decoder decodeObjectForKey:YBOPTIONS_KEY_CONTENT_TITLE];
        self.program = [decoder decodeObjectForKey:YBOPTIONS_KEY_CONTENT_PROGRAM];
        self.contentDuration = [decoder decodeObjectForKey:YBOPTIONS_KEY_CONTENT_DURATION];
        self.contentTransactionCode = [decoder decodeObjectForKey:YBOPTIONS_KEY_CONTENT_TRANSACTION_CODE];
        self.contentStreamingProtocol = [decoder decodeObjectForKey:YBOPTIONS_KEY_CONTENT_STREAMING_PROTOCOL];
        self.contentBitrate = [decoder decodeObjectForKey:YBOPTIONS_KEY_CONTENT_BITRATE];
        self.contentThroughput = [decoder decodeObjectForKey:YBOPTIONS_KEY_CONTENT_THROUGHPUT];
        self.contentRendition = [decoder decodeObjectForKey:YBOPTIONS_KEY_CONTENT_RENDITION];
        self.contentCdn = [decoder decodeObjectForKey:YBOPTIONS_KEY_CONTENT_CDN];
        self.contentFps = [decoder decodeObjectForKey:YBOPTIONS_KEY_CONTENT_FPS];
        self.contentMetadata = [decoder decodeObjectForKey:YBOPTIONS_KEY_CONTENT_METADATA];
        self.contentIsLiveNoSeek = [decoder decodeObjectForKey:YBOPTIONS_KEY_CONTENT_IS_LIVE_NO_SEEK];
        self.adMetadata = [decoder decodeObjectForKey:YBOPTIONS_KEY_AD_METADATA];
        self.adsAfterStop = [decoder decodeObjectForKey:YBOPTIONS_KEY_ADS_AFTERSTOP];
        self.adCampaign = [decoder decodeObjectForKey:YBOPTIONS_KEY_AD_CAMPAIGN];
        self.adTitle = [decoder decodeObjectForKey:YBOPTIONS_KEY_AD_TITLE];
        self.adResource = [decoder decodeObjectForKey:YBOPTIONS_KEY_CONTENT_RESOURCE];
        self.autoDetectBackground = [decoder decodeObjectForKey:YBOPTIONS_KEY_BACKGROUND];
        self.offline = [decoder decodeObjectForKey:YBOPTIONS_KEY_OFFLINE];
        self.anonymousUser = [decoder decodeObjectForKey:YBOPTIONS_KEY_ANONYMOUS_USER];
        self.isInfinity = [decoder decodeObjectForKey:YBOPTIONS_KEY_IS_INFINITY];
        self.smartswitchConfigCode = [decoder decodeObjectForKey:YBOPTIONS_KEY_SS_CONFIG_CODE];
        self.smartswitchGroupCode = [decoder decodeObjectForKey:YBOPTIONS_KEY_SS_GROUP_CODE];
        self.smartswitchContractCode = [decoder decodeObjectForKey:YBOPTIONS_KEY_SS_CONTRACT_CODE];
        self.customDimension1 = [decoder decodeObjectForKey:YBOPTIONS_KEY_CUSTOM_DIMENSION_1];
        self.customDimension2 = [decoder decodeObjectForKey:YBOPTIONS_KEY_CUSTOM_DIMENSION_2];
        self.customDimension3 = [decoder decodeObjectForKey:YBOPTIONS_KEY_CUSTOM_DIMENSION_3];
        self.customDimension4 = [decoder decodeObjectForKey:YBOPTIONS_KEY_CUSTOM_DIMENSION_4];
        self.customDimension5 = [decoder decodeObjectForKey:YBOPTIONS_KEY_CUSTOM_DIMENSION_5];
        self.customDimension6 = [decoder decodeObjectForKey:YBOPTIONS_KEY_CUSTOM_DIMENSION_6];
        self.customDimension7 = [decoder decodeObjectForKey:YBOPTIONS_KEY_CUSTOM_DIMENSION_7];
        self.customDimension8 = [decoder decodeObjectForKey:YBOPTIONS_KEY_CUSTOM_DIMENSION_8];
        self.customDimension9 = [decoder decodeObjectForKey:YBOPTIONS_KEY_CUSTOM_DIMENSION_9];
        self.customDimension10 = [decoder decodeObjectForKey:YBOPTIONS_KEY_CUSTOM_DIMENSION_10];
        self.customDimension11 = [decoder decodeObjectForKey:YBOPTIONS_KEY_CUSTOM_DIMENSION_11];
        self.customDimension12 = [decoder decodeObjectForKey:YBOPTIONS_KEY_CUSTOM_DIMENSION_12];
        self.customDimension13 = [decoder decodeObjectForKey:YBOPTIONS_KEY_CUSTOM_DIMENSION_13];
        self.customDimension14 = [decoder decodeObjectForKey:YBOPTIONS_KEY_CUSTOM_DIMENSION_14];
        self.customDimension15 = [decoder decodeObjectForKey:YBOPTIONS_KEY_CUSTOM_DIMENSION_15];
        self.customDimension16 = [decoder decodeObjectForKey:YBOPTIONS_KEY_CUSTOM_DIMENSION_16];
        self.customDimension17 = [decoder decodeObjectForKey:YBOPTIONS_KEY_CUSTOM_DIMENSION_17];
        self.customDimension18 = [decoder decodeObjectForKey:YBOPTIONS_KEY_CUSTOM_DIMENSION_18];
        self.customDimension19 = [decoder decodeObjectForKey:YBOPTIONS_KEY_CUSTOM_DIMENSION_19];
        self.customDimension20 = [decoder decodeObjectForKey:YBOPTIONS_KEY_CUSTOM_DIMENSION_20];
        self.adCustomDimension1 = [decoder decodeObjectForKey:YBOPTIONS_KEY_AD_CUSTOM_DIMENSION_1];
        self.adCustomDimension2 = [decoder decodeObjectForKey:YBOPTIONS_KEY_AD_CUSTOM_DIMENSION_2];
        self.adCustomDimension3 = [decoder decodeObjectForKey:YBOPTIONS_KEY_AD_CUSTOM_DIMENSION_3];
        self.adCustomDimension4 = [decoder decodeObjectForKey:YBOPTIONS_KEY_AD_CUSTOM_DIMENSION_4];
        self.adCustomDimension5 = [decoder decodeObjectForKey:YBOPTIONS_KEY_AD_CUSTOM_DIMENSION_5];
        self.adCustomDimension6 = [decoder decodeObjectForKey:YBOPTIONS_KEY_AD_CUSTOM_DIMENSION_6];
        self.adCustomDimension7 = [decoder decodeObjectForKey:YBOPTIONS_KEY_AD_CUSTOM_DIMENSION_7];
        self.adCustomDimension8 = [decoder decodeObjectForKey:YBOPTIONS_KEY_AD_CUSTOM_DIMENSION_8];
        self.adCustomDimension9 = [decoder decodeObjectForKey:YBOPTIONS_KEY_AD_CUSTOM_DIMENSION_9];
        self.adCustomDimension10 = [decoder decodeObjectForKey:YBOPTIONS_KEY_AD_CUSTOM_DIMENSION_10];
        self.appName = [decoder decodeObjectForKey:YBOPTIONS_KEY_APP_NAME];
        self.appReleaseVersion = [decoder decodeObjectForKey:YBOPTIONS_KEY_APP_RELEASE_VERSION];
        self.waitForMetadata = [[decoder decodeObjectForKey:YBOPTIONS_KEY_WAIT_METADATA] isEqualToValue:@NO];
        self.pendingMetadata = [decoder decodeObjectForKey:YBOPTIONS_KEY_PENDING_METADATA];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:@(self.enabled) forKey:YBOPTIONS_KEY_ENABLED];
    [coder encodeObject:@(self.httpSecure) forKey:YBOPTIONS_KEY_HTTP_SECURE];
    [coder encodeObject:self.host forKey:YBOPTIONS_KEY_HOST];
    [coder encodeObject:self.accountCode forKey:YBOPTIONS_KEY_ACCOUNT_CODE];
    [coder encodeObject:self.username forKey:YBOPTIONS_KEY_USERNAME];
    [coder encodeObject:self.userType forKey:YBOPTIONS_KEY_USER_TYPE];
    [coder encodeObject:@(self.parseHls) forKey:YBOPTIONS_KEY_PARSE_HLS];
    [coder encodeObject:self.parseCdnNameHeader forKey:YBOPTIONS_KEY_PARSE_CDN_NAME_HEADER];
    [coder encodeObject:@(self.parseCdnNode) forKey:YBOPTIONS_KEY_PARSE_CDN_NODE];
    [coder encodeObject:self.parseCdnNodeList forKey:YBOPTIONS_KEY_PARSE_CDN_NODE_LIST];
    [coder encodeObject:self.experimentIds forKey:YBOPTIONS_KEY_EXPERIMENT_IDS];
    [coder encodeObject:self.networkIP forKey:YBOPTIONS_KEY_NETWORK_IP];
    [coder encodeObject:self.networkIsp forKey:YBOPTIONS_KEY_NETWORK_ISP];
    [coder encodeObject:self.networkConnectionType forKey:YBOPTIONS_KEY_NETWORK_CONNECTION_TYPE];
    [coder encodeObject:self.networkObfuscateIp forKey:YBOPTIONS_KEY_NETWORK_OBFUSCATE_IP];
    [coder encodeObject:self.deviceCode forKey:YBOPTIONS_KEY_DEVICE_CODE];
    [coder encodeObject:@(self.forceInit) forKey:YBOPTIONS_KEY_FORCEINIT];
    [coder encodeObject:self.deviceModel forKey:YBOPTIONS_KEY_DEVICE_MODEL];
    [coder encodeObject:self.deviceBrand forKey:YBOPTIONS_KEY_DEVICE_BRAND];
    [coder encodeObject:self.deviceType forKey:YBOPTIONS_KEY_DEVICE_TYPE];
    [coder encodeObject:self.deviceName forKey:YBOPTIONS_KEY_DEVICE_NAME];
    [coder encodeObject:self.deviceOsName forKey:YBOPTIONS_KEY_DEVICE_OS_NAME];
    [coder encodeObject:self.deviceOsVersion forKey:YBOPTIONS_KEY_DEVICE_OS_VERSION];
    [coder encodeObject:self.contentStreamingProtocol forKey:YBOPTIONS_KEY_CONTENT_STREAMING_PROTOCOL];
    [coder encodeObject:self.contentResource forKey:YBOPTIONS_KEY_CONTENT_RESOURCE];
    [coder encodeObject:self.contentIsLive forKey:YBOPTIONS_KEY_CONTENT_IS_LIVE];
    [coder encodeObject:self.contentTitle forKey:YBOPTIONS_KEY_CONTENT_TITLE];
    [coder encodeObject:self.program forKey:YBOPTIONS_KEY_CONTENT_PROGRAM];
    [coder encodeObject:self.contentDuration forKey:YBOPTIONS_KEY_CONTENT_DURATION];
    [coder encodeObject:self.contentTransactionCode forKey:YBOPTIONS_KEY_CONTENT_TRANSACTION_CODE];
    [coder encodeObject:self.contentBitrate forKey:YBOPTIONS_KEY_CONTENT_BITRATE];
    [coder encodeObject:self.contentThroughput forKey:YBOPTIONS_KEY_CONTENT_THROUGHPUT];
    [coder encodeObject:self.contentRendition forKey:YBOPTIONS_KEY_CONTENT_RENDITION];
    [coder encodeObject:self.contentCdn forKey:YBOPTIONS_KEY_CONTENT_CDN];
    [coder encodeObject:self.contentFps forKey:YBOPTIONS_KEY_CONTENT_FPS];
    [coder encodeObject:self.contentMetadata forKey:YBOPTIONS_KEY_CONTENT_METADATA];
    [coder encodeObject:self.contentIsLiveNoSeek forKey:YBOPTIONS_KEY_CONTENT_IS_LIVE_NO_SEEK];
    [coder encodeObject:self.adMetadata forKey:YBOPTIONS_KEY_AD_METADATA];
    [coder encodeObject:self.adsAfterStop forKey:YBOPTIONS_KEY_ADS_AFTERSTOP];
    [coder encodeObject:self.adCampaign forKey:YBOPTIONS_KEY_AD_CAMPAIGN];
    [coder encodeObject:self.adTitle forKey:YBOPTIONS_KEY_AD_TITLE];
    [coder encodeObject:self.adResource forKey:YBOPTIONS_KEY_AD_RESOURCE];
    [coder encodeObject:@(self.autoDetectBackground) forKey:YBOPTIONS_KEY_BACKGROUND];
    [coder encodeObject:@(self.offline) forKey:YBOPTIONS_KEY_OFFLINE];
    [coder encodeObject:self.anonymousUser forKey:YBOPTIONS_KEY_ANONYMOUS_USER];
    [coder encodeObject:self.isInfinity forKey:YBOPTIONS_KEY_IS_INFINITY];
    [coder encodeObject:self.smartswitchConfigCode forKey:YBOPTIONS_KEY_SS_CONFIG_CODE];
    [coder encodeObject:self.smartswitchGroupCode forKey:YBOPTIONS_KEY_SS_GROUP_CODE];
    [coder encodeObject:self.smartswitchContractCode forKey:YBOPTIONS_KEY_SS_CONTRACT_CODE];
    [coder encodeObject:self.customDimension1 forKey:YBOPTIONS_KEY_CUSTOM_DIMENSION_1];
    [coder encodeObject:self.customDimension2 forKey:YBOPTIONS_KEY_CUSTOM_DIMENSION_2];
    [coder encodeObject:self.customDimension3 forKey:YBOPTIONS_KEY_CUSTOM_DIMENSION_3];
    [coder encodeObject:self.customDimension4 forKey:YBOPTIONS_KEY_CUSTOM_DIMENSION_4];
    [coder encodeObject:self.customDimension5 forKey:YBOPTIONS_KEY_CUSTOM_DIMENSION_5];
    [coder encodeObject:self.customDimension6 forKey:YBOPTIONS_KEY_CUSTOM_DIMENSION_6];
    [coder encodeObject:self.customDimension7 forKey:YBOPTIONS_KEY_CUSTOM_DIMENSION_7];
    [coder encodeObject:self.customDimension8 forKey:YBOPTIONS_KEY_CUSTOM_DIMENSION_8];
    [coder encodeObject:self.customDimension9 forKey:YBOPTIONS_KEY_CUSTOM_DIMENSION_9];
    [coder encodeObject:self.customDimension10 forKey:YBOPTIONS_KEY_CUSTOM_DIMENSION_10];
    [coder encodeObject:self.customDimension11 forKey:YBOPTIONS_KEY_CUSTOM_DIMENSION_11];
    [coder encodeObject:self.customDimension12 forKey:YBOPTIONS_KEY_CUSTOM_DIMENSION_12];
    [coder encodeObject:self.customDimension13 forKey:YBOPTIONS_KEY_CUSTOM_DIMENSION_13];
    [coder encodeObject:self.customDimension14 forKey:YBOPTIONS_KEY_CUSTOM_DIMENSION_14];
    [coder encodeObject:self.customDimension15 forKey:YBOPTIONS_KEY_CUSTOM_DIMENSION_15];
    [coder encodeObject:self.customDimension16 forKey:YBOPTIONS_KEY_CUSTOM_DIMENSION_16];
    [coder encodeObject:self.customDimension17 forKey:YBOPTIONS_KEY_CUSTOM_DIMENSION_17];
    [coder encodeObject:self.customDimension18 forKey:YBOPTIONS_KEY_CUSTOM_DIMENSION_18];
    [coder encodeObject:self.customDimension19 forKey:YBOPTIONS_KEY_CUSTOM_DIMENSION_19];
    [coder encodeObject:self.customDimension20 forKey:YBOPTIONS_KEY_CUSTOM_DIMENSION_20];
    [coder encodeObject:self.adCustomDimension1 forKey:YBOPTIONS_KEY_AD_CUSTOM_DIMENSION_1];
    [coder encodeObject:self.adCustomDimension2 forKey:YBOPTIONS_KEY_AD_CUSTOM_DIMENSION_2];
    [coder encodeObject:self.adCustomDimension3 forKey:YBOPTIONS_KEY_AD_CUSTOM_DIMENSION_3];
    [coder encodeObject:self.adCustomDimension4 forKey:YBOPTIONS_KEY_AD_CUSTOM_DIMENSION_4];
    [coder encodeObject:self.adCustomDimension5 forKey:YBOPTIONS_KEY_AD_CUSTOM_DIMENSION_5];
    [coder encodeObject:self.adCustomDimension6 forKey:YBOPTIONS_KEY_AD_CUSTOM_DIMENSION_6];
    [coder encodeObject:self.adCustomDimension7 forKey:YBOPTIONS_KEY_AD_CUSTOM_DIMENSION_7];
    [coder encodeObject:self.adCustomDimension8 forKey:YBOPTIONS_KEY_AD_CUSTOM_DIMENSION_8];
    [coder encodeObject:self.adCustomDimension9 forKey:YBOPTIONS_KEY_AD_CUSTOM_DIMENSION_9];
    [coder encodeObject:self.adCustomDimension10 forKey:YBOPTIONS_KEY_AD_CUSTOM_DIMENSION_10];
    [coder encodeObject:self.appName forKey:YBOPTIONS_KEY_APP_NAME];
    [coder encodeObject:self.appReleaseVersion forKey:YBOPTIONS_KEY_APP_RELEASE_VERSION];
    [coder encodeObject:@(self.waitForMetadata) forKey:YBOPTIONS_KEY_WAIT_METADATA];
    [coder encodeObject:self.pendingMetadata forKey:YBOPTIONS_KEY_PENDING_METADATA];
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
    
    self.waitForMetadata = false;
    self.pendingMetadata = [[NSArray alloc] init];
}

- (NSDictionary *) toDictionary {
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    [dict setValue:@(self.enabled) forKey:YBOPTIONS_KEY_ENABLED];
    [dict setValue:@(self.httpSecure) forKey:YBOPTIONS_KEY_HTTP_SECURE];
    [dict setValue:self.host forKey:YBOPTIONS_KEY_HOST];
    [dict setValue:self.accountCode forKey:YBOPTIONS_KEY_ACCOUNT_CODE];
    [dict setValue:self.username forKey:YBOPTIONS_KEY_USERNAME];
    [dict setValue:self.userType forKey:YBOPTIONS_KEY_USER_TYPE];
    [dict setValue:@(self.parseHls) forKey:YBOPTIONS_KEY_PARSE_HLS];
    [dict setValue:self.parseCdnNameHeader forKey:YBOPTIONS_KEY_PARSE_CDN_NAME_HEADER];
    [dict setValue:@(self.parseCdnNode) forKey:YBOPTIONS_KEY_PARSE_CDN_NODE];
    [dict setValue:self.parseCdnNodeList forKey:YBOPTIONS_KEY_PARSE_CDN_NODE_LIST];
    [dict setValue:self.experimentIds forKey:YBOPTIONS_KEY_EXPERIMENT_IDS];
    [dict setValue:self.networkIP forKey:YBOPTIONS_KEY_NETWORK_IP];
    [dict setValue:self.networkIsp forKey:YBOPTIONS_KEY_NETWORK_ISP];
    [dict setValue:self.networkConnectionType forKey:YBOPTIONS_KEY_NETWORK_CONNECTION_TYPE];
    [dict setValue:self.networkObfuscateIp forKey:YBOPTIONS_KEY_NETWORK_OBFUSCATE_IP];
    [dict setValue:self.deviceCode forKey:YBOPTIONS_KEY_DEVICE_CODE];
    [dict setValue:@(self.forceInit) forKey:YBOPTIONS_KEY_FORCEINIT];
    [dict setValue:self.deviceModel forKey:YBOPTIONS_KEY_DEVICE_MODEL];
    [dict setValue:self.deviceBrand forKey:YBOPTIONS_KEY_DEVICE_BRAND];
    [dict setValue:self.deviceType forKey:YBOPTIONS_KEY_DEVICE_TYPE];
    [dict setValue:self.deviceName forKey:YBOPTIONS_KEY_DEVICE_NAME];
    [dict setValue:self.deviceOsName forKey:YBOPTIONS_KEY_DEVICE_OS_NAME];
    [dict setValue:self.deviceOsVersion forKey:YBOPTIONS_KEY_DEVICE_OS_VERSION];
    [dict setValue:self.contentStreamingProtocol forKey:YBOPTIONS_KEY_CONTENT_STREAMING_PROTOCOL];
    [dict setValue:self.contentResource forKey:YBOPTIONS_KEY_CONTENT_RESOURCE];
    [dict setValue:self.contentIsLive forKey:YBOPTIONS_KEY_CONTENT_IS_LIVE];
    [dict setValue:self.contentTitle forKey:YBOPTIONS_KEY_CONTENT_TITLE];
    [dict setValue:self.program forKey:YBOPTIONS_KEY_CONTENT_PROGRAM];
    [dict setValue:self.contentDuration forKey:YBOPTIONS_KEY_CONTENT_DURATION];
    [dict setValue:self.contentTransactionCode forKey:YBOPTIONS_KEY_CONTENT_TRANSACTION_CODE];
    [dict setValue:self.contentBitrate forKey:YBOPTIONS_KEY_CONTENT_BITRATE];
    [dict setValue:self.contentThroughput forKey:YBOPTIONS_KEY_CONTENT_THROUGHPUT];
    [dict setValue:self.contentRendition forKey:YBOPTIONS_KEY_CONTENT_RENDITION];
    [dict setValue:self.contentCdn forKey:YBOPTIONS_KEY_CONTENT_CDN];
    [dict setValue:self.contentFps forKey:YBOPTIONS_KEY_CONTENT_FPS];
    [dict setValue:self.contentMetadata forKey:YBOPTIONS_KEY_CONTENT_METADATA];
    [dict setValue:self.contentIsLiveNoSeek forKey:YBOPTIONS_KEY_CONTENT_IS_LIVE_NO_SEEK];
    [dict setValue:self.adMetadata forKey:YBOPTIONS_KEY_AD_METADATA];
    [dict setValue:self.adsAfterStop forKey:YBOPTIONS_KEY_ADS_AFTERSTOP];
    [dict setValue:self.adCampaign forKey:YBOPTIONS_KEY_AD_CAMPAIGN];
    [dict setValue:self.adTitle forKey:YBOPTIONS_KEY_AD_TITLE];
    [dict setValue:self.adResource forKey:YBOPTIONS_KEY_AD_RESOURCE];
    [dict setValue:@(self.autoDetectBackground) forKey:YBOPTIONS_KEY_BACKGROUND];
    [dict setValue:@(self.offline) forKey:YBOPTIONS_KEY_OFFLINE];
    [dict setValue:self.anonymousUser forKey:YBOPTIONS_KEY_ANONYMOUS_USER];
    [dict setValue:self.isInfinity forKey:YBOPTIONS_KEY_IS_INFINITY];
    [dict setValue:self.smartswitchConfigCode forKey:YBOPTIONS_KEY_SS_CONFIG_CODE];
    [dict setValue:self.smartswitchGroupCode forKey:YBOPTIONS_KEY_SS_GROUP_CODE];
    [dict setValue:self.smartswitchContractCode forKey:YBOPTIONS_KEY_SS_CONTRACT_CODE];
    [dict setValue:self.customDimension1 forKey:YBOPTIONS_KEY_CUSTOM_DIMENSION_1];
    [dict setValue:self.customDimension2 forKey:YBOPTIONS_KEY_CUSTOM_DIMENSION_2];
    [dict setValue:self.customDimension3 forKey:YBOPTIONS_KEY_CUSTOM_DIMENSION_3];
    [dict setValue:self.customDimension4 forKey:YBOPTIONS_KEY_CUSTOM_DIMENSION_4];
    [dict setValue:self.customDimension5 forKey:YBOPTIONS_KEY_CUSTOM_DIMENSION_5];
    [dict setValue:self.customDimension6 forKey:YBOPTIONS_KEY_CUSTOM_DIMENSION_6];
    [dict setValue:self.customDimension7 forKey:YBOPTIONS_KEY_CUSTOM_DIMENSION_7];
    [dict setValue:self.customDimension8 forKey:YBOPTIONS_KEY_CUSTOM_DIMENSION_8];
    [dict setValue:self.customDimension9 forKey:YBOPTIONS_KEY_CUSTOM_DIMENSION_9];
    [dict setValue:self.customDimension10 forKey:YBOPTIONS_KEY_CUSTOM_DIMENSION_10];
    [dict setValue:self.customDimension11 forKey:YBOPTIONS_KEY_CUSTOM_DIMENSION_11];
    [dict setValue:self.customDimension12 forKey:YBOPTIONS_KEY_CUSTOM_DIMENSION_12];
    [dict setValue:self.customDimension13 forKey:YBOPTIONS_KEY_CUSTOM_DIMENSION_13];
    [dict setValue:self.customDimension14 forKey:YBOPTIONS_KEY_CUSTOM_DIMENSION_14];
    [dict setValue:self.customDimension15 forKey:YBOPTIONS_KEY_CUSTOM_DIMENSION_15];
    [dict setValue:self.customDimension16 forKey:YBOPTIONS_KEY_CUSTOM_DIMENSION_16];
    [dict setValue:self.customDimension17 forKey:YBOPTIONS_KEY_CUSTOM_DIMENSION_17];
    [dict setValue:self.customDimension18 forKey:YBOPTIONS_KEY_CUSTOM_DIMENSION_18];
    [dict setValue:self.customDimension19 forKey:YBOPTIONS_KEY_CUSTOM_DIMENSION_19];
    [dict setValue:self.customDimension20 forKey:YBOPTIONS_KEY_CUSTOM_DIMENSION_20];
    [dict setValue:self.adCustomDimension1 forKey:YBOPTIONS_KEY_AD_CUSTOM_DIMENSION_1];
    [dict setValue:self.adCustomDimension2 forKey:YBOPTIONS_KEY_AD_CUSTOM_DIMENSION_2];
    [dict setValue:self.adCustomDimension3 forKey:YBOPTIONS_KEY_AD_CUSTOM_DIMENSION_3];
    [dict setValue:self.adCustomDimension4 forKey:YBOPTIONS_KEY_AD_CUSTOM_DIMENSION_4];
    [dict setValue:self.adCustomDimension5 forKey:YBOPTIONS_KEY_AD_CUSTOM_DIMENSION_5];
    [dict setValue:self.adCustomDimension6 forKey:YBOPTIONS_KEY_AD_CUSTOM_DIMENSION_6];
    [dict setValue:self.adCustomDimension7 forKey:YBOPTIONS_KEY_AD_CUSTOM_DIMENSION_7];
    [dict setValue:self.adCustomDimension8 forKey:YBOPTIONS_KEY_AD_CUSTOM_DIMENSION_8];
    [dict setValue:self.adCustomDimension9 forKey:YBOPTIONS_KEY_AD_CUSTOM_DIMENSION_9];
    [dict setValue:self.adCustomDimension10 forKey:YBOPTIONS_KEY_AD_CUSTOM_DIMENSION_10];
    [dict setValue:self.appName forKey:YBOPTIONS_KEY_APP_NAME];
    [dict setValue:self.appReleaseVersion forKey:YBOPTIONS_KEY_APP_RELEASE_VERSION];
    [dict setValue:@(self.waitForMetadata) forKey:YBOPTIONS_KEY_WAIT_METADATA];
    [dict setValue:self.pendingMetadata forKey:YBOPTIONS_KEY_PENDING_METADATA];
    return [[NSDictionary alloc] initWithDictionary:dict];
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
