//
//  UnityAdsAdapterInitializationDelegate.h
//  MoPubSDK
//
//  Copyright © 2021 MoPub. All rights reserved.
//

#ifndef UnityAdsAdapterInitializationDelegate_h
#define UnityAdsAdapterInitializationDelegate_h

#import <UnityAds/UnityAds.h>

@interface UnityAdsAdapterInitializationDelegate : NSObject<UnityAdsInitializationDelegate>

+ (instancetype)newWith: (void(^ _Nullable)(NSError * _Nullable))complete;

@property(nonatomic, copy) void (^ initializationCompleteBlock)(void);
@property(nonatomic, copy) void (^ initCompletion)(NSError * _Nullable);
@property(nonatomic, copy) void (^ initializationFailedBlock)(int error, NSString *message);

@end

#endif /* UnityAdsAdapterInitializationDelegate_h */
