var checkForChatLoad = function () {
    if(window.helpshiftConfig) {
        window.webkit.messageHandlers.chatLoad.postMessage({});
    } else {
        setTimeout(() => {
          checkForChatLoad();
        }, 200);
    }
};

checkForChatLoad();
