//
//  HelpshiftWebchatDelegate.h
//  HelpshiftOSXSalesDemo
//
//  Copyright © 2019 Helpshift. All rights reserved.
//

#ifndef HelpshiftWebchatDelegate_h
#define HelpshiftWebchatDelegate_h

@protocol HelpshiftWebchatDelegate <NSObject>

- (void) chatLoad;
- (void) chatEnd;
- (void) conversationStart:(NSDictionary *) conversation;
- (void) conversationEnd;
- (void) conversationRejected;
- (void) conversationResolved;
- (void) conversationReopened;

- (void) messageAdd:(NSDictionary *) message;
- (void) csatSubmit:(NSDictionary *) csatInfo;

- (void) userChanged:(NSDictionary *) userInfo;

- (void) newUnreadMessages:(NSInteger) count;


@end

#endif /* HelpshiftWebchatDelegate_h */
