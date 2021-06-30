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

@implementation UnityAdsErrorFactory

+ (NSError *)createErrorWith:(NSString *)description andReason:(NSString *)reason andSuggestion:(NSString *)suggestion {
    NSDictionary *userInfo = @{
                               NSLocalizedDescriptionKey: NSLocalizedString(description, nil),
                               NSLocalizedFailureReasonErrorKey: NSLocalizedString(reason, nil),
                               NSLocalizedRecoverySuggestionErrorKey: NSLocalizedString(suggestion, nil)
                               };

    return [NSError errorWithDomain:NSStringFromClass([self class]) code:0 userInfo:userInfo];
}

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
    MOPUBErrorCode code;
    NSString *description;
    
    switch(type) {
        case kUnityShowErrorNotInitialized:
            code = MOPUBErrorSDKNotInitialized;
            description = kUnityAdsAdapterShowErrorNotInitialized;
            break;
        case kUnityShowErrorNotReady:
            code = MOPUBErrorUnknown;
            description = kUnityAdsAdapterShowErrorNotReady;
            break;
        case kUnityShowErrorVideoPlayerError:
            code = MOPUBErrorUnknown;
            description = kUnityAdsAdapterShowErrorVideoPlayerError;
            break;
        case kUnityShowErrorInvalidArgument:
            code = MOPUBErrorUnknown;
            description = kUnityAdsAdapterShowErrorInvalidArgument;
            break;
        case kUnityShowErrorNoConnection:
            code = MOPUBErrorUnknown;
            description = kUnityAdsAdapterShowErrorNoConnection;
            break;
        case kUnityShowErrorAlreadyShowing:
            code = MOPUBErrorUnknown;
            description = kUnityAdsAdapterShowErrorAlreadyShowing;
            break;
        case kUnityShowErrorInternalError:
            code = MOPUBErrorUnknown;
            description = kUnityAdsAdapterShowErrorInternalError;
            break;
        default:
            code = MOPUBErrorUnknown;
            description = kUnityAdsAdapterShowErrorUnknown;
            break;
    }
    
    return [NSError errorWithCode:code localizedDescription:description];
}

@end


