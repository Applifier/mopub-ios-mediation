//
//  UnityAdsAdapterConfiguration.h
//  MoPubSDK
//
//  Copyright © 2021 MoPub. All rights reserved.
//

#ifndef UnityAdsAdapterConfiguration_h
#define UnityAdsAdapterConfiguration_h

#import <MPBaseAdapterConfiguration.h>

/**
 Provides adapter information back to the SDK and is the main access point
 for all adapter-level configuration.
 */
@interface UnityAdsAdapterConfiguration : MPBaseAdapterConfiguration

#pragma mark - MPAdapterConfiguration

/**
 The version of the adapter.
 */
@property (nonatomic, copy, readonly) NSString * _Nonnull adapterVersion;

/**
 An optional identity token used for ORTB bidding requests required for Advanced Bidding.
 */
@property (nonatomic, copy, readonly) NSString * _Nullable biddingToken;

/**
 MoPub-specific name of the network.
 @remark This value should correspond to `creative_network_name` in the dashboard.
 */
@property (nonatomic, copy, readonly) NSString * _Nonnull moPubNetworkName;

/**
 The version of the underlying network SDK.
 */
@property (nonatomic, copy, readonly) NSString * _Nonnull networkSdkVersion;

#pragma mark - Caching

/**
 Updates the initialization parameters for the current network.
 @param parameters New set of initialization parameters. Only @c NSString, @c NSNumber, @c NSArray, and @c NSDictionary types are allowed. Nothing will be done if @c nil is passed in.
 */
+ (void)updateInitializationParameters:(NSDictionary * _Nonnull)parameters;

#pragma mark - Initialization

/**
 Initializes the underlying network SDK with a given set of initialization parameters.
 @param configuration Optional set of JSON-codable configuration parameters that correspond specifically to the network. Only @c NSString, @c NSNumber, @c NSArray, and @c NSDictionary types are allowed. This value may be @c nil.
 @param complete Optional completion block that is invoked when the underlying network SDK has completed initialization. This value may be @c nil.
 @remarks Classes that implement this protocol must account for the possibility of @c initializeNetworkWithConfiguration:complete: being called multiple times. It is up to each individual adapter to determine whether re-initialization is allowed or not.
 */
- (void)initializeNetworkWithConfiguration:(NSDictionary<NSString *, id> * _Nullable)configuration complete:(void(^ _Nullable)(NSError * _Nullable))complete;

@end

#endif /* UnityAdsAdapterConfiguration_h */
