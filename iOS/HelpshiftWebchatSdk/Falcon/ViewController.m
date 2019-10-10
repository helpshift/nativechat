//
//  ViewController.m
//  Falcon
//
//  Created by rhishikesh on 26/07/19.
//  Copyright © 2019 Helpshift. All rights reserved.
//

#import "ViewController.h"
#import <HelpshiftWebchatSdk/Helpshift.h>

@interface ViewController ()

@end

@implementation ViewController

- (void) viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction) login:(id)sender {
    // FIXME: setting just widget options here will replace them !
    // how can this be improved to add, spread over
//    [Helpshift updateConfig:@{ @"widgetOptions" :
//                               @{
//                                   @"showLauncher" : @NO
//                                },
//                             }];

    [Helpshift loginWithUserIdentifier:@"id"
                              withName:@"name"
                              andEmail:@"email"];

}

- (IBAction) chat:(id)sender {
    [Helpshift showConversationWith:self andWebchatDelegate:self];
}

- (void) chatEnd {
    NSLog(@"%s", __FUNCTION__);
}

- (void) conversationEnd {
    NSLog(@"%s", __FUNCTION__);
}

- (void) conversationRejected {
    NSLog(@"%s", __FUNCTION__);
}

- (void) conversationReopened {
    NSLog(@"%s", __FUNCTION__);
}

- (void) conversationResolved {
    NSLog(@"%s", __FUNCTION__);
}

- (void) conversationStart:(NSDictionary *)conversation {
    NSLog(@"%s", __FUNCTION__);
}

- (void) csatSubmit:(NSDictionary *)csatInfo {
    NSLog(@"%s", __FUNCTION__);
}

- (void) messageAdd:(NSDictionary *)message {
    NSLog(@"%s", __FUNCTION__);
}

- (void) newUnreadMessages:(NSInteger)count {
    if(count) {
        // Initalize new notification
        NSLog(@"Show a notification");
    }
}

- (void) userChanged:(NSDictionary *)userInfo {
    NSLog(@"%s", __FUNCTION__);
}


@end
