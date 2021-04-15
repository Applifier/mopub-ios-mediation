//
//  UnityAdsConstants.h
//  MoPubSDK
//
//  Copyright © 2021 MoPub. All rights reserved.
//

#ifndef UnityAdsConstants_h
#define UnityAdsConstants_h

#import <Foundation/Foundation.h>

#pragma mark - Adapter Metadata

static NSString *const kUnityAdsAdapterVersion = @"3.7.1.1";
static NSString *const kUnityAdsAdapterMoPubNetworkName = @"unity";
static NSString *const kUnityAdsAdapterErrorDomain = @"com.mopub.mopub-ios-sdk.mopub-unity-adapters";

#pragma mark - Adapter Key Constants

static NSString *const kUnityAdsTestMode = @"testMode";
static NSString *const kUnityAdsGameId = @"gameId";
static NSString *const kUnityAdsOptionPlacementId = @"placementId";
static NSString *const kUnityAdsOptionZoneId = @"zoneId";

#pragma mark - Initialization Error Descriptions

static NSString *const kUnityAdsAdapterInitializationErrorEmptyGameId = @"[UnityAds] initialization skipped. The gameId is empty. Ensure it is properly configured on the MoPub dashboard.";
static NSString *const kUnityAdsAdapterInitializationErrorInternalError = @"[UnityAds] TODO: kUnityAdapterInitializationErrorInternalError";
static NSString *const kUnityAdsAdapterInitializationErrorInvalidArgument = @"[UnityAds] TODO: kUnityAdapterInitializationErrorInvalidArgument";
static NSString *const kUnityAdsAdapterInitializationErrorAdBlockerDetected = @"[UnityAds] TODO: kUnityAdapterInitializationErrorAdBlockerDetected";
static NSString *const kUnityAdsAdapterInitializationErrorUnknown = @"[UnityAds] TODO: kUnityAdapterInitializationErrorUnknown";

#pragma mark - Load Error Descriptions

static NSString *const kUnityAdsAdapterLoadErrorInvalidArguemnt = @"[UnityAds] TODO: kUnityAdsAdapterLoadErrorInvalidArguemnt";
static NSString *const kUnityAdsAdapterLoadErrorInitializeFailed = @"[UnityAds] TODO: kUnityAdsAdapterLoadErrorInitializeFailed";
static NSString *const kUnityAdsAdapterLoadErrorInvalidArgument = @"[UnityAds] TODO: kUnityAdsAdapterLoadErrorInvalidArgument";
static NSString *const kUnityAdsAdapterLoadErrorNoFill = @"[UnityAds] TODO: kUnityAdsAdapterLoadErrorNoFill";
static NSString *const kUnityAdsAdapterLoadErrorTimeout = @"[UnityAds] TODO: kUnityAdsAdapterLoadErrorTimeout";
static NSString *const kUnityAdsAdapterLoadErrorInternal = @"[UnityAds] TODO: kUnityAdsAdapterLoadErrorInternalError";
static NSString *const kUnityAdsAdapterLoadErrorUnknown = @"[UnityAds] TODO: kUnityAdsAdapterLoadErrorUnknown";

#pragma mark - Show Error Descriptions

static NSString *const kUnityAdsAdapterShowWarningLoadNotSuccessful = @"[UnityAds] received call to show before successfully loading an ad";
static NSString *const kUnityAdsAdapterShowErrorNotInitialized = @"[UnityAds] TODO: kUnityAdapterShowErrorNotInitialized";
static NSString *const kUnityAdsAdapterShowErrorNotReady = @"[UnityAds] TODO: kUnityAdapterShowErrorNotReady";
static NSString *const kUnityAdsAdapterShowErrorVideoPlayerError = @"[UnityAds] TODO: kUnityAdapterShowErrorVideoPlayerError";
static NSString *const kUnityAdsAdapterShowErrorInvalidArgument = @"[UnityAds] TODO: kUnityAdapterShowErrorInvalidArgument";
static NSString *const kUnityAdsAdapterShowErrorNoConnection = @"[UnityAds] TODO: kUnityAdapterShowErrorNoConnection";
static NSString *const kUnityAdsAdapterShowErrorAlreadyShowing = @"[UnityAds] TODO: kUnityAdapterShowErrorAlreadyShowing";
static NSString *const kUnityAdsAdapterShowErrorInternalError = @"[UnityAds] TODO: kUnityAdapterShowErrorInternalError";
static NSString *const kUnityAdsAdapterShowErrorUnknown = @"[UnityAds] TODO: kUnityAdapterShowErrorUnknown";

#endif /* UnityAdsConstants_h */
