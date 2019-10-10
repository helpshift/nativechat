//
//  HelpshiftWebchatViewController.h
//  HelpshiftWebchatSdk
//
//  Created by rhishikesh on 26/07/19.
//  Copyright © 2019 Helpshift. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HelpshiftWebchatWebview.h"

NS_ASSUME_NONNULL_BEGIN

@interface HelpshiftWebchatViewController : UIViewController
- (void) setWebchatDelegate:(id<HelpshiftWebchatDelegate>) webchatDelegate;
@end

NS_ASSUME_NONNULL_END
