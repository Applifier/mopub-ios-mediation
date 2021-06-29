//
//  UnityAdsErrorFactory.m
//  MoPubSDK
//
//  Copyright © 2021 MoPub. All rights reserved.
//


#import "UnityAdsConstants.h"

#if __has_include(<MoPub/MoPub.h>)
    #import <MoPub/MoPub.h>
#elif __has_include(<MoPubSDK/MoPub.h>)
    #import <MoPubSDK/MoPub.h>
#else
    #import "MPFullscreenAdAdapter.h"
#endif

#import "MPLogging.h"
#import "MPError.h"
#import "UnityAdsErrorFactory.h"



@interface UnityErrorLogEvent: NSObject<UnityAdsLogMessage>
//@property (nonatomic) MPBLogLevel logLevel;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *details;


+(instancetype)newEmptyGameID: (NSString *)details;
@end


@implementation UnityErrorLogEvent
+newWithMessage: (NSString *)message andDetails: (NSString *)details {
    UnityErrorLogEvent *event = [UnityErrorLogEvent new];
    //event.logLevel = MPBLogLevelDebug; // TODO: Set
    event.message = message;
    event.details = details;
    return event;
}

+(instancetype)newEmptyGameID: (NSString *)details {
    return [self newWithMessage: @"initialization skipped. The gameId is empty. Ensure it is properly configured on the MoPub dashboard: "
                andDetails: details];
}

- (MPBLogLevel)logLevel {
    return MPBLogLevelDebug;
}


@end


@implementation UnityAdsErrorFactory

-(NSError *)loadErrorForType: (UnityAdsLoadError) type withMessage: (NSString *) message {
    MOPUBErrorCode code;
    NSString *description;
    
    switch(type) {
        case kUnityAdsLoadErrorInitializeFailed:
            code = MOPUBErrorSDKNotInitialized;
            description = kUnityAdsAdapterLoadErrorInitializeFailed;
            break;
        case kUnityAdsLoadErrorInvalidArgument:
            code = MOPUBErrorUnknown;
            description = kUnityAdsAdapterLoadErrorInvalidArgument;
            break;
        case kUnityAdsLoadErrorNoFill:
            code = MOPUBErrorNoInventory;
            description = kUnityAdsAdapterLoadErrorNoFill;
            break;
        case kUnityAdsLoadErrorTimeout:
            code = MOPUBErrorNetworkTimedOut;
            description = kUnityAdsAdapterLoadErrorTimeout;
            break;
        case kUnityAdsLoadErrorInternal:
            code = MOPUBErrorUnknown;
            description = kUnityAdsAdapterLoadErrorInternal;
            break;
        default:
            code = MOPUBErrorUnknown;
            description = kUnityAdsAdapterLoadErrorUnknown;
            break;
    }
    
    return [NSError errorWithCode:code localizedDescription:description];
}

-(NSError *)showErrorForType: (UnityAdsShowError) type withMessage: (NSString *) message {
    return nil; // TODO
}


- (id<UnityAdsLogMessage>)loadErrorlogEvent:(UnityAdsLoadError)type withMessage:(NSString *)message {
    switch(type) {
        case kUnityAdsLoadErrorInitializeFailed:
            return  [UnityErrorLogEvent newEmptyGameID: message];
            break;
 
        default:

            break;
    }
    return nil;
}
@end


