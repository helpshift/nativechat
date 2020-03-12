//
//  HelpshiftWebchatViewController.m
//  HelpshiftOSXSalesDemo
//
//  Copyright © 2019 Helpshift. All rights reserved.
//

#import "HelpshiftWebchatViewController.h"

@interface HelpshiftWebchatViewController ()

@end

@implementation HelpshiftWebchatViewController

- (instancetype) initWithNibName:(NSNibName)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self->webview = [HelpshiftWebchatWebview sharedInstance];
        [self->webview setHelpshiftWebchatDelegate:self];
        [self->webview setUIDelegate:self];
    }

    return self;
}

- (void) login {
    [self->webview loginWithIdentifier:@"rhi" userName:@"Rhishikesh" andEmail:@"r@h.com"];
}

- (void) updateHelpshiftConfig {
    [self->webview updateHelpshiftConfig:@{
//                                           @"widgetOptions" : @{
//                                                   @"showLauncher" : @NO
//                                                   },
                                           @"uiConfig" : @{ @"global": @{
                                                   @"color": @"#444"
                                                   }},
                                           }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.

    [self.view addSubview:self->webview];
    self->webview.translatesAutoresizingMaskIntoConstraints = false;
    [NSLayoutConstraint activateConstraints:@[
                                              [self.view.leftAnchor constraintEqualToAnchor:self->webview.leftAnchor],
                                              [self.view.rightAnchor constraintEqualToAnchor:self->webview.rightAnchor],
                                              [self.view.topAnchor constraintEqualToAnchor:self->webview.topAnchor],
                                              [self.view.bottomAnchor constraintEqualToAnchor:self->webview.bottomAnchor]
                                              ]];
}

- (void)chatLoad {
    NSString *jsPath = [[NSBundle mainBundle] pathForResource:@"HelpshiftWebchatWrapper" ofType:@"js"];
    NSString *jsCode = [NSString stringWithContentsOfFile:jsPath encoding:NSUTF8StringEncoding error:nil];
    [self->webview evaluateJavaScript:jsCode completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error : %@", error);
        }
    }];
    [self login];
}

- (void)chatEnd {
    NSLog(@"%s", __FUNCTION__);
}

- (void)conversationEnd {
    NSLog(@"%s", __FUNCTION__);
}

- (void)conversationRejected {
    NSLog(@"%s", __FUNCTION__);

}

- (void)conversationReopened {
    NSLog(@"%s", __FUNCTION__);
}

- (void)conversationResolved {
    NSLog(@"%s", __FUNCTION__);
}

- (void)conversationStart:(NSDictionary *)conversation {
    NSLog(@"%s", __FUNCTION__);
}

- (void)csatSubmit:(NSDictionary *)csatInfo {
    NSLog(@"%s", __FUNCTION__);
}

- (void)messageAdd:(NSDictionary *)message {
    NSLog(@"%s", __FUNCTION__);
}

- (void)newUnreadMessages:(NSInteger)count {
    if (count) {
        //Initalize new notification
        NSUserNotification *notification = [[NSUserNotification alloc] init];
        //Set the title of the notification
        [notification setTitle:@"You have 1 new message from Support"];
        if (count > 1) {
            [notification setTitle:[NSString stringWithFormat:@"You have %d new messages from Support", (int)count]];
        }
        //Set the time and date on which the nofication will be deliverd (for example 20 secons later than the current date and time)
        [notification setDeliveryDate:[NSDate date]];
        //Set the sound, this can be either nil for no sound, NSUserNotificationDefaultSoundName for the default sound (tri-tone) and a string of a .caf file that is in the bundle (filname and extension)
        [notification setSoundName:NSUserNotificationDefaultSoundName];

        //Get the default notification center
        NSUserNotificationCenter *center = [NSUserNotificationCenter defaultUserNotificationCenter];
        //Scheldule our NSUserNotification
        [center scheduleNotification:notification];
    }
}

- (void)userChanged:(NSDictionary *)userInfo {
    NSLog(@"%s", __FUNCTION__);

}

- (void)webView:(WKWebView *)webView runOpenPanelWithParameters:(WKOpenPanelParameters *)parameters initiatedByFrame:(WKFrameInfo *)frame completionHandler:(void (^)(NSArray<NSURL *> * _Nullable))completionHandler {
    NSOpenPanel *openPanel = [[NSOpenPanel alloc] init];
    openPanel.canChooseFiles = YES;
    [openPanel beginWithCompletionHandler:^(NSModalResponse result) {
        if (result == NSModalResponseOK && openPanel.URL) {
            completionHandler(@[openPanel.URL]);
        } else if (result == NSModalResponseCancel) {
            completionHandler(nil);
        }
    }];
}

- (WKWebView *)webView:(WKWebView *)webView createWebViewWithConfiguration:(WKWebViewConfiguration *)configuration forNavigationAction:(WKNavigationAction *)navigationAction windowFeatures:(WKWindowFeatures *)windowFeatures {
    NSViewController *viewController = [[NSViewController alloc] initWithNibName:nil bundle:nil];
    WKWebView *downloadWebview = [[WKWebView alloc] initWithFrame:CGRectMake(0,0,400,400) configuration:configuration];
    [downloadWebview loadRequest:navigationAction.request];
    viewController.view = downloadWebview;

    NSWindow *window = [[NSWindow alloc] init];
    //set the window to be borderless
    [window setStyleMask:NSWindowStyleMaskBorderless];

    //show the window as modal
    [window setContentViewController:viewController];
    [window center];
    [self presentViewControllerAsModalWindow:viewController];
    return nil;
}
@end
