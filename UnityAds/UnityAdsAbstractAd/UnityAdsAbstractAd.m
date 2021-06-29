//
//  UnityAdsAbstractAd.m
//  MoPub-TestApp-Local
//
//  Created by Richard Hawkins on 4/20/21.
//  Copyright © 2021 Unity Ads. All rights reserved.
//

#import <UnityAds/UnityAds.h>
#import "UnityAdsInterstitialCustomEvent.h"
#import "UnityAdsAdapterConfiguration.h"
#import "UnityAdsLogger.h"
#import "UnityAdsDomainLogger.h"
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

#import "MPLogging.h"
#import "UnityAdsLogger.h"
#import "UnityAdsErrorFactory.h"

- (instancetype) init {
    self = [super init];
    if (self) {
        self.logger = [[UnityAdsDomainLogger alloc] init: @"Abstract"];
        UnityErrorLogEvent *msg = [UnityErrorLogEvent newWithMessage:@"|-o-| TESTING" andDetails:@"foo"];
        [self.logger logMessage:msg];
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
        MPLogWarn(kUnityAdsAdapterShowWarningLoadNotSuccessful);
    }
    
    //MPLogAdEvent([MPLogEvent fullscreenAdAdapterAdWillAppear:NSStringFromClass(self.class)], _placementId);
    [UnityAds show:viewController placementId:_placementId showDelegate:self];
}

#pragma mark - UnityAdsLoadDelegate Methods

- (void)unityAdsAdLoaded:(NSString * _Nonnull)placementId {
    [self.logger logMessage: @"|-o-| Testing"];
    self.adLoaded = YES;
    [self.delegate fullscreenAdAdapterDidLoadAd:self];
}

- (void)unityAdsAdFailedToLoad:(NSString * _Nonnull)placementId withError:(UnityAdsLoadError)error withMessage:(NSString * _Nonnull)message {
    NSError *loadError = [self.errorFactory loadErrorForType:error withMessage:message];
    [self.logger logMessage: [self.errorFactory loadErrorlogEvent: error withMessage: message]];
    // TODO: verify if mopub will logs this error, or if we need to.
    [self.delegate fullscreenAdAdapter:self didFailToLoadAdWithError: loadError];
}

#pragma mark - UnityAdsShowDelegate Methods

-(void)unityAdsShowStart:(NSString * _Nonnull)placementId {
   // TODO: MPLogAdEvent([MPLogEvent adShowAttemptForAdapter:NSStringFromClass(self.class)], [self getAdNetworkId]);
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






