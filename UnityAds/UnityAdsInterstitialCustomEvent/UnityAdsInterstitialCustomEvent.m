//
//  UnityAdsInterstitial.m
//  MoPubSDK
//
//  Copyright © 2021 MoPub. All rights reserved.
//

#import <UnityAds/UnityAds.h>
#import "UnityAdsInterstitialCustomEvent.h"
#import "UnityAdsAdapterConfiguration.h"
#import "UnityAdsLogger.h"
#import "UnityAdsDomainLogger.h"
#import "MPLogging.h"
#import "UnityAdsConstants.h"
#import "UnityAdsAbstractAd.h"

#if __has_include(<MoPub/MoPub.h>)
    #import <MoPub/MoPub.h>
#elif __has_include(<MoPubSDK/MoPub.h>)
    #import <MoPubSDK/MoPub.h>
#else
    #import "MPFullscreenAdAdapter.h"
#endif
#import "MPError.h"

@interface UnityAdsInterstitialCustomEvent ()
    
@end

@implementation UnityAdsInterstitialCustomEvent
- (instancetype) init {
    self = [super init];
    if (self) {
        self.logger = [[UnityAdsDomainLogger alloc] init: @"Interstitial"];
    }
    return self;
}
@end
