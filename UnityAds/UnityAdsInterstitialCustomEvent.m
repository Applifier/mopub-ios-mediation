//
//  UnityAdsInterstitialCustomEvent.m
//  MoPubSDK
//
//  Copyright (c) 2016 MoPub. All rights reserved.
//

#import "UnityAdsInterstitialCustomEvent.h"
#import "UnityAdsInstanceMediationSettings.h"
#import "UnityRouter.h"
#if __has_include("MoPub.h")
    #import "MPLogging.h"
#endif
#import "UnityAdsAdapterConfiguration.h"

static NSString *const kMPUnityInterstitialVideoGameId = @"gameId";
static NSString *const kUnityAdsOptionPlacementIdKey = @"placementId";
static NSString *const kUnityAdsOptionZoneIdKey = @"zoneId";

@interface UnityAdsInterstitialCustomEvent () <UnityAdsLoadDelegate, UnityAdsExtendedDelegate>

@property (nonatomic, copy) NSString *placementId;
@property (nonatomic) NSString *objectId;
@property (nonatomic) int impressionOrdinal;
@property (nonatomic) int missedImpressionOrdinal;

@end

@implementation UnityAdsInterstitialCustomEvent
@dynamic delegate;
@dynamic localExtras;
@dynamic hasAdAvailable;
int impressionOrdinal;
int missedImpressionOrdinal;

#pragma mark - MPFullscreenAdAdapter Override

- (BOOL)isRewardExpected {
    return NO;
}

- (BOOL)hasAdAvailable {
    return [UnityAds isReady:self.placementId];
}

- (NSString *) getAdNetworkId {
    return (self.placementId != nil) ? self.placementId : @"";
}

- (void)requestAdWithAdapterInfo:(NSDictionary *)info adMarkup:(NSString *)adMarkup {
    NSString *gameId = [info objectForKey:kMPUnityInterstitialVideoGameId];
    self.placementId = [info objectForKey:kUnityAdsOptionPlacementIdKey];
    
    if (self.placementId == nil) {
        self.placementId = [info objectForKey:kUnityAdsOptionZoneIdKey];
    }
    
    if (gameId == nil || self.placementId == nil) {
          NSError *error = [self createErrorWith:@"Unity Ads adapter failed to request interstitial ad"
                                       andReason:@"Configured with an invalid placement id"
                                   andSuggestion:@""];
          MPLogAdEvent([MPLogEvent adLoadFailedForAdapter:NSStringFromClass(self.class) error:error], [self getAdNetworkId]);
        [self.delegate fullscreenAdAdapter:self didFailToLoadAdWithError:error];
        return;
    }
    
    // Only need to cache game ID for SDK initialization
    [UnityAdsAdapterConfiguration updateInitializationParameters:info];

    if (![UnityAds isInitialized]) {
        [[UnityRouter sharedRouter] initializeWithGameId:gameId withCompletionHandler:nil];
        
        NSError *error = [self createErrorWith:@"Unity Ads adapter failed to request interstitial ad, Unity Ads is not initialized yet. Failing this ad request and calling Unity Ads initialization so it would be available for an upcoming ad request"
                                     andReason:@"Unity Ads is not initialized."
                                 andSuggestion:@""];
        MPLogAdEvent([MPLogEvent adLoadFailedForAdapter:NSStringFromClass(self.class) error:error], [self getAdNetworkId]);
        [self.delegate fullscreenAdAdapter:self didFailToLoadAdWithError:error];
        
        return;
    }
    
    if (adMarkup != nil) {
        _objectId = [[NSUUID UUID] UUIDString];
        
        UADSLoadOptions *options = [UADSLoadOptions new];
        [options setObjectId:_objectId];
        [options setAdMarkup:adMarkup];
        
        [UnityAds load:self.placementId options:options loadDelegate:self];
    } else {
        [UnityAds load:self.placementId loadDelegate:self];
    }
    
    MPLogAdEvent([MPLogEvent adLoadAttemptForAdapter:NSStringFromClass(self.class) dspCreativeId:nil dspName:nil], [self getAdNetworkId]);
}

- (NSError *)createErrorWith:(NSString *)description andReason:(NSString *)reaason andSuggestion:(NSString *)suggestion {
    NSDictionary *userInfo = @{
                               NSLocalizedDescriptionKey: NSLocalizedString(description, nil),
                               NSLocalizedFailureReasonErrorKey: NSLocalizedString(reaason, nil),
                               NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(suggestion, nil)
                               };
    
    return [NSError errorWithDomain:NSStringFromClass([self class]) code:0 userInfo:userInfo];
}

- (void)presentAdFromViewController:(UIViewController *)viewController
{
    if ([UnityAds isReady:_placementId]) {
        MPLogAdEvent([MPLogEvent adShowAttemptForAdapter:NSStringFromClass(self.class)], [self getAdNetworkId]);
        [UnityAds addDelegate:self];
        
        if (_objectId != nil) {
            UADSShowOptions *options = [UADSShowOptions new];
            [options setObjectId:_objectId];
            
            [UnityAds show:viewController placementId:_placementId options:options];
        } else {
            [UnityAds show:viewController placementId:_placementId];
        }
    } else {
        NSError *error = [self createErrorWith:@"Unity Ads failed to show interstitial"
                                     andReason:@"There is no available interstitial ad."
                                 andSuggestion:@""];
        
        MPLogAdEvent([MPLogEvent adShowFailedForAdapter:NSStringFromClass(self.class) error:error], [self getAdNetworkId]);
        [self.delegate fullscreenAdAdapter:self didFailToShowAdWithError:error];
    }
}

- (void)handleDidInvalidateAd
{
    [UnityAds removeDelegate:self];
}

/// This callback is used for expiration, please see here: https://developers.mopub.com/networks/integrate/build-adapters-ios/#quick-start-for-fullscreen-ads
- (void)handleDidPlayAd
{
    // If we no longer have an ad available, report back up to the application that this ad expired.
    // We receive this message only when this ad has reported an ad has loaded and another ad unit
    // has played a video for the same ad network.
    if (![self hasAdAvailable]) {
        MPLogInfo(@"Unity Ads interstitial has expired");
        [self.delegate fullscreenAdAdapterDidExpire:self];
        MPLogAdEvent([MPLogEvent adExpiredWithTimeInterval:0], [self getAdNetworkId]);
    }
}

- (BOOL)enableAutomaticImpressionAndClickTracking
{
    return NO;
}

#pragma mark - UnityRouterDelegate

- (void)unityAdsReady:(NSString *)placementId
{
    // No-op
}

/// This method only handles show-related errors. Load-related errors are handled by unityAdsAdFailedToLoad.
- (void)unityAdsDidError:(UnityAdsError)error withMessage:(NSString *)message
{
    [UnityAds removeDelegate:self];
    
    if (error == kUnityAdsErrorShowError) {
      NSError *showError= [self createErrorWith:@"Unity Ads failed to show interstitial"
                                      andReason:message
                                  andSuggestion:@""];
        MPLogAdEvent([MPLogEvent adShowFailedForAdapter:NSStringFromClass(self.class) error:showError], [self getAdNetworkId]);
        [self.delegate fullscreenAdAdapter:self didFailToShowAdWithError:showError];
    } else {
        NSError *otherError= [self createErrorWith:@"Unity Ads interstitial failure"
                                           andReason:message
                                       andSuggestion:@""];
        MPLogAdEvent([MPLogEvent adShowFailedForAdapter:NSStringFromClass(self.class) error:otherError], [self getAdNetworkId]);
        [self.delegate fullscreenAdAdapter:self didFailToShowAdWithError:otherError];
    }
}

- (void) unityAdsDidStart:(NSString *)placementId
{
    [self.delegate fullscreenAdAdapterAdWillAppear:self];
    MPLogAdEvent([MPLogEvent adWillAppearForAdapter:NSStringFromClass(self.class)], [self getAdNetworkId]);
    MPLogAdEvent([MPLogEvent adShowSuccessForAdapter:NSStringFromClass(self.class)], [self getAdNetworkId]);

    [self.delegate fullscreenAdAdapterAdDidAppear:self];
    [self.delegate fullscreenAdAdapterDidTrackImpression:self];
    MPLogAdEvent([MPLogEvent adDidAppearForAdapter:NSStringFromClass(self.class)], [self getAdNetworkId]);
}

- (void) unityAdsDidFinish:(NSString *)placementId withFinishState:(UnityAdsFinishState)state
{
    [UnityAds removeDelegate:self];
    [self.delegate fullscreenAdAdapterAdWillDisappear:self];
    MPLogAdEvent([MPLogEvent adWillDisappearForAdapter:NSStringFromClass(self.class)], [self getAdNetworkId]);

    [self.delegate fullscreenAdAdapterAdDidDisappear:self];
    MPLogAdEvent([MPLogEvent adDidDisappearForAdapter:NSStringFromClass(self.class)], [self getAdNetworkId]);
    
    // Signal that the fullscreen ad is closing and the state should be reset.
    // `fullscreenAdAdapterAdDidDismiss:` was introduced in MoPub SDK 5.15.0.
    if ([self.delegate respondsToSelector:@selector(fullscreenAdAdapterAdDidDismiss:)]) {
        [self.delegate fullscreenAdAdapterAdDidDismiss:self];
    }
}

- (void) unityAdsDidClick:(NSString *)placementId
{
    MPLogAdEvent([MPLogEvent adTappedForAdapter:NSStringFromClass(self.class)], [self getAdNetworkId]);
    [self.delegate fullscreenAdAdapterDidReceiveTap:self];
    [self.delegate fullscreenAdAdapterDidTrackClick:self];
    MPLogAdEvent([MPLogEvent adWillLeaveApplicationForAdapter:NSStringFromClass(self.class)], [self getAdNetworkId]);
    [self.delegate fullscreenAdAdapterWillLeaveApplication:self];
}

- (void)unityAdsPlacementStateChanged:(nonnull NSString *)placementId oldState:(UnityAdsPlacementState)oldState newState:(UnityAdsPlacementState)newState {
    // no-op
}

- (void)unityAdsAdLoaded:(NSString *)placementId {
    [self.delegate fullscreenAdAdapterDidLoadAd:self];
    MPLogAdEvent([MPLogEvent adLoadSuccessForAdapter:NSStringFromClass(self.class)], [self getAdNetworkId]);
    [self sendMetadataAdShownCorrect:YES];
}

- (void)unityAdsAdFailedToLoad:(nonnull NSString *)placementId {
    NSError *errorLoad = [self createErrorWith:@"Unity Ads failed to load interstitial ad"
                                     andReason:@""
                                 andSuggestion:@""];
    MPLogAdEvent([MPLogEvent adLoadFailedForAdapter:NSStringFromClass(self.class) error:errorLoad], [self getAdNetworkId]);
    [self.delegate fullscreenAdAdapter:self didFailToLoadAdWithError:errorLoad];
    [self sendMetadataAdShownCorrect:NO];
}

- (void) sendMetadataAdShownCorrect: (BOOL) isAdShown {
    UADSMediationMetaData *headerBiddingMeta = [[UADSMediationMetaData alloc]initWithCategory:@"mediation"];
    if(isAdShown) {
        [headerBiddingMeta setOrdinal: ++_impressionOrdinal];
    }
    else {
        [headerBiddingMeta setMissedImpressionOrdinal: ++_missedImpressionOrdinal];
    }
    [headerBiddingMeta commit];
}

- (void)unityAdsAdLoaded:(NSString *)placementId {
    [self.delegate fullscreenAdAdapterDidLoadAd:self];
    MPLogAdEvent([MPLogEvent adLoadSuccessForAdapter:NSStringFromClass(self.class)], [self getAdNetworkId]);
    [self sendMetadataAdShownCorrect:YES];
}

- (void)unityAdsAdFailedToLoad:(nonnull NSString *)placementId {
    NSError *errorLoad = [self createErrorWith:@"Unity Ads failed to load an ad"
                                 andReason:@""
                             andSuggestion:@""];
    [self.delegate fullscreenAdAdapter:self didFailToLoadAdWithError:errorLoad];
    MPLogAdEvent([MPLogEvent adLoadFailedForAdapter:NSStringFromClass(self.class) error:errorLoad], [self getAdNetworkId]);
    [self sendMetadataAdShownCorrect:NO];
}

- (void) sendMetadataAdShownCorrect: (BOOL) isAdShown {
    UADSMediationMetaData *headerBiddingMeta = [[UADSMediationMetaData alloc]initWithCategory:@"mediation"];
    if(isAdShown) {
        [headerBiddingMeta setOrdinal: ++impressionOrdinal];
    }
    else {
        [headerBiddingMeta setMissedImpressionOrdinal: ++missedImpressionOrdinal];
    }
    [headerBiddingMeta commit];
}

@end
