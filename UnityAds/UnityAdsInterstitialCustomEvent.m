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

@interface UnityAdsInterstitialCustomEvent ()

@property (nonatomic, copy) NSString *placementId;

@end

@implementation UnityAdsInterstitialCustomEvent

@dynamic delegate;
@dynamic localExtras;
@dynamic hasAdAvailable;

- (NSString *) getAdNetworkId {
    return (self.placementId != nil) ? self.placementId : @"";
}

#pragma mark - MPFullscreenAdAdapter Override

- (BOOL)enableAutomaticImpressionAndClickTracking
{
    return NO;
}

- (BOOL)isRewardExpected {
    return NO;
}

- (BOOL)hasAdAvailable{
    return YES;
}

- (void)requestAdWithAdapterInfo:(NSDictionary *)info adMarkup:(NSString *)adMarkup {
    NSString *placementId = [info objectForKey:kUnityAdsOptionPlacementId];
    if (placementId == nil) {
        placementId = [info objectForKey:kUnityAdsOptionZoneId];
    }
    
    [UnityAds load:placementId loadDelegate:self];
    MPLogAdEvent([MPLogEvent adLoadAttemptForAdapter:NSStringFromClass(self.class) dspCreativeId:nil dspName:nil], placementId);
}

- (void)presentAdFromViewController:(UIViewController *)viewController {
    if (![self hasAdAvailable]) {
        MPLogWarn(kUnityAdsShowWarningLoadNotSuccessful);
    }

    // fullscreenAdAdapterAdWillAppear:self
    MPLogAdEvent([MPLogEvent adShowAttemptForAdapter:NSStringFromClass(self.class)], [self getAdNetworkId]);
    
    [UnityAds show:viewController placementId:_placementId showDelegate:self];
}

- (void)handleDidInvalidateAd
{
  // Nothing to clean up.
}

@end
