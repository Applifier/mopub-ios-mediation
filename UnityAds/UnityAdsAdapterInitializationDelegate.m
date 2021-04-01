//
//  UnityAdsAdapterInitializationDelegate.m
//  MoPubSDK
//
//  Copyright © 2021 MoPub. All rights reserved.
//

#include "UnityAdsAdapterInitializationDelegate.h"

@implementation UnityAdsAdapterInitializationDelegate

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
        NSError *initError = nil; //[NSError errorWithCode:(MOPUBErrorSDKNotInitialized) localizedDescription:message];
        _initCompletion(initError);
    }
}

@end
