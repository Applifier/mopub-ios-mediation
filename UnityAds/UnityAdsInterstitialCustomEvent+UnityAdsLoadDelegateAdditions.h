//
//  UnityAdsInterstitial+UnityAdsLoadDelegateAdditions.h
//  MoPubSDK
//
//  Copyright © 2021 MoPub. All rights reserved.
//

#ifndef UnityAdsInterstitial_UnityAdsLoadDelegateAdditions_h
#define UnityAdsInterstitial_UnityAdsLoadDelegateAdditions_h

#import <UnityAds/UnityAds.h>
#import "UnityAdsInterstitialCustomEvent.h"

/**
 *  The `UnityAdsLoadDelegate` protocol defines the required methods for receiving messages from UnityAds.load() method.
 */
@interface UnityAdsInterstitialCustomEvent (UnityAdsLoadDelegate)

/**
 *  Callback triggered when a load request has successfully filled the specified placementId with an ad that is ready to show.
 *
 *  @param placementId The ID of the placement as defined in Unity Ads admin tools.
 */
- (void)unityAdsAdLoaded:(NSString * _Nonnull)placementId;

/**
 * Called when load request has failed to load an ad for a requested placement.
 * @param placementId The ID of the placement as defined in Unity Ads admin tools.
 * @param error UnityAdsLoadError.
 * @param message A human readable error message.
 */
- (void)unityAdsAdFailedToLoad:(NSString * _Nonnull)placementId withError:(UnityAdsLoadError)error withMessage:(nonnull NSString * _Nonnull)message;

@end

#endif /* UnityAdsInterstitial_UnityAdsLoadDelegateAdditions_h */
