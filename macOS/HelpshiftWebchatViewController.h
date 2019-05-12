//
//  HelpshiftWebchatViewController.h
//  HelpshiftOSXSalesDemo
//
//  Copyright © 2019 Helpshift. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "HelpshiftWebchatWebview.h"

NS_ASSUME_NONNULL_BEGIN

@interface HelpshiftWebchatViewController : NSViewController <HelpshiftWebchatDelegate>
{
    HelpshiftWebchatWebview *webview;
}
@end

NS_ASSUME_NONNULL_END
