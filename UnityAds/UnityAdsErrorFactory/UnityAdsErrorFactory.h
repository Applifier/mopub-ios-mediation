//
//  UnityAdsErrorFactory.h
//  MoPubSDK
//
//  Copyright © 2021 MoPub. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UnityAds/UnityAds.h>
#import "UnityAdsLogger.h"

NS_ASSUME_NONNULL_BEGIN

@interface UnityAdsErrorFactory : NSObject
-(id<UnityAdsLogMessage>)loadErrorlogEvent: (UnityAdsLoadError) type withMessage: (NSString *)message;
-(NSError *)loadErrorForType: (UnityAdsLoadError) type withMessage: (NSString *)message;
-(NSError *)showErrorForType: (UnityAdsShowError) type withMessage: (NSString *)message;
@end

NS_ASSUME_NONNULL_END
