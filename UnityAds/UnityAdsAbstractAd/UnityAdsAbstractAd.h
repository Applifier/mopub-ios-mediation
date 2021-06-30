//
//  UnityAdsAbstractAd.h
//  MoPubSDK
//
//  Copyright © 2021 MoPub. All rights reserved.
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

// TODO: Rename this?
struct MoPubError {
    MOPUBErrorCode code;
    NSString *description;
};

@interface UnityAdsAbstractAd : MPFullscreenAdAdapter <MPThirdPartyFullscreenAdAdapter, UnityAdsLoadDelegate, UnityAdsShowDelegate>
@property (nonatomic) UnityAdsErrorFactory *errorFactory;

@end

#endif /* Header_h */
