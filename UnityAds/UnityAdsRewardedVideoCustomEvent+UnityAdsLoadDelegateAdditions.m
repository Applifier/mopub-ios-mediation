//
//  UnityAdsRewardedVideoCustomEvent+UnityAdsLoadDelegateAdditions.m
//  MoPubSDK
//
//  Copyright © 2021 MoPub. All rights reserved.
//

#import "UnityAdsConstants.h"
#import "UnityAdsRewardedVideoCustomEvent+UnityAdsLoadDelegateAdditions.h"

#if __has_include(<MoPub/MoPub.h>)
    #import <MoPub/MoPub.h>
#elif __has_include(<MoPubSDK/MoPub.h>)
    #import <MoPubSDK/MoPub.h>
#else
    #import "MPFullscreenAdAdapter.h"
#endif

#import "MPLogging.h"
#import "MPError.h"

@interface UnityAdsRewardedVideoCustomEvent ()

@property (nonatomic, copy) NSString *placementId;
@property (nonatomic) BOOL adLoaded;

@end

@implementation UnityAdsRewardedVideoCustomEvent (UnityAdsLoadDelegate)

- (void)unityAdsAdLoaded:(NSString * _Nonnull)placementId {
    self.adLoaded = YES;
    [self.delegate fullscreenAdAdapterDidLoadAd:self];
}

- (void)unityAdsAdFailedToLoad:(NSString * _Nonnull)placementId withError:(UnityAdsLoadError)error withMessage:(NSString * _Nonnull)message {

    MOPUBErrorCode code;
    NSString *description;

    switch(error) {
        case kUnityAdsLoadErrorInitializeFailed:
            code = MOPUBErrorSDKNotInitialized;
            description = kUnityAdsAdapterLoadErrorInitializeFailed;
            break;
        case kUnityAdsLoadErrorInvalidArgument:
            code = MOPUBErrorUnknown;
            description = kUnityAdsAdapterLoadErrorInvalidArgument;
            break;
        case kUnityAdsLoadErrorNoFill:
            code = MOPUBErrorNoInventory;
            description = kUnityAdsAdapterLoadErrorNoFill;
            break;
        case kUnityAdsLoadErrorTimeout:
            code = MOPUBErrorNetworkTimedOut;
            description = kUnityAdsAdapterLoadErrorTimeout;
            break;
        case kUnityAdsLoadErrorInternal:
            code = MOPUBErrorUnknown;
            description = kUnityAdsAdapterLoadErrorInternal;
            break;
        default:
            code = MOPUBErrorUnknown;
            description = kUnityAdsAdapterLoadErrorUnknown;
            break;
    }

    NSError *loadError = [NSError errorWithCode:code localizedDescription:description];
    [self.delegate fullscreenAdAdapter:self didFailToLoadAdWithError: loadError];
}

@end
