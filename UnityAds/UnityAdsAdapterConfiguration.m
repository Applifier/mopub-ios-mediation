//
//  UnityAdsAdapterConfiguration.m
//  MoPubSDK
//
//  Copyright © 2017 MoPub. All rights reserved.
//

#import <UnityAds/UnityAds.h>
#import "UnityAdsAdapterConfiguration.h"
#import "UnityRouter.h"
#if __has_include("MoPub.h")
#import "MoPub.h"
#import "MPLogging.h"
#endif

//Adapter version
NSString *const ADAPTER_VERSION = @"3.4.2.0";

// Initialization configuration keys
static NSString * const kUnityAdsGameId = @"gameId";

// Errors
static NSString * const kAdapterErrorDomain = @"com.mopub.mopub-ios-sdk.mopub-unity-adapters";


typedef NS_ENUM(NSInteger, UnityAdsAdapterErrorCode) {
    UnityAdsAdapterErrorCodeMissingGameId,
};

@implementation UnityAdsAdapterConfiguration

#pragma mark - Caching

+ (void)updateInitializationParameters:(NSDictionary *)parameters {
    // These should correspond to the required parameters checked in
    // `initializeNetworkWithConfiguration:complete:`
    NSString * gameId = parameters[kUnityAdsGameId];
    
    if (gameId != nil) {
        NSDictionary * configuration = @{ kUnityAdsGameId: gameId };
        [UnityAdsAdapterConfiguration setCachedInitializationParameters:configuration];
    }
}

#pragma mark - MPAdapterConfiguration

- (NSString *)adapterVersion {
    return ADAPTER_VERSION;
}

- (NSString *)biddingToken {
    return [UnityAds requestToken];
}

- (NSString *)moPubNetworkName {
    return @"unity";
}

- (NSString *)networkSdkVersion {
    return [UnityAds getVersion];
}

- (void)initializeNetworkWithConfiguration:(NSDictionary<NSString *, id> *)configuration
                                  complete:(void(^)(NSError *))complete {
    NSString * gameId = configuration[kUnityAdsGameId];
    if (gameId == nil) {
        NSError * error = [NSError errorWithDomain:kAdapterErrorDomain code:UnityAdsAdapterErrorCodeMissingGameId userInfo:@{ NSLocalizedDescriptionKey: @"Unity Ads initialization skipped. The gameId is empty. Ensure it is properly configured on the MoPub dashboard." }];
        MPLogEvent([MPLogEvent error:error message:nil]);
        
        if (complete != nil) {
            complete(error);
        }
        return;
    }
    
    [[UnityRouter sharedRouter] initializeWithGameId:gameId];
    if (complete != nil) {
        complete(nil);
    }
    
    MPBLogLevel logLevel = [[MoPub sharedInstance] logLevel];
    BOOL debugModeEnabled = logLevel == MPBLogLevelDebug;

    [UnityAds setDebugMode:debugModeEnabled];
    [UnityAds addDelegate:self];
}

- (void)unityAdsTokenReady:(NSString*)token {
}

- (void)unityAdsBidFailedToLoad:(NSString*)uuid {
}


- (void)unityAdsBidLoaded:(NSString*)uuid {
}

- (void)unityAdsDidError:(UnityAdsError)error withMessage:(nonnull NSString *)message {
}

- (void)unityAdsDidFinish:(nonnull NSString *)placementId withFinishState:(UnityAdsFinishState)state {
}

- (void)unityAdsDidStart:(nonnull NSString *)placementId {
}

- (void)unityAdsReady:(nonnull NSString *)placementId {
}

@end
