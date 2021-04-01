//
//  UnityAdsConstants.h
//  MoPubSDK
//
//  Copyright © 2021 MoPub. All rights reserved.
//

#ifndef UnityAdsConstants_h
#define UnityAdsConstants_h

static NSString *const kAdapterVersion = @"3.7.1.1";
static NSString *const kMoPubNetworkName = @"unity";

static NSString *const kUnityAdsGameId = @"gameId";
static NSString *const kUnityAdsOptionPlacementId = @"placementId";
static NSString *const kUnityAdsOptionZoneId = @"zoneId";

static NSString *const kAdapterErrorDomain = @"com.mopub.mopub-ios-sdk.mopub-unity-adapters";

static NSString *const kUnityAdsInitializationErrorEmptyGameId = @"[UnityAds] initialization skipped. The gameId is empty. Ensure it is properly configured on the MoPub dashboard.";
static NSString *const kUnityAdsShowWarningLoadNotSuccessful = @"[UnityAds] received call to show before successfully loading an ad";

#endif /* UnityAdsConstants_h */
