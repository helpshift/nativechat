# Webchat + macOS

## Introduction
With the release of version `2.4` of the Helpshift macOS SDK, we have officially deprecated the macOS SDK product line and we will not be maintaining it going forward. If you are currently using the macOS SDK in your app, we suggest moving to using the Helpshift Webchat product to provide a support channel for your customers while keeping the conversation inside your app.

In order to help you achieve this, we have put together a POC, and this document will help you migrate away from the macOS SDK while supporting all of the major use-cases of an in-app Customer support channel.

## Basic setup
In order for the user to be able to continue his open conversations across app sessions, app will need to use a user login which is consistent with the user id being used in the app. In addition, Admins will need to enable Webchat Re-engagement via the Dashboard settings page. If you want to know how this is to be done, please refer to this link :
[Webchat Re-engagement](https://support.helpshift.com/kb/article/how-do-i-make-my-web-chat-asynchronous/)

For details on the login mechanism, please refer to the `HelpshiftWebchatViewController/login` method.

### Conversation only
If you only want to show the conversation screen with Webchat, please follow the below instructions.

To start showing the webchat widget for your domain, please ensure that you are able to host a publicly accessible webpage which embeds the Helpshift webchat widget into an html page.

To find the embed code for your domain, please check our [getting started guide](https://developers.helpshift.com/web-chat/).

An example of a very simple webpage with embedded webchat has been provided.
File name : `helpshift-webchat.html`
The `HelpshiftWebchatWebview.m` file will then inject the embed code into the browser using the `jScript` variable.

The next step will be to actually load the webpage in a browser and make sure the webchat widget loads properly.
Suggestion here is to test with Safari since that is the webview with `WKWebview` will provide.

### Web support / FAQs with logged in webchat
If you want to show the user FAQs and provide a use the app's login for the support conversation, please follow the below instructions.

The `HelpshiftWebchatWebview.m` file will create a webview and load the websupport URL which embeds webchat. To find out how to enable webchat for your websupport portal, please get in touch with your Site admin. The URL generally looks like :

https://domain-name.helpshift.com/webchat/a/app-name

To check the code flow, set the `openFAQs` variable to `YES` and follow along.
When showing FAQs, the code will load `HelpshiftWebchatOnload.js` which will periodically check if Helpshift webchat has loaded on the websupport portal. When load is complete, it will fire the `chatLoad` event which will be handled in the `HelpshiftWebchatViewController` class. Recommendation is to load the `HelpshiftWebchatWrapper` JS file after this and also make sure to call login so that the webchat session always has a logged in user before the user can start a conversation.

### Common

Finally, create a `WKWebview` instance in your app and load the URL which you enabled in the previous step.
You should now have a working webchat in your macOS app although its still missing a lot of bells and whistles.

## Customize webchat

The Helpshift webchat widget comes with a host of options to configure and customize the appearance.
One of the first things you should do is to make the widget full screen and also remove the close button and webchat launcher.
The idea here is that your webview should be showing only the webchat in open state.

In order to achieve this, there are a couple of ways to go about it.
All approaches share the same philosophy, run JS code in the webview context once the Helpshift webchat widget has been loaded.
Our recommendation is to use the `WKUserScript` mechanism to load and run a JS file from your ObjC code.
The code required for this has been added to the Helpshift webchat webview subclass for your reference.

Once you are able to run this JS code, you should have a way to open a full screen webchat widget inside of your webview.

## API interaction

### ObjC to JS
The next stage of integration is the ability to call JS APIs from ObjC and get callbacks from JS to ObjC.

To enable this interaction, we will again rely on the evaluateJavascript method exposed by the WKWebview class.

To convert ObjC parameters to JS, you can rely on JSON as the data interchange format.
Examples of how this can happen have been added to the `HelpshiftWebchatWebview` API class.

For updating the helpshift config, please note that you need to merge the new dictionary with the existing `window.helpshiftConfig` object.

### JS to ObjC

In order to receive callbacks from JavaScript to your ObjC code, we will use the webkit message handler functionality provided by the WKWebview class.
First we will register the webview for receiving message callbacks for the events that we are interested in.
This is done in the `HelpshiftWebchatWebview` class by adding `HelpshiftWebchatScriptMessageHandler` as the script message handler.

Then we will register JavaScript delegates in our `HelpshiftWebchatWrapper.js` file.
These delegates will listen to the events from Helpshift webchat and pass them along to the webkit message handlers.
This in turn will call our ObjC delegate for `HelpshiftWebchatScriptMessageHandler`

From here we can decide how to route the callback for further processing based on the message name.
In the example code, we have created a `HelpshiftWebchatDelegate` delegate which can be implemented in your view controller to receive updates from the JS code.
To set the delegate property, use the `setHelpshiftWebchatDelegate:` API from`HelpshiftWebchatWebview` class.
