//
//  UnityAdsInterstitial.m
//  MoPubSDK
//
//  Copyright © 2021 MoPub. All rights reserved.
//

#import <UnityAds/UnityAds.h>
#import "UnityAdsInterstitialCustomEvent.h"
#import "UnityAdsInterstitialCustomEvent+UnityAdsLoadDelegateAdditions.h"
#import "UnityAdsInterstitialCustomEvent+UnityAdsShowDelegateAdditions.h"
#import "UnityAdsAdapterConfiguration.h"
#import "MPLogging.h"
#import "UnityAdsConstants.h"

#if __has_include(<MoPub/MoPub.h>)
    #import <MoPub/MoPub.h>
#elif __has_include(<MoPubSDK/MoPub.h>)
    #import <MoPubSDK/MoPub.h>
#else
    #import "MPFullscreenAdAdapter.h"
#endif

@interface UnityAdsInterstitialCustomEvent ()

@property (nonatomic, copy) NSString *placementId;
@property (nonatomic) BOOL adLoaded;

@end

@implementation UnityAdsInterstitialCustomEvent

@dynamic delegate;
@dynamic localExtras;
@dynamic hasAdAvailable;

#pragma mark - MPFullscreenAdAdapter Override

- (BOOL)enableAutomaticImpressionAndClickTracking
{
    return NO;
}

- (BOOL)isRewardExpected {
    return NO;
}

- (BOOL)hasAdAvailable{
    return _adLoaded;
}

- (void)requestAdWithAdapterInfo:(NSDictionary *)info adMarkup:(NSString *)adMarkup {
    _placementId = [info objectForKey:kUnityAdsOptionPlacementId];
    if (_placementId == nil) {
        _placementId = ([info objectForKey:kUnityAdsOptionZoneId] != nil) ? [info objectForKey:kUnityAdsOptionZoneId] : @"";
    }
    
    MPLogAdEvent([MPLogEvent adLoadAttemptForAdapter:NSStringFromClass(self.class) dspCreativeId:nil dspName:nil], _placementId);
    [UnityAds load:_placementId loadDelegate:self];
}

- (void)presentAdFromViewController:(UIViewController *)viewController {
    if (![self hasAdAvailable]) {
        MPLogWarn(kUnityAdsAdapterShowWarningLoadNotSuccessful);
    }
    
    //MPLogAdEvent([MPLogEvent fullscreenAdAdapterAdWillAppear:NSStringFromClass(self.class)], _placementId);
    [UnityAds show:viewController placementId:_placementId showDelegate:self];
}

@end
