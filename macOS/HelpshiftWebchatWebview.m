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

NSString *HelpShiftPlatformID = @"<platform-id>";
NSString *HelpShiftDomain = @"domain";
NSString *webSupportPortalURL = @"https://domain.helpshift.com/webchat/a/app-name";

NSString *jScript = @"(function () { var PLATFORM_ID = '%@',DOMAIN = '%@',LANGUAGE = 'en'; window.helpshiftConfig = { platformId: PLATFORM_ID, domain: DOMAIN, language: LANGUAGE, uiConfig: { global: { color: '#444'}, widgetFrame: { primaryBgColor: '#2973c7', primaryTextColor: '#ffe'}}}; /* Widget Options Start */ helpshiftConfig.widgetOptions = {/* All widget specific options go here.*/ fullScreen: true, showCloseButton: false, showLauncher: false }; }) (); !function(t,e){if('function'!=typeof window.Helpshift){var n=function(){n.q.push(arguments)};n.q=[],window.Helpshift=n;var i,a=t.getElementsByTagName('script')[0];if(t.getElementById(e))return;i=t.createElement('script'),i.async=!0,i.id=e,i.src='https://webchat.helpshift.com/webChat.js';var o=function(){window.Helpshift('init')};window.attachEvent?i.attachEvent('onload',o):i.addEventListener('load',o,!1),a.parentNode.insertBefore(i,a)}else window.Helpshift('update')}(document,'hs-chat');";

@implementation HelpshiftWebchatWebview

+ (instancetype) sharedInstance {
    static HelpshiftWebchatWebview *instance = nil;
    BOOL openFAQs = true;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSURL *url = nil;
        NSURLRequest *request = nil;
        if (openFAQs) {
            url = [NSURL URLWithString:webSupportPortalURL];
            request = [NSURLRequest requestWithURL:url];
        } else {
            url = [NSURL URLWithString:@"http://127.0.0.1:8000/"];
        }
        NSError *error;

        NSString *jsPath = [[NSBundle mainBundle] pathForResource:@"HelpshiftWebchatOnLoad" ofType:@"js"];
        NSString *jsSource = [NSString stringWithContentsOfFile:jsPath encoding:NSUTF8StringEncoding error:nil];
        NSURL *localHTML = [[NSBundle mainBundle]URLForResource:@"helpshift-webchat" withExtension:@"html"];
        NSString *contentsOfHTML = [NSString stringWithContentsOfURL:localHTML encoding:NSUTF8StringEncoding error:&error];

        WKUserScript *wrapperScript = [[WKUserScript alloc] initWithSource:jsSource
                                                             injectionTime:WKUserScriptInjectionTimeAtDocumentEnd
                                                          forMainFrameOnly:YES];

        WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
        WKUserContentController *contentController = [[WKUserContentController alloc] init];

        if (!openFAQs) {
            WKUserScript *script = [[WKUserScript alloc]
                                    initWithSource:[NSString stringWithFormat:jScript, HelpShiftPlatformID, HelpShiftDomain] injectionTime:WKUserScriptInjectionTimeAtDocumentEnd
                                    forMainFrameOnly:YES];
            [contentController addUserScript:script];
        }
        [contentController addUserScript:wrapperScript];
        configuration.userContentController = contentController;

        HelpshiftWebchatScriptMessageHandler *scriptMessageHandler = [[HelpshiftWebchatScriptMessageHandler alloc] init];

        [contentController addScriptMessageHandler:scriptMessageHandler name:kChatEndEvent];
        [contentController addScriptMessageHandler:scriptMessageHandler name:kChatLoadEvent];
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

        if (openFAQs) {
            [instance loadRequest:request];
        } else {
            [instance loadHTMLString:contentsOfHTML baseURL:[NSURL URLWithString:@"http://localhost"]];
        }
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
                              kConversationReopenedEvent,
                              kChatLoadEvent
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
        case 10:
            if ([_webchatDelegate respondsToSelector:@selector(chatLoad)]) {
                [_webchatDelegate chatLoad];
            }
            break;
        default:
            break;
    }
}


@end
