//
//  UnityAdsMediationSettingsProtocol.h
//  MoPubSDK
//
//  Copyright © 2021 MoPub. All rights reserved.
//

#ifndef UnityAdsMediationSettingsProtocol_h
#define UnityAdsMediationSettingsProtocol_h

#import "MPMediationSettingsProtocol.h"

/**
 * `UnityInstanceMediationSettings` allows the application to provide per-instance properties
 * to configure aspects of Unity ads. See `MPMediationSettingsProtocol` to see how mediation settings
 * are used.
 */
@interface UnityAdsMediationSettingsProtocol : NSObject <MPMediationSettingsProtocol>

/**
 * An NSString that's used as an identifier for a specific user, and is passed along to Unity
 * when the rewarded video ad is played.
 */
@property (nonatomic, copy) NSString *userIdentifier;

@end

#endif /* UnityAdsMediationSettingsProtocol_h */
