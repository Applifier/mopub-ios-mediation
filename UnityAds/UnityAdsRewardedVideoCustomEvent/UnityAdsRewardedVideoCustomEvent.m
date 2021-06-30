//
//  UnityAdsRewardedVideoCustomEvent.m
//  MoPubSDK
//
//  Copyright © 2021 MoPub. All rights reserved.
//

#import <UnityAds/UnityAds.h>
#import "UnityAdsRewardedVideoCustomEvent.h"
#import "UnityAdsAdapterConfiguration.h"
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

@interface UnityAdsRewardedVideoCustomEvent ()
    
@end

@implementation UnityAdsRewardedVideoCustomEvent
- (instancetype) init {
    self = [super init];
    if (self) {
    }
    return self;
}

#pragma mark - UnityAdsShowDelegate Overrides

-(void)unityAdsShowComplete:(NSString * _Nonnull)placementId withFinishState:(UnityAdsShowCompletionState)state{
    if (state == kUnityShowCompletionStateCompleted) {
        MPReward *reward = [[MPReward alloc] initWithCurrencyType:kMPRewardCurrencyTypeUnspecified
                                                           amount:@(kMPRewardCurrencyAmountUnspecified)];
        [self.delegate fullscreenAdAdapter:self willRewardUser:reward];
    }
    [super unityAdsShowComplete:placementId withFinishState:state];
}

@end
