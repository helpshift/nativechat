//
//  HelpshiftWebchatViewController.m
//  HelpshiftWebchatSdk
//
//  Copyright © 2019 Helpshift. All rights reserved.
//

#import "HelpshiftWebchatViewController.h"
#import "PersistentData.h"

@interface HelpshiftWebchatViewController () {
    HelpshiftWebchatWebview *webview;
}
@end

@implementation HelpshiftWebchatViewController

static CGFloat const kHeaderViewHeight = 50.0;

- (instancetype) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self) {
        self->webview = [HelpshiftWebchatWebview sharedInstance];
    }

    return self;
}

- (void) login {
    [self->webview loginWithIdentifier:[PersistentData stringForKey:@"userIdentifier"]
                              userName:[PersistentData stringForKey:@"userName"]
                              andEmail:[PersistentData stringForKey:@"userEmail"]];
}

- (void) updateHelpshiftConfig {
    [self->webview updateHelpshiftConfig:[PersistentData objectForKey:@"config"]];
}

- (void) updateCustomIssueFields {
    NSDictionary *customIssueFieldsDictionary = @{
        @"your_custom_key_1" : @"your_custom_value_1",
        @"your_custom_key_2" : @"your_custom_value_2",
    };
    
    [self->webview updateCustomIssueFields:customIssueFieldsDictionary];
}

- (void) setWebchatDelegate:(id<HelpshiftWebchatDelegate>) webchatDelegate {
    [self->webview setHelpshiftWebchatDelegate:webchatDelegate];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self login];
        // [self updateHelpshiftConfig];
    });
}

- (void) viewDidLoad {
    [super viewDidLoad];

    CGRect webViewFrame = [[self view] bounds];
    webViewFrame.size.height -= kHeaderViewHeight;

    [self.view addSubview:self->webview];
    self->webview.translatesAutoresizingMaskIntoConstraints = false;
    [NSLayoutConstraint activateConstraints:@[
         [self.view.leftAnchor constraintEqualToAnchor:self->webview.leftAnchor],
         [self.view.rightAnchor constraintEqualToAnchor:self->webview.rightAnchor],
         [self.view.topAnchor constraintEqualToAnchor:self->webview.topAnchor],
         [self.view.bottomAnchor constraintEqualToAnchor:self->webview.bottomAnchor]
    ]];
}

@end
