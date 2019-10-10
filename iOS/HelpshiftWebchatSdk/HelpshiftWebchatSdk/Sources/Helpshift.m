//
//  Helpshift.m
//  HelpshiftWebchatSdk
//
//  Created by rhishikesh on 26/07/19.
//  Copyright © 2019 Helpshift. All rights reserved.
//

#import "Helpshift.h"
#import "PersistentData.h"
#import "HelpshiftWebchatViewController.h"

@implementation Helpshift

+ (void) installWithPlatformId:(NSString *)platformId andDomain:(NSString *)domain {
    [PersistentData initializeData];
    [PersistentData setString:platformId forKey:@"platformId"];
    [PersistentData setString:domain forKey:@"domain"];
}

+ (void) updateConfig:(NSDictionary *)newConfig {
    [PersistentData setObject:newConfig forKey:@"config"];
}

+ (void) loginWithUserIdentifier:(NSString *)userIdentifier
    withName:(NSString *)userName
    andEmail:(NSString *)userEmail {
    [PersistentData setString:userIdentifier forKey:@"userIdentifier"];
    [PersistentData setString:userName forKey:@"userName"];
    [PersistentData setString:userEmail forKey:@"userEmail"];
}

+ (void) showConversationWith:(UIViewController *)viewController andWebchatDelegate:(id<HelpshiftWebchatDelegate>) delegate {
    HelpshiftWebchatViewController *webchatController = [[HelpshiftWebchatViewController alloc] initWithNibName:nil bundle:nil];
    [webchatController setWebchatDelegate:delegate];
    [viewController.navigationController pushViewController:webchatController animated:YES];
}
@end
