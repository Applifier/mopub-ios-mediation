//
//  UnityAdsAdapterInitializationDelegate.m
//  MoPubSDK
//
//  Copyright © 2021 MoPub. All rights reserved.
//

#include "UnityAdsConstants.h"
#include "UnityAdsAdapterInitializationDelegate.h"

#if __has_include(<MoPub/MoPub.h>)
    #import <MoPub/MoPub.h>
#elif __has_include(<MoPubSDK/MoPub.h>)
    #import <MoPubSDK/MoPub.h>
#else
    #import "MPFullscreenAdAdapter.h"
#endif
#import "MPError.h"

@implementation UnityAdsAdapterInitializationDelegate

- (instancetype)init {
    return [self initWith: 0];
}

- (instancetype)initWith: (void(^ _Nullable)(NSError * _Nullable))complete {
    self = [super init];
    if (self) {
        _initCompletion = complete;
    }
    return self;
}

- (void)initializationComplete {
    if (_initCompletion) {
        _initCompletion(nil);
    }
    if (self.initializationCompleteBlock) {
        self.initializationCompleteBlock();
    }
}

- (void)initializationFailed:(UnityAdsInitializationError)error withMessage:(NSString * _Nonnull)message {
    if (_initCompletion) {
        NSString *description;

        switch(error) {
            case kUnityInitializationErrorInternalError:
                description = kUnityAdsAdapterInitializationErrorInternalError;
                break;
            case kUnityInitializationErrorInvalidArgument:
                description = kUnityAdsAdapterInitializationErrorInvalidArgument;
                break;
            case kUnityInitializationErrorAdBlockerDetected:
                description = kUnityAdsAdapterInitializationErrorAdBlockerDetected;
                break;
            default:
                description = kUnityAdsAdapterInitializationErrorUnknown;
                break;
        }

        NSError *initError = [NSError errorWithCode:MOPUBErrorSDKNotInitialized localizedDescription:description];
        _initCompletion(initError);
    }
}

@end
