//
//  UnityAdsInterstitial+UnityAdsShowDelegateAdditions.m
//  MoPubSDK
//
//  Copyright © 2021 MoPub. All rights reserved.
//

#import <UnityAds/UnityAds.h>
#import "UnityAdsInterstitialCustomEvent+UnityAdsShowDelegateAdditions.h"

@implementation UnityAdsInterstitialCustomEvent (UnityAdsShowDelegate)

- (void)unityAdsShowStart:(NSString * _Nonnull)placementId {
    [self.delegate fullscreenAdAdapterAdWillAppear:self];
    [self.delegate fullscreenAdAdapterAdDidAppear:self];
}

- (void)unityAdsShowClick:(NSString * _Nonnull)placementId {
    [self.delegate fullscreenAdAdapterWillLeaveApplication:self];
    [self.delegate fullscreenAdAdapterDidReceiveTap:self];
}

- (void)unityAdsShowComplete:(NSString * _Nonnull)placementId withFinishState:(UnityAdsShowCompletionState)state {
    [self.delegate fullscreenAdAdapterAdWillDisappear:self];
    [self.delegate fullscreenAdAdapterAdDidDisappear:self];
    [self.delegate fullscreenAdAdapterAdDidDismiss:self];
}

- (void)unityAdsShowFailed:(NSString * _Nonnull)placementId withError:(UnityAdsShowError)error withMessage:(NSString * _Nonnull)message {
//    switch (error) {
//        case kUnityShowErrorNotInitialized:
//        case kUnityShowErrorNotReady:
//            [self.delegate fullscreenAdAdapterDidExpire:self];
//        case kUnityShowErrorVideoPlayerError:
//        case kUnityShowErrorInvalidArgument:
//        case kUnityShowErrorNoConnection:
//        case kUnityShowErrorAlreadyShowing:
//        default kUnityShowErrorInternalError:
//            [self.delegate fullscreenAdAdapter:self didFailToShowAdWithError:NSError];
//    }
}

@end
