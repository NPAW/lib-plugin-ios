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
NSString * const YBOPTIONS_KEY_USER_EMAIL = @"user.email";
NSString * const YBOPTIONS_KEY_EXPERIMENT_IDS = @"experiments";
NSString * const YBOPTIONS_KEY_SS_CONFIG_CODE = @"smartswitch.configCode";
NSString * const YBOPTIONS_KEY_SS_GROUP_CODE = @"smartswitch.groupCode";
NSString * const YBOPTIONS_KEY_SS_CONTRACT_CODE = @"smartswitch.contractCode";

NSString * const YBOPTIONS_KEY_PARSE_HLS = @"parse.Hls";
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

NSString * const YBOPTIONS_KEY_SESSION_METRICS = @"session.metrics";

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
        self.userEmail = [decoder decodeObjectForKey:YBOPTIONS_KEY_USER_EMAIL];
        self.parseHls = [[decoder decodeObjectForKey:YBOPTIONS_KEY_PARSE_HLS] isEqualToValue:@YES];
        self.parseCdnNameHeader = [decoder decodeObjectForKey:YBOPTIONS_KEY_PARSE_CDN_NAME_HEADER];
        self.parseCdnNode = [[decoder decodeObjectForKey:YBOPTIONS_KEY_PARSE_CDN_NODE] isEqualToValue:@YES];
        self.parseCdnNodeList = [decoder decodeObjectForKey:YBOPTIONS_KEY_PARSE_CDN_NODE_LIST];
        self.parseLocationHeader = [[decoder decodeObjectForKey:YBOPTIONS_KEY_PARSE_LOCATION_HEADER] isEqualToValue:@YES];
        self.experimentIds = [decoder decodeObjectForKey:YBOPTIONS_KEY_EXPERIMENT_IDS];
        self.networkIP = [decoder decodeObjectForKey:YBOPTIONS_KEY_NETWORK_IP];
        self.networkIsp = [decoder decodeObjectForKey:YBOPTIONS_KEY_NETWORK_ISP];
        self.networkConnectionType = [decoder decodeObjectForKey:YBOPTIONS_KEY_NETWORK_CONNECTION_TYPE];
        self.userObfuscateIp = [decoder decodeObjectForKey:YBOPTIONS_KEY_USER_OBFUSCATE_IP];
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
        self.contentPackage = [decoder decodeObjectForKey:YBOPTIONS_KEY_CONTENT_PACKAGE];
        self.contentSaga = [decoder decodeObjectForKey:YBOPTIONS_KEY_CONTENT_SAGA];
        self.contentTvShow = [decoder decodeObjectForKey:YBOPTIONS_KEY_CONTENT_TV_SHOW];
        self.contentSeason = [decoder decodeObjectForKey:YBOPTIONS_KEY_CONTENT_SEASON];
        self.contentEpisodeTitle = [decoder decodeObjectForKey:YBOPTIONS_KEY_CONTENT_EPISODE_TITLE];
        self.contentChannel = [decoder decodeObjectForKey:YBOPTIONS_KEY_CONTENT_CHANNEL];
        self.contentId = [decoder decodeObjectForKey:YBOPTIONS_KEY_CONTENT_ID];
        self.contentImdbId = [decoder decodeObjectForKey:YBOPTIONS_KEY_CONTENT_IMDB_ID];
        self.contentGracenoteId = [decoder decodeObjectForKey:YBOPTIONS_KEY_CONTENT_GRACENOTE_ID];
        self.contentType = [decoder decodeObjectForKey:YBOPTIONS_KEY_CONTENT_TYPE];
        self.contentGenre = [decoder decodeObjectForKey:YBOPTIONS_KEY_CONTENT_GENRE];
        self.contentLanguage = [decoder decodeObjectForKey:YBOPTIONS_KEY_CONTENT_LANGUAGE];
        self.contentSubtitles = [decoder decodeObjectForKey:YBOPTIONS_KEY_CONTENT_SUBTITLES];
        self.contentContractedResolution = [decoder decodeObjectForKey:YBOPTIONS_KEY_CONTENT_CONTRACTED_RESOLUTION];
        self.contentCost = [decoder decodeObjectForKey:YBOPTIONS_KEY_CONTENT_COST];
        self.contentPrice = [decoder decodeObjectForKey:YBOPTIONS_KEY_CONTENT_PRICE];
        self.contentPlaybackType = [decoder decodeObjectForKey:YBOPTIONS_KEY_CONTENT_PLAYBACK_TYPE];
        self.contentDrm = [decoder decodeObjectForKey:YBOPTIONS_KEY_CONTENT_DRM];
        self.contentEncodingVideoCodec = [decoder decodeObjectForKey:YBOPTIONS_KEY_CONTENT_ENCODING_VIDEO_CODEC];
        self.contentEncodingAudioCodec = [decoder decodeObjectForKey:YBOPTIONS_KEY_CONTENT_ENCODING_AUDIO_CODEC];
        self.contentEncodingCodecSettings = [decoder decodeObjectForKey:YBOPTIONS_KEY_CONTENT_ENCODING_CODEC_SETTINGS];
        self.contentEncodingCodecProfile = [decoder decodeObjectForKey:YBOPTIONS_KEY_CONTENT_ENCODING_CODEC_PROFILE];
        self.contentEncodingContainerFormat = [decoder decodeObjectForKey:YBOPTIONS_KEY_CONTENT_ENCODING_CONTAINER_FORMAT];
        self.adMetadata = [decoder decodeObjectForKey:YBOPTIONS_KEY_AD_METADATA];
        self.adsAfterStop = [decoder decodeObjectForKey:YBOPTIONS_KEY_ADS_AFTERSTOP];
        self.adCampaign = [decoder decodeObjectForKey:YBOPTIONS_KEY_AD_CAMPAIGN];
        self.adTitle = [decoder decodeObjectForKey:YBOPTIONS_KEY_AD_TITLE];
        self.adResource = [decoder decodeObjectForKey:YBOPTIONS_KEY_AD_RESOURCE];
        self.adGivenBreaks = [decoder decodeObjectForKey:YBOPTIONS_KEY_AD_GIVEN_BREAKS];
        self.adExpectedBreaks = [decoder decodeObjectForKey:YBOPTIONS_KEY_AD_EXPECTED_BREAKS];
        self.adExpectedPattern = [decoder decodeObjectForKey:YBOPTIONS_KEY_AD_EXPECTED_PATTERN];
        self.adBreaksTime = [decoder decodeObjectForKey:YBOPTIONS_KEY_AD_BREAKS_TIME];
        self.adGivenAds = [decoder decodeObjectForKey:YBOPTIONS_KEY_AD_GIVEN_ADS];
        self.autoDetectBackground = [decoder decodeObjectForKey:YBOPTIONS_KEY_BACKGROUND];
        self.offline = [decoder decodeObjectForKey:YBOPTIONS_KEY_OFFLINE];
        self.anonymousUser = [decoder decodeObjectForKey:YBOPTIONS_KEY_ANONYMOUS_USER];
        self.isInfinity = [decoder decodeObjectForKey:YBOPTIONS_KEY_IS_INFINITY];
        self.smartswitchConfigCode = [decoder decodeObjectForKey:YBOPTIONS_KEY_SS_CONFIG_CODE];
        self.smartswitchGroupCode = [decoder decodeObjectForKey:YBOPTIONS_KEY_SS_GROUP_CODE];
        self.smartswitchContractCode = [decoder decodeObjectForKey:YBOPTIONS_KEY_SS_CONTRACT_CODE];
        self.contentCustomDimension1 = [decoder decodeObjectForKey:YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_1];
        self.contentCustomDimension2 = [decoder decodeObjectForKey:YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_2];
        self.contentCustomDimension3 = [decoder decodeObjectForKey:YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_3];
        self.contentCustomDimension4 = [decoder decodeObjectForKey:YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_4];
        self.contentCustomDimension5 = [decoder decodeObjectForKey:YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_5];
        self.contentCustomDimension6 = [decoder decodeObjectForKey:YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_6];
        self.contentCustomDimension7 = [decoder decodeObjectForKey:YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_7];
        self.contentCustomDimension8 = [decoder decodeObjectForKey:YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_8];
        self.contentCustomDimension9 = [decoder decodeObjectForKey:YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_9];
        self.contentCustomDimension10 = [decoder decodeObjectForKey:YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_10];
        self.contentCustomDimension11 = [decoder decodeObjectForKey:YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_11];
        self.contentCustomDimension12 = [decoder decodeObjectForKey:YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_12];
        self.contentCustomDimension13 = [decoder decodeObjectForKey:YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_13];
        self.contentCustomDimension14 = [decoder decodeObjectForKey:YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_14];
        self.contentCustomDimension15 = [decoder decodeObjectForKey:YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_15];
        self.contentCustomDimension16 = [decoder decodeObjectForKey:YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_16];
        self.contentCustomDimension17 = [decoder decodeObjectForKey:YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_17];
        self.contentCustomDimension18 = [decoder decodeObjectForKey:YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_18];
        self.contentCustomDimension19 = [decoder decodeObjectForKey:YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_19];
        self.contentCustomDimension20 = [decoder decodeObjectForKey:YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_20];
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
    [coder encodeObject:self.userEmail forKey:YBOPTIONS_KEY_USER_EMAIL];
    [coder encodeObject:@(self.parseHls) forKey:YBOPTIONS_KEY_PARSE_HLS];
    [coder encodeObject:self.parseCdnNameHeader forKey:YBOPTIONS_KEY_PARSE_CDN_NAME_HEADER];
    [coder encodeObject:@(self.parseCdnNode) forKey:YBOPTIONS_KEY_PARSE_CDN_NODE];
    [coder encodeObject:self.parseCdnNodeList forKey:YBOPTIONS_KEY_PARSE_CDN_NODE_LIST];
    [coder encodeObject:@(self.parseLocationHeader) forKey:YBOPTIONS_KEY_PARSE_LOCATION_HEADER];
    [coder encodeObject:self.experimentIds forKey:YBOPTIONS_KEY_EXPERIMENT_IDS];
    [coder encodeObject:self.networkIP forKey:YBOPTIONS_KEY_NETWORK_IP];
    [coder encodeObject:self.networkIsp forKey:YBOPTIONS_KEY_NETWORK_ISP];
    [coder encodeObject:self.networkConnectionType forKey:YBOPTIONS_KEY_NETWORK_CONNECTION_TYPE];
    [coder encodeObject:self.userObfuscateIp forKey:YBOPTIONS_KEY_USER_OBFUSCATE_IP];
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
    [coder encodeObject:self.contentPackage forKey:YBOPTIONS_KEY_CONTENT_PACKAGE];
    [coder encodeObject:self.contentSaga forKey:YBOPTIONS_KEY_CONTENT_SAGA];
    [coder encodeObject:self.contentTvShow forKey:YBOPTIONS_KEY_CONTENT_TV_SHOW];
    [coder encodeObject:self.contentSeason forKey:YBOPTIONS_KEY_CONTENT_SEASON];
    [coder encodeObject:self.contentEpisodeTitle forKey:YBOPTIONS_KEY_CONTENT_EPISODE_TITLE];
    [coder encodeObject:self.contentChannel forKey:YBOPTIONS_KEY_CONTENT_CHANNEL];
    [coder encodeObject:self.contentId forKey:YBOPTIONS_KEY_CONTENT_ID];
    [coder encodeObject:self.contentImdbId forKey:YBOPTIONS_KEY_CONTENT_IMDB_ID];
    [coder encodeObject:self.contentGracenoteId forKey:YBOPTIONS_KEY_CONTENT_GRACENOTE_ID];
    [coder encodeObject:self.contentType forKey:YBOPTIONS_KEY_CONTENT_TYPE];
    [coder encodeObject:self.contentGenre forKey:YBOPTIONS_KEY_CONTENT_GENRE];
    [coder encodeObject:self.contentLanguage forKey:YBOPTIONS_KEY_CONTENT_LANGUAGE];
    [coder encodeObject:self.contentSubtitles forKey:YBOPTIONS_KEY_CONTENT_SUBTITLES];
    [coder encodeObject:self.contentContractedResolution forKey:YBOPTIONS_KEY_CONTENT_CONTRACTED_RESOLUTION];
    [coder encodeObject:self.contentCost forKey:YBOPTIONS_KEY_CONTENT_COST];
    [coder encodeObject:self.contentPrice forKey:YBOPTIONS_KEY_CONTENT_PRICE];
    [coder encodeObject:self.contentPlaybackType forKey:YBOPTIONS_KEY_CONTENT_PLAYBACK_TYPE];
    [coder encodeObject:self.contentDrm forKey:YBOPTIONS_KEY_CONTENT_DRM];
    [coder encodeObject:self.contentEncodingVideoCodec forKey:YBOPTIONS_KEY_CONTENT_ENCODING_VIDEO_CODEC];
    [coder encodeObject:self.contentEncodingAudioCodec forKey:YBOPTIONS_KEY_CONTENT_ENCODING_AUDIO_CODEC];
    [coder encodeObject:self.contentEncodingCodecSettings forKey:YBOPTIONS_KEY_CONTENT_ENCODING_CODEC_SETTINGS];
    [coder encodeObject:self.contentEncodingCodecProfile forKey:YBOPTIONS_KEY_CONTENT_ENCODING_CODEC_PROFILE];
    [coder encodeObject:self.contentEncodingContainerFormat forKey:YBOPTIONS_KEY_CONTENT_ENCODING_CONTAINER_FORMAT];
    [coder encodeObject:self.adMetadata forKey:YBOPTIONS_KEY_AD_METADATA];
    [coder encodeObject:self.adsAfterStop forKey:YBOPTIONS_KEY_ADS_AFTERSTOP];
    [coder encodeObject:self.adCampaign forKey:YBOPTIONS_KEY_AD_CAMPAIGN];
    [coder encodeObject:self.adTitle forKey:YBOPTIONS_KEY_AD_TITLE];
    [coder encodeObject:self.adResource forKey:YBOPTIONS_KEY_AD_RESOURCE];
    [coder encodeObject:self.adGivenBreaks forKey:YBOPTIONS_KEY_AD_GIVEN_BREAKS];
    [coder encodeObject:self.adExpectedBreaks forKey:YBOPTIONS_KEY_AD_EXPECTED_BREAKS];
    [coder encodeObject:self.adExpectedPattern forKey:YBOPTIONS_KEY_AD_EXPECTED_PATTERN];
    [coder encodeObject:self.adBreaksTime forKey:YBOPTIONS_KEY_AD_BREAKS_TIME];
    [coder encodeObject:self.adGivenAds forKey:YBOPTIONS_KEY_AD_GIVEN_ADS];
    [coder encodeObject:@(self.autoDetectBackground) forKey:YBOPTIONS_KEY_BACKGROUND];
    [coder encodeObject:@(self.offline) forKey:YBOPTIONS_KEY_OFFLINE];
    [coder encodeObject:self.anonymousUser forKey:YBOPTIONS_KEY_ANONYMOUS_USER];
    [coder encodeObject:self.isInfinity forKey:YBOPTIONS_KEY_IS_INFINITY];
    [coder encodeObject:self.smartswitchConfigCode forKey:YBOPTIONS_KEY_SS_CONFIG_CODE];
    [coder encodeObject:self.smartswitchGroupCode forKey:YBOPTIONS_KEY_SS_GROUP_CODE];
    [coder encodeObject:self.smartswitchContractCode forKey:YBOPTIONS_KEY_SS_CONTRACT_CODE];
    [coder encodeObject:self.contentCustomDimension1 forKey:YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_1];
    [coder encodeObject:self.contentCustomDimension2 forKey:YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_2];
    [coder encodeObject:self.contentCustomDimension3 forKey:YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_3];
    [coder encodeObject:self.contentCustomDimension4 forKey:YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_4];
    [coder encodeObject:self.contentCustomDimension5 forKey:YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_5];
    [coder encodeObject:self.contentCustomDimension6 forKey:YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_6];
    [coder encodeObject:self.contentCustomDimension7 forKey:YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_7];
    [coder encodeObject:self.contentCustomDimension8 forKey:YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_8];
    [coder encodeObject:self.contentCustomDimension9 forKey:YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_9];
    [coder encodeObject:self.contentCustomDimension10 forKey:YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_10];
    [coder encodeObject:self.contentCustomDimension11 forKey:YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_11];
    [coder encodeObject:self.contentCustomDimension12 forKey:YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_12];
    [coder encodeObject:self.contentCustomDimension13 forKey:YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_13];
    [coder encodeObject:self.contentCustomDimension14 forKey:YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_14];
    [coder encodeObject:self.contentCustomDimension15 forKey:YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_15];
    [coder encodeObject:self.contentCustomDimension16 forKey:YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_16];
    [coder encodeObject:self.contentCustomDimension17 forKey:YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_17];
    [coder encodeObject:self.contentCustomDimension18 forKey:YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_18];
    [coder encodeObject:self.contentCustomDimension19 forKey:YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_19];
    [coder encodeObject:self.contentCustomDimension20 forKey:YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_20];
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
    self.host = @"a-fds.youborafds01.com";
    self.accountCode = @"nicetest";
    self.username = nil;
    self.userType = nil;
    self.userEmail = nil;
    self.anonymousUser = nil;
    
    self.parseHls = false;
    self.parseLocationHeader = false;
    self.parseCdnNameHeader = @"x-cdn-forward";
    self.parseCdnNode = false;
    self.parseLocationHeader = false;
    // TODO: Node list constants
    self.parseCdnNodeList = [NSMutableArray arrayWithObjects:YouboraCDNNameAkamai, YouboraCDNNameCloudfront, YouboraCDNNameLevel3, YouboraCDNNameFastly, YouboraCDNNameHighwinds, YouboraCDNNameTelefonica, nil];
    
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
    
    self.autoDetectBackground = YES;
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
    [dict setValue:self.userEmail forKey:YBOPTIONS_KEY_USER_EMAIL];
    [dict setValue:@(self.parseHls) forKey:YBOPTIONS_KEY_PARSE_HLS];
    [dict setValue:self.parseCdnNameHeader forKey:YBOPTIONS_KEY_PARSE_CDN_NAME_HEADER];
    [dict setValue:@(self.parseCdnNode) forKey:YBOPTIONS_KEY_PARSE_CDN_NODE];
    [dict setValue:self.parseCdnNodeList forKey:YBOPTIONS_KEY_PARSE_CDN_NODE_LIST];
    [dict setValue:@(self.parseLocationHeader) forKey:YBOPTIONS_KEY_PARSE_LOCATION_HEADER];
    [dict setValue:self.experimentIds forKey:YBOPTIONS_KEY_EXPERIMENT_IDS];
    [dict setValue:self.networkIP forKey:YBOPTIONS_KEY_NETWORK_IP];
    [dict setValue:self.networkIsp forKey:YBOPTIONS_KEY_NETWORK_ISP];
    [dict setValue:self.networkConnectionType forKey:YBOPTIONS_KEY_NETWORK_CONNECTION_TYPE];
    [dict setValue:self.userObfuscateIp forKey:YBOPTIONS_KEY_USER_OBFUSCATE_IP];
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
    [dict setValue:self.contentPackage forKey:YBOPTIONS_KEY_CONTENT_PACKAGE];
    [dict setValue:self.contentSaga forKey:YBOPTIONS_KEY_CONTENT_SAGA];
    [dict setValue:self.contentTvShow forKey:YBOPTIONS_KEY_CONTENT_TV_SHOW];
    [dict setValue:self.contentSeason forKey:YBOPTIONS_KEY_CONTENT_SEASON];
    [dict setValue:self.contentEpisodeTitle forKey:YBOPTIONS_KEY_CONTENT_EPISODE_TITLE];
    [dict setValue:self.contentChannel forKey:YBOPTIONS_KEY_CONTENT_CHANNEL];
    [dict setValue:self.contentId forKey:YBOPTIONS_KEY_CONTENT_ID];
    [dict setValue:self.contentImdbId forKey:YBOPTIONS_KEY_CONTENT_IMDB_ID];
    [dict setValue:self.contentGracenoteId forKey:YBOPTIONS_KEY_CONTENT_GRACENOTE_ID];
    [dict setValue:self.contentType forKey:YBOPTIONS_KEY_CONTENT_TYPE];
    [dict setValue:self.contentGenre forKey:YBOPTIONS_KEY_CONTENT_GENRE];
    [dict setValue:self.contentLanguage forKey:YBOPTIONS_KEY_CONTENT_LANGUAGE];
    [dict setValue:self.contentSubtitles forKey:YBOPTIONS_KEY_CONTENT_SUBTITLES];
    [dict setValue:self.contentContractedResolution forKey:YBOPTIONS_KEY_CONTENT_CONTRACTED_RESOLUTION];
    [dict setValue:self.contentCost forKey:YBOPTIONS_KEY_CONTENT_COST];
    [dict setValue:self.contentPrice forKey:YBOPTIONS_KEY_CONTENT_PRICE];
    [dict setValue:self.contentPlaybackType forKey:YBOPTIONS_KEY_CONTENT_PLAYBACK_TYPE];
    [dict setValue:self.contentDrm forKey:YBOPTIONS_KEY_CONTENT_DRM];
    [dict setValue:self.contentEncodingVideoCodec forKey:YBOPTIONS_KEY_CONTENT_ENCODING_VIDEO_CODEC];
    [dict setValue:self.contentEncodingAudioCodec forKey:YBOPTIONS_KEY_CONTENT_ENCODING_AUDIO_CODEC];
    [dict setValue:self.contentEncodingCodecSettings forKey:YBOPTIONS_KEY_CONTENT_ENCODING_CODEC_SETTINGS];
    [dict setValue:self.contentEncodingCodecProfile forKey:YBOPTIONS_KEY_CONTENT_ENCODING_CODEC_PROFILE];
    [dict setValue:self.contentEncodingContainerFormat forKey:YBOPTIONS_KEY_CONTENT_ENCODING_CONTAINER_FORMAT];
    [dict setValue:self.adMetadata forKey:YBOPTIONS_KEY_AD_METADATA];
    [dict setValue:self.adsAfterStop forKey:YBOPTIONS_KEY_ADS_AFTERSTOP];
    [dict setValue:self.adCampaign forKey:YBOPTIONS_KEY_AD_CAMPAIGN];
    [dict setValue:self.adTitle forKey:YBOPTIONS_KEY_AD_TITLE];
    [dict setValue:self.adResource forKey:YBOPTIONS_KEY_AD_RESOURCE];
    [dict setValue:self.adGivenBreaks forKey:YBOPTIONS_KEY_AD_GIVEN_BREAKS];
    [dict setValue:self.adExpectedBreaks forKey:YBOPTIONS_KEY_AD_EXPECTED_BREAKS];
    [dict setValue:self.adExpectedPattern forKey:YBOPTIONS_KEY_AD_EXPECTED_PATTERN];
    [dict setValue:self.adBreaksTime forKey:YBOPTIONS_KEY_AD_BREAKS_TIME];
    [dict setValue:self.adGivenAds forKey:YBOPTIONS_KEY_AD_GIVEN_ADS];
    [dict setValue:@(self.autoDetectBackground) forKey:YBOPTIONS_KEY_BACKGROUND];
    [dict setValue:@(self.offline) forKey:YBOPTIONS_KEY_OFFLINE];
    [dict setValue:self.anonymousUser forKey:YBOPTIONS_KEY_ANONYMOUS_USER];
    [dict setValue:self.isInfinity forKey:YBOPTIONS_KEY_IS_INFINITY];
    [dict setValue:self.smartswitchConfigCode forKey:YBOPTIONS_KEY_SS_CONFIG_CODE];
    [dict setValue:self.smartswitchGroupCode forKey:YBOPTIONS_KEY_SS_GROUP_CODE];
    [dict setValue:self.smartswitchContractCode forKey:YBOPTIONS_KEY_SS_CONTRACT_CODE];
    [dict setValue:self.contentCustomDimension1 forKey:YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_1];
    [dict setValue:self.contentCustomDimension2 forKey:YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_2];
    [dict setValue:self.contentCustomDimension3 forKey:YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_3];
    [dict setValue:self.contentCustomDimension4 forKey:YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_4];
    [dict setValue:self.contentCustomDimension5 forKey:YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_5];
    [dict setValue:self.contentCustomDimension6 forKey:YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_6];
    [dict setValue:self.contentCustomDimension7 forKey:YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_7];
    [dict setValue:self.contentCustomDimension8 forKey:YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_8];
    [dict setValue:self.contentCustomDimension9 forKey:YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_9];
    [dict setValue:self.contentCustomDimension10 forKey:YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_10];
    [dict setValue:self.contentCustomDimension11 forKey:YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_11];
    [dict setValue:self.contentCustomDimension12 forKey:YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_12];
    [dict setValue:self.contentCustomDimension13 forKey:YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_13];
    [dict setValue:self.contentCustomDimension14 forKey:YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_14];
    [dict setValue:self.contentCustomDimension15 forKey:YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_15];
    [dict setValue:self.contentCustomDimension16 forKey:YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_16];
    [dict setValue:self.contentCustomDimension17 forKey:YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_17];
    [dict setValue:self.contentCustomDimension18 forKey:YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_18];
    [dict setValue:self.contentCustomDimension19 forKey:YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_19];
    [dict setValue:self.contentCustomDimension20 forKey:YBOPTIONS_KEY_CONTENT_CUSTOM_DIMENSION_20];
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

@end
