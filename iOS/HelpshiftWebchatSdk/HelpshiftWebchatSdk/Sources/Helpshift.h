//
//  Helpshift.h
//  HelpshiftWebchatSdk
//
//  Created by rhishikesh on 26/07/19.
//  Copyright © 2019 Helpshift. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HelpshiftWebchatDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface Helpshift : NSObject

+ (void) installWithPlatformId:(NSString *)platformId andDomain:(NSString *)domain;
+ (void) updateConfig:(NSDictionary *)newConfig;

+ (void) loginWithUserIdentifier:(NSString *)userIdentifier
    withName:(NSString *)userName
    andEmail:(NSString *)userEmail;

+ (void) showConversationWith:(UIViewController *)viewController andWebchatDelegate:(id<HelpshiftWebchatDelegate>) delegate;

@end

NS_ASSUME_NONNULL_END
