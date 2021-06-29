//
//  UnityAdsAdapterConfiguration.m
//  MoPubSDK
//
//  Copyright © 2021 MoPub. All rights reserved.
//

#import <UnityAds/UnityAds.h>
#import "UnityAdsConstants.h"
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
    return kUnityAdsAdapterVersion;
}

- (NSString * _Nullable)biddingToken {
    return nil;
}

- (NSString * _Nonnull)moPubNetworkName {
    return kUnityAdsAdapterMoPubNetworkName;
}

- (NSString * _Nonnull)networkSdkVersion {
    return [UnityAds getVersion];
}

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

#pragma mark - Initialization

- (void)initializeNetworkWithConfiguration:(NSDictionary<NSString *, id> * _Nullable)configuration complete:(void(^ _Nullable)(NSError * _Nullable))complete {
    UnityAdsAdapterInitializationDelegate *delegate = [UnityAdsAdapterInitializationDelegate newWith: complete];
    NSString * gameId = configuration[kUnityAdsGameId];
    BOOL testMode = [[configuration[kUnityAdsTestMode] lowercaseString] isEqualToString:@"yes"];
    
    [UnityAds initialize:gameId
                testMode:testMode
  enablePerPlacementLoad:true
  initializationDelegate:delegate];
}

@end
