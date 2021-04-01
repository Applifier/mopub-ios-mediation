//
//  UnityAdsAdapterInitializationDelegate.h
//  MoPubSDK
//
//  Copyright © 2021 MoPub. All rights reserved.
//

#ifndef UnityAdsAdapterInitializationDelegate_h
#define UnityAdsAdapterInitializationDelegate_h

#import <UnityAds/UnityAds.h>

/**
 TODO: Question: Why is it necissary to wrap UnityAdsInitializationDelegate like this?
 TODO: doc string.
 */
@interface UnityAdsAdapterInitializationDelegate : NSObject<UnityAdsInitializationDelegate>

/**
 TODO: doc string.
 */

@property(nonatomic, copy) void (^ initializationCompleteBlock)(void);
@property(nonatomic, copy) void (^ initCompletion)(NSError * _Nullable);
/**
 TODO: doc string.
 */
@property(nonatomic, copy) void (^ initializationFailedBlock)(int error, NSString *message);

@end

#endif /* UnityAdsAdapterInitializationDelegate_h */
