//
//  HelpshiftWebchatWebview.m
//  HelpshiftOSXSalesDemo
//
//  Copyright © 2019 Helpshift. All rights reserved.
//

#import "HelpshiftWebchatWebview.h"

@interface HelpshiftWebchatWebview ()
{
    HelpshiftWebchatScriptMessageHandler *scriptMessageHandler;
}

@end

@implementation HelpshiftWebchatWebview

+ (instancetype) sharedInstance {
    static HelpshiftWebchatWebview *instance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *url = [NSURL URLWithString:@"http://127.0.0.1:8000"];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        NSString *jsPath = [[NSBundle mainBundle] pathForResource:@"HelpshiftWebchatWrapper" ofType:@"js"];
        NSString *jsSource = [NSString stringWithContentsOfFile:jsPath encoding:NSUTF8StringEncoding error:nil];
        
        WKUserScript *wrapperScript = [[WKUserScript alloc] initWithSource:jsSource injectionTime:WKUserScriptInjectionTimeAtDocumentEnd forMainFrameOnly:NO];
        
        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        WKUserContentController *contentController = [[WKUserContentController alloc] init];
        
        [contentController addUserScript:wrapperScript];
        configuration.userContentController = contentController;
        
        HelpshiftWebchatScriptMessageHandler *scriptMessageHandler = [[HelpshiftWebchatScriptMessageHandler alloc] init];
        
        [contentController addScriptMessageHandler:scriptMessageHandler name:kChatEndEvent];
        [contentController addScriptMessageHandler:scriptMessageHandler name:kNewUnreadMessagesEvent];
        [contentController addScriptMessageHandler:scriptMessageHandler name:kUserChangedEvent];
        [contentController addScriptMessageHandler:scriptMessageHandler name:kConversationStartEvent];
        [contentController addScriptMessageHandler:scriptMessageHandler name:kMessageAddEvent];
        [contentController addScriptMessageHandler:scriptMessageHandler name:kCsatSubmitEvent];
        [contentController addScriptMessageHandler:scriptMessageHandler name:kConversationEndEvent];
        [contentController addScriptMessageHandler:scriptMessageHandler name:kConversationRejectedEvent];
        [contentController addScriptMessageHandler:scriptMessageHandler name:kConversationResolvedEvent];
        [contentController addScriptMessageHandler:scriptMessageHandler name:kConversationReopenedEvent];

        instance = [[HelpshiftWebchatWebview alloc] initWithFrame:CGRectMake(0, 0, 0, 0)
                                                    configuration:configuration];
        instance->scriptMessageHandler = scriptMessageHandler;
        
        [instance loadRequest:request];
    });
    
    return instance;
}


#pragma mark Webchat APIs

- (void) loginWithIdentifier:(NSString *) identifier userName:(NSString *) userName andEmail:(NSString *) email {
    NSString *jsCode = [NSString stringWithFormat:@"window.helpshiftConfig.userId = '%@'; \n window.helpshiftConfig.userName = '%@'; \n window.helpshiftConfig.userEmail = '%@'; \n Helpshift('updateHelpshiftConfig');",
                        identifier, userName, email];
    
    [self evaluateJavaScript:jsCode completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error : %@", error);
        }
    }];
}

- (void) updateHelpshiftConfig:(NSDictionary *) configDictionary {
    NSError *error;
    NSString *jsCode = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:configDictionary
                                                       options:0
                                                         error:&error];
    if (!jsonData) {
        jsCode = @"";
    } else {
        NSString *configJson = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        jsCode = [NSString stringWithFormat:@"window.helpshiftConfig = {...window.helpshiftConfig, ...%@}; Helpshift('updateHelpshiftConfig')", configJson];
    }
    
    [self evaluateJavaScript:jsCode completionHandler:^(id _Nullable result, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Error : %@", error);
        }
    }];
}

- (void) setHelpshiftWebchatDelegate:(id<HelpshiftWebchatDelegate>) delegate {
    self->scriptMessageHandler.webchatDelegate = delegate;
}

@end

@implementation HelpshiftWebchatScriptMessageHandler

#pragma mark WKScriptMessageHandler delegate
- (void)userContentController:(nonnull WKUserContentController *)userContentController didReceiveScriptMessage:(nonnull WKScriptMessage *)message {
    
    if (_webchatDelegate == nil) {
        return;
    }
    
    NSDictionary *messageData = (NSDictionary *) message.body;
    NSArray *messageNames = @[
                              kChatEndEvent,
                              kNewUnreadMessagesEvent,
                              kUserChangedEvent,
                              kConversationStartEvent,
                              kMessageAddEvent,
                              kCsatSubmitEvent,
                              kConversationEndEvent,
                              kConversationRejectedEvent,
                              kConversationResolvedEvent,
                              kConversationReopenedEvent
                              ];
    
    NSUInteger messageIndex = [messageNames indexOfObject:message.name];
    switch (messageIndex) {
        case 0:
            if ([_webchatDelegate respondsToSelector:@selector(chatEnd)]) {
                [_webchatDelegate chatEnd];
            }
            break;
        case 1:
            if ([_webchatDelegate respondsToSelector:@selector(newUnreadMessages:)]) {
                [_webchatDelegate newUnreadMessages:[[messageData objectForKey:@"unreadCount"] integerValue]];
            }
            break;
        case 2:
            if ([_webchatDelegate respondsToSelector:@selector(userChanged:)]) {
                [_webchatDelegate userChanged:messageData];
            }
            break;
        case 3:
            if ([_webchatDelegate respondsToSelector:@selector(conversationStart:)]) {
                [_webchatDelegate conversationStart:messageData];
            }
            break;
        case 4:
            if ([_webchatDelegate respondsToSelector:@selector(messageAdd:)]) {
                [_webchatDelegate messageAdd:messageData];
            }
            break;
        case 5:
            if ([_webchatDelegate respondsToSelector:@selector(csatSubmit:)]) {
                [_webchatDelegate csatSubmit:messageData];
            }
            break;
        case 6:
            if ([_webchatDelegate respondsToSelector:@selector(conversationEnd)]) {
                [_webchatDelegate conversationEnd];
            }
            break;
        case 7:
            if ([_webchatDelegate respondsToSelector:@selector(conversationRejected)]) {
                [_webchatDelegate conversationRejected];
            }
            break;
        case 8:
            if ([_webchatDelegate respondsToSelector:@selector(conversationResolved)]) {
                [_webchatDelegate conversationResolved];
            }
            break;
        case 9:
            if ([_webchatDelegate respondsToSelector:@selector(conversationReopened)]) {
                [_webchatDelegate conversationReopened];
            }
            break;

        default:
            break;
    }
}


@end
