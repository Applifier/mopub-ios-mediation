//
//  Header.h
//  MoPub-TestApp-Local
//
//  Created by Richard Hawkins on 4/20/21.
//  Copyright © 2021 Unity Ads. All rights reserved.
//

#ifndef Header_h
#define Header_h

#import <MPFullscreenAdAdapter.h>
#if __has_include(<MoPub/MoPub.h>)
    #import <MoPub/MoPub.h>
#elif __has_include(<MoPubSDK/MoPub.h>)
    #import <MoPubSDK/MoPub.h>
#else
    #import "MPFullscreenAdAdapter.h"
#endif
#import "MPError.h"
#import "UnityAdsErrorFactory.h"

// TODO: Rename this
struct MoPubError {
    MOPUBErrorCode code;
    NSString *description;
};

// TODO: Update MoPub dahsboard to include new class UnityAdsInterstitial
/**
 TODO: doc string.
 */
@interface UnityAdsAbstractAd : MPFullscreenAdAdapter <MPThirdPartyFullscreenAdAdapter, UnityAdsLoadDelegate, UnityAdsShowDelegate>
@property (nonatomic) UnityAdsErrorFactory *errorFactory;
@property (nonatomic) id<UnityAdsLogger> logger;

@end

#endif /* Header_h */
