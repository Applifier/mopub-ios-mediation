//
//  UnityAdsRewardedVideoCustomEvent.m
//  MoPubSDK
//
//  Copyright (c) 2016 MoPub. All rights reserved.
//

#import "UnityAdsRewardedVideoCustomEvent.h"
#import "UnityAdsInstanceMediationSettings.h"
#import "UnityAdsAdapterConfiguration.h"
#import "UnityRouter.h"
#if __has_include("MoPub.h")
    #import "MPReward.h"
    #import "MPRewardedVideoError.h"
    #import "MPLogging.h"
#endif

static NSString *const kMPUnityRewardedVideoGameId = @"gameId";
static NSString *const kUnityAdsOptionPlacementIdKey = @"placementId";
static NSString *const kUnityAdsOptionZoneIdKey = @"zoneId";

@interface UnityAdsRewardedVideoCustomEvent () <UnityAdsLoadDelegate, UnityAdsShowDelegate>

@property (nonatomic, copy) NSString *placementId;

@end

@implementation UnityAdsRewardedVideoCustomEvent
@dynamic delegate;
@dynamic localExtras;
@dynamic hasAdAvailable;

- (void)initializeSdkWithParameters:(NSDictionary *)parameters {
    NSString *gameId = [parameters objectForKey:kMPUnityRewardedVideoGameId];
    if (gameId == nil) {
        MPLogInfo(@"Initialization parameters did not contain gameId.");
        return;
    }

    [[UnityRouter sharedRouter] initializeWithGameId:gameId withCompletionHandler:nil];
}

#pragma mark - MPFullscreenAdAdapter Override

- (BOOL)isRewardExpected
{
    return YES;
}

- (BOOL)hasAdAvailable {
    return [UnityAds isReady:self.placementId];
}

- (NSString *) getAdNetworkId {
    return (self.placementId != nil) ? self.placementId : @"";
}

- (void)requestAdWithAdapterInfo:(NSDictionary *)info adMarkup:(NSString *)adMarkup
{
    NSString *gameId = [info objectForKey:kMPUnityRewardedVideoGameId];
    if (gameId == nil) {
        NSError *error = [NSError errorWithDomain:MoPubRewardedVideoAdsSDKDomain code:MPRewardedVideoAdErrorInvalidCustomEvent userInfo:@{NSLocalizedDescriptionKey: @"Custom event class data did not contain gameId.", NSLocalizedRecoverySuggestionErrorKey: @"Update your MoPub custom event class data to contain a valid Unity Ads gameId."}];

        MPLogAdEvent([MPLogEvent adLoadFailedForAdapter:NSStringFromClass(self.class) error:error], [self getAdNetworkId]);
        [self.delegate fullscreenAdAdapter:self didFailToLoadAdWithError:error];
        return;
    }

    // Only need to cache game ID for SDK initialization
    [UnityAdsAdapterConfiguration updateInitializationParameters:info];

    self.placementId = [info objectForKey:kUnityAdsOptionPlacementIdKey];
    if (self.placementId == nil) {
        self.placementId = [info objectForKey:kUnityAdsOptionZoneIdKey];
    }

    if (self.placementId == nil) {
        NSError *error = [NSError errorWithDomain:MoPubRewardedVideoAdsSDKDomain code:MPRewardedVideoAdErrorInvalidCustomEvent userInfo:@{NSLocalizedDescriptionKey: @"Custom event class data did not contain placementId.", NSLocalizedRecoverySuggestionErrorKey: @"Update your MoPub custom event class data to contain a valid Unity Ads placementId."}];
        MPLogAdEvent([MPLogEvent adLoadFailedForAdapter:NSStringFromClass(self.class) error:error], [self getAdNetworkId]);
        [self.delegate fullscreenAdAdapter:self didFailToLoadAdWithError:error];
        return;
    }
    
    if (![UnityAds isInitialized]) {
        [[UnityRouter sharedRouter] initializeWithGameId:gameId withCompletionHandler:nil];
        
        NSError *error = [NSError errorWithDomain:MoPubRewardedVideoAdsSDKDomain code:MPRewardedVideoAdErrorInvalidCustomEvent userInfo:@{NSLocalizedDescriptionKey: @"Unity Ads adapter failed to request rewarded video ad. Unity Ads is not initialized yet. Failing this ad request and calling Unity Ads initialization so it would be available for an upcoming ad request.", NSLocalizedRecoverySuggestionErrorKey: @""}];
        MPLogAdEvent([MPLogEvent adLoadFailedForAdapter:NSStringFromClass(self.class) error:error], [self getAdNetworkId]);
        [self.delegate fullscreenAdAdapter:self didFailToLoadAdWithError:error];
        return;
    }
    
    MPLogAdEvent([MPLogEvent adLoadAttemptForAdapter:NSStringFromClass(self.class) dspCreativeId:nil dspName:nil], [self getAdNetworkId]);
    [UnityAds load:self.placementId loadDelegate:self];
}

- (void)presentAdFromViewController:(UIViewController *)viewController
{
    if ([self hasAdAvailable]) {
        MPLogAdEvent([MPLogEvent adShowAttemptForAdapter:NSStringFromClass(self.class)], [self getAdNetworkId]);
        [UnityAds show:viewController placementId:_placementId showDelegate:self];
    } else {
        NSError *error = [NSError errorWithDomain:MoPubRewardedVideoAdsSDKDomain code:MPRewardedVideoAdErrorNoAdsAvailable userInfo:nil];
        MPLogAdEvent([MPLogEvent adLoadFailedForAdapter:NSStringFromClass(self.class) error:error], [self getAdNetworkId]);
        [self.delegate fullscreenAdAdapter:self didFailToShowAdWithError:error];
    }
}

- (void)handleDidInvalidateAd
{
  // Nothing to clean up.
}

/// This callback is used for expiration
- (void)handleDidPlayAd
{
    // If we no longer have an ad available, report back up to the application that this ad expired.
    // We receive this message only when this ad has reported an ad has loaded and another ad unit
    // has played a video for the same ad network.
    if (![self hasAdAvailable]) {
        MPLogInfo(@"Unity Ads interstitial has expired");
        [self.delegate fullscreenAdAdapterDidExpire:self];
    }
}

- (BOOL)enableAutomaticImpressionAndClickTracking
{
    return NO;
}

#pragma mark - UnityAdsLoadDelegate Methods

- (void)unityAdsAdFailedToLoad:(nonnull NSString *)placementId withError:(UnityAdsLoadError)error withMessage:(NSString *)message {
    NSString* unityErrorMessage = [NSString stringWithFormat:@"Unity Ads failed to load a rewarded video ad for %@, with error message: %@", placementId, message];
    NSError *loadError = [NSError errorWithDomain:MoPubRewardedVideoAdsSDKDomain code:MPRewardedVideoAdErrorUnknown userInfo:@{NSLocalizedDescriptionKey: unityErrorMessage}];

    MPLogAdEvent([MPLogEvent adLoadFailedForAdapter:NSStringFromClass(self.class) error:loadError], [self getAdNetworkId]);
    [self.delegate fullscreenAdAdapter:self didFailToLoadAdWithError:loadError];
}

- (void)unityAdsAdLoaded:(nonnull NSString *)placementId {
    MPLogAdEvent([MPLogEvent adLoadSuccessForAdapter:NSStringFromClass(self.class)], [self getAdNetworkId]);
    [self.delegate fullscreenAdAdapterDidLoadAd:self];
}

#pragma mark - UnityAdsShowDelegate Methods

- (void)unityAdsShowStart:(nonnull NSString *)placementId {
  [self.delegate fullscreenAdAdapterAdWillAppear:self];
  MPLogAdEvent([MPLogEvent adWillAppearForAdapter:NSStringFromClass(self.class)], [self getAdNetworkId]);

  [self.delegate fullscreenAdAdapterAdDidAppear:self];
  [self.delegate fullscreenAdAdapterDidTrackImpression:self];
  MPLogAdEvent([MPLogEvent adShowSuccessForAdapter:NSStringFromClass(self.class)], [self getAdNetworkId]);
  MPLogAdEvent([MPLogEvent adDidAppearForAdapter:NSStringFromClass(self.class)], [self getAdNetworkId]);
}

- (void)unityAdsShowClick:(NSString *)placementId {
  MPLogAdEvent([MPLogEvent adTappedForAdapter:NSStringFromClass(self.class)], [self getAdNetworkId]);
  [self.delegate fullscreenAdAdapterDidReceiveTap:self];
  [self.delegate fullscreenAdAdapterDidTrackClick:self];
  MPLogAdEvent([MPLogEvent adWillLeaveApplicationForAdapter:NSStringFromClass(self.class)], [self getAdNetworkId]);
  [self.delegate fullscreenAdAdapterWillLeaveApplication:self];
}

- (void)unityAdsShowComplete:(NSString *)placementId withFinishState:(UnityAdsShowCompletionState)state {
  if (state == kUnityAdsFinishStateCompleted) {
      MPReward *reward = [[MPReward alloc] initWithCurrencyType:kMPRewardCurrencyTypeUnspecified
                                                         amount:@(kMPRewardCurrencyAmountUnspecified)];
      [self.delegate fullscreenAdAdapter:self willRewardUser:reward];
  }

  MPLogAdEvent([MPLogEvent adWillDisappearForAdapter:NSStringFromClass(self.class)], [self getAdNetworkId]);
  MPLogAdEvent([MPLogEvent adDidDisappearForAdapter:NSStringFromClass(self.class)], [self getAdNetworkId]);
  [self.delegate fullscreenAdAdapterAdWillDisappear:self];
  [self.delegate fullscreenAdAdapterAdDidDisappear:self];

  // Signal that the fullscreen ad is closing and the state should be reset.
  // `fullscreenAdAdapterAdDidDismiss:` was introduced in MoPub SDK 5.15.0.
  if ([self.delegate respondsToSelector:@selector(fullscreenAdAdapterAdDidDismiss:)]) {
      [self.delegate fullscreenAdAdapterAdDidDismiss:self];
  }
}

- (void)unityAdsShowFailed:(NSString *)placementId withError:(UnityAdsShowError)error withMessage:(NSString *)message {

    NSString* unityErrorMessage = [NSString stringWithFormat:@"Unity Ads failed to show a rewarded video ad for %@, with error message: %@", placementId, message];
    NSError *showError = [NSError errorWithDomain:MoPubRewardedVideoAdsSDKDomain code:MPRewardedVideoAdErrorUnknown userInfo:@{NSLocalizedDescriptionKey: unityErrorMessage}];

    MPLogAdEvent([MPLogEvent adLoadFailedForAdapter:NSStringFromClass(self.class) error:showError], [self getAdNetworkId]);
    [self.delegate fullscreenAdAdapter:self didFailToLoadAdWithError:showError];
}

@end
