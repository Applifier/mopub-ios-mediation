//
//  UnityAdsRewardedVideoCustomEvent.h
//  MoPubSDK
//
//  Copyright © 2021 MoPub. All rights reserved.
//

#ifndef UnityAdsRewardedVideoCustomEvent_h
#define UnityAdsRewardedVideoCustomEvent_h

#import <Foundation/Foundation.h>

#if __has_include(<MoPub/MoPub.h>)
    #import <MoPub/MoPub.h>
#elif __has_include(<MoPubSDK/MoPub.h>)
    #import <MoPubSDK/MoPub.h>
#else
    #import "MPFullscreenAdAdapter.h"
#endif

@interface UnityAdsRewardedVideoCustomEvent : MPFullscreenAdAdapter <MPThirdPartyFullscreenAdAdapter>

@end

#endif /* UnityAdsRewardedVideoCustomEvent_h */
