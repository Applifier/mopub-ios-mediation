//
//  UnityAdsInterstitial+UnityAdsShowDelegateAdditions.m
//  MoPubSDK
//
//  Copyright © 2021 MoPub. All rights reserved.
//

#import <UnityAds/UnityAds.h>
#import "UnityAdsConstants.h"
#import "UnityAdsInterstitialCustomEvent+UnityAdsShowDelegateAdditions.h"
#import "MPError.h"

@implementation UnityAdsInterstitialCustomEvent (UnityAdsShowDelegate)

- (void)unityAdsShowStart:(NSString * _Nonnull)placementId {
    // TODO: MPLogAdEvent([MPLogEvent adShowAttemptForAdapter:NSStringFromClass(self.class)], [self getAdNetworkId]);
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

    MOPUBErrorCode code;
    NSString *description;

    switch (error) {
        case kUnityShowErrorNotInitialized:
            code = MOPUBErrorUnknown;
            description = kUnityAdsAdapterShowErrorInternalError;
            break;
        case kUnityShowErrorNotReady:
            code = MOPUBErrorUnknown;
            description = kUnityAdsAdapterShowErrorInternalError;
            break;
        case kUnityShowErrorVideoPlayerError:
            code = MOPUBErrorUnknown;
            description = kUnityAdsAdapterShowErrorInternalError;
            break;
        case kUnityShowErrorInvalidArgument:
            code = MOPUBErrorUnknown;
            description = kUnityAdsAdapterShowErrorInternalError;
            break;
        case kUnityShowErrorNoConnection:
            code = MOPUBErrorUnknown;
            description = kUnityAdsAdapterShowErrorInternalError;
            break;
        case kUnityShowErrorAlreadyShowing:
            code = MOPUBErrorUnknown;
            description = kUnityAdsAdapterShowErrorInternalError;
            break;
        case kUnityShowErrorInternalError:
            code = MOPUBErrorUnknown;
            description = kUnityAdsAdapterShowErrorInternalError;
            break;
        default:
            code = MOPUBErrorUnknown;
            description = kUnityAdsAdapterShowErrorUnknown;
            break;
    }

    NSError *showError = [NSError errorWithCode:code localizedDescription:description];
    [self.delegate fullscreenAdAdapter:self didFailToShowAdWithError: showError];
}

@end
