//
//  HelpshiftWebchatWebview.h
//  HelpshiftOSXSalesDemo
//
//  Copyright © 2019 Helpshift. All rights reserved.
//

#import <WebKit/WebKit.h>
#import "HelpshiftWebchatDelegate.h"

#define kChatEndEvent              @"chatEnd"
#define kNewUnreadMessagesEvent    @"newUnreadMessages"
#define kUserChangedEvent          @"userChanged"
#define kConversationStartEvent    @"conversationStart"
#define kMessageAddEvent           @"messageAdd"
#define kCsatSubmitEvent           @"csatSubmit"
#define kConversationEndEvent      @"conversationEnd"
#define kConversationRejectedEvent @"conversationRejected"
#define kConversationResolvedEvent @"conversationResolved"
#define kConversationReopenedEvent @"conversationReopened"

NS_ASSUME_NONNULL_BEGIN

@interface HelpshiftWebchatWebview : WKWebView <WKScriptMessageHandler>

+ (instancetype) sharedInstance;

- (void) loginWithIdentifier:(NSString *)identifier userName:(NSString *)userName andEmail:(NSString *)email;

- (void) updateHelpshiftConfig:(NSDictionary *)configDictionary;

- (void) setHelpshiftWebchatDelegate:(id<HelpshiftWebchatDelegate>)delegate;

@end

@interface HelpshiftWebchatScriptMessageHandler : NSObject <WKScriptMessageHandler>

@property (nonatomic) id<HelpshiftWebchatDelegate> webchatDelegate;

@end


NS_ASSUME_NONNULL_END
