//
//  UnityAdsAdapterConfiguration.m
//  MoPubSDK
//
//  Copyright © 2021 MoPub. All rights reserved.
//

#import <UnityAds/UnityAds.h>
#import "UnityAdsAdapterConfiguration.h"
#import "UnityAdsAdapterInitializationDelegate.h"
#if __has_include("MoPub.h")
    #import "MoPub.h"
    #import "MPLogging.h"
#endif
#import "UnityAdsConstants.h"

@implementation UnityAdsAdapterConfiguration

#pragma mark - MPAdapterConfiguration

- (NSString * _Nonnull)adapterVersion {
    return kAdapterVersion;
}

- (NSString * _Nullable)biddingToken {
    return nil;
}

- (NSString * _Nonnull)moPubNetworkName {
    return kMoPubNetworkName;
}

- (NSString * _Nonnull)networkSdkVersion {
    return [UnityAds getVersion];
}

#pragma mark - Caching

/**
 TOOD: Doc
 */
+ (void)updateInitializationParameters:(NSDictionary *)parameters {
    // These should correspond to the required parameters checked in
    // `initializeNetworkWithConfiguration:complete:`
    NSString * gameId = parameters[kUnityAdsGameId];
    
    if (gameId != nil) {
        NSDictionary * configuration = @{ kUnityAdsGameId: gameId };
        [UnityAdsAdapterConfiguration setCachedInitializationParameters:configuration];
    }
}

#pragma mark - Initialization

/**
 TODO: Doc
 */
- (void)initializeNetworkWithConfiguration:(NSDictionary<NSString *, id> * _Nullable)configuration complete:(void(^ _Nullable)(NSError * _Nullable))complete {
    UnityAdsAdapterInitializationDelegate *delegate = [[UnityAdsAdapterInitializationDelegate alloc] init];
    delegate.initCompletion = complete;
    NSString * gameId = configuration[kUnityAdsGameId];
    
    // TODO: Question: Is there a way to test if the MoPub SDK is configured for test mode
    // and use that setting for testmode here?
    [UnityAds initialize:gameId
                testMode:true
  enablePerPlacementLoad:true
  initializationDelegate:delegate];
}

@end
