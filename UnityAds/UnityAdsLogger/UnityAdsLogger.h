//
//  UnityAdsLogger.h
//  MoPubSDK
//
//  Copyright © 2021 MoPub. All rights reserved.
//

#ifndef UnityAdsLogger_h
#define UnityAdsLogger_h

#import <UnityAds/UnityAds.h>

#if __has_include(<MoPub/MoPub.h>)
    #import <MoPub/MoPub.h>
#elif __has_include(<MoPubSDK/MoPub.h>)
    #import <MoPubSDK/MoPub.h>
#else
    #import "MPFullscreenAdAdapter.h"
#endif

#import "MPLogging.h"

@protocol UnityAdsLogMessage <NSObject>
-(MPBLogLevel)logLevel;
-(NSString *)message;
-(NSString *)details;
@end

@interface UnityAdsLogger
@end

@protocol UnityAdsLogger <NSObject>

-(void)logMessage:(id<UnityAdsLogMessage>)message;

@end

#endif /* UnityAdsLogger_h */
