//
//  UnityAdsRewardedVideoCustomEvent+UnityAdsShowDelegateAdditions.h
//  MoPubSDK
//
//  Copyright © 2021 MoPub. All rights reserved.
//

#ifndef UnityAdsRewardedVideoCustomEvent_UnityAdsShowDelegateAdditions_h
#define UnityAdsRewardedVideoCustomEvent_UnityAdsShowDelegateAdditions_h

#import <UnityAds/UnityAds.h>
#import "UnityAdsRewardedVideoCustomEvent.h"

/**
 * The `UnityAdsShowDelegate` defines the methods which will notify UnityAds show call
 * is either successfully completed with its completion state or failed with error category and error message
 */
@interface UnityAdsRewardedVideoCustomEvent (UnityAdsShowDelegate)

/**
 * Called when UnityAds has started to show ad with a specific placement.
 * @param placementId The ID of the placement as defined in Unity Ads admin tools.
 */
- (void)unityAdsShowStart:(NSString * _Nonnull)placementId;

/**
 * Called when UnityAds has received a click while showing ad with a specific placement.
 * @param placementId The ID of the placement as defined in Unity Ads admin tools.
 */
- (void)unityAdsShowClick:(NSString * _Nonnull)placementId;

/**
 * Called when UnityAds completes show operation successfully for a placement with completion state.
 * @param placementId The ID of the placement as defined in Unity Ads admin tools.
 * @param state An enum value indicating the finish state of the ad. Possible values are `Completed`, `Skipped`.
 */
- (void)unityAdsShowComplete:(NSString * _Nonnull)placementId withFinishState:(UnityAdsShowCompletionState)state;

/**
 * Called when UnityAds has failed to show a specific placement with an error message and error category.
 * @param placementId The ID of the placement as defined in Unity Ads admin tools.
 * @param error UnityAdsShowError.
 * @param message A human readable error message
 */
- (void)unityAdsShowFailed:(NSString * _Nonnull)placementId withError:(UnityAdsShowError)error withMessage:(NSString * _Nonnull)message;

@end

#endif /* UnityAdsRewardedVideoCustomEvent_UnityAdsShowDelegateAdditions_h */
