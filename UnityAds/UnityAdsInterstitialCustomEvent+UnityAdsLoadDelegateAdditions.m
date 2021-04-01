//
//  UnityAdsInterstitial+UnityAdsLoadDelegateAdditions.m
//  MoPubSDK
//
//  Copyright © 2021 MoPub. All rights reserved.
//

#import "UnityAdsInterstitialCustomEvent+UnityAdsLoadDelegateAdditions.h"
#import "MPLogging.h"

@interface UnityAdsInterstitialCustomEvent ()

// TODO: Question: is this best practice?
@property (nonatomic, copy) NSString *placementId;

@end

@implementation UnityAdsInterstitialCustomEvent (UnityAdsLoadDelegate)

- (void)unityAdsAdLoaded:(NSString * _Nonnull)placementId {
    self.placementId = placementId;
    [self.delegate fullscreenAdAdapterDidLoadAd:self];
}

- (void)unityAdsAdFailedToLoad:(NSString * _Nonnull)placementId withError:(UnityAdsLoadError)error withMessage:(NSString * _Nonnull)message {
    self.placementId = placementId;
    NSError *loadError = nil;
//
//    switch(error) {
//        case kUnityAdsLoadErrorInitializeFailed:
//        case kUnityAdsLoadErrorInternal:
//        case kUnityAdsLoadErrorInvalidArgument:
//        case kUnityAdsLoadErrorNoFill:
//        case kUnityAdsLoadErrorTimeout:
//        case default:
//            loadError = [NSError errorWithDomain:MoPubRewardedVideoAdsSDKDomain code:MPRewardedVideoAdErrorUnknown userInfo:@{NSLocalizedDescriptionKey: unityErrorMessage}];
//    }
    MPLogAdEvent([MPLogEvent adLoadFailedForAdapter:NSStringFromClass(self.class) error:loadError], placementId);
    [self.delegate fullscreenAdAdapter:self didFailToLoadAdWithError: loadError];
}

@end
 
