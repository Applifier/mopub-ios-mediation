//
//  UnityAdsDomainLogger.h
//  MoPub-TestApp-Local
//
//  Created by Richard Hawkins on 6/7/21.
//  Copyright © 2021 Unity Ads. All rights reserved.
//

#ifndef UnityAdsDomainLogger_h
#define UnityAdsDomainLogger_h

@interface UnityAdsDomainLogger : NSObject<UnityAdsLogger>

@property (nonatomic, copy) NSString *domain;

- (instancetype) init:(NSString *) domain;

@end

#endif /* UnityAdsDomainLogger_h */
