//
//  UnityAdsAbstractAd.m
//  MoPubSDK
//
//  Copyright © 2021 MoPub. All rights reserved.
//

#import <UnityAds/UnityAds.h>
#import "UnityAdsInterstitialCustomEvent.h"
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

@interface UnityAdsAbstractAd ()

@property (nonatomic, copy) NSString *placementId;
@property (nonatomic) BOOL adLoaded;

@end

@implementation UnityAdsAbstractAd

@dynamic delegate;
@dynamic localExtras;
@dynamic hasAdAvailable;

#pragma mark - MPFullscreenAdAdapter Override

- (instancetype) init {
    self = [super init];
    if (self) {
    }
    return self;
}

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
    // Since `presentAdFromViewController` can be called before the `UnityAdsLoadDelegate`
    // methods are fired, _placementId is stored so after an ad has been requested the
    // appropriate placement ID will be passed to the call to `show`.
    _placementId = [info objectForKey:kUnityAdsOptionPlacementId];
    if (_placementId == nil) {
        _placementId = ([info objectForKey:kUnityAdsOptionZoneId] != nil) ? [info objectForKey:kUnityAdsOptionZoneId] : @"";
    }
    
    MPLogAdEvent([MPLogEvent adLoadAttemptForAdapter:NSStringFromClass(self.class) dspCreativeId:nil dspName:nil], _placementId);
    [UnityAds load:_placementId loadDelegate:self];
}


- (void)presentAdFromViewController:(UIViewController *)viewController {
    if (![self hasAdAvailable]) {
        MPLogInfo(kUnityAdsAdapterShowWarningLoadNotSuccessful);
        // Allow to continue to show call, giving Unity Ads insight that an ad
        // was attempted to be shown.
    }
    
    [UnityAds show:viewController placementId:_placementId showDelegate:self];
}

#pragma mark - UnityAdsLoadDelegate Methods

- (void)unityAdsAdLoaded:(NSString * _Nonnull)placementId {
    self.adLoaded = YES;
    [self.delegate fullscreenAdAdapterDidLoadAd:self];
}

- (void)unityAdsAdFailedToLoad:(NSString * _Nonnull)placementId withError:(UnityAdsLoadError)error withMessage:(NSString * _Nonnull)message {
    NSError *loadError = [self.errorFactory loadErrorForType:error withMessage:message];
    [MPLogEvent adLoadFailedForAdapter:@"" error:loadError];
    [self.delegate fullscreenAdAdapter:self didFailToLoadAdWithError: loadError];
}

#pragma mark - UnityAdsShowDelegate Methods

-(void)unityAdsShowStart:(NSString * _Nonnull)placementId {
   [self.delegate fullscreenAdAdapterAdWillAppear:self];
   [self.delegate fullscreenAdAdapterAdDidAppear:self];
}

-(void)unityAdsShowClick:(NSString * _Nonnull)placementId {
   [self.delegate fullscreenAdAdapterWillLeaveApplication:self];
   [self.delegate fullscreenAdAdapterDidReceiveTap:self];
}

-(void)unityAdsShowComplete:(NSString * _Nonnull)placementId withFinishState:(UnityAdsShowCompletionState)state{
   [self.delegate fullscreenAdAdapterAdWillDisappear:self];
   [self.delegate fullscreenAdAdapterAdDidDisappear:self];
   [self.delegate fullscreenAdAdapterAdDidDismiss:self];
}

-(void)unityAdsShowFailed:(nonnull NSString *)placementId withError:(UnityAdsShowError)error withMessage:(nonnull NSString *)message {
    NSError *loadError = [self.errorFactory showErrorForType: error withMessage: message];

    [self.delegate fullscreenAdAdapter:self didFailToLoadAdWithError: loadError];
}

@end






