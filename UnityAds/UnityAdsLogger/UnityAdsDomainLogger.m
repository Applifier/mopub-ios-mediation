//
//  UnityAdsLogger.m
//  MoPubSDK
//
//  Copyright © 2021 MoPub. All rights reserved.
//

#import <UnityAds/UnityAds.h>
#import "UnityAdsLogger.h"
#import "UnityAdsDomainLogger.h"

@implementation UnityAdsDomainLogger

- (instancetype) init:(NSString *) domain {
    self = [super init];
    if (self) {
        self.domain = domain;
    }
    return self;
}

- (void)logMessage:(id<UnityAdsLogMessage>)message {
    MPLogEvent *event = [[MPLogEvent alloc] initWithMessage: [self messageFrom: message]
                                                      level: message.logLevel];
    MPLogEvent(event);
}

-(NSString *)messageFrom: (id<UnityAdsLogMessage>)message {
    NSString *domain = @"";
    if (self.domain != nil && ![self.domain isEqualToString:@""]) {
        domain = [NSString stringWithFormat: @"%@: ", self.domain];
    }

    return [NSString stringWithFormat: @"[UnityAds]: %@%@ details: %@ ",
            domain,
            message.message ?: @"",
            message.details ?: @"nil"];

}

@end

