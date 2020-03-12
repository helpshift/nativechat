//  Copyright © 2019 Helpshift. All rights reserved.

//helpshiftConfig.widgetOptions = {
//    showCloseButton: false,
//    showLauncher: false,
//    fullScreen: true,
//};
//
//window.helpshiftConfig.uiConfig = {
//    global: {
//        color: "#888"
//    },
//};

var chatEndHandler = function () {
    window.webkit.messageHandlers.chatEnd.postMessage({});
};
Helpshift("addEventListener", "chatEnd", chatEndHandler);

var newUnreadMessagesEventHandler = function (data) {
    window.webkit.messageHandlers.newUnreadMessages.postMessage({ unreadCount: data.unreadCount });
}
Helpshift("addEventListener", "newUnreadMessages", newUnreadMessagesEventHandler);

var userChangedHandler = function (data) {
    window.webkit.messageHandlers.userChanged.postMessage(data);
};
Helpshift("addEventListener", "userChanged", userChangedHandler);

var conversationStartEventHandler = function (data) {
    window.webkit.messageHandlers.conversationStart.postMessage(data);
}
Helpshift("addEventListener", "conversationStart", conversationStartEventHandler);

var messageAddEventHandler = function (data) {
    window.webkit.messageHandlers.messageAdd.postMessage(data);

}
Helpshift("addEventListener", "messageAdd", messageAddEventHandler);

var csatSubmitEventHandler = function (data) {
    window.webkit.messageHandlers.csatSubmit.postMessage(data);
}
Helpshift("addEventListener", "csatSubmit", csatSubmitEventHandler);

var conversationEndEventHandler = function () {
    window.webkit.messageHandlers.conversationEnd.postMessage({});
}
Helpshift("addEventListener", "conversationEnd", conversationEndEventHandler);


var conversationRejectedEventHandler = function () {
    window.webkit.messageHandlers.conversationRejected.postMessage({});
}
Helpshift("addEventListener", "conversationRejected", conversationRejectedEventHandler);


var conversationResolvedEventHandler = function () {
    window.webkit.messageHandlers.conversationResolved.postMessage({});
}
Helpshift("addEventListener", "conversationResolved", conversationResolvedEventHandler);


var conversationReopenedEventHandler = function () {
    window.webkit.messageHandlers.conversationReopened.postMessage({});
}
Helpshift("addEventListener", "conversationReopened", conversationReopenedEventHandler);
