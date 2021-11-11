//
//  YBOptions.m
//  YouboraLib
//
//  Created by Joan on 17/03/2017.
//  Copyright © 2017 NPAW. All rights reserved.
//

#import "YBOptions.h"
#import "YBCdnParser.h"
#import "YouboraLib/YouboraLib-Swift.h"
#import "YBLog.h"

@interface YBOptions()

@property (nonatomic, strong) NSString * internalContentStreamingProtocol;
@property (nonatomic, strong) NSString * internalContentTransportFormat;

@end

@implementation YBOptions

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
NSString * const YBOPTIONS_KEY_USER_EMAIL = @"user.email";
NSString * const YBOPTIONS_KEY_EXPERIMENT_IDS = @"experiments";
NSString * const YBOPTIONS_KEY_SS_CONFIG_CODE = @"smartswitch.configCode";
NSString * const YBOPTIONS_KEY_SS_GROUP_CODE = @"smartswitch.groupCode";
NSString * const YBOPTIONS_KEY_SS_CONTRACT_CODE = @"smartswitch.contractCode";

NSString * const YBOPTIONS_KEY_PARSE_HLS = @"parse.Hls";
NSString * const YBOPTIONS_KEY_PARSE_DASH = @"parse.Dash";
NSString * const YBOPTIONS_KEY_PARSE_CDN_NAME_HEADER = @"parse.CdnNameHeader";
NSString * const YBOPTIONS_KEY_PARSE_CDN_NODE = @"parse.CdnNode";
NSString * const YBOPTIONS_KEY_PARSE_CDN_NODE_LIST = @"parse.CdnNodeList";
NSString * const YBOPTIONS_KEY_PARSE_LOCATION_HEADER = @"parse.LocationHeader";

NSString * const YBOPTIONS_KEY_NETWORK_IP = @"network.IP";
NSString * const YBOPTIONS_KEY_NETWORK_ISP = @"network.Isp";
NSString * const YBOPTIONS_KEY_NETWORK_CONNECTION_TYPE = @"network.connectionType";
NSString * const YBOPTIONS_KEY_USER_OBFUSCATE_IP = @"user.ObfuscateIp";

NSString * const YBOPTIONS_KEY_DEVICE_CODE = @"device.code";
NSString * const YBOPTIONS_KEY_DEVICE_MODEL = @"device.model";
NSString * const YBOPTIONS_KEY_DEVICE_BRAND = @"device.brand";
NSString * const YBOPTIONS_KEY_DEVICE_TYPE = @"device.type";
NSString * const YBOPTIONS_KEY_DEVICE_NAME = @"device.name";
NSString * const YBOPTIONS_KEY_DEVICE_OS_NAME = @"device.osNme";
NSString * const YBOPTIONS_KEY_DEVICE_OS_VERSION = @"device.osVersion";
NSString * const YBOPTIONS_KEY_DEVICE_IS_ANONYMOUS = @"device.isAnonymous";

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

NSString * const YBOPTIONS_KEY_CONTENT_PACKAGE = @"content.package";
NSString * const YBOPTIONS_KEY_CONTENT_SAGA = @"content.saga";
NSString * const YBOPTIONS_KEY_CONTENT_TV_SHOW = @"content.tvShow";
NSString * const YBOPTIONS_KEY_CONTENT_SEASON = @"content.season";
NSString * const YBOPTIONS_KEY_CONTENT_EPISODE_TITLE = @"content.episodeTitle";
NSString * const YBOPTIONS_KEY_CONTENT_CHANNEL = @"content.Channel";
NSString * const YBOPTIONS_KEY_CONTENT_ID = @"content.id";
NSString * const YBOPTIONS_KEY_CONTENT_IMDB_ID = @"content.imdbId";
NSString * const YBOPTIONS_KEY_CONTENT_GRACENOTE_ID = @"content.gracenoteId";
NSString * const YBOPTIONS_KEY_CONTENT_TYPE = @"content.type";
NSString * const YBOPTIONS_KEY_CONTENT_GENRE = @"content.genre";
NSString * const YBOPTIONS_KEY_CONTENT_LANGUAGE = @"content.language";
NSString * const YBOPTIONS_KEY_CONTENT_SUBTITLES = @"content.subtitles";
NSString * const YBOPTIONS_KEY_CONTENT_CONTRACTED_RESOLUTION = @"content.contractedResolution";
NSString * const YBOPTIONS_KEY_CONTENT_COST = @"content.cost";
NSString * const YBOPTIONS_KEY_CONTENT_PRICE = @"content.price";
NSString * const YBOPTIONS_KEY_CONTENT_PLAYBACK_TYPE = @"content.playbackType";
NSString * const YBOPTIONS_KEY_CONTENT_DRM = @"content.drm";
NSString * const YBOPTIONS_KEY_CONTENT_ENCODING_VIDEO_CODEC = @"content.encoding.videoCodec";
NSString * const YBOPTIONS_KEY_CONTENT_ENCODING_AUDIO_CODEC = @"content.encoding.audioCodec";
NSString * const YBOPTIONS_KEY_CONTENT_ENCODING_CODEC_SETTINGS = @"content.encoding.codecSettings";
NSString * const YBOPTIONS_KEY_CONTENT_ENCODING_CODEC_PROFILE = @"content.encoding.codecProfile";
NSString * const YBOPTIONS_KEY_CONTENT_ENCODING_CONTAINER_FORMAT = @"content.encoding.containerFormat";

NSString * const YBOPTIONS_KEY_AD_METADATA = @"ad.metadata";
NSString * const YBOPTIONS_KEY_AD_IGNORE = @"ad.ignore";
NSString * const YBOPTIONS_KEY_ADS_AFTERSTOP = @"ad.afterStop";
NSString * const YBOPTIONS_KEY_AD_CAMPAIGN = @"ad.campaign";
NSString * const YBOPTIONS_KEY_AD_TITLE = @"ad.title";
NSString * const YBOPTIONS_KEY_AD_RESOURCE = @"ad.resource";
NSString * const YBOPTIONS_KEY_AD_GIVEN_BREAKS = @"ad.givenBreaks";
NSString * const YBOPTIONS_KEY_AD_EXPECTED_BREAKS = @"ad.expectedBreaks";
NSString * const YBOPTIONS_KEY_AD_EXPECTED_PATTERN = @"ad.expectedPattern";
NSString * const YBOPTIONS_KEY_AD_BREAKS_TIME = @"ad.breaksTime";
NSString * const YBOPTIONS_KEY_AD_GIVEN_ADS = @"ad.givenAds";
NSString * const YBOPTIONS_KEY_AD_CREATIVEID = @"ad.creativeId";
NSString * const YBOPTIONS_KEY_AD_PROVIDER = @"ad.provider";

NSString * const YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_1 = @"contentCustom.dimension.1";
NSString * const YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_2 = @"contentCustom.dimension.2";
NSString * const YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_3 = @"contentCustom.dimension.3";
NSString * const YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_4 = @"contentCustom.dimension.4";
NSString * const YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_5 = @"contentCustom.dimension.5";
NSString * const YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_6 = @"contentCustom.dimension.6";
NSString * const YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_7 = @"contentCustom.dimension.7";
NSString * const YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_8 = @"contentCustom.dimension.8";
NSString * const YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_9 = @"contentCustom.dimension.9";
NSString * const YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_10 = @"contentCustom.dimension.10";
NSString * const YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_11 = @"contentCustom.dimension.11";
NSString * const YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_12 = @"contentCustom.dimension.12";
NSString * const YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_13 = @"contentCustom.dimension.13";
NSString * const YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_14 = @"contentCustom.dimension.14";
NSString * const YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_15 = @"contentCustom.dimension.15";
NSString * const YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_16 = @"contentCustom.dimension.16";
NSString * const YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_17 = @"contentCustom.dimension.17";
NSString * const YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_18 = @"contentCustom.dimension.18";
NSString * const YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_19 = @"contentCustom.dimension.19";
NSString * const YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_20 = @"contentCustom.dimension.20";

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

NSString * const YBOPTIONS_KEY_LINKED_VIEW_ID = @"linkedViewId";
NSString * const YBOPTIONS_KEY_WAIT_METADATA = @"waitForMetadata";
NSString * const YBOPTIONS_KEY_PENDING_METADATA = @"pendingMetadata";

NSString * const YBOPTIONS_KEY_SESSION_METRICS = @"session.metrics";

NSString * const YBOPTIONS_AD_POSITION_PRE = @"pre";
NSString * const YBOPTIONS_AD_POSITION_MID = @"mid";
NSString * const YBOPTIONS_AD_POSITION_POST = @"post";

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
        self.enabled = [[decoder decodeObjectForKey:YBOptionKeys.enabled] isEqualToValue:@YES];
        self.httpSecure = [[decoder decodeObjectForKey:YBOptionKeys.httpSecure] isEqualToValue:@YES];
        self.host = [decoder decodeObjectForKey:YBOptionKeys.host];
        self.accountCode = [decoder decodeObjectForKey:YBOptionKeys.accountCode];
        self.username = [decoder decodeObjectForKey:YBOptionKeys.username];
        self.userType = [decoder decodeObjectForKey:YBOptionKeys.userType];
        self.userEmail = [decoder decodeObjectForKey:YBOptionKeys.userEmail];
        self.parseResource = [decoder decodeBoolForKey:YBOptionKeys.parseResource];
        
        self.cdnSwitchHeader = [decoder decodeBoolForKey:YBOptionKeys.cdnSwitchHeader];
        self.cdnTTL = [decoder decodeBoolForKey:YBOptionKeys.cdnTTL];
        self.parseDash = [decoder decodeBoolForKey:YBOptionKeys.parseDash];
        self.parseHls = [[decoder decodeObjectForKey:YBOptionKeys.parseHls] isEqualToValue:@YES];
        self.parseLocationHeader = [[decoder decodeObjectForKey:YBOptionKeys.parseLocationHeader] isEqualToValue:@YES];
        
        self.parseCdnNode = [[decoder decodeObjectForKey:YBOptionKeys.parseCdnNode] isEqualToValue:@YES];
        self.parseCdnNameHeader = [decoder decodeObjectForKey:YBOptionKeys.parseCdnNameHeader];
        self.parseCdnNodeList = [decoder decodeObjectForKey:YBOptionKeys.parseCdnNodeList];
        self.experimentIds = [decoder decodeObjectForKey:YBOptionKeys.experimentIds];
        self.networkIP = [decoder decodeObjectForKey:YBOptionKeys.networkIP];
        self.networkIsp = [decoder decodeObjectForKey:YBOptionKeys.networkIsp];
        self.networkConnectionType = [decoder decodeObjectForKey:YBOptionKeys.networkConnectionType];
        self.userObfuscateIp = [decoder decodeObjectForKey:YBOptionKeys.userObfuscateIp];
        self.deviceCode = [decoder decodeObjectForKey:YBOptionKeys.deviceCode];
        self.forceInit = [[decoder decodeObjectForKey:YBOptionKeys.forceInit] isEqualToValue:@YES];
        self.deviceModel = [decoder decodeObjectForKey:YBOptionKeys.deviceModel];
        self.deviceName = [decoder decodeObjectForKey:YBOptionKeys.deviceName];
        self.deviceBrand = [decoder decodeObjectForKey:YBOptionKeys.deviceBrand];
        self.deviceType = [decoder decodeObjectForKey:YBOptionKeys.deviceType];
        self.deviceOsName = [decoder decodeObjectForKey:YBOptionKeys.deviceOsNme];
        self.deviceOsVersion = [decoder decodeObjectForKey:YBOptionKeys.deviceOsVersion];
        self.deviceIsAnonymous = [[decoder decodeObjectForKey:YBOptionKeys.deviceIsAnonymous] isEqualToValue:@YES];
        self.deviceUUID = [decoder decodeObjectForKey:YBOptionKeys.deviceUUID];
        self.deviceEDID = [decoder decodeObjectForKey:YBOptionKeys.deviceEDID];
        self.contentResource = [decoder decodeObjectForKey:YBOptionKeys.contentResource];
        self.contentIsLive = [decoder decodeObjectForKey:YBOptionKeys.contentIsLive];
        self.contentTitle = [decoder decodeObjectForKey:YBOptionKeys.contentTitle];
        self.program = [decoder decodeObjectForKey:YBOptionKeys.contentProgram];
        self.contentDuration = [decoder decodeObjectForKey:YBOptionKeys.contentDuration];
        self.contentTransactionCode = [decoder decodeObjectForKey:YBOptionKeys.contentTransactionCode];
        self.contentStreamingProtocol = [decoder decodeObjectForKey:YBOptionKeys.contentStreamingProtocol];
        self.contentTransportFormat = [decoder decodeObjectForKey:YBOptionKeys.contentTransportFormat];
        self.contentBitrate = [decoder decodeObjectForKey:YBOptionKeys.contentBitrate];
        self.contentTotalBytes = [decoder decodeObjectForKey: YBOptionKeys.contentTotalBytes];
        self.sendTotalBytes = [decoder decodeObjectForKey: YBOptionKeys.sendTotalBytes];
        self.contentThroughput = [decoder decodeObjectForKey:YBOptionKeys.contentThroughput];
        self.contentRendition = [decoder decodeObjectForKey:YBOptionKeys.contentRendition];
        self.contentCdn = [decoder decodeObjectForKey:YBOptionKeys.contentCdn];
        self.contentCdnNode = [decoder decodeObjectForKey:YBOptionKeys.contentCdnNode];
        self.contentCdnType = [decoder decodeObjectForKey:YBOptionKeys.contentCdnType];
        self.contentFps = [decoder decodeObjectForKey:YBOptionKeys.contentFps];
        self.contentMetadata = [decoder decodeObjectForKey:YBOptionKeys.contentMetadata];
        self.contentMetrics = [decoder decodeObjectForKey:YBOptionKeys.contentMetrics];
        self.contentIsLiveNoSeek = [decoder decodeObjectForKey:YBOptionKeys.contentIsLiveNoSeek];
        self.contentIsLiveNoMonitor = [decoder decodeObjectForKey:YBOptionKeys.contentIsLiveNoMonitor];
        self.contentPackage = [decoder decodeObjectForKey:YBOptionKeys.contentPackage];
        self.contentSaga = [decoder decodeObjectForKey:YBOptionKeys.contentSaga];
        self.contentTvShow = [decoder decodeObjectForKey:YBOptionKeys.contentTvShow];
        self.contentSeason = [decoder decodeObjectForKey:YBOptionKeys.contentSeason];
        self.contentEpisodeTitle = [decoder decodeObjectForKey:YBOptionKeys.contentEpisodeTitle];
        self.contentChannel = [decoder decodeObjectForKey:YBOptionKeys.contentChannel];
        self.contentId = [decoder decodeObjectForKey:YBOptionKeys.contentId];
        self.contentImdbId = [decoder decodeObjectForKey:YBOptionKeys.contentImdbId];
        self.contentGracenoteId = [decoder decodeObjectForKey:YBOptionKeys.contentGracenoteId];
        self.contentType = [decoder decodeObjectForKey:YBOptionKeys.contentType];
        self.contentGenre = [decoder decodeObjectForKey:YBOptionKeys.contentGenre];
        self.contentLanguage = [decoder decodeObjectForKey:YBOptionKeys.contentLanguage];
        self.contentSubtitles = [decoder decodeObjectForKey:YBOptionKeys.contentSubtitles];
        self.contentContractedResolution = [decoder decodeObjectForKey:YBOptionKeys.contentContractedResolution];
        self.contentCost = [decoder decodeObjectForKey:YBOptionKeys.contentCost];
        self.contentPrice = [decoder decodeObjectForKey:YBOptionKeys.contentPrice];
        self.contentPlaybackType = [decoder decodeObjectForKey:YBOptionKeys.contentPlaybackType];
        self.contentDrm = [decoder decodeObjectForKey:YBOptionKeys.contentDrm];
        self.contentEncodingVideoCodec = [decoder decodeObjectForKey:YBOptionKeys.contentEncodingVideoCodec];
        self.contentEncodingAudioCodec = [decoder decodeObjectForKey:YBOptionKeys.contentEncodingAudioCodec];
        self.contentEncodingCodecSettings = [decoder decodeObjectForKey:YBOptionKeys.contentEncodingCodecSettings];
        self.contentEncodingCodecProfile = [decoder decodeObjectForKey:YBOptionKeys.contentEncodingCodecProfile];
        self.contentEncodingContainerFormat = [decoder decodeObjectForKey:YBOptionKeys.contentEncodingContainerFormat];
        self.adMetadata = [decoder decodeObjectForKey:YBOptionKeys.adMetadata];
        self.adsAfterStop = [decoder decodeObjectForKey:YBOptionKeys.adAfterStop];
        self.adCampaign = [decoder decodeObjectForKey:YBOptionKeys.adCampaign];
        self.adTitle = [decoder decodeObjectForKey:YBOptionKeys.adTitle];
        self.adResource = [decoder decodeObjectForKey:YBOptionKeys.adResource];
        self.adGivenBreaks = [decoder decodeObjectForKey:YBOptionKeys.adGivenBreaks];
        self.adExpectedBreaks = [decoder decodeObjectForKey:YBOptionKeys.adExpectedBreaks];
        self.adExpectedPattern = [decoder decodeObjectForKey:YBOptionKeys.adExpectedPattern];
        self.adBreaksTime = [decoder decodeObjectForKey:YBOptionKeys.adBreaksTime];
        self.adGivenAds = [decoder decodeObjectForKey:YBOptionKeys.adGivenAds];
        self.adCreativeId = [decoder decodeObjectForKey:YBOptionKeys.adCreativeId];
        self.adProvider = [decoder decodeObjectForKey:YBOptionKeys.adProvider];
        self.autoDetectBackground = [[decoder decodeObjectForKey:YBOptionKeys.background] isEqualToValue:@YES];
        self.adBlockerDetected = [decoder decodeObjectForKey:YBOptionKeys.adBlockerDetected];
        self.offline = [[decoder decodeObjectForKey:YBOptionKeys.offline] isEqualToValue:@YES];
        self.anonymousUser = [decoder decodeObjectForKey:YBOptionKeys.anonymousUser];
        self.isInfinity = [decoder decodeObjectForKey: YBOptionKeys.isInfinity];
        self.smartswitchConfigCode = [decoder decodeObjectForKey:YBOptionKeys.ssConfigCode];
        self.smartswitchGroupCode = [decoder decodeObjectForKey:YBOptionKeys.ssGroupCode];
        self.smartswitchContractCode = [decoder decodeObjectForKey:YBOptionKeys.ssContractCode];
        self.contentCustomDimension1 = [decoder decodeObjectForKey:YBOptionKeys.contentCustomDimension1];
        self.contentCustomDimension2 = [decoder decodeObjectForKey:YBOptionKeys.contentCustomDimension2];
        self.contentCustomDimension3 = [decoder decodeObjectForKey:YBOptionKeys.contentCustomDimension3];
        self.contentCustomDimension4 = [decoder decodeObjectForKey:YBOptionKeys.contentCustomDimension4];
        self.contentCustomDimension5 = [decoder decodeObjectForKey:YBOptionKeys.contentCustomDimension5];
        self.contentCustomDimension6 = [decoder decodeObjectForKey:YBOptionKeys.contentCustomDimension6];
        self.contentCustomDimension7 = [decoder decodeObjectForKey:YBOptionKeys.contentCustomDimension7];
        self.contentCustomDimension8 = [decoder decodeObjectForKey:YBOptionKeys.contentCustomDimension8];
        self.contentCustomDimension9 = [decoder decodeObjectForKey:YBOptionKeys.contentCustomDimension9];
        self.contentCustomDimension10 = [decoder decodeObjectForKey:YBOptionKeys.contentCustomDimension10];
        self.contentCustomDimension11 = [decoder decodeObjectForKey:YBOptionKeys.contentCustomDimension11];
        self.contentCustomDimension12 = [decoder decodeObjectForKey:YBOptionKeys.contentCustomDimension12];
        self.contentCustomDimension13 = [decoder decodeObjectForKey:YBOptionKeys.contentCustomDimension13];
        self.contentCustomDimension14 = [decoder decodeObjectForKey:YBOptionKeys.contentCustomDimension14];
        self.contentCustomDimension15 = [decoder decodeObjectForKey:YBOptionKeys.contentCustomDimension15];
        self.contentCustomDimension16 = [decoder decodeObjectForKey:YBOptionKeys.contentCustomDimension16];
        self.contentCustomDimension17 = [decoder decodeObjectForKey:YBOptionKeys.contentCustomDimension17];
        self.contentCustomDimension18 = [decoder decodeObjectForKey:YBOptionKeys.contentCustomDimension18];
        self.contentCustomDimension19 = [decoder decodeObjectForKey:YBOptionKeys.contentCustomDimension19];
        self.contentCustomDimension20 = [decoder decodeObjectForKey:YBOptionKeys.contentCustomDimension20];
        self.contentCustomDimensions = [decoder decodeObjectForKey:YBOptionKeys.contentCustomDimensions];
        self.adCustomDimension1 = [decoder decodeObjectForKey:YBOptionKeys.adCustomDimension1];
        self.adCustomDimension2 = [decoder decodeObjectForKey:YBOptionKeys.adCustomDimension2];
        self.adCustomDimension3 = [decoder decodeObjectForKey:YBOptionKeys.adCustomDimension3];
        self.adCustomDimension4 = [decoder decodeObjectForKey:YBOptionKeys.adCustomDimension4];
        self.adCustomDimension5 = [decoder decodeObjectForKey:YBOptionKeys.adCustomDimension5];
        self.adCustomDimension6 = [decoder decodeObjectForKey:YBOptionKeys.adCustomDimension6];
        self.adCustomDimension7 = [decoder decodeObjectForKey:YBOptionKeys.adCustomDimension7];
        self.adCustomDimension8 = [decoder decodeObjectForKey:YBOptionKeys.adCustomDimension8];
        self.adCustomDimension9 = [decoder decodeObjectForKey:YBOptionKeys.adCustomDimension9];
        self.adCustomDimension10 = [decoder decodeObjectForKey:YBOptionKeys.adCustomDimension10];
        self.appName = [decoder decodeObjectForKey:YBOptionKeys.appName];
        self.appReleaseVersion = [decoder decodeObjectForKey:YBOptionKeys.appReleaseVersion];
        self.linkedViewId = [decoder decodeObjectForKey:YBOptionKeys.linkedViewId];
        self.waitForMetadata = [[decoder decodeObjectForKey:YBOptionKeys.waitMetadata] isEqualToValue:@YES];
        self.pendingMetadata = [decoder decodeObjectForKey:YBOptionKeys.pendingMetadata];
        self.sessionMetrics = [decoder decodeObjectForKey:YBOptionKeys.sessionMetrics];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:@(self.enabled) forKey:YBOptionKeys.enabled];
    [coder encodeObject:@(self.httpSecure) forKey:YBOptionKeys.httpSecure];
    [coder encodeObject:self.host forKey:YBOptionKeys.host];
    [coder encodeObject:self.accountCode forKey:YBOptionKeys.accountCode];
    [coder encodeObject:self.username forKey:YBOptionKeys.username];
    [coder encodeObject:self.userType forKey:YBOptionKeys.userType];
    [coder encodeObject:self.userEmail forKey:YBOptionKeys.userEmail];
    
    [coder encodeBool:self.parseResource forKey:YBOptionKeys.parseResource];
    [coder encodeBool:self.cdnSwitchHeader forKey:YBOptionKeys.cdnSwitchHeader];
    [coder encodeBool:self.cdnTTL forKey:YBOptionKeys.cdnTTL];
    [coder encodeBool:self.parseDash forKey:YBOptionKeys.parseDash];
    [coder encodeObject:@(self.parseHls) forKey:YBOptionKeys.parseHls];
    [coder encodeObject:@(self.parseCdnNode) forKey:YBOptionKeys.parseCdnNode];
    [coder encodeObject:@(self.parseLocationHeader) forKey:YBOptionKeys.parseLocationHeader];
    
    [coder encodeObject:self.parseCdnNameHeader forKey:YBOptionKeys.parseCdnNameHeader];
    [coder encodeObject:self.parseCdnNodeList forKey:YBOptionKeys.parseCdnNodeList];
    [coder encodeObject:self.experimentIds forKey:YBOptionKeys.experimentIds];
    [coder encodeObject:self.networkIP forKey:YBOptionKeys.networkIP];
    [coder encodeObject:self.networkIsp forKey:YBOptionKeys.networkIsp];
    [coder encodeObject:self.networkConnectionType forKey:YBOptionKeys.networkConnectionType];
    [coder encodeObject:self.userObfuscateIp forKey:YBOptionKeys.userObfuscateIp];
    [coder encodeObject:self.deviceCode forKey:YBOptionKeys.deviceCode];
    [coder encodeObject:@(self.forceInit) forKey:YBOptionKeys.forceInit];
    [coder encodeObject:self.deviceModel forKey:YBOptionKeys.deviceModel];
    [coder encodeObject:self.deviceBrand forKey:YBOptionKeys.deviceBrand];
    [coder encodeObject:self.deviceType forKey:YBOptionKeys.deviceType];
    [coder encodeObject:self.deviceName forKey:YBOptionKeys.deviceName];
    [coder encodeObject:self.deviceOsName forKey:YBOptionKeys.deviceOsNme];
    [coder encodeObject:self.deviceOsVersion forKey:YBOptionKeys.deviceOsVersion];
    [coder encodeObject:@(self.deviceIsAnonymous) forKey:YBOptionKeys.deviceIsAnonymous];
    [coder encodeObject:self.deviceUUID forKey:YBOptionKeys.deviceUUID];
    [coder encodeObject:self.deviceEDID forKey:YBOptionKeys.deviceEDID];
    [coder encodeObject:self.contentStreamingProtocol forKey:YBOptionKeys.contentStreamingProtocol];
    [coder encodeObject:self.contentTransportFormat forKey:YBOptionKeys.contentTransportFormat];
    [coder encodeObject:self.contentResource forKey:YBOptionKeys.contentResource];
    [coder encodeObject:self.contentIsLive forKey:YBOptionKeys.contentIsLive];
    [coder encodeObject:self.contentTitle forKey:YBOptionKeys.contentTitle];
    [coder encodeObject:self.program forKey:YBOptionKeys.contentProgram];
    [coder encodeObject:self.contentDuration forKey:YBOptionKeys.contentDuration];
    [coder encodeObject:self.contentTransactionCode forKey:YBOptionKeys.contentTransactionCode];
    [coder encodeObject:self.contentBitrate forKey:YBOptionKeys.contentBitrate];
    [coder encodeObject:self.contentTotalBytes forKey:YBOptionKeys.contentTotalBytes];
    [coder encodeObject:self.sendTotalBytes forKey:YBOptionKeys.sendTotalBytes];
    [coder encodeObject:self.contentThroughput forKey:YBOptionKeys.contentThroughput];
    [coder encodeObject:self.contentRendition forKey:YBOptionKeys.contentRendition];
    [coder encodeObject:self.contentCdn forKey:YBOptionKeys.contentCdn];
    [coder encodeObject:self.contentCdnNode forKey:YBOptionKeys.contentCdnNode];
    [coder encodeObject:self.contentCdnType forKey:YBOptionKeys.contentCdnType];
    [coder encodeObject:self.contentFps forKey:YBOptionKeys.contentFps];
    [coder encodeObject:self.contentMetadata forKey:YBOptionKeys.contentMetadata];
    [coder encodeObject:self.contentMetrics forKey:YBOptionKeys.contentMetrics];
    [coder encodeObject:self.contentIsLiveNoSeek forKey:YBOptionKeys.contentIsLiveNoSeek];
    [coder encodeObject:self.contentIsLiveNoMonitor forKey:YBOptionKeys.contentIsLiveNoMonitor];
    [coder encodeObject:self.contentPackage forKey:YBOptionKeys.contentPackage];
    [coder encodeObject:self.contentSaga forKey:YBOptionKeys.contentSaga];
    [coder encodeObject:self.contentTvShow forKey:YBOptionKeys.contentTvShow];
    [coder encodeObject:self.contentSeason forKey:YBOptionKeys.contentSeason];
    [coder encodeObject:self.contentEpisodeTitle forKey:YBOptionKeys.contentEpisodeTitle];
    [coder encodeObject:self.contentChannel forKey:YBOptionKeys.contentChannel];
    [coder encodeObject:self.contentId forKey:YBOptionKeys.contentId];
    [coder encodeObject:self.contentImdbId forKey:YBOptionKeys.contentImdbId];
    [coder encodeObject:self.contentGracenoteId forKey:YBOptionKeys.contentGracenoteId];
    [coder encodeObject:self.contentType forKey:YBOptionKeys.contentType];
    [coder encodeObject:self.contentGenre forKey:YBOptionKeys.contentGenre];
    [coder encodeObject:self.contentLanguage forKey:YBOptionKeys.contentLanguage];
    [coder encodeObject:self.contentSubtitles forKey:YBOptionKeys.contentSubtitles];
    [coder encodeObject:self.contentContractedResolution forKey:YBOptionKeys.contentContractedResolution];
    [coder encodeObject:self.contentCost forKey:YBOptionKeys.contentCost];
    [coder encodeObject:self.contentPrice forKey:YBOptionKeys.contentPrice];
    [coder encodeObject:self.contentPlaybackType forKey:YBOptionKeys.contentPlaybackType];
    [coder encodeObject:self.contentDrm forKey:YBOptionKeys.contentDrm];
    [coder encodeObject:self.contentEncodingVideoCodec forKey:YBOptionKeys.contentEncodingVideoCodec];
    [coder encodeObject:self.contentEncodingAudioCodec forKey:YBOptionKeys.contentEncodingAudioCodec];
    [coder encodeObject:self.contentEncodingCodecSettings forKey:YBOptionKeys.contentEncodingCodecSettings];
    [coder encodeObject:self.contentEncodingCodecProfile forKey:YBOptionKeys.contentEncodingCodecProfile];
    [coder encodeObject:self.contentEncodingContainerFormat forKey:YBOptionKeys.contentEncodingContainerFormat];
    [coder encodeObject:self.adMetadata forKey:YBOptionKeys.adMetadata];
    [coder encodeObject:self.adsAfterStop forKey:YBOptionKeys.adAfterStop];
    [coder encodeObject:self.adCampaign forKey:YBOptionKeys.adCampaign];
    [coder encodeObject:self.adTitle forKey:YBOptionKeys.adTitle];
    [coder encodeObject:self.adResource forKey:YBOptionKeys.adResource];
    [coder encodeObject:self.adGivenBreaks forKey:YBOptionKeys.adGivenBreaks];
    [coder encodeObject:self.adExpectedBreaks forKey:YBOptionKeys.adExpectedBreaks];
    [coder encodeObject:self.adExpectedPattern forKey:YBOptionKeys.adExpectedPattern];
    [coder encodeObject:self.adBreaksTime forKey:YBOptionKeys.adBreaksTime];
    [coder encodeObject:self.adGivenAds forKey:YBOptionKeys.adGivenAds];
    [coder encodeObject:self.adCreativeId forKey:YBOptionKeys.adCreativeId];
    [coder encodeObject:self.adProvider forKey:YBOptionKeys.adProvider];
    [coder encodeObject:@(self.autoDetectBackground) forKey:YBOptionKeys.background];
    [coder encodeObject:self.adBlockerDetected forKey:YBOptionKeys.adBlockerDetected];
    [coder encodeObject:@(self.offline) forKey:YBOptionKeys.offline];
    [coder encodeObject:self.anonymousUser forKey:YBOptionKeys.anonymousUser];
    [coder encodeObject:self.isInfinity forKey: YBOptionKeys.isInfinity];
    [coder encodeObject:self.smartswitchConfigCode forKey:YBOptionKeys.ssConfigCode];
    [coder encodeObject:self.smartswitchGroupCode forKey:YBOptionKeys.ssGroupCode];
    [coder encodeObject:self.smartswitchContractCode forKey:YBOptionKeys.ssContractCode];
    [coder encodeObject:self.contentCustomDimension1 forKey:YBOptionKeys.contentCustomDimension1];
    [coder encodeObject:self.contentCustomDimension2 forKey:YBOptionKeys.contentCustomDimension2];
    [coder encodeObject:self.contentCustomDimension3 forKey:YBOptionKeys.contentCustomDimension3];
    [coder encodeObject:self.contentCustomDimension4 forKey:YBOptionKeys.contentCustomDimension4];
    [coder encodeObject:self.contentCustomDimension5 forKey:YBOptionKeys.contentCustomDimension5];
    [coder encodeObject:self.contentCustomDimension6 forKey:YBOptionKeys.contentCustomDimension6];
    [coder encodeObject:self.contentCustomDimension7 forKey:YBOptionKeys.contentCustomDimension7];
    [coder encodeObject:self.contentCustomDimension8 forKey:YBOptionKeys.contentCustomDimension8];
    [coder encodeObject:self.contentCustomDimension9 forKey:YBOptionKeys.contentCustomDimension9];
    [coder encodeObject:self.contentCustomDimension10 forKey:YBOptionKeys.contentCustomDimension10];
    [coder encodeObject:self.contentCustomDimension11 forKey:YBOptionKeys.contentCustomDimension11];
    [coder encodeObject:self.contentCustomDimension12 forKey:YBOptionKeys.contentCustomDimension12];
    [coder encodeObject:self.contentCustomDimension13 forKey:YBOptionKeys.contentCustomDimension13];
    [coder encodeObject:self.contentCustomDimension14 forKey:YBOptionKeys.contentCustomDimension14];
    [coder encodeObject:self.contentCustomDimension15 forKey:YBOptionKeys.contentCustomDimension15];
    [coder encodeObject:self.contentCustomDimension16 forKey:YBOptionKeys.contentCustomDimension16];
    [coder encodeObject:self.contentCustomDimension17 forKey:YBOptionKeys.contentCustomDimension17];
    [coder encodeObject:self.contentCustomDimension18 forKey:YBOptionKeys.contentCustomDimension18];
    [coder encodeObject:self.contentCustomDimension19 forKey:YBOptionKeys.contentCustomDimension19];
    [coder encodeObject:self.contentCustomDimension20 forKey:YBOptionKeys.contentCustomDimension20];
    [coder encodeObject:self.contentCustomDimensions forKey:YBOptionKeys.contentCustomDimensions];
    [coder encodeObject:self.adCustomDimension1 forKey:YBOptionKeys.adCustomDimension1];
    [coder encodeObject:self.adCustomDimension2 forKey:YBOptionKeys.adCustomDimension2];
    [coder encodeObject:self.adCustomDimension3 forKey:YBOptionKeys.adCustomDimension3];
    [coder encodeObject:self.adCustomDimension4 forKey:YBOptionKeys.adCustomDimension4];
    [coder encodeObject:self.adCustomDimension5 forKey:YBOptionKeys.adCustomDimension5];
    [coder encodeObject:self.adCustomDimension6 forKey:YBOptionKeys.adCustomDimension6];
    [coder encodeObject:self.adCustomDimension7 forKey:YBOptionKeys.adCustomDimension7];
    [coder encodeObject:self.adCustomDimension8 forKey:YBOptionKeys.adCustomDimension8];
    [coder encodeObject:self.adCustomDimension9 forKey:YBOptionKeys.adCustomDimension9];
    [coder encodeObject:self.adCustomDimension10 forKey:YBOptionKeys.adCustomDimension10];
    [coder encodeObject:self.appName forKey:YBOptionKeys.appName];
    [coder encodeObject:self.appReleaseVersion forKey:YBOptionKeys.appReleaseVersion];
    [coder encodeObject:self.linkedViewId forKey:YBOptionKeys.linkedViewId];
    [coder encodeObject:@(self.waitForMetadata) forKey:YBOptionKeys.waitMetadata];
    [coder encodeObject:self.pendingMetadata forKey:YBOptionKeys.pendingMetadata];
    [coder encodeObject:self.sessionMetrics forKey:YBOptionKeys.sessionMetrics];
}

- (void) defaultValues {
    self.enabled = true;
    self.httpSecure = true;
    self.host = @"a-fds.youborafds01.com";
    self.accountCode = @"nicetest";
    self.username = nil;
    self.userType = nil;
    self.userEmail = nil;
    self.anonymousUser = nil;
    
    self.parseResource = false;
    self.parseHls = false;
    self.parseDash = false;
    self.parseCdnNode = false;
    self.parseLocationHeader = false;
    
    self.parseCdnNameHeader = @"x-cdn-forward";
    
    // TODO: Node list YBConstants
    self.parseCdnNodeList = [NSMutableArray arrayWithObjects:YouboraCDNNameAkamai, YouboraCDNNameCloudfront, YouboraCDNNameLevel3, YouboraCDNNameFastly, YouboraCDNNameHighwinds, YouboraCDNNameTelefonica, YouboraCDNNameAmazon, YouboraCDNNameEdgecast,nil];
    
    self.cdnSwitchHeader = NO;
    self.cdnTTL = 60;
    
    self.experimentIds = [[NSMutableArray alloc] init];
    
    self.networkIP = nil;
    self.networkIsp = nil;
    self.networkConnectionType = nil;
    self.userObfuscateIp = nil;
    
    self.deviceCode = nil;
    self.deviceModel = nil;
    self.deviceBrand = nil;
    self.deviceType = nil;
    self.deviceName = nil;
    self.deviceOsName = nil;
    self.deviceOsVersion = nil;
    self.deviceIsAnonymous = false;
    self.deviceUUID = nil;
    self.deviceEDID = nil;

    self.forceInit = false;
    
    self.contentStreamingProtocol = nil;
    self.contentResource = nil;
    self.contentIsLive = nil;
    self.contentTitle = nil;
    self.program = nil;
    self.contentDuration = nil;
    self.contentTransactionCode = nil;
    self.contentBitrate = nil;
    self.contentTotalBytes = nil;
    self.sendTotalBytes = nil;
    self.contentThroughput = nil;
    self.contentRendition = nil;
    self.contentCdn = nil;
    self.contentCdnNode = nil;
    self.contentCdnType = nil;
    self.contentFps = nil;
    self.contentMetadata = [NSMutableDictionary dictionary];
    self.contentMetrics = [NSMutableDictionary dictionary];
    self.contentIsLiveNoSeek = nil;
    self.contentIsLiveNoMonitor = nil;
    self.contentPackage = nil;
    self.contentSaga = nil;
    self.contentTvShow = nil;
    self.contentSeason = nil;
    self.contentEpisodeTitle = nil;
    self.contentChannel = nil;
    self.contentId = nil;
    self.contentImdbId = nil;
    self.contentGracenoteId = nil;
    self.contentType = nil;
    self.contentGenre = nil;
    self.contentLanguage = nil;
    self.contentSubtitles = nil;
    self.contentContractedResolution = nil;
    self.contentCost = nil;
    self.contentPrice = nil;
    self.contentPlaybackType = nil;
    self.contentDrm = nil;
    self.contentEncodingVideoCodec = nil;
    self.contentEncodingAudioCodec = nil;
    self.contentEncodingCodecSettings = [NSMutableDictionary dictionary];
    self.contentEncodingCodecProfile = nil;
    self.contentEncodingContainerFormat = nil;
    
    self.adMetadata = [NSMutableDictionary dictionary];
    self.adsAfterStop = @0;
    self.adCampaign = nil;
    self.adTitle = nil;
    self.adResource = nil;
    self.adGivenBreaks = nil;
    self.adExpectedBreaks = nil;
    self.adExpectedPattern = nil;
    self.adBreaksTime = nil;
    self.adGivenAds = nil;
    self.adCreativeId = nil;
    self.adProvider = nil;
    
    self.autoDetectBackground = YES;
    self.adBlockerDetected = nil;
    self.offline = NO;
    
    self.isInfinity = nil;
    
    //SmartSwitch
    self.smartswitchConfigCode = nil;
    self.smartswitchGroupCode = nil;
    self.smartswitchContractCode = nil;
    
    self.contentCustomDimension1 = nil;
    self.contentCustomDimension2 = nil;
    self.contentCustomDimension3 = nil;
    self.contentCustomDimension4 = nil;
    self.contentCustomDimension5 = nil;
    self.contentCustomDimension6 = nil;
    self.contentCustomDimension7 = nil;
    self.contentCustomDimension8 = nil;
    self.contentCustomDimension9 = nil;
    self.contentCustomDimension10 = nil;
    self.contentCustomDimension11 = nil;
    self.contentCustomDimension12 = nil;
    self.contentCustomDimension13 = nil;
    self.contentCustomDimension14 = nil;
    self.contentCustomDimension15 = nil;
    self.contentCustomDimension16 = nil;
    self.contentCustomDimension17 = nil;
    self.contentCustomDimension18 = nil;
    self.contentCustomDimension19 = nil;
    self.contentCustomDimension20 = nil;
    self.contentCustomDimensions = nil;

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
    
    self.linkedViewId = nil;
    self.waitForMetadata = false;
    self.pendingMetadata = [[NSArray alloc] init];
    
    self.sessionMetrics = [NSMutableDictionary dictionary];
}

- (NSDictionary *) toDictionary {
    NSMutableDictionary * dict = [[NSMutableDictionary alloc] init];
    [dict setValue:@(self.enabled) forKey:YBOptionKeys.enabled];
    [dict setValue:@(self.httpSecure) forKey:YBOptionKeys.httpSecure];
    [dict setValue:self.host forKey:YBOptionKeys.host];
    [dict setValue:self.accountCode forKey:YBOptionKeys.accountCode];
    [dict setValue:self.username forKey:YBOptionKeys.username];
    [dict setValue:self.userType forKey:YBOptionKeys.userType];
    [dict setValue:self.userEmail forKey:YBOptionKeys.userEmail];
    
    [dict setValue:@(self.parseResource) forKey:YBOptionKeys.parseResource];
    [dict setValue:@(self.cdnSwitchHeader) forKey:YBOptionKeys.cdnSwitchHeader];
    [dict setValue:@(self.cdnTTL) forKey:YBOptionKeys.cdnTTL];
    [dict setValue:@(self.parseDash) forKey:YBOptionKeys.parseDash];
    [dict setValue:@(self.parseHls) forKey:YBOptionKeys.parseHls];
    [dict setValue:@(self.parseCdnNode) forKey:YBOptionKeys.parseCdnNode];
    [dict setValue:@(self.parseLocationHeader) forKey:YBOptionKeys.parseLocationHeader];
    
    [dict setValue:self.parseCdnNameHeader forKey:YBOptionKeys.parseCdnNameHeader];
    [dict setValue:self.parseCdnNodeList forKey:YBOptionKeys.parseCdnNodeList];
    [dict setValue:self.experimentIds forKey:YBOptionKeys.experimentIds];
    [dict setValue:self.networkIP forKey:YBOptionKeys.networkIP];
    [dict setValue:self.networkIsp forKey:YBOptionKeys.networkIsp];
    [dict setValue:self.networkConnectionType forKey:YBOptionKeys.networkConnectionType];
    [dict setValue:self.userObfuscateIp forKey:YBOptionKeys.userObfuscateIp];
    [dict setValue:self.deviceCode forKey:YBOptionKeys.deviceCode];
    [dict setValue:@(self.forceInit) forKey:YBOptionKeys.forceInit];
    [dict setValue:self.deviceModel forKey:YBOptionKeys.deviceModel];
    [dict setValue:self.deviceBrand forKey:YBOptionKeys.deviceBrand];
    [dict setValue:self.deviceType forKey:YBOptionKeys.deviceType];
    [dict setValue:self.deviceName forKey:YBOptionKeys.deviceName];
    [dict setValue:self.deviceOsName forKey:YBOptionKeys.deviceOsNme];
    [dict setValue:self.deviceOsVersion forKey:YBOptionKeys.deviceOsVersion];
    [dict setValue:@(self.deviceIsAnonymous) forKey:YBOptionKeys.deviceIsAnonymous];
    [dict setValue:self.deviceUUID forKey: YBOptionKeys.deviceUUID];
    [dict setValue:self.deviceEDID forKey: YBOptionKeys.deviceEDID];
    [dict setValue:self.contentStreamingProtocol forKey:YBOptionKeys.contentStreamingProtocol];
    [dict setValue:self.contentTransportFormat forKey:YBOptionKeys.contentTransportFormat];
    [dict setValue:self.contentResource forKey:YBOptionKeys.contentResource];
    [dict setValue:self.contentIsLive forKey:YBOptionKeys.contentIsLive];
    [dict setValue:self.contentTitle forKey:YBOptionKeys.contentTitle];
    [dict setValue:self.program forKey:YBOptionKeys.contentProgram];
    [dict setValue:self.contentDuration forKey:YBOptionKeys.contentDuration];
    [dict setValue:self.contentTransactionCode forKey:YBOptionKeys.contentTransactionCode];
    [dict setValue:self.contentBitrate forKey:YBOptionKeys.contentBitrate];
    [dict setValue:self.contentTotalBytes forKey:YBOptionKeys.contentTotalBytes];
    [dict setValue:self.sendTotalBytes forKey:YBOptionKeys.sendTotalBytes];
    [dict setValue:self.contentThroughput forKey:YBOptionKeys.contentThroughput];
    [dict setValue:self.contentRendition forKey:YBOptionKeys.contentRendition];
    [dict setValue:self.contentCdn forKey:YBOptionKeys.contentCdn];
    [dict setValue:self.contentCdnNode forKey:YBOptionKeys.contentCdnNode];
    [dict setValue:self.contentCdnType forKey:YBOptionKeys.contentCdnType];
    [dict setValue:self.contentFps forKey:YBOptionKeys.contentFps];
    [dict setValue:self.contentMetadata forKey:YBOptionKeys.contentMetadata];
    [dict setValue:self.contentMetrics forKey:YBOptionKeys.contentMetrics];
    [dict setValue:self.contentIsLiveNoSeek forKey:YBOptionKeys.contentIsLiveNoSeek];
    [dict setValue:self.contentIsLiveNoMonitor forKey:YBOptionKeys.contentIsLiveNoMonitor];
    [dict setValue:self.contentPackage forKey:YBOptionKeys.contentPackage];
    [dict setValue:self.contentSaga forKey:YBOptionKeys.contentSaga];
    [dict setValue:self.contentTvShow forKey:YBOptionKeys.contentTvShow];
    [dict setValue:self.contentSeason forKey:YBOptionKeys.contentSeason];
    [dict setValue:self.contentEpisodeTitle forKey:YBOptionKeys.contentEpisodeTitle];
    [dict setValue:self.contentChannel forKey:YBOptionKeys.contentChannel];
    [dict setValue:self.contentId forKey:YBOptionKeys.contentId];
    [dict setValue:self.contentImdbId forKey:YBOptionKeys.contentImdbId];
    [dict setValue:self.contentGracenoteId forKey:YBOptionKeys.contentGracenoteId];
    [dict setValue:self.contentType forKey:YBOptionKeys.contentType];
    [dict setValue:self.contentGenre forKey:YBOptionKeys.contentGenre];
    [dict setValue:self.contentLanguage forKey:YBOptionKeys.contentLanguage];
    [dict setValue:self.contentSubtitles forKey:YBOptionKeys.contentSubtitles];
    [dict setValue:self.contentContractedResolution forKey:YBOptionKeys.contentContractedResolution];
    [dict setValue:self.contentCost forKey:YBOptionKeys.contentCost];
    [dict setValue:self.contentPrice forKey:YBOptionKeys.contentPrice];
    [dict setValue:self.contentPlaybackType forKey:YBOptionKeys.contentPlaybackType];
    [dict setValue:self.contentDrm forKey:YBOptionKeys.contentDrm];
    [dict setValue:self.contentEncodingVideoCodec forKey:YBOptionKeys.contentEncodingVideoCodec];
    [dict setValue:self.contentEncodingAudioCodec forKey:YBOptionKeys.contentEncodingAudioCodec];
    [dict setValue:self.contentEncodingCodecSettings forKey:YBOptionKeys.contentEncodingCodecSettings];
    [dict setValue:self.contentEncodingCodecProfile forKey:YBOptionKeys.contentEncodingCodecProfile];
    [dict setValue:self.contentEncodingContainerFormat forKey:YBOptionKeys.contentEncodingContainerFormat];
    [dict setValue:self.adMetadata forKey:YBOptionKeys.adMetadata];
    [dict setValue:self.adsAfterStop forKey:YBOptionKeys.adAfterStop];
    [dict setValue:self.adCampaign forKey:YBOptionKeys.adCampaign];
    [dict setValue:self.adTitle forKey:YBOptionKeys.adTitle];
    [dict setValue:self.adResource forKey:YBOptionKeys.adResource];
    [dict setValue:self.adGivenBreaks forKey:YBOptionKeys.adGivenBreaks];
    [dict setValue:self.adExpectedBreaks forKey:YBOptionKeys.adExpectedBreaks];
    [dict setValue:self.adExpectedPattern forKey:YBOptionKeys.adExpectedPattern];
    [dict setValue:self.adBreaksTime forKey:YBOptionKeys.adBreaksTime];
    [dict setValue:self.adGivenAds forKey:YBOptionKeys.adGivenAds];
    [dict setValue:self.adCreativeId forKey:YBOptionKeys.adCreativeId];
    [dict setValue:self.adProvider forKey:YBOptionKeys.adProvider];
    [dict setValue:@(self.autoDetectBackground) forKey:YBOptionKeys.background];
    [dict setValue:self.adBlockerDetected forKey:YBOptionKeys.adBlockerDetected];
    [dict setValue:@(self.offline) forKey:YBOptionKeys.offline];
    [dict setValue:self.anonymousUser forKey:YBOptionKeys.anonymousUser];
    [dict setValue:self.isInfinity forKey: YBOptionKeys.isInfinity];
    [dict setValue:self.smartswitchConfigCode forKey:YBOptionKeys.ssConfigCode];
    [dict setValue:self.smartswitchGroupCode forKey:YBOptionKeys.ssGroupCode];
    [dict setValue:self.smartswitchContractCode forKey:YBOptionKeys.ssContractCode];
    [dict setValue:self.contentCustomDimension1 forKey:YBOptionKeys.contentCustomDimension1];
    [dict setValue:self.contentCustomDimension2 forKey:YBOptionKeys.contentCustomDimension2];
    [dict setValue:self.contentCustomDimension3 forKey:YBOptionKeys.contentCustomDimension3];
    [dict setValue:self.contentCustomDimension4 forKey:YBOptionKeys.contentCustomDimension4];
    [dict setValue:self.contentCustomDimension5 forKey:YBOptionKeys.contentCustomDimension5];
    [dict setValue:self.contentCustomDimension6 forKey:YBOptionKeys.contentCustomDimension6];
    [dict setValue:self.contentCustomDimension7 forKey:YBOptionKeys.contentCustomDimension7];
    [dict setValue:self.contentCustomDimension8 forKey:YBOptionKeys.contentCustomDimension8];
    [dict setValue:self.contentCustomDimension9 forKey:YBOptionKeys.contentCustomDimension9];
    [dict setValue:self.contentCustomDimension10 forKey:YBOptionKeys.contentCustomDimension10];
    [dict setValue:self.contentCustomDimension11 forKey:YBOptionKeys.contentCustomDimension11];
    [dict setValue:self.contentCustomDimension12 forKey:YBOptionKeys.contentCustomDimension12];
    [dict setValue:self.contentCustomDimension13 forKey:YBOptionKeys.contentCustomDimension13];
    [dict setValue:self.contentCustomDimension14 forKey:YBOptionKeys.contentCustomDimension14];
    [dict setValue:self.contentCustomDimension15 forKey:YBOptionKeys.contentCustomDimension15];
    [dict setValue:self.contentCustomDimension16 forKey:YBOptionKeys.contentCustomDimension16];
    [dict setValue:self.contentCustomDimension17 forKey:YBOptionKeys.contentCustomDimension17];
    [dict setValue:self.contentCustomDimension18 forKey:YBOptionKeys.contentCustomDimension18];
    [dict setValue:self.contentCustomDimension19 forKey:YBOptionKeys.contentCustomDimension19];
    [dict setValue:self.contentCustomDimension20 forKey:YBOptionKeys.contentCustomDimension20];
    [dict setValue:self.contentCustomDimensions forKey:YBOptionKeys.contentCustomDimensions];
    [dict setValue:self.adCustomDimension1 forKey:YBOptionKeys.adCustomDimension1];
    [dict setValue:self.adCustomDimension2 forKey:YBOptionKeys.adCustomDimension2];
    [dict setValue:self.adCustomDimension3 forKey:YBOptionKeys.adCustomDimension3];
    [dict setValue:self.adCustomDimension4 forKey:YBOptionKeys.adCustomDimension4];
    [dict setValue:self.adCustomDimension5 forKey:YBOptionKeys.adCustomDimension5];
    [dict setValue:self.adCustomDimension6 forKey:YBOptionKeys.adCustomDimension6];
    [dict setValue:self.adCustomDimension7 forKey:YBOptionKeys.adCustomDimension7];
    [dict setValue:self.adCustomDimension8 forKey:YBOptionKeys.adCustomDimension8];
    [dict setValue:self.adCustomDimension9 forKey:YBOptionKeys.adCustomDimension9];
    [dict setValue:self.adCustomDimension10 forKey:YBOptionKeys.adCustomDimension10];
    [dict setValue:self.appName forKey:YBOptionKeys.appName];
    [dict setValue:self.appReleaseVersion forKey:YBOptionKeys.appReleaseVersion];
    [dict setValue:self.linkedViewId forKey:YBOptionKeys.linkedViewId];
    [dict setValue:@(self.waitForMetadata) forKey:YBOptionKeys.waitMetadata];
    [dict setValue:self.pendingMetadata forKey:YBOptionKeys.pendingMetadata];
    [dict setValue:self.sessionMetrics forKey:YBOptionKeys.sessionMetrics];
    return [[NSDictionary alloc] initWithDictionary:dict];
}

- (void) setResourceParseJoin:(bool)parse {
    if (!self.parseResource && parse) {
        self.parseResource = parse;
    }
}

- (void) setContentTitle2:(NSString *)contentTitle2 {
    self.program = contentTitle2;
}

- (void) setExtraParam1:(NSString *)extraparam1 {
    self.contentCustomDimension1 = extraparam1;
}

- (void) setExtraParam2:(NSString *)extraparam2 {
    self.contentCustomDimension2 = extraparam2;
}

- (void) setExtraParam3:(NSString *)extraparam3 {
    self.contentCustomDimension3 = extraparam3;
}

- (void) setExtraParam4:(NSString *)extraparam4 {
    self.contentCustomDimension4 = extraparam4;
}

- (void) setExtraParam5:(NSString *)extraparam5 {
    self.contentCustomDimension5 = extraparam5;
}

- (void) setExtraParam6:(NSString *)extraparam6 {
    self.contentCustomDimension6 = extraparam6;
}

- (void) setExtraParam7:(NSString *)extraparam7 {
    self.contentCustomDimension7 = extraparam7;
}

- (void) setExtraParam8:(NSString *)extraparam8 {
    self.contentCustomDimension8 = extraparam8;
}

- (void) setExtraParam9:(NSString *)extraparam9 {
    self.contentCustomDimension9 = extraparam9;
}

- (void) setExtraParam10:(NSString *)extraparam10 {
    self.contentCustomDimension10 = extraparam10;
}

- (void) setExtraParam11:(NSString *)extraparam11 {
    self.contentCustomDimension11 = extraparam11;
}

- (void) setExtraParam12:(NSString *)extraparam12 {
    self.contentCustomDimension12 = extraparam12;
}

- (void) setExtraParam13:(NSString *)extraparam13 {
    self.contentCustomDimension13 = extraparam13;
}

- (void) setExtraParam14:(NSString *)extraparam14 {
    self.contentCustomDimension14 = extraparam14;
}

- (void) setExtraParam15:(NSString *)extraparam15 {
    self.contentCustomDimension15 = extraparam15;
}

- (void) setExtraParam16:(NSString *)extraparam16 {
    self.contentCustomDimension16 = extraparam16;
}

- (void) setExtraParam17:(NSString *)extraparam17 {
    self.contentCustomDimension17 = extraparam17;
}

- (void) setExtraParam18:(NSString *)extraparam18 {
    self.contentCustomDimension18 = extraparam18;
}

- (void) setExtraParam19:(NSString *)extraparam19 {
    self.contentCustomDimension19 = extraparam19;
}

- (void) setExtraParam20:(NSString *)extraparam20 {
    self.contentCustomDimension20 = extraparam20;
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

- (void) setNetworkObfuscateIp:(NSValue *)networkObfuscateIp {
    self.userObfuscateIp = networkObfuscateIp;
}

- (void)setDeviceEDID:(id)deviceEDID {
    if ([deviceEDID isKindOfClass:[NSData class]]) {
        _deviceEDID = [[NSString alloc] initWithData:deviceEDID encoding:NSUTF8StringEncoding];
    } else if ([deviceEDID isKindOfClass:[NSString class]]) {
        _deviceEDID = deviceEDID;
    } else if (deviceEDID) {
        [YBLog error:@"DeviceEDID value format is wrong. Please set this option as a String or Data."];
    }
}

-(void)setContentStreamingProtocol:(NSString*)streamingProtocol {
    NSArray <NSString*> *allowedProtocols = @[
        YBConstantsStreamProtocol.dash,
        YBConstantsStreamProtocol.hds,
        YBConstantsStreamProtocol.hls,
        YBConstantsStreamProtocol.mss,
        YBConstantsStreamProtocol.rtmp,
        YBConstantsStreamProtocol.rtp,
        YBConstantsStreamProtocol.rtsp
    ];
    
    for (NSString *allowedStreamingProtocol in allowedProtocols) {
        if ([[allowedStreamingProtocol lowercaseString] isEqualToString:[streamingProtocol lowercaseString]]) {
            self.internalContentStreamingProtocol = streamingProtocol;
            return;
        }
    }
}

-(NSString*)contentStreamingProtocol {
    return self.internalContentStreamingProtocol;
}

-(void)setContentTransportFormat:(NSString*)transportFormat {
    NSArray <NSString*> *allowedFormats= @[
        YBConstantsTransportFormat.hlsFmp4,
        YBConstantsTransportFormat.hlsTs,
        YBConstantsTransportFormat.hlsCmfv
    ];
    
    for (NSString *allowedFormat in allowedFormats) {
        if ([[allowedFormat lowercaseString] isEqualToString:[transportFormat lowercaseString]]) {
            self.internalContentTransportFormat = transportFormat;
            return;
        }
    }
}

-(NSString*)contentTransportFormat {
    return self.internalContentTransportFormat;
}
@end
